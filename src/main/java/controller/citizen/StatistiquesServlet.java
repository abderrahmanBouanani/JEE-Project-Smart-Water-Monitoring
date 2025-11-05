package controller.citizen;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "StatistiquesServlet", urlPatterns = {"/consommation/stats"})
public class StatistiquesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("pageTitle", "Statistiques de Consommation");
        request.setAttribute("contentPage", "stats.jsp"); // <-- Ajout de cette ligne
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/citizen/dashboard.jsp");
        dispatcher.forward(request, response);
    }
}
