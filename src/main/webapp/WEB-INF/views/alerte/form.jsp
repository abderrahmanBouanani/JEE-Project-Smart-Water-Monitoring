<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty alerte ? 'Créer une nouvelle' : 'Modifier l\''} Alerte - Smart Water Monitoring</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px;
        }
        .container { max-width: 800px; }
        .header-section, .form-card {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            border: 1px solid #e9ecef;
        }
        .btn-primary { background-color: #3498db; border-color: #3498db; }
        .form-section { margin-bottom: 2rem; }
        .form-section legend {
            font-size: 1.2rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #3498db;
        }
        textarea.form-control { min-height: 120px; resize: vertical; }
    </style>
</head>
<body>
    <div class="container">
        <!-- En-tête -->
        <div class="header-section">
            <div class="system-name">
                <h1>Smart Water Monitoring</h1>
                <p>Gestion des alertes système</p>
            </div>
            <h2 class="mb-0">
                <i class="fas ${empty alerte ? 'fa-bell' : 'fa-edit'} me-2"></i>
                ${empty alerte ? 'Créer une nouvelle' : 'Modifier l\''} Alerte
            </h2>
        </div>

        <!-- Formulaire -->
        <div class="form-card">
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/alertes" method="post">
                <!-- ✅ CORRECTION : Utiliser "id" au lieu de "idAlerte" -->
                <c:if test="${not empty alerte}">
                    <input type="hidden" name="id" value="${alerte.idAlerte}"/>
                </c:if>

                <fieldset class="form-section">
                    <legend>Détails de l'Alerte</legend>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="type" class="form-label">Type d'alerte</label>
                            <select id="type" name="type" class="form-select" required>
                                <option value="">Sélectionner un type</option>
                                <!-- ✅ CORRECTION : Utiliser les valeurs de l'enum TypeAlerte -->
                                <option value="SEUIL_DEPASSE" ${alerte.type == 'SEUIL_DEPASSE' ? 'selected' : ''}>Seuil dépassé</option>
                                <option value="FUITE_DETECTEE" ${alerte.type == 'FUITE_DETECTEE' ? 'selected' : ''}>Fuite détectée</option>
                                <option value="CAPTEUR_OFFLINE" ${alerte.type == 'CAPTEUR_OFFLINE' ? 'selected' : ''}>Capteur offline</option>
                            </select>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="niveauUrgence" class="form-label">Niveau d'urgence</label>
                            <select id="niveauUrgence" name="niveauUrgence" class="form-select" required>
                                <option value="">Sélectionner un niveau</option>
                                <option value="FAIBLE" ${alerte.niveauUrgence == 'FAIBLE' ? 'selected' : ''}>Faible</option>
                                <option value="MOYEN" ${alerte.niveauUrgence == 'MOYEN' ? 'selected' : ''}>Moyen</option>
                                <option value="ELEVE" ${alerte.niveauUrgence == 'ELEVE' ? 'selected' : ''}>Élevé</option>
                                <option value="CRITIQUE" ${alerte.niveauUrgence == 'CRITIQUE' ? 'selected' : ''}>Critique</option>
                            </select>
                        </div>
                    </div>

                    <!-- ✅ CORRECTION : Ajouter la sélection d'utilisateur -->
                    <div class="mb-3">
                        <label for="utilisateurId" class="form-label">Utilisateur concerné</label>
                        <select id="utilisateurId" name="utilisateurId" class="form-select" required>
                            <option value="">Sélectionner un utilisateur</option>
                            <c:forEach var="utilisateur" items="${utilisateurs}">
                                <option value="${utilisateur.idUtilisateur}"
                                    ${alerte.utilisateur != null && alerte.utilisateur.idUtilisateur == utilisateur.idUtilisateur ? 'selected' : ''}>
                                    ${utilisateur.nom} (${utilisateur.email})
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="message" class="form-label">Message de l'alerte</label>
                        <textarea
                            id="message"
                            name="message"
                            class="form-control"
                            placeholder="Décrivez l'alerte en détail..."
                            required
                            rows="4">${alerte.message}</textarea>
                    </div>

                    <!-- ✅ CORRECTION : Afficher seulement en mode édition -->
                    <c:if test="${not empty alerte}">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Statut</label>
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" role="switch"
                                           id="estLue" name="estLue" value="true"
                                           ${alerte.estLue ? 'checked' : ''}>
                                    <label class="form-check-label" for="estLue">
                                        Alerte lue
                                    </label>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Date de création</label>
                                <p class="form-control-plaintext">${alerte.dateCreation}</p>
                            </div>
                        </div>
                    </c:if>
                </fieldset>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i>${empty alerte ? 'Créer l\'alerte' : 'Enregistrer les modifications'}
                    </button>
                    <a href="${pageContext.request.contextPath}/alertes" class="btn btn-outline-secondary">
                        <i class="fas fa-times me-2"></i>Annuler
                    </a>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>