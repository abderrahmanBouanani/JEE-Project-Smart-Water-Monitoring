package controller.api;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Utilisateur;
import services.DonneeCapteurService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * API REST pour récupérer les données de consommation en temps réel
 * Format JSON pour AJAX
 */
@WebServlet(name = "ConsumptionDataApiServlet", urlPatterns = {"/api/consumption/data"})
public class ConsumptionDataApiServlet extends HttpServlet {

    private final DonneeCapteurService donneeCapteurService = new DonneeCapteurService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Vérifier l'authentification
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\": \"Non authentifié\"}");
                return;
            }

            Utilisateur user = (Utilisateur) session.getAttribute("user");
            String period = request.getParameter("period"); // "daily" ou "monthly"

            Map<String, Object> result = new HashMap<>();

            if ("daily".equals(period)) {
                // Récupérer les données quotidiennes
                List<Double> dailyData = donneeCapteurService.getDailyConsumptionLast7Days(user.getIdUtilisateur());
                result.put("success", true);
                result.put("period", "daily");
                result.put("data", dailyData);
                result.put("labels", getDailyLabels());
                System.out.println("📊 API - Données quotidiennes envoyées: " + dailyData);

            } else if ("monthly".equals(period)) {
                // Récupérer les données mensuelles
                List<Double> monthlyData = donneeCapteurService.getMonthlyConsumptionLast6Months(user.getIdUtilisateur());
                result.put("success", true);
                result.put("period", "monthly");
                result.put("data", monthlyData);
                result.put("labels", getMonthlyLabels());
                System.out.println("📊 API - Données mensuelles envoyées: " + monthlyData);

            } else {
                // Par défaut, retourner les deux
                List<Double> dailyData = donneeCapteurService.getDailyConsumptionLast7Days(user.getIdUtilisateur());
                List<Double> monthlyData = donneeCapteurService.getMonthlyConsumptionLast6Months(user.getIdUtilisateur());

                Map<String, Object> daily = new HashMap<>();
                daily.put("data", dailyData);
                daily.put("labels", getDailyLabels());

                Map<String, Object> monthly = new HashMap<>();
                monthly.put("data", monthlyData);
                monthly.put("labels", getMonthlyLabels());

                result.put("success", true);
                result.put("daily", daily);
                result.put("monthly", monthly);
                System.out.println("📊 API - Toutes les données envoyées");
            }

            // Envoyer la réponse JSON
            String jsonResponse = gson.toJson(result);
            PrintWriter out = response.getWriter();
            out.print(jsonResponse);
            out.flush();

        } catch (Exception e) {
            System.err.println("❌ Erreur API ConsumptionData: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    /**
     * Génère les labels pour les 7 derniers jours
     */
    private List<String> getDailyLabels() {
        List<String> labels = new java.util.ArrayList<>();
        String[] days = {"Dim", "Lun", "Mar", "Mer", "Jeu", "Ven", "Sam"};
        java.util.Calendar cal = java.util.Calendar.getInstance();

        for (int i = 6; i >= 0; i--) {
            java.util.Calendar temp = (java.util.Calendar) cal.clone();
            temp.add(java.util.Calendar.DAY_OF_MONTH, -i);
            labels.add(days[temp.get(java.util.Calendar.DAY_OF_WEEK) - 1]);
        }
        return labels;
    }

    /**
     * Génère les labels pour les 6 derniers mois
     */
    private List<String> getMonthlyLabels() {
        List<String> labels = new java.util.ArrayList<>();
        String[] months = {"Jan", "Fév", "Mar", "Avr", "Mai", "Jun", "Jul", "Aoû", "Sep", "Oct", "Nov", "Déc"};
        java.util.Calendar cal = java.util.Calendar.getInstance();

        for (int i = 5; i >= 0; i--) {
            java.util.Calendar temp = (java.util.Calendar) cal.clone();
            temp.add(java.util.Calendar.MONTH, -i);
            labels.add(months[temp.get(java.util.Calendar.MONTH)]);
        }
        return labels;
    }
}
