<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Capteurs - Smart Water Monitoring</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .header-section {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
            margin-bottom: 1rem;
        }
        .content-card {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .btn-primary {
            background-color: #3498db;
            border-color: #3498db;
        }
        .table th {
            background-color: #3498db;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <!-- En-tête -->
        <div class="header-section">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="mb-1">📡 Gestion des Capteurs</h1>
                    <p class="text-muted mb-0">Administration des capteurs connectés</p>
                </div>
                <a href="${pageContext.request.contextPath}/capteurs?action=new" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>Nouveau Capteur
                </a>
            </div>
        </div>

        <!-- Messages -->
        <c:if test="${param.success != null}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="fas fa-check-circle me-2"></i>
                Opération réalisée avec succès.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="fas fa-exclamation-triangle me-2"></i>
                Une erreur est survenue lors de l'opération.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Statistiques -->
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="stat-card">
                    <div class="text-primary mb-2">
                        <i class="fas fa-microchip fa-2x"></i>
                    </div>
                    <h3 class="text-primary">${totalCapteurs}</h3>
                    <p class="text-muted mb-0">Total Capteurs</p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="stat-card">
                    <div class="text-success mb-2">
                        <i class="fas fa-check-circle fa-2x"></i>
                    </div>
                    <h3 class="text-success">${capteursActifs}</h3>
                    <p class="text-muted mb-0">Capteurs Actifs</p>
                </div>
            </div>

        </div>

        <!-- Liste des capteurs -->
        <div class="content-card">
            <c:choose>
                <c:when test="${not empty capteurs && capteurs.size() > 0}">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Référence</th>
                                    <th>Type</th>
                                    <th>Emplacement</th>
                                    <th>Propriétaire</th>
                                    <th>État</th>
                                    <th>Seuil Alerte</th>
                                    <th>Date Installation</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="capteur" items="${capteurs}">
                                    <tr>
                                        <td><strong>#${capteur.idCapteur}</strong></td>
                                        <td>
                                            <strong>${capteur.reference}</strong>
                                        </td>
                                        <td>
                                            <span class="badge bg-info">${capteur.type}</span>
                                        </td>
                                        <td>${capteur.emplacement}</td>
                                        <td>
                                            <c:if test="${capteur.utilisateur != null}">
                                                <div class="fw-medium">${capteur.utilisateur.nom}</div>
                                                <small class="text-muted">${capteur.utilisateur.email}</small>
                                            </c:if>
                                            <c:if test="${capteur.utilisateur == null}">
                                                <span class="text-muted">-</span>
                                            </c:if>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${capteur.etat}">
                                                    <span class="badge bg-success">
                                                        <i class="fas fa-check me-1"></i>Actif
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">
                                                        <i class="fas fa-times me-1"></i>Inactif
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="badge bg-warning">${capteur.seuilAlerte}</span>
                                        </td>
                                        <td>${capteur.dateInstallation}</td>
                                        <td>
                                            <div class="btn-group btn-group-sm">
                                                <a href="${pageContext.request.contextPath}/capteurs?action=edit&id=${capteur.idCapteur}"
                                                   class="btn btn-outline-primary" title="Modifier">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/capteurs?action=delete&id=${capteur.idCapteur}"
                                                   class="btn btn-outline-danger"
                                                   onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce capteur ?')"
                                                   title="Supprimer">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center text-muted py-5">
                        <i class="fas fa-microchip fa-3x mb-3"></i>
                        <h4>📭 Aucun capteur</h4>
                        <p class="mb-4">Aucun capteur n'a été configuré dans le système.</p>
                        <a href="${pageContext.request.contextPath}/capteurs?action=new" class="btn btn-primary">
                            <i class="fas fa-plus me-2"></i>Ajouter le premier capteur
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Navigation -->
        <div class="mt-4 text-center">
            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i>Retour à l'accueil
            </a>
        </div>


    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>