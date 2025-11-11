package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Utilisateur;
import model.TypeUtilisateur;
import services.UtilisateurService;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "UtilisateurServlet", urlPatterns = {"/utilisateurs"})
public class UtilisateurServlet extends HttpServlet {

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
            System.err.println("❌ ACCÈS REFUSÉ: Utilisateur " + user.getNom() + " tente d'accéder à la gestion des utilisateurs");
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
                    deleteUtilisateur(request, response);
                    break;
                default:
                    listUtilisateurs(request, response);
                    break;
            }
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid ID format", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");

        String nom = request.getParameter("nom");
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motDePasse");
        String adresse = request.getParameter("adresse");
        TypeUtilisateur type = TypeUtilisateur.valueOf(request.getParameter("type"));

        boolean success;

        if (idParam == null || idParam.isEmpty()) {
            // Création
            Utilisateur newUser = new Utilisateur();
            newUser.setNom(nom);
            newUser.setEmail(email);
            newUser.setMotDePasse(motDePasse); // Dans une vraie app, il faudrait hasher le mot de passe
            newUser.setAdresse(adresse);
            newUser.setType(type);
            newUser.setDateInscription(LocalDateTime.now());
            success = utilisateurService.create(newUser);
        } else {
            // Mise à jour
            Long id = Long.parseLong(idParam);
            Utilisateur utilisateur = utilisateurService.findById(id);
            if (utilisateur != null) {
                utilisateur.setNom(nom);
                utilisateur.setEmail(email);
                utilisateur.setAdresse(adresse);
                utilisateur.setType(type);
                // Ne pas mettre à jour le mot de passe s'il est laissé vide
                if (motDePasse != null && !motDePasse.isEmpty()) {
                    utilisateur.setMotDePasse(motDePasse);
                }
                success = utilisateurService.update(utilisateur);
            } else {
                success = false;
            }
        }

        if (success) {
            response.sendRedirect("utilisateurs");
        } else {
            response.sendRedirect("utilisateurs?error=true");
        }
    }

    private void listUtilisateurs(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Utilisateur> utilisateurs = utilisateurService.findAll();
            if (utilisateurs == null) {
                utilisateurs = new java.util.ArrayList<>();
            }
            request.setAttribute("utilisateurs", utilisateurs);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/utilisateur/list.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            System.err.println("Error listing utilisateurs: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement des utilisateurs");
            request.setAttribute("utilisateurs", new java.util.ArrayList<>());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/utilisateur/list.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("typesUtilisateur", TypeUtilisateur.values());
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/utilisateur/form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        Utilisateur utilisateurExistant = utilisateurService.findById(id);
        request.setAttribute("utilisateur", utilisateurExistant);
        request.setAttribute("typesUtilisateur", TypeUtilisateur.values());
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/utilisateur/form.jsp");
        dispatcher.forward(request, response);
    }

    private void deleteUtilisateur(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        Utilisateur utilisateurASupprimer = utilisateurService.findById(id);
        if (utilisateurASupprimer != null) {
            utilisateurService.delete(utilisateurASupprimer);
        }
        response.sendRedirect("utilisateurs");
    }
}
