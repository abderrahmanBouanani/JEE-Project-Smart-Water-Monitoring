package controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import dao.CapteurIoTDao;
import dao.UtilisateurDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Alerte;
import model.CapteurIoT;
import model.TypeAlerte;
import model.Utilisateur;
import services.AlerteService;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * API REST pour recevoir les alertes des capteurs IoT
 * URL: /api/alertes
 * Méthode: POST
 * Format JSON: {"capteurId": 1, "type": "SEUIL_DEPASSE", "message": "...", "niveauUrgence": "ELEVEE"}
 */
@WebServlet(name = "AlerteApiServlet", urlPatterns = {"/api/alertes"})
public class AlerteApiServlet extends HttpServlet {

    private final AlerteService alerteService = new AlerteService();
    private final CapteurIoTDao capteurDao = new CapteurIoTDao();
    private final UtilisateurDao utilisateurDao = new UtilisateurDao();
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
            System.out.println("🚨 Alerte reçue : " + jsonData);
            
            // Parser le JSON
            JsonObject jsonObject = gson.fromJson(jsonData, JsonObject.class);
            
            // Valider les champs requis
            if (!jsonObject.has("capteurId") || !jsonObject.has("type") || 
                !jsonObject.has("message") || !jsonObject.has("niveauUrgence")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                responseJson.addProperty("status", "error");
                responseJson.addProperty("message", "Champs manquants: capteurId, type, message et niveauUrgence requis");
                out.print(gson.toJson(responseJson));
                return;
            }
            
            Long capteurId = jsonObject.get("capteurId").getAsLong();
            String typeStr = jsonObject.get("type").getAsString();
            String message = jsonObject.get("message").getAsString();
            String niveauUrgence = jsonObject.get("niveauUrgence").getAsString();
            
            // Vérifier que le capteur existe
            CapteurIoT capteur = capteurDao.findById(capteurId);
            if (capteur == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                responseJson.addProperty("status", "error");
                responseJson.addProperty("message", "Capteur introuvable avec ID: " + capteurId);
                out.print(gson.toJson(responseJson));
                return;
            }
            
            // Récupérer l'utilisateur propriétaire du capteur
            Utilisateur utilisateur = capteur.getUtilisateur();
            if (utilisateur == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                responseJson.addProperty("status", "error");
                responseJson.addProperty("message", "Capteur sans propriétaire");
                out.print(gson.toJson(responseJson));
                return;
            }
            
            // Convertir le type d'alerte
            TypeAlerte typeAlerte;
            try {
                typeAlerte = TypeAlerte.valueOf(typeStr);
            } catch (IllegalArgumentException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                responseJson.addProperty("status", "error");
                responseJson.addProperty("message", "Type d'alerte invalide: " + typeStr + 
                    ". Types valides: SEUIL_DEPASSE, FUITE_DETECTEE, CAPTEUR_OFFLINE");
                out.print(gson.toJson(responseJson));
                return;
            }
            
            // Créer l'alerte
            Alerte alerte = new Alerte(typeAlerte, message, niveauUrgence, utilisateur);
            
            // Note: On ne peut pas facilement lier la DonneeCapteur ici car on ne l'a pas
            // L'alerte sera créée sans lien vers une donnée spécifique
            
            // Sauvegarder l'alerte
            boolean success = alerteService.create(alerte);
            
            if (success) {
                response.setStatus(HttpServletResponse.SC_CREATED);
                responseJson.addProperty("status", "success");
                responseJson.addProperty("message", "Alerte créée avec succès");
                responseJson.addProperty("capteurId", capteurId);
                responseJson.addProperty("type", typeStr);
                responseJson.addProperty("utilisateur", utilisateur.getNom());
                
                System.out.println("✅ Alerte sauvegardée : " + typeStr + 
                                 " pour capteur #" + capteurId + 
                                 " (Utilisateur: " + utilisateur.getNom() + ")");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                responseJson.addProperty("status", "error");
                responseJson.addProperty("message", "Échec de l'enregistrement de l'alerte");
            }
            
        } catch (JsonSyntaxException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            responseJson.addProperty("status", "error");
            responseJson.addProperty("message", "Format JSON invalide: " + e.getMessage());
            System.err.println("❌ Erreur JSON: " + e.getMessage());
            
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
        responseJson.addProperty("endpoint", "/api/alertes");
        responseJson.addProperty("method", "POST");
        responseJson.addProperty("format", 
            "{\"capteurId\": 1, \"type\": \"SEUIL_DEPASSE\", \"message\": \"...\", \"niveauUrgence\": \"ELEVEE\"}");
        responseJson.addProperty("typesValides", "SEUIL_DEPASSE, FUITE_DETECTEE, CAPTEUR_OFFLINE");
        
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        response.getWriter().print(gson.toJson(responseJson));
    }
}
