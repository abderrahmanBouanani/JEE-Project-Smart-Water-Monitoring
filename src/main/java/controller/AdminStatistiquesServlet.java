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
import services.*;

import java.io.IOException;

@WebServlet(name = "AdminStatistiquesServlet", urlPatterns = {"/adminStatistiques"})
public class AdminStatistiquesServlet extends HttpServlet {

    private final UtilisateurService utilisateurService = new UtilisateurService();
    private final CapteurIoTService capteurService = new CapteurIoTService();
    private final AlerteService alerteService = new AlerteService();
    private final DonneeCapteurService donneeCapteurService = new DonneeCapteurService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utilisateur loggedInUser = (Utilisateur) session.getAttribute("user");

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Vérifier que l'utilisateur est un ADMINISTRATEUR
        if (loggedInUser.getType() != TypeUtilisateur.ADMINISTRATEUR) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        try {
            // Récupérer les statistiques
            System.out.println("=== Début récupération statistiques ===");
            
            long totalUtilisateurs = 0;
            long totalCitoyens = 0;
            long totalAdmins = 0;
            long totalCapteurs = 0;
            long capteursActifs = 0;
            long capteursInactifs = 0;
            long totalAlertes = 0;
            long alertesNonLues = 0;
            long totalDonnees = 0;
            double consommationTotale = 0.0;
            double consommationMoyenne = 0.0;
            
            try {
                totalUtilisateurs = utilisateurService.countAll();
                System.out.println("✅ Total utilisateurs: " + totalUtilisateurs);
            } catch (Exception e) {
                System.err.println("❌ Erreur countAll utilisateurs: " + e.getMessage());
                e.printStackTrace();
            }
            
            try {
                totalCitoyens = utilisateurService.countByType(TypeUtilisateur.CITOYEN);
                System.out.println("✅ Total citoyens: " + totalCitoyens);
            } catch (Exception e) {
                System.err.println("❌ Erreur countByType citoyens: " + e.getMessage());
                e.printStackTrace();
            }
            
            try {
                totalAdmins = utilisateurService.countByType(TypeUtilisateur.ADMINISTRATEUR);
                System.out.println("✅ Total admins: " + totalAdmins);
            } catch (Exception e) {
                System.err.println("❌ Erreur countByType admins: " + e.getMessage());
                e.printStackTrace();
            }
            
            try {
                totalCapteurs = capteurService.countAll();
                System.out.println("✅ Total capteurs: " + totalCapteurs);
            } catch (Exception e) {
                System.err.println("❌ Erreur countAll capteurs: " + e.getMessage());
                e.printStackTrace();
            }
            
            try {
                capteursActifs = capteurService.countByStatus(true);
                System.out.println("✅ Capteurs actifs: " + capteursActifs);
            } catch (Exception e) {
                System.err.println("❌ Erreur countByStatus actifs: " + e.getMessage());
                e.printStackTrace();
            }
            
            try {
                capteursInactifs = capteurService.countByStatus(false);
                System.out.println("✅ Capteurs inactifs: " + capteursInactifs);
            } catch (Exception e) {
                System.err.println("❌ Erreur countByStatus inactifs: " + e.getMessage());
                e.printStackTrace();
            }
            
            try {
                totalAlertes = alerteService.countAll();
                System.out.println("✅ Total alertes: " + totalAlertes);
            } catch (Exception e) {
                System.err.println("❌ Erreur countAll alertes: " + e.getMessage());
                e.printStackTrace();
            }
            
            try {
                alertesNonLues = alerteService.countUnread();
                System.out.println("✅ Alertes non lues: " + alertesNonLues);
            } catch (Exception e) {
                System.err.println("❌ Erreur countUnread: " + e.getMessage());
                e.printStackTrace();
            }
            
            try {
                totalDonnees = donneeCapteurService.countAll();
                System.out.println("✅ Total données: " + totalDonnees);
            } catch (Exception e) {
                System.err.println("❌ Erreur countAll données: " + e.getMessage());
                e.printStackTrace();
            }
            
            try {
                consommationTotale = donneeCapteurService.getTotalConsumption();
                System.out.println("✅ Consommation totale: " + consommationTotale);
            } catch (Exception e) {
                System.err.println("❌ Erreur getTotalConsumption: " + e.getMessage());
                e.printStackTrace();
            }
            
            try {
                consommationMoyenne = donneeCapteurService.getAverageConsumption();
                System.out.println("✅ Consommation moyenne: " + consommationMoyenne);
            } catch (Exception e) {
                System.err.println("❌ Erreur getAverageConsumption: " + e.getMessage());
                e.printStackTrace();
            }

            // Passer les données à la JSP
            request.setAttribute("totalUtilisateurs", totalUtilisateurs);
            request.setAttribute("totalCitoyens", totalCitoyens);
            request.setAttribute("totalAdmins", totalAdmins);
            request.setAttribute("totalCapteurs", totalCapteurs);
            request.setAttribute("capteursActifs", capteursActifs);
            request.setAttribute("capteursInactifs", capteursInactifs);
            request.setAttribute("totalAlertes", totalAlertes);
            request.setAttribute("alertesNonLues", alertesNonLues);
            request.setAttribute("totalDonnees", totalDonnees);
            request.setAttribute("consommationTotale", consommationTotale);
            request.setAttribute("consommationMoyenne", consommationMoyenne);

            System.out.println("=== Fin récupération statistiques - Redirection vers JSP ===");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/statistiques.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            System.err.println("❌ ERREUR GLOBALE AdminStatistiquesServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur lors du chargement des statistiques: " + e.getMessage());
        }
    }
}
