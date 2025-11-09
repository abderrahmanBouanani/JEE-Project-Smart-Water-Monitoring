package controller.citizen;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Alerte;
import model.Utilisateur;
import services.AlerteService;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "MesAlertesServlet", urlPatterns = {"/mes-alertes"})
public class MesAlertesServlet extends HttpServlet {

    private final AlerteService alerteService = new AlerteService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== DEBUG MES ALERTES SERVLET ===");

        try {
            HttpSession session = request.getSession();
            Utilisateur user = (Utilisateur) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            // DEBUG: Afficher l'utilisateur connecté
            System.out.println("👤 Utilisateur connecté: ID=" + user.getIdUtilisateur() + ", Nom=" + user.getNom());

            // ✅ Récupérer les alertes SPÉCIFIQUES à cet utilisateur
            System.out.println("📦 Récupération des alertes POUR L'UTILISATEUR ID: " + user.getIdUtilisateur());
            List<Alerte> alertes = alerteService.findByUserId(user.getIdUtilisateur());
            List<Alerte> alertesNonLues = alerteService.findUnreadByUserId(user.getIdUtilisateur());

            System.out.println("✅ Alertes récupérées: " + alertes.size() + " total, " + alertesNonLues.size() + " non lues");

            // Afficher le détail des alertes
            for (Alerte alerte : alertes) {
                System.out.println("🚨 Alerte: " + alerte.getType() + " - " + alerte.getMessage() +
                        " (Lue: " + alerte.isEstLue() + ")");
            }

            // ENVOYER LES DONNÉES À LA JSP
            request.setAttribute("alertes", alertes);
            request.setAttribute("alertesNonLues", alertesNonLues);
            request.setAttribute("userId", user.getIdUtilisateur());

            System.out.println("🚀 Forward vers la JSP...");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/citizen/mes_alertes.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            System.out.println("❌ ERREUR: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/citizen/mes_alertes.jsp");
            dispatcher.forward(request, response);
        }
    }
}