package controller.citizen;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Utilisateur;
import services.UtilisateurService;

import java.io.IOException;

@WebServlet(name = "ProfilServlet", urlPatterns = {"/profil"})
public class ProfilServlet extends HttpServlet {

    private final UtilisateurService utilisateurService = new UtilisateurService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utilisateur user = (Utilisateur) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        request.setAttribute("pageTitle", "Mon Profil Utilisateur");
        request.setAttribute("contentPage", "profil.jsp");

        if ("edit".equals(action)) {
            request.setAttribute("editMode", true);
        } else {
            request.setAttribute("editMode", false);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/citizen/dashboard.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utilisateur user = (Utilisateur) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Récupérer les données du formulaire
        String nom = request.getParameter("nom");
        String email = request.getParameter("email");
        String adresse = request.getParameter("adresse");
        String motDePasse = request.getParameter("motDePasse"); // Optionnel

        // Mettre à jour l'objet utilisateur
        user.setNom(nom);
        user.setEmail(email);
        user.setAdresse(adresse);

        if (motDePasse != null && !motDePasse.isEmpty()) {
            user.setMotDePasse(motDePasse); // Dans une vraie app, hasher le mot de passe
        }

        boolean success = utilisateurService.update(user);

        if (success) {
            // Mettre à jour l'utilisateur dans la session après la modification
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/profil?success=true");
        } else {
            request.setAttribute("error", "Erreur lors de la mise à jour du profil.");
            request.setAttribute("editMode", true); // Rester en mode édition en cas d'erreur
            request.setAttribute("pageTitle", "Mon Profil Utilisateur");
            request.setAttribute("contentPage", "profil.jsp");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/citizen/dashboard.jsp");
            dispatcher.forward(request, response);
        }
    }
}
