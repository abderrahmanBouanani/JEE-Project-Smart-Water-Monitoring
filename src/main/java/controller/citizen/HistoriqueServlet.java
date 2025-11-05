package controller.citizen;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "HistoriqueServlet", urlPatterns = {"/consommation/historique"})
public class HistoriqueServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("pageTitle", "Historique de Consommation");
        request.setAttribute("contentPage", "historique.jsp"); // <-- Ajout de cette ligne
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/citizen/dashboard.jsp");
        dispatcher.forward(request, response);
    }
}
