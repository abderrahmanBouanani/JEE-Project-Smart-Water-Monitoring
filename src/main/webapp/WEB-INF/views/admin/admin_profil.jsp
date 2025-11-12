<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Profil Administrateur - Smart Water Monitoring</title>
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

        .profile-card {
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

        .profile-details p {
            padding: 0.75rem 0;
            border-bottom: 1px solid #e9ecef;
            margin: 0;
        }

        .profile-details p:last-child {
            border-bottom: none;
        }

        .profile-info {
            font-weight: 500;
            color: #2c3e50;
            min-width: 150px;
            display: inline-block;
        }

        .password-note {
            font-size: 0.875rem;
            color: #6c757d;
            font-style: italic;
            margin-top: 0.25rem;
        }

        .admin-badge {
            background-color: #e74c3c;
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
            font-size: 0.875rem;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- En-tête avec nom du système -->
        <div class="header-section">
            <div class="system-name">
                <h1>Smart Water Monitoring</h1>
                <p>Gestion du profil administrateur</p>
            </div>

            <h2 class="mb-0">
                <i class="fas fa-user-shield me-2"></i>
                Mon Profil Administrateur
            </h2>
        </div>

        <!-- Messages -->
        <c:if test="${param.success == 'true'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>Profil mis à jour avec succès !
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Contenu du profil -->
        <div class="profile-card">
            <c:choose>
                <c:when test="${editMode}">
                    <!-- Mode Édition -->
                    <h4 class="mb-4">
                        <i class="fas fa-edit me-2"></i>Modifier mon Profil
                    </h4>

                    <form action="${pageContext.request.contextPath}/admin/profil" method="post">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="nom" class="form-label">Nom complet</label>
                                <input type="text"
                                       id="nom"
                                       name="nom"
                                       class="form-control"
                                       value="${adminUser.nom}"
                                       placeholder="Votre nom complet"
                                       required>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email"
                                       id="email"
                                       name="email"
                                       class="form-control"
                                       value="${adminUser.email}"
                                       placeholder="votre@email.com"
                                       required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="adresse" class="form-label">Adresse</label>
                            <input type="text"
                                   id="adresse"
                                   name="adresse"
                                   class="form-control"
                                   value="${adminUser.adresse}"
                                   placeholder="Votre adresse">
                        </div>

                        <div class="mb-4">
                            <label for="motDePasse" class="form-label">Nouveau mot de passe</label>
                            <input type="password"
                                   id="motDePasse"
                                   name="motDePasse"
                                   class="form-control"
                                   placeholder="Laisser vide pour ne pas changer">
                            <div class="password-note">
                                Laisser vide pour conserver le mot de passe actuel
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>Enregistrer les modifications
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/profil" class="btn btn-outline-secondary">
                                <i class="fas fa-times me-2"></i>Annuler
                            </a>
                        </div>
                    </form>
                </c:when>
                <c:otherwise>
                    <!-- Mode Lecture -->
                    <h4 class="mb-4">
                        <i class="fas fa-user me-2"></i>Informations du profil
                    </h4>

                    <div class="profile-details">
                        <p>
                            <span class="profile-info">Nom :</span>
                            ${adminUser.nom}
                        </p>
                        <p>
                            <span class="profile-info">Email :</span>
                            ${adminUser.email}
                        </p>
                        <p>
                            <span class="profile-info">Adresse :</span>
                            ${adminUser.adresse}
                        </p>
                        <p>
                            <span class="profile-info">Type de compte :</span>
                            <span class="admin-badge">${adminUser.type}</span>
                        </p>
                        <p>
                            <span class="profile-info">Date d'inscription :</span>
                            ${adminUser.dateInscription}
                        </p>
                    </div>

                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/admin/profil?action=edit" class="btn btn-primary">
                            <i class="fas fa-edit me-2"></i>Modifier mon profil
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="mt-4 pt-3 border-top">
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Retour à l'accueil Admin
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>