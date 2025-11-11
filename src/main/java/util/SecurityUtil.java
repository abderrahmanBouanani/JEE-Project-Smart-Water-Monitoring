package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Utilisateur;
import model.TypeUtilisateur;

import java.io.IOException;

/**
 * Utility class for security checks and authorization
 */
public class SecurityUtil {

    /**
     * Vérifie si l'utilisateur est authentifié
     */
    public static boolean isUserAuthenticated(HttpSession session) {
        return session != null && session.getAttribute("user") != null;
    }

    /**
     * Vérifie si l'utilisateur est un administrateur
     */
    public static boolean isUserAdmin(HttpSession session) {
        if (!isUserAuthenticated(session)) {
            return false;
        }
        Utilisateur user = (Utilisateur) session.getAttribute("user");
        return user.getType() == TypeUtilisateur.ADMINISTRATEUR;
    }

    /**
     * Vérifie si l'utilisateur est un citoyen
     */
    public static boolean isUserCitizen(HttpSession session) {
        if (!isUserAuthenticated(session)) {
            return false;
        }
        Utilisateur user = (Utilisateur) session.getAttribute("user");
        return user.getType() == TypeUtilisateur.CITOYEN;
    }

    /**
     * Récupère l'utilisateur actuel de la session
     */
    public static Utilisateur getCurrentUser(HttpSession session) {
        if (!isUserAuthenticated(session)) {
            return null;
        }
        return (Utilisateur) session.getAttribute("user");
    }

    /**
     * Redirige vers la page de login si l'utilisateur n'est pas authentifié
     */
    public static boolean redirectIfNotAuthenticated(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!isUserAuthenticated(request.getSession(false))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return true;
        }
        return false;
    }

    /**
     * Redirige vers le dashboard si l'utilisateur n'est pas un administrateur
     */
    public static boolean redirectIfNotAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (!isUserAdmin(session)) {
            Utilisateur user = getCurrentUser(session);
            if (user != null) {
                System.err.println("❌ ACCÈS REFUSÉ: Utilisateur " + user.getNom() +
                                 " (Type: " + user.getType() + ") tente d'accéder à une page admin");
            }
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return true;
        }
        return false;
    }

    /**
     * Redirige vers le dashboard si l'utilisateur n'est pas un citoyen
     */
    public static boolean redirectIfNotCitizen(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (!isUserCitizen(session)) {
            response.sendRedirect(request.getContextPath() + "/admin");
            return true;
        }
        return false;
    }
}

