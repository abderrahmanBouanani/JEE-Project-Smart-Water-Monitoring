package controller.citizen;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "VisualisationServlet", urlPatterns = {"/consommation/visualisation"})
public class VisualisationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Chargez directement visualisation.jsp sans passer par le template
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/citizen/visualisation.jsp");
        dispatcher.forward(request, response);
    }
}