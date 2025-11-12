package controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import dao.CapteurIoTDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.CapteurIoT;
import model.DonneeCapteur;
import services.DonneeCapteurService;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;

/**
 * API REST pour recevoir les données des capteurs IoT
 * URL: /api/waterdata
 * Méthode: POST
 * Format JSON: {"capteurId": 1, "valeurConsommation": 25.5}
 */
@WebServlet(name = "DataApiServlet", urlPatterns = {"/api/waterdata"})
public class DataApiServlet extends HttpServlet {

    private final DonneeCapteurService donneeCapteurService = new DonneeCapteurService();
    private final CapteurIoTDao capteurDao = new CapteurIoTDao();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Configuration de la réponse en JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        JsonObject responseJson = new JsonObject();
        
        try {
            // Lire le corps de la requête JSON
            StringBuilder jsonBuilder = new StringBuilder();
            String line;
            try (BufferedReader reader = request.getReader()) {
                while ((line = reader.readLine()) != null) {
                    jsonBuilder.append(line);
                }
            }
            
            String jsonData = jsonBuilder.toString();
            System.out.println("📥 Données reçues : " + jsonData);
            
            // Parser le JSON
            JsonObject jsonObject = gson.fromJson(jsonData, JsonObject.class);
            
            // Extraire les données
            if (!jsonObject.has("capteurId") || !jsonObject.has("valeurConsommation")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                responseJson.addProperty("status", "error");
                responseJson.addProperty("message", "Champs manquants: capteurId et valeurConsommation requis");
                out.print(gson.toJson(responseJson));
                return;
            }
            
            Long capteurId = jsonObject.get("capteurId").getAsLong();
            double valeurConsommation = jsonObject.get("valeurConsommation").getAsDouble();
            
            // Vérifier que le capteur existe
            CapteurIoT capteur = capteurDao.findById(capteurId);
            if (capteur == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                responseJson.addProperty("status", "error");
                responseJson.addProperty("message", "Capteur introuvable avec ID: " + capteurId);
                out.print(gson.toJson(responseJson));
                return;
            }
            
            // Créer l'objet DonneeCapteur
            DonneeCapteur donneeCapteur = new DonneeCapteur();
            donneeCapteur.setCapteur(capteur);
            donneeCapteur.setValeurConsommation(valeurConsommation);
            donneeCapteur.setHorodatage(LocalDateTime.now());
            
            // Sauvegarder en base de données
            boolean success = donneeCapteurService.create(donneeCapteur);
            
            if (success) {
                response.setStatus(HttpServletResponse.SC_CREATED);
                responseJson.addProperty("status", "success");
                responseJson.addProperty("message", "Donnée enregistrée avec succès");
                responseJson.addProperty("capteurId", capteurId);
                responseJson.addProperty("valeurConsommation", valeurConsommation);
                responseJson.addProperty("horodatage", donneeCapteur.getHorodatage().toString());
                
                System.out.println("✅ Donnée sauvegardée : Capteur #" + capteurId + 
                                 ", Consommation: " + valeurConsommation + "L");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                responseJson.addProperty("status", "error");
                responseJson.addProperty("message", "Échec de l'enregistrement en base de données");
            }
            
        } catch (JsonSyntaxException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            responseJson.addProperty("status", "error");
            responseJson.addProperty("message", "Format JSON invalide: " + e.getMessage());
            System.err.println("❌ Erreur JSON: " + e.getMessage());
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            responseJson.addProperty("status", "error");
            responseJson.addProperty("message", "Format de nombre invalide: " + e.getMessage());
            System.err.println("❌ Erreur format nombre: " + e.getMessage());
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            responseJson.addProperty("status", "error");
            responseJson.addProperty("message", "Erreur serveur: " + e.getMessage());
            System.err.println("❌ Erreur serveur: " + e.getMessage());
            e.printStackTrace();
        }
        
        out.print(gson.toJson(responseJson));
        out.flush();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        JsonObject responseJson = new JsonObject();
        responseJson.addProperty("status", "info");
        responseJson.addProperty("message", "Cette API accepte uniquement les requêtes POST");
        responseJson.addProperty("endpoint", "/api/waterdata");
        responseJson.addProperty("method", "POST");
        responseJson.addProperty("format", "{\"capteurId\": 1, \"valeurConsommation\": 25.5}");
        
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        response.getWriter().print(gson.toJson(responseJson));
    }
}
