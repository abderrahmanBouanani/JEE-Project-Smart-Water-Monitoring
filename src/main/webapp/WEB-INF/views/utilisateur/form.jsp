<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty utilisateur ? 'Créer un nouvel' : 'Modifier l\''} Utilisateur - Smart Water Monitoring</title>
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

        .password-note {
            font-size: 0.875rem;
            color: #6c757d;
            font-style: italic;
            margin-top: 0.25rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- En-tête avec nom du système -->
        <div class="header-section">
            <div class="system-name">
                <h1>Smart Water Monitoring</h1>
                <p>Gestion des utilisateurs</p>
            </div>

            <h2 class="mb-0">
                <i class="fas ${empty utilisateur ? 'fa-user-plus' : 'fa-user-edit'} me-2"></i>
                ${empty utilisateur ? 'Créer un nouvel' : 'Modifier l\''} Utilisateur
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

            <form action="${pageContext.request.contextPath}/utilisateurs" method="post">
                <c:if test="${not empty utilisateur}">
                    <input type="hidden" name="id" value="${utilisateur.idUtilisateur}"/>
                </c:if>

                <fieldset class="form-section">
                    <legend>Détails de l'Utilisateur</legend>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="nom" class="form-label">Nom complet</label>
                            <input type="text"
                                   id="nom"
                                   name="nom"
                                   class="form-control"
                                   value="${utilisateur.nom}"
                                   placeholder="Nom complet de l'utilisateur"
                                   required>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email"
                                   id="email"
                                   name="email"
                                   class="form-control"
                                   value="${utilisateur.email}"
                                   placeholder="adresse@email.com"
                                   required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="motDePasse" class="form-label">Mot de passe</label>
                            <input type="password"
                                   id="motDePasse"
                                   name="motDePasse"
                                   class="form-control"
                                   placeholder="${not empty utilisateur ? 'Laisser vide pour ne pas changer' : 'Saisir le mot de passe'}">
                            <c:if test="${not empty utilisateur}">
                                <div class="password-note">
                                    Laisser vide pour conserver le mot de passe actuel
                                </div>
                            </c:if>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="type" class="form-label">Type d'utilisateur</label>
                            <select id="type" name="type" class="form-select">
                                <c:forEach var="type" items="${typesUtilisateur}">
                                    <option value="${type}" ${utilisateur.type == type ? 'selected' : ''}>
                                        ${type}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="adresse" class="form-label">Adresse</label>
                        <input type="text"
                               id="adresse"
                               name="adresse"
                               class="form-control"
                               value="${utilisateur.adresse}"
                               placeholder="Adresse complète de l'utilisateur">
                    </div>
                </fieldset>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i>Enregistrer
                    </button>
                    <a href="${pageContext.request.contextPath}/utilisateurs" class="btn btn-outline-secondary">
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
            document.getElementById('nom').focus();
        });
    </script>
</body>
</html>