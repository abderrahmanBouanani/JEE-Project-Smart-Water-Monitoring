package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Utilisateur;
import model.TypeUtilisateur;

import java.io.IOException;

@WebFilter("/*") // Intercepte toutes les requêtes
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        // Permettre l'accès aux pages publiques
        if (path.startsWith("/login.jsp") || path.startsWith("/signup.jsp") || path.startsWith("/auth") ||
            path.startsWith("/signup") || path.startsWith("/assets/") || path.startsWith("/")) {
            chain.doFilter(request, response); // Continue vers la ressource demandée
            return;
        }

        HttpSession session = httpRequest.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            // Pas de session ou pas d'utilisateur en session -> redirection vers la page de login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
        } else {
            // L'utilisateur est authentifié, maintenant vérifier l'accès selon le rôle
            Utilisateur user = (Utilisateur) session.getAttribute("user");

            // 🛡️ Restriction d'accès à l'interface ADMIN
            if (path.startsWith("/admin/") || path.startsWith("/utilisateurs") ||
                path.startsWith("/alertes") || path.startsWith("/capteurs")) {

                // Vérifier que l'utilisateur est un administrateur
                if (user.getType() != TypeUtilisateur.ADMINISTRATEUR) {
                    System.err.println("❌ ACCÈS REFUSÉ: Utilisateur " + user.getNom() +
                                     " (Type: " + user.getType() + ") tente d'accéder à: " + path);

                    // Rediriger vers le dashboard client
                    httpResponse.sendRedirect(httpRequest.getContextPath() + "/dashboard");
                    return;
                }
            }

            // ✅ L'utilisateur a les permissions requises
            chain.doFilter(request, response);
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}
