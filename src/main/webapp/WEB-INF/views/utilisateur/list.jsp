<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Utilisateurs - Smart Water Monitoring</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
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

        .content-card {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border: 1px solid #e9ecef;
        }

        .btn-primary {
            background-color: #3498db;
            border-color: #3498db;
            border-radius: 5px;
            font-weight: 500;
        }

        .btn-primary:hover {
            background-color: #2980b9;
            border-color: #2980b9;
        }

        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }

        .table {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0 0 1px #e9ecef;
        }

        .table thead th {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 1rem;
            font-weight: 500;
        }

        .table tbody td {
            padding: 1rem;
            vertical-align: middle;
            border-color: #e9ecef;
        }

        .actions-column {
            white-space: nowrap;
        }

        .badge-admin {
            background-color: #e74c3c;
            color: white;
        }

        .badge-citoyen {
            background-color: #27ae60;
            color: white;
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
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

            <div class="d-flex justify-content-between align-items-center">
                <h2 class="mb-0">Liste des Utilisateurs</h2>
                <a href="${pageContext.request.contextPath}/utilisateurs?action=new" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>Créer un utilisateur
                </a>
            </div>
        </div>

        <!-- Contenu principal -->
        <div class="content-card">
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nom</th>
                            <th>Email</th>
                            <th>Adresse</th>
                            <th>Type</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="utilisateur" items="${utilisateurs}">
                            <tr>
                                <td><strong>${utilisateur.idUtilisateur}</strong></td>
                                <td>${utilisateur.nom}</td>
                                <td>${utilisateur.email}</td>
                                <td>${utilisateur.adresse}</td>
                                <td>
                                    <span class="badge ${utilisateur.type == 'ADMINISTRATEUR' ? 'badge-admin' : 'badge-citoyen'}">
                                        ${utilisateur.type}
                                    </span>
                                </td>
                                <td class="actions-column">
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/utilisateurs?action=edit&id=${utilisateur.idUtilisateur}"
                                           class="btn btn-outline-primary btn-sm">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/utilisateurs?action=delete&id=${utilisateur.idUtilisateur}"
                                           class="btn btn-outline-danger btn-sm"
                                           onclick="return confirm('Êtes-vous sûr de vouloir supprimer cet utilisateur ?')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Retour à l'accueil
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>