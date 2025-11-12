package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Utilisateur;
import model.TypeUtilisateur;
import services.UtilisateurService;
import util.SecurityUtil;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet(name = "SignupServlet", urlPatterns = {"/signup"})
public class SignupServlet extends HttpServlet {

    private final UtilisateurService utilisateurService = new UtilisateurService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nom = request.getParameter("nom");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String adresse = request.getParameter("adresse");

        // Vérifier si l'utilisateur existe déjà
        if (utilisateurService.findByEmail(email) != null) {
            request.setAttribute("error", "Un compte avec cet email existe déjà.");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }

        // Créer le nouvel utilisateur
        Utilisateur newUser = new Utilisateur();
        newUser.setNom(nom);
        newUser.setEmail(email);
        newUser.setMotDePasse(SecurityUtil.hashPassword(password)); // Hash le mot de passe avec BCrypt
        newUser.setAdresse(adresse);
        newUser.setDateInscription(LocalDateTime.now());
        newUser.setType(TypeUtilisateur.CITOYEN); // Le type par défaut pour l'inscription

        boolean success = utilisateurService.create(newUser);

        if (success) {
            // Rediriger vers la page de connexion avec un message de succès
            response.sendRedirect(request.getContextPath() + "/login.jsp?signup=success");
        } else {
            // Gérer l'échec de la création
            request.setAttribute("error", "Une erreur est survenue lors de la création du compte.");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
        }
    }
}
