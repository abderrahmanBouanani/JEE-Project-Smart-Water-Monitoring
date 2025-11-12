package controller.citizen;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import services.HistoriqueConsommationService;
import model.HistoriqueConsommation;
import model.Utilisateur;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HistoriqueServlet", urlPatterns = {"/consommation/historique"})
public class HistoriqueServlet extends HttpServlet {

    private HistoriqueConsommationService consommationService = new HistoriqueConsommationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== DEBUG HISTORIQUE SERVLET ===");

        try {
            HttpSession session = request.getSession();
            Utilisateur user = (Utilisateur) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            // DEBUG: Afficher l'utilisateur connecté
            System.out.println("👤 Utilisateur connecté: ID=" + user.getIdUtilisateur() + ", Nom=" + user.getNom());

            // Récupérer les données SPÉCIFIQUES à cet utilisateur
            System.out.println("📦 Récupération des données POUR L'UTILISATEUR ID: " + user.getIdUtilisateur());
            List<HistoriqueConsommation> historiques = consommationService.findByUserId(user.getIdUtilisateur());
            System.out.println("✅ Données récupérées: " + historiques.size() + " enregistrements");

            // ✅ CORRECTION: Afficher les données SANS accéder à l'utilisateur (pour éviter les erreurs)
            for (HistoriqueConsommation h : historiques) {
                System.out.println("📊 " + h.getDate() + " | " + h.getVolumeTotal() + "L | " + h.getCoutEstime() + "€");
                // Ne pas appeler h.getUtilisateur() ici pour éviter LazyInitializationException
            }

            // Calculs
            double totalVolume = 0;
            double totalCout = 0;
            for (HistoriqueConsommation h : historiques) {
                totalVolume += h.getVolumeTotal();
                totalCout += h.getCoutEstime();
            }
            double moyenneVolume = historiques.size() > 0 ? totalVolume / historiques.size() : 0;

            System.out.println("🧮 Totaux calculés - Volume: " + totalVolume + " | Coût: " + totalCout);

            // ENVOYER LES DONNÉES À LA JSP
            request.setAttribute("historiques", historiques);
            request.setAttribute("totalVolume", String.format("%.1f", totalVolume));
            request.setAttribute("totalCout", String.format("%.1f", totalCout));
            request.setAttribute("moyenneVolume", String.format("%.1f", moyenneVolume));
            request.setAttribute("userId", user.getIdUtilisateur());

            System.out.println("🚀 Forward vers la JSP...");

            request.getRequestDispatcher("/WEB-INF/views/citizen/historique.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("❌ ERREUR: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/citizen/historique.jsp").forward(request, response);
        }
    }
}