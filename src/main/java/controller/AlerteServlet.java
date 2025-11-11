package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Alerte;
import model.TypeAlerte;
import model.Utilisateur;
import model.TypeUtilisateur;
import services.AlerteService;
import services.UtilisateurService;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "AlerteServlet", urlPatterns = {"/alertes"})
public class AlerteServlet extends HttpServlet {

    private final AlerteService alerteService = new AlerteService();
    private final UtilisateurService utilisateurService = new UtilisateurService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 🛡️ Vérifier que l'utilisateur est un ADMINISTRATEUR
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Utilisateur user = (Utilisateur) session.getAttribute("user");
        if (user.getType() != TypeUtilisateur.ADMINISTRATEUR) {
            System.err.println("❌ ACCÈS REFUSÉ: Utilisateur " + user.getNom() + " tente d'accéder à la gestion des alertes");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteAlerte(request, response);
                    break;
                default:
                    listAlertes(request, response);
                    break;
            }
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid ID format", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");

        String message = request.getParameter("message");
        String niveauUrgence = request.getParameter("niveauUrgence"); // Correction du nom du paramètre
        TypeAlerte type = TypeAlerte.valueOf(request.getParameter("type"));

        boolean success;

        if (idParam == null || idParam.isEmpty()) {
            // --- CREATION ---
            Alerte newAlerte = new Alerte();
            newAlerte.setType(type);
            newAlerte.setMessage(message);
            newAlerte.setNiveauUrgence(niveauUrgence);
            newAlerte.setDateCreation(LocalDateTime.now());
            newAlerte.setEstLue(false);

            Utilisateur placeholderUser = utilisateurService.findById(1L);
            if (placeholderUser == null) {
                throw new ServletException("Placeholder user with ID 1 not found.");
            }
            newAlerte.setUtilisateur(placeholderUser);

            success = alerteService.create(newAlerte);
        } else {
            // --- MISE A JOUR ---
            Long id = Long.parseLong(idParam);
            Alerte alerte = alerteService.findById(id);
            if (alerte != null) {
                alerte.setType(type);
                alerte.setMessage(message);
                alerte.setNiveauUrgence(niveauUrgence);
                alerte.setEstLue(request.getParameter("estLue") != null && request.getParameter("estLue").equals("true"));
                success = alerteService.update(alerte);
            } else {
                success = false;
            }
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/alertes");
        } else {
            response.sendRedirect(request.getContextPath() + "/alertes?error=true");
        }
    }

    private void listAlertes(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Alerte> alertes = alerteService.findAll();
            if (alertes == null) {
                alertes = new java.util.ArrayList<>();
            }
            request.setAttribute("alertes", alertes);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/alerte/list.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            System.err.println("Error listing alertes: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement des alertes");
            request.setAttribute("alertes", new java.util.ArrayList<>());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/alerte/list.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setAttribute("typesAlerte", TypeAlerte.values());
            List<Utilisateur> utilisateurs = utilisateurService.findAll();
            if (utilisateurs == null) {
                utilisateurs = new java.util.ArrayList<>();
            }
            request.setAttribute("utilisateurs", utilisateurs);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/alerte/form.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            System.err.println("Error showing new form: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement du formulaire");
            request.setAttribute("typesAlerte", TypeAlerte.values());
            request.setAttribute("utilisateurs", new java.util.ArrayList<>());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/alerte/form.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        System.out.println("📝 Modification alerte ID: " + id);

        Alerte alerteExistante = alerteService.findById(id);
        request.setAttribute("alerte", alerteExistante);
        request.setAttribute("typesAlerte", TypeAlerte.values());
        request.setAttribute("utilisateurs", utilisateurService.findAll());

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/alerte/form.jsp");
        dispatcher.forward(request, response);
    }

    private void deleteAlerte(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        Alerte alerteASupprimer = alerteService.findById(id);
        if (alerteASupprimer != null) {
            alerteService.delete(alerteASupprimer);
        }
        response.sendRedirect(request.getContextPath() + "/alertes");
    }
}
