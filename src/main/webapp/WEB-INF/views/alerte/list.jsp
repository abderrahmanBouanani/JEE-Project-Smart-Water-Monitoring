<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Alertes - Smart Water Monitoring</title>
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

        .badge-urgence-critique {
            background-color: #e74c3c;
            color: white;
        }

        .badge-urgence-elevee {
            background-color: #e67e22;
            color: white;
        }

        .badge-urgence-moyenne {
            background-color: #f39c12;
            color: white;
        }

        .badge-urgence-faible {
            background-color: #27ae60;
            color: white;
        }

        .badge-lue {
            background-color: #27ae60;
            color: white;
        }

        .badge-non-lue {
            background-color: #e74c3c;
            color: white;
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .alerte-non-lue {
            background-color: #fff5f5;
            font-weight: 500;
        }

        .statut-lue {
            display: inline-block;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            text-align: center;
            line-height: 20px;
            font-size: 0.75rem;
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

            <div class="d-flex justify-content-between align-items-center">
                <h2 class="mb-0">Liste des Alertes</h2>
                <a href="${pageContext.request.contextPath}/alertes?action=new" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>Créer une alerte
                </a>
            </div>
        </div>

        <!-- Contenu principal -->
        <div class="content-card">
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Type</th>
                            <th>Message</th>
                            <th>Date</th>
                            <th>Niveau</th>
                            <th>Statut</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="alerte" items="${alertes}">
                            <tr class="${alerte.estLue ? '' : 'alerte-non-lue'}">
                                <td><strong>${alerte.idAlerte}</strong></td>
                                <td>${alerte.type}</td>
                                <td>${alerte.message}</td>
                                <td>${alerte.dateCreation}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${alerte.niveauUrgence == 'CRITIQUE'}">
                                            <span class="badge badge-urgence-critique">${alerte.niveauUrgence}</span>
                                        </c:when>
                                        <c:when test="${alerte.niveauUrgence == 'ÉLEVÉE'}">
                                            <span class="badge badge-urgence-elevee">${alerte.niveauUrgence}</span>
                                        </c:when>
                                        <c:when test="${alerte.niveauUrgence == 'MOYENNE'}">
                                            <span class="badge badge-urgence-moyenne">${alerte.niveauUrgence}</span>
                                        </c:when>
                                        <c:when test="${alerte.niveauUrgence == 'FAIBLE'}">
                                            <span class="badge badge-urgence-faible">${alerte.niveauUrgence}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">${alerte.niveauUrgence}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${alerte.estLue}">
                                            <span class="badge badge-lue">Lue</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-non-lue">Non lue</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="actions-column">
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/alertes?action=edit&id=${alerte.idAlerte}"
                                           class="btn btn-outline-primary btn-sm"
                                           title="Modifier">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/alertes?action=delete&id=${alerte.idAlerte}"
                                           class="btn btn-outline-danger btn-sm"
                                           onclick="return confirm('Êtes-vous sûr de vouloir supprimer cette alerte ?')"
                                           title="Supprimer">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                        <c:if test="${not alerte.estLue}">
                                            <a href="${pageContext.request.contextPath}/alertes?action=marquerLue&id=${alerte.idAlerte}"
                                               class="btn btn-outline-success btn-sm"
                                               title="Marquer comme lue">
                                                <i class="fas fa-check"></i>
                                            </a>
                                        </c:if>
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