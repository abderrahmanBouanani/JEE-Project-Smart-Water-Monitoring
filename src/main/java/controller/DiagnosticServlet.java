package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Utilisateur;
import model.TypeUtilisateur;
import model.CapteurIoT;
import services.CapteurIoTService;
import org.hibernate.Session;
import org.hibernate.Transaction;
import util.HibernateUtil;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet de diagnostic pour les administrateurs
 * Permet de vérifier l'intégrité des données
 */
@WebServlet(name = "DiagnosticServlet", urlPatterns = {"/admin/diagnostic"})
public class DiagnosticServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Utilisateur user = (Utilisateur) session.getAttribute("user");

            // Vérifier que c'est un administrateur
            if (user == null || !TypeUtilisateur.ADMINISTRATEUR.equals(user.getType())) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            System.out.println("🔍 Diagnostic page accédée par: " + user.getNom());

            // Récupérer les statistiques
            Map<String, Object> diagnostics = new HashMap<>();

            // Compter les capteurs
            CapteurIoTService capteurService = new CapteurIoTService();
            java.util.List<CapteurIoT> allCapteurs = capteurService.findAll();
            diagnostics.put("totalCapteurs", allCapteurs != null ? allCapteurs.size() : 0);

            // Vérifier les types enum
            Session hibSession = null;
            Transaction tx = null;
            try {
                hibSession = HibernateUtil.getSessionFactory().openSession();
                tx = hibSession.beginTransaction();

                // Compter les capteurs par type
                String typeStatsQuery = "SELECT c.type, COUNT(c) FROM CapteurIoT c GROUP BY c.type";
                java.util.List<Object[]> typeStats = hibSession.createQuery(typeStatsQuery).list();
                diagnostics.put("typeStats", typeStats);

                // Chercher les valeurs enum invalides
                String invalidQuery = "SELECT COUNT(c) FROM CapteurIoT c WHERE c.type NOT IN " +
                        "('RESIDENTIEL', 'INDUSTRIEL', 'AGRICOLE', 'DEBIT_EAU', 'QUALITE_EAU')";
                Long invalidCount = hibSession.createQuery(invalidQuery, Long.class).uniqueResult();
                diagnostics.put("invalidEnumCount", invalidCount != null ? invalidCount : 0L);

                tx.commit();
            } catch (Exception e) {
                if (tx != null) tx.rollback();
                diagnostics.put("typeStats", new java.util.ArrayList<>());
                diagnostics.put("invalidEnumCount", "Erreur");
                System.out.println("⚠️ Erreur lors du calcul des statistiques: " + e.getMessage());
            } finally {
                if (hibSession != null) hibSession.close();
            }

            request.setAttribute("diagnostics", diagnostics);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/diagnostic.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            System.out.println("❌ Erreur DiagnosticServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}

