package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CapteurIoT;
import model.TypeCapteur;
import model.Utilisateur;
import model.TypeUtilisateur;
import services.CapteurIoTService;
import services.UtilisateurService;
import services.DonneeCapteurService;
import util.EnumUtil;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "CapteurIoTServlet", urlPatterns = {"/capteurs"})
public class CapteurIoTServlet extends HttpServlet {

    private final CapteurIoTService capteurIoTService = new CapteurIoTService();
    private final UtilisateurService utilisateurService = new UtilisateurService();
    private final DonneeCapteurService donneeCapteurService = new DonneeCapteurService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== DEBUG CAPTEUR SERVLET (GET) ===");

        try {
            HttpSession session = request.getSession();
            Utilisateur user = (Utilisateur) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            // Vérifier si admin
            if (!TypeUtilisateur.ADMINISTRATEUR.equals(user.getType())) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return;
            }

            System.out.println("👤 Admin connecté: " + user.getNom());

            String action = request.getParameter("action");
            if (action == null) {
                action = "list";
            }

            System.out.println("📋 Action: " + action);

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

        } catch (Exception e) {
            System.out.println("❌ ERREUR CapteurServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/capteurs?error=true");
        }
    }

    private void listCapteurs(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Récupérer tous les capteurs
            List<CapteurIoT> capteurs = capteurIoTService.findAll();
            if (capteurs == null) {
                capteurs = new java.util.ArrayList<>();
            }
            System.out.println("✅ Capteurs récupérés: " + capteurs.size());

            // Calculer les statistiques
            long totalCapteurs = capteurs.size();
            long capteursActifs = capteurs.stream().filter(CapteurIoT::isEtat).count();
            List donneesCapteursAll = donneeCapteurService.findAll();
            long totalDonnees = (donneesCapteursAll != null) ? donneesCapteursAll.size() : 0;

            request.setAttribute("capteurs", capteurs);
            request.setAttribute("totalCapteurs", totalCapteurs);
            request.setAttribute("capteursActifs", capteursActifs);
            request.setAttribute("totalDonnees", totalDonnees);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/capteur/list.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            System.out.println("❌ Erreur listCapteurs: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement des capteurs");
            request.setAttribute("capteurs", new java.util.ArrayList<>());
            request.setAttribute("totalCapteurs", 0);
            request.setAttribute("capteursActifs", 0);
            request.setAttribute("totalDonnees", 0);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/capteur/list.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setAttribute("typesCapteur", TypeCapteur.values());
            List<Utilisateur> utilisateurs = utilisateurService.findAll();
            if (utilisateurs == null) {
                utilisateurs = new java.util.ArrayList<>();
            }
            request.setAttribute("utilisateurs", utilisateurs);
            System.out.println("✅ Formulaire création - Types: " + TypeCapteur.values().length + ", Users: " + utilisateurs.size());

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/capteur/form.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            System.out.println("❌ Erreur showNewForm: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement du formulaire");
            request.setAttribute("typesCapteur", TypeCapteur.values());
            request.setAttribute("utilisateurs", new java.util.ArrayList<>());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/capteur/form.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Long id = Long.parseLong(request.getParameter("id"));
            System.out.println("📝 Modification capteur ID: " + id);

            CapteurIoT capteurExistant = capteurIoTService.findById(id);
            if (capteurExistant == null) {
                throw new ServletException("Capteur non trouvé: " + id);
            }

            request.setAttribute("capteur", capteurExistant);
            request.setAttribute("typesCapteur", TypeCapteur.values());
            request.setAttribute("utilisateurs", utilisateurService.findAll());

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/capteur/form.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            System.out.println("❌ Erreur showEditForm: " + e.getMessage());
            throw e;
        }
    }

    private void deleteCapteur(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Long id = Long.parseLong(request.getParameter("id"));
            CapteurIoT capteurASupprimer = capteurIoTService.findById(id);
            if (capteurASupprimer != null) {
                capteurIoTService.delete(capteurASupprimer);
                System.out.println("🗑️ Capteur supprimé: " + capteurASupprimer.getReference());
            }
            response.sendRedirect(request.getContextPath() + "/capteurs?success=true");
        } catch (Exception e) {
            System.out.println("❌ Erreur deleteCapteur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/capteurs?error=true");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== DEBUG CAPTEUR SERVLET (POST) ===");

        try {
            HttpSession session = request.getSession();
            Utilisateur user = (Utilisateur) session.getAttribute("user");

            if (user == null || !TypeUtilisateur.ADMINISTRATEUR.equals(user.getType())) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            String idParam = request.getParameter("id");

            // Récupération des paramètres
            String reference = request.getParameter("reference");
            TypeCapteur type = EnumUtil.parseEnum(TypeCapteur.class, request.getParameter("type"), TypeCapteur.DEBIT_EAU);
            String emplacement = request.getParameter("emplacement");
            boolean etat = "on".equals(request.getParameter("etat"));
            double seuilAlerte = Double.parseDouble(request.getParameter("seuilAlerte"));
            Long utilisateurId = Long.parseLong(request.getParameter("utilisateurId"));

            Utilisateur proprietaire = utilisateurService.findById(utilisateurId);
            if (proprietaire == null) {
                throw new ServletException("Utilisateur propriétaire non trouvé: " + utilisateurId);
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
                newCapteur.setDateInstallation(LocalDate.now());

                success = capteurIoTService.create(newCapteur);
                System.out.println("✅ Nouveau capteur créé: " + reference + " pour " + proprietaire.getNom());
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
                    System.out.println("✅ Capteur mis à jour: " + reference);
                } else {
                    success = false;
                    System.out.println("❌ Capteur non trouvé: " + id);
                }
            }

            if (success) {
                response.sendRedirect(request.getContextPath() + "/capteurs?success=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/capteurs?error=true");
            }

        } catch (Exception e) {
            System.out.println("❌ ERREUR POST CapteurServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/capteurs?error=true");
        }
    }
}