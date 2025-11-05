package controller;

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

@WebServlet(name = "AuthServlet", urlPatterns = {"/auth"})
public class AuthServlet extends HttpServlet {

    private final UtilisateurService utilisateurService = new UtilisateurService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            login(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("logout".equals(action)) {
            logout(request, response);
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Utilisateur utilisateur = utilisateurService.findByEmail(email);

        if (utilisateur != null && utilisateur.getMotDePasse().equals(password)) {
            HttpSession session = request.getSession();
            session.setAttribute("user", utilisateur);

            // Redirection en fonction du rôle
            if (utilisateur.getType() == TypeUtilisateur.ADMINISTRATEUR) {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            } else if (utilisateur.getType() == TypeUtilisateur.CITOYEN) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                // Fallback pour d'autres types d'utilisateurs si nécessaire
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
        } else {
            request.setAttribute("error", "Email ou mot de passe incorrect.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
