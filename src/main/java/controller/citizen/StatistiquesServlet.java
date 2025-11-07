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
        // Chargez directement stats.jsp sans JSTL
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/citizen/stats.jsp");
        dispatcher.forward(request, response);
    }
}