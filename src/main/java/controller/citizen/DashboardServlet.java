package controller.citizen;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Alerte;
import model.CapteurIoT;
import model.HistoriqueConsommation;
import model.Utilisateur;
import services.AlerteService;
import services.CapteurIoTService;
import services.HistoriqueConsommationService;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    private final AlerteService alerteService = new AlerteService();
    private final CapteurIoTService capteurService = new CapteurIoTService();
    private final HistoriqueConsommationService historiqueService = new HistoriqueConsommationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== DEBUG DASHBOARD SERVLET ===");

        try {
            HttpSession session = request.getSession();
            Utilisateur user = (Utilisateur) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            // DEBUG: Afficher l'utilisateur connecté
            System.out.println("👤 Utilisateur connecté: ID=" + user.getIdUtilisateur() + ", Nom=" + user.getNom());

            // ✅ Récupérer les données SPÉCIFIQUES à cet utilisateur
            System.out.println("📦 Récupération des données POUR L'UTILISATEUR ID: " + user.getIdUtilisateur());

            List<Alerte> alertesNonLues = alerteService.findUnreadByUserId(user.getIdUtilisateur());
            List<CapteurIoT> capteurs = capteurService.findByUserId(user.getIdUtilisateur());
            List<HistoriqueConsommation> historiqueRecent = historiqueService.findByUserId(user.getIdUtilisateur());

            // Limiter l'historique récent aux 5 derniers enregistrements
            if (historiqueRecent.size() > 5) {
                historiqueRecent = historiqueRecent.subList(0, 5);
            }

            // Calculer les statistiques
            long capteursActifs = capteurService.countActiveByUserId(user.getIdUtilisateur());
            long totalCapteurs = capteurs.size();

            double consommationJour = 0;
            double coutJour = 0;
            if (!historiqueRecent.isEmpty()) {
                // Prendre la consommation du jour le plus récent
                HistoriqueConsommation dernierJour = historiqueRecent.get(0);
                consommationJour = dernierJour.getVolumeTotal();
                coutJour = dernierJour.getCoutEstime();
            }

            System.out.println("✅ Données dashboard récupérées:");
            System.out.println("   - Alertes non lues: " + alertesNonLues.size());
            System.out.println("   - Capteurs: " + totalCapteurs + " (actifs: " + capteursActifs + ")");
            System.out.println("   - Historique récent: " + historiqueRecent.size() + " enregistrements");
            System.out.println("   - Consommation jour: " + consommationJour + "L");
            System.out.println("   - Coût jour: " + coutJour + "€");

            // ENVOYER LES DONNÉES À LA JSP
            request.setAttribute("alertesNonLues", alertesNonLues);
            request.setAttribute("capteurs", capteurs);
            request.setAttribute("historiqueRecent", historiqueRecent);
            request.setAttribute("userId", user.getIdUtilisateur());

            // Statistiques pour les cartes
            request.setAttribute("capteursActifs", capteursActifs);
            request.setAttribute("totalCapteurs", totalCapteurs);
            request.setAttribute("consommationJour", consommationJour);
            request.setAttribute("coutJour", coutJour);

            System.out.println("🚀 Forward vers la JSP...");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/citizen/dashboard.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            System.out.println("❌ ERREUR Dashboard: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement du dashboard: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/citizen/dashboard.jsp");
            dispatcher.forward(request, response);
        }
    }
}