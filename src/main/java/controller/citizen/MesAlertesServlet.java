package controller.citizen;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "MesAlertesServlet", urlPatterns = {"/mes-alertes"})
public class MesAlertesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Chargez directement mes_alertes.jsp sans passer par le template
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/citizen/mes_alertes.jsp");
        dispatcher.forward(request, response);
    }
}