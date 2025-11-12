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
import services.UtilisateurService;

import java.io.IOException;

@WebServlet(name = "AdminProfilServlet", urlPatterns = {"/admin/profil"})
public class AdminProfilServlet extends HttpServlet {

    private final UtilisateurService utilisateurService = new UtilisateurService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Utilisateur loggedInUser = (Utilisateur) session.getAttribute("user");

            if (loggedInUser == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            // 🛡️ Vérifier que l'utilisateur est un ADMINISTRATEUR
            if (loggedInUser.getType() != TypeUtilisateur.ADMINISTRATEUR) {
                System.err.println("❌ ACCÈS REFUSÉ: Utilisateur non-admin " + loggedInUser.getNom() +
                                 " tente d'accéder au profil admin");
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return;
            }

            Utilisateur adminUser = utilisateurService.findById(loggedInUser.getIdUtilisateur());

            if (adminUser == null) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            // --- DEBUT DEBUG --- //
            System.out.println("✅ DEBUG AdminProfilServlet - adminUser ID: " + adminUser.getIdUtilisateur());
            System.out.println("✅ DEBUG AdminProfilServlet - adminUser Nom: " + adminUser.getNom());
            System.out.println("✅ DEBUG AdminProfilServlet - adminUser Email: " + adminUser.getEmail());
            System.out.println("✅ DEBUG AdminProfilServlet - adminUser Adresse: " + adminUser.getAdresse());
            System.out.println("✅ DEBUG AdminProfilServlet - adminUser Type: " + adminUser.getType());
            System.out.println("✅ DEBUG AdminProfilServlet - adminUser Date Inscription: " + adminUser.getDateInscription());
            // --- FIN DEBUG --- //

            String action = request.getParameter("action");

            request.setAttribute("pageTitle", "Mon Profil Administrateur");

            if ("edit".equals(action)) {
                request.setAttribute("editMode", true);
            } else {
                request.setAttribute("editMode", false);
            }

            request.setAttribute("adminUser", adminUser); // Passer l'utilisateur rechargé à la JSP

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/admin_profil.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            System.err.println("Error in AdminProfilServlet doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement du profil");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/admin_profil.jsp");
            dispatcher.forward(request, response);
        }
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utilisateur loggedInUser = (Utilisateur) session.getAttribute("user");

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Utilisateur adminUser = utilisateurService.findById(loggedInUser.getIdUtilisateur());

        if (adminUser == null) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Récupérer les données du formulaire
        String nom = request.getParameter("nom");
        String email = request.getParameter("email");
        String adresse = request.getParameter("adresse");
        String motDePasse = request.getParameter("motDePasse"); // Optionnel

        // Mettre à jour l'objet utilisateur rechargé
        adminUser.setNom(nom);
        adminUser.setEmail(email);
        adminUser.setAdresse(adresse);

        if (motDePasse != null && !motDePasse.isEmpty()) {
            adminUser.setMotDePasse(motDePasse); // Dans une vraie app, hasher le mot de passe
        }

        boolean success = utilisateurService.update(adminUser);

        if (success) {
            session.setAttribute("user", adminUser);
            response.sendRedirect(request.getContextPath() + "/admin/profil?success=true");
        } else {
            request.setAttribute("error", "Erreur lors de la mise à jour du profil.");
            request.setAttribute("editMode", true); // Rester en mode édition en cas d'erreur
            request.setAttribute("adminUser", adminUser); // Repasser l'objet pour le formulaire
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/admin_profil.jsp");
            dispatcher.forward(request, response);
        }
    }
}
