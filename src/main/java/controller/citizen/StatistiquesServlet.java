package controller.citizen;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Statistique;
import model.Utilisateur;
import services.StatistiqueService;
import services.DonneeCapteurService;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StatistiquesServlet", urlPatterns = {"/consommation/stats"})
public class StatistiquesServlet extends HttpServlet {

    private final StatistiqueService statistiqueService = new StatistiqueService();
    private final DonneeCapteurService donneeCapteurService = new DonneeCapteurService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== DEBUG STATISTIQUES SERVLET ===");

        try {
            HttpSession session = request.getSession();
            Utilisateur user = (Utilisateur) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            // DEBUG: Afficher l'utilisateur connecté
            System.out.println("👤 Utilisateur connecté: ID=" + user.getIdUtilisateur() + ", Nom=" + user.getNom());

            // ✅ Récupérer les statistiques SPÉCIFIQUES à cet utilisateur
            System.out.println("📦 Récupération des statistiques POUR L'UTILISATEUR ID: " + user.getIdUtilisateur());
            List<Statistique> statistiques = statistiqueService.findByUserId(user.getIdUtilisateur());

            System.out.println("✅ Statistiques récupérées: " + statistiques.size() + " enregistrements");

            // Afficher le détail des statistiques
            for (Statistique stat : statistiques) {
                System.out.println("📊 " + stat.getType() + " - " + stat.getValeur() + " (" + stat.getPeriode() + ")");
            }

            // Calculer quelques métriques pour les graphiques
            Double consommationMoyenne = statistiqueService.getConsommationMoyenneByUserId(user.getIdUtilisateur());
            Double consommationTotale = statistiqueService.getConsommationTotaleByUserId(user.getIdUtilisateur());

            // ✅ RÉCUPÉRER LES VRAIES DONNÉES DE CONSOMMATION
            System.out.println("📊 Récupération des données de consommation réelles...");
            List<Double> donneesQuotidiennes = donneeCapteurService.getDailyConsumptionLast7Days(user.getIdUtilisateur());
            List<Double> donneesMensuelles = donneeCapteurService.getMonthlyConsumptionLast6Months(user.getIdUtilisateur());

            System.out.println("✅ Données quotidiennes (7 jours): " + donneesQuotidiennes);
            System.out.println("✅ Données mensuelles (6 mois): " + donneesMensuelles);

            // ENVOYER LES DONNÉES À LA JSP
            request.setAttribute("statistiques", statistiques);
            request.setAttribute("userId", user.getIdUtilisateur());
            request.setAttribute("consommationMoyenne", consommationMoyenne);
            request.setAttribute("consommationTotale", consommationTotale);

            // Données RÉELLES pour les graphiques
            request.setAttribute("donneesQuotidiennes", donneesQuotidiennes);
            request.setAttribute("donneesMensuelles", donneesMensuelles);

            System.out.println("🚀 Forward vers la JSP...");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/citizen/stats.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            System.out.println("❌ ERREUR Statistiques: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement des statistiques: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/citizen/stats.jsp");
            dispatcher.forward(request, response);
        }
    }
}