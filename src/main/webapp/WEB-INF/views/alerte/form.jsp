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

        .container {
            max-width: 800px;
        }

        .header-section {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            border: 1px solid #e9ecef;
        }

        .system-name {
            color: #2c3e50;
            margin-bottom: 1rem;
        }

        .system-name h1 {
            font-size: 1.8rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .system-name p {
            color: #7f8c8d;
            margin: 0;
        }

        .form-card {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border: 1px solid #e9ecef;
        }

        .form-control {
            border-radius: 5px;
            padding: 0.75rem;
        }

        .form-label {
            font-weight: 500;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .form-select {
            border-radius: 5px;
            padding: 0.75rem;
        }

        .btn-primary {
            background-color: #3498db;
            border-color: #3498db;
            border-radius: 5px;
            font-weight: 500;
            padding: 0.75rem 1.5rem;
        }

        .btn-primary:hover {
            background-color: #2980b9;
            border-color: #2980b9;
        }

        .btn-outline-secondary {
            border-radius: 5px;
            padding: 0.75rem 1.5rem;
        }

        .form-section {
            margin-bottom: 2rem;
        }

        .form-section legend {
            font-size: 1.2rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #3498db;
            width: 100%;
        }

        .urgence-option {
            padding: 0.5rem;
            border-radius: 5px;
            margin-bottom: 0.25rem;
        }

        .urgence-critique {
            background-color: #ffeaea;
            border-left: 4px solid #e74c3c;
        }

        .urgence-elevee {
            background-color: #fff3e0;
            border-left: 4px solid #e67e22;
        }

        .urgence-moyenne {
            background-color: #fff9e6;
            border-left: 4px solid #f39c12;
        }

        .urgence-faible {
            background-color: #e8f5e8;
            border-left: 4px solid #27ae60;
        }

        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- En-tête avec nom du système -->
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
                <c:if test="${not empty alerte}">
                    <input type="hidden" name="idAlerte" value="${alerte.idAlerte}"/>
                </c:if>

                <fieldset class="form-section">
                    <legend>Détails de l'Alerte</legend>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="type" class="form-label">Type d'alerte</label>
                            <select id="type" name="type" class="form-select" required>
                                <option value="">Sélectionner un type</option>
                                <option value="FUITE" ${alerte.type == 'FUITE' ? 'selected' : ''}>Fuite d'eau</option>
                                <option value="PRESSION" ${alerte.type == 'PRESSION' ? 'selected' : ''}>Problème de pression</option>
                                <option value="QUALITE" ${alerte.type == 'QUALITE' ? 'selected' : ''}>Qualité de l'eau</option>
                                <option value="CAPTEUR" ${alerte.type == 'CAPTEUR' ? 'selected' : ''}>Défaillance capteur</option>
                                <option value="SYSTEME" ${alerte.type == 'SYSTEME' ? 'selected' : ''}>Problème système</option>
                                <option value="MAINTENANCE" ${alerte.type == 'MAINTENANCE' ? 'selected' : ''}>Maintenance</option>
                                <option value="SECURITE" ${alerte.type == 'SECURITE' ? 'selected' : ''}>Sécurité</option>
                            </select>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="niveauUrgence" class="form-label">Niveau d'urgence</label>
                            <select id="niveauUrgence" name="niveauUrgence" class="form-select" required>
                                <option value="">Sélectionner un niveau</option>
                                <option value="FAIBLE" ${alerte.niveauUrgence == 'FAIBLE' ? 'selected' : ''} class="urgence-faible">Faible</option>
                                <option value="MOYENNE" ${alerte.niveauUrgence == 'MOYENNE' ? 'selected' : ''} class="urgence-moyenne">Moyenne</option>
                                <option value="ÉLEVÉE" ${alerte.niveauUrgence == 'ÉLEVÉE' ? 'selected' : ''} class="urgence-elevee">Élevée</option>
                                <option value="CRITIQUE" ${alerte.niveauUrgence == 'CRITIQUE' ? 'selected' : ''} class="urgence-critique">Critique</option>
                            </select>
                        </div>
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

                    <c:if test="${not empty alerte}">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Statut</label>
                                <div class="form-check">
                                    <input class="form-check-input"
                                           type="checkbox"
                                           id="estLue"
                                           name="estLue"
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

    <script>
        // Focus sur le premier champ
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('type').focus();

            // Ajouter des classes CSS aux options de niveau d'urgence
            const niveauUrgenceSelect = document.getElementById('niveauUrgence');
            if (niveauUrgenceSelect) {
                // Appliquer les styles aux options existantes
                const options = niveauUrgenceSelect.options;
                for (let i = 0; i < options.length; i++) {
                    const option = options[i];
                    if (option.value === 'CRITIQUE') {
                        option.classList.add('urgence-critique');
                    } else if (option.value === 'ÉLEVÉE') {
                        option.classList.add('urgence-elevee');
                    } else if (option.value === 'MOYENNE') {
                        option.classList.add('urgence-moyenne');
                    } else if (option.value === 'FAIBLE') {
                        option.classList.add('urgence-faible');
                    }
                }
            }
        });
    </script>
</body>
</html>

