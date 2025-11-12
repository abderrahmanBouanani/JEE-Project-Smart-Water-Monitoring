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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== POST MES ALERTES SERVLET ===");

        try {
            HttpSession session = request.getSession();
            Utilisateur user = (Utilisateur) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            String action = request.getParameter("action");
            String alerteIdParam = request.getParameter("alerteId");

            System.out.println("📝 Action: " + action + ", Alerte ID: " + alerteIdParam);

            if (action != null && alerteIdParam != null) {
                Long alerteId = Long.parseLong(alerteIdParam);
                boolean success = false;

                switch (action) {
                    case "marquer-lue":
                        success = alerteService.marquerCommeLue(alerteId, user.getIdUtilisateur());
                        if (success) {
                            request.getSession().setAttribute("success", "Alerte marquée comme lue !");
                        } else {
                            request.getSession().setAttribute("error", "Erreur lors du marquage de l'alerte");
                        }
                        break;

                    case "archiver":
                        success = alerteService.archiverAlerte(alerteId, user.getIdUtilisateur());
                        if (success) {
                            request.getSession().setAttribute("success", "Alerte archivée !");
                        } else {
                            request.getSession().setAttribute("error", "Erreur lors de l'archivage de l'alerte");
                        }
                        break;

                    case "tout-marquer-lu":
                        success = alerteService.toutMarquerCommeLu(user.getIdUtilisateur());
                        if (success) {
                            request.getSession().setAttribute("success", "Toutes les alertes marquées comme lues !");
                        } else {
                            request.getSession().setAttribute("error", "Erreur lors du marquage des alertes");
                        }
                        break;
                }
            }

            // Rediriger vers la page des alertes
            response.sendRedirect(request.getContextPath() + "/mes-alertes");

        } catch (Exception e) {
            System.out.println("❌ ERREUR POST: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("error", "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/mes-alertes");
        }
    }
}