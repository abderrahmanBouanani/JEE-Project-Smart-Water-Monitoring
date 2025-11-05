package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*") // Intercepte toutes les requêtes
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        // Permettre l'accès aux pages publiques (login, ressources statiques, etc.)
        if (path.startsWith("/login.jsp") || path.startsWith("/auth") || path.startsWith("/assets/")) {
            chain.doFilter(request, response); // Continue vers la ressource demandée
            return;
        }

        HttpSession session = httpRequest.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            // Pas de session ou pas d'utilisateur en session -> redirection vers la page de login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
        } else {
            // L'utilisateur est authentifié, on le laisse passer
            chain.doFilter(request, response);
        }
    }

    // Méthodes init() et destroy() peuvent rester vides pour cet exemple
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}
