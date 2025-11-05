package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.CapteurIoT;
import model.TypeCapteur;
import model.Utilisateur;
import services.CapteurIoTService;
import services.UtilisateurService;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "CapteurIoTServlet", urlPatterns = {"/capteurs"})
public class CapteurIoTServlet extends HttpServlet {

    private final CapteurIoTService capteurIoTService = new CapteurIoTService();
    private final UtilisateurService utilisateurService = new UtilisateurService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteCapteur(request, response);
                    break;
                default:
                    listCapteurs(request, response);
                    break;
            }
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid ID format", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");

        String reference = request.getParameter("reference");
        TypeCapteur type = TypeCapteur.valueOf(request.getParameter("type"));
        String emplacement = request.getParameter("emplacement");
        boolean etat = "on".equals(request.getParameter("etat"));
        double seuilAlerte = Double.parseDouble(request.getParameter("seuilAlerte"));
        Long utilisateurId = Long.parseLong(request.getParameter("utilisateurId"));

        Utilisateur proprietaire = utilisateurService.findById(utilisateurId);
        if (proprietaire == null) {
            throw new ServletException("Utilisateur propriétaire non trouvé.");
        }

        boolean success;

        if (idParam == null || idParam.isEmpty()) {
            // Création
            CapteurIoT newCapteur = new CapteurIoT();
            newCapteur.setReference(reference);
            newCapteur.setType(type);
            newCapteur.setEmplacement(emplacement);
            newCapteur.setEtat(etat);
            newCapteur.setSeuilAlerte(seuilAlerte);
            newCapteur.setUtilisateur(proprietaire);
            newCapteur.setDateInstallation(LocalDate.from(LocalDateTime.now()));
            success = capteurIoTService.create(newCapteur);
        } else {
            // Mise à jour
            Long id = Long.parseLong(idParam);
            CapteurIoT capteur = capteurIoTService.findById(id);
            if (capteur != null) {
                capteur.setReference(reference);
                capteur.setType(type);
                capteur.setEmplacement(emplacement);
                capteur.setEtat(etat);
                capteur.setSeuilAlerte(seuilAlerte);
                capteur.setUtilisateur(proprietaire);
                success = capteurIoTService.update(capteur);
            } else {
                success = false;
            }
        }

        if (success) {
            response.sendRedirect("capteurs");
        } else {
            response.sendRedirect("capteurs?error=true");
        }
    }

    private void listCapteurs(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<CapteurIoT> capteurs = capteurIoTService.findAll();
        request.setAttribute("capteurs", capteurs);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/capteur/list.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("typesCapteur", TypeCapteur.values());
        request.setAttribute("utilisateurs", utilisateurService.findAll());
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/capteur/form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        CapteurIoT capteurExistant = capteurIoTService.findById(id);
        request.setAttribute("capteur", capteurExistant);
        request.setAttribute("typesCapteur", TypeCapteur.values());
        request.setAttribute("utilisateurs", utilisateurService.findAll());
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/capteur/form.jsp");
        dispatcher.forward(request, response);
    }

    private void deleteCapteur(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        CapteurIoT capteurASupprimer = capteurIoTService.findById(id);
        if (capteurASupprimer != null) {
            capteurIoTService.delete(capteurASupprimer);
        }
        response.sendRedirect("capteurs");
    }
}
