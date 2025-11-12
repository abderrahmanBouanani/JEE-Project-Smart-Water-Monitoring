package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jobs.DailyAggregationJob;
import model.TypeUtilisateur;
import model.Utilisateur;
import services.DataAggregationService;

import java.io.IOException;
import java.util.Map;

/**
 * Servlet pour afficher les statistiques d'agrégation.
 * L'interface d'administration est maintenant en lecture seule :
 * les actions manuelles (veille / exécution / période) ont été supprimées.
 */
@WebServlet(name = "AggregationServlet", urlPatterns = {"/admin/aggregation"})
public class AggregationServlet extends HttpServlet {

    private final DataAggregationService aggregationService = new DataAggregationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Vérification de sécurité : Admin uniquement
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Utilisateur user = (Utilisateur) session.getAttribute("user");
        if (user.getType() != TypeUtilisateur.ADMINISTRATEUR) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // Page en lecture seule : afficher uniquement la page principale avec les statistiques.
        afficherPagePrincipale(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Vérification de sécurité
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Utilisateur user = (Utilisateur) session.getAttribute("user");
        if (user.getType() != TypeUtilisateur.ADMINISTRATEUR) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // POST n'accepte plus d'actions : rediriger vers la page en lecture seule
        afficherPagePrincipale(request, response);
    }

    /**
     * Affiche la page principale de gestion de l'agrégation
     */
    private void afficherPagePrincipale(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer les statistiques
        Map<String, Object> stats = aggregationService.getStatistiquesAggregation();
        request.setAttribute("stats", stats);
        
        // Vérifier si le job est actif
        boolean jobActif = DailyAggregationJob.getInstance().isRunning();
        request.setAttribute("jobActif", jobActif);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/aggregation.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Affiche les statistiques d'agrégation
     */
    private void afficherStatistiques(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Map<String, Object> stats = aggregationService.getStatistiquesAggregation();
        request.setAttribute("stats", stats);
        request.setAttribute("message", "Statistiques mises à jour");
        afficherPagePrincipale(request, response);
    }
    // Les méthodes d'exécution manuelle et d'agrégation par période ont été retirées
    // pour rendre la page d'administration en lecture seule. Si besoin d'actions
    // futures, garder la logique côté service et job, mais ne pas exposer d'actions
    // dangereuses via l'interface admin.
}
