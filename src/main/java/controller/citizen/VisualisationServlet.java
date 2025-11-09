package controller.citizen;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CapteurIoT;
import model.DonneeCapteur;
import model.Utilisateur;
import services.CapteurIoTService;
import services.DonneeCapteurService;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "VisualisationServlet", urlPatterns = {"/consommation/visualisation"})
public class VisualisationServlet extends HttpServlet {

    private final CapteurIoTService capteurService = new CapteurIoTService();
    private final DonneeCapteurService donneeCapteurService = new DonneeCapteurService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== DEBUG VISUALISATION SERVLET ===");

        try {
            HttpSession session = request.getSession();
            Utilisateur user = (Utilisateur) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            // DEBUG: Afficher l'utilisateur connecté
            System.out.println("👤 Utilisateur connecté: ID=" + user.getIdUtilisateur() + ", Nom=" + user.getNom());

            // ✅ Récupérer les capteurs SPÉCIFIQUES à cet utilisateur
            System.out.println("📦 Récupération des capteurs POUR L'UTILISATEUR ID: " + user.getIdUtilisateur());
            List<CapteurIoT> capteurs = capteurService.findByUserId(user.getIdUtilisateur());

            // Récupérer les dernières données de chaque capteur
            List<DonneeCapteur> dernieresDonnees = donneeCapteurService.findRecentByUserId(user.getIdUtilisateur());

            System.out.println("✅ Données visualisation récupérées:");
            System.out.println("   - Capteurs: " + capteurs.size());
            System.out.println("   - Dernières données: " + dernieresDonnees.size());

            // Afficher le détail des capteurs
            for (CapteurIoT capteur : capteurs) {
                System.out.println("📡 Capteur: " + capteur.getReference() + " - " + capteur.getEmplacement() +
                        " (" + (capteur.isEtat() ? "Actif" : "Inactif") + ")");
            }

            // ENVOYER LES DONNÉES À LA JSP
            request.setAttribute("capteurs", capteurs);
            request.setAttribute("dernieresDonnees", dernieresDonnees);
            request.setAttribute("userId", user.getIdUtilisateur());

            System.out.println("🚀 Forward vers la JSP...");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/citizen/visualisation.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            System.out.println("❌ ERREUR Visualisation: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement de la visualisation: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/citizen/visualisation.jsp");
            dispatcher.forward(request, response);
        }
    }
}