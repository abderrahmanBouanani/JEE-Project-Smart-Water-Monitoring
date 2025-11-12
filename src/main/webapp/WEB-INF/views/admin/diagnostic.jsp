<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diagnostic - Intégrité des Données</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <div class="row">
        <div class="col-12">
            <h1 class="mb-4">
                <i class="fas fa-stethoscope me-2"></i>Diagnostic - Intégrité des Données
            </h1>
        </div>
    </div>

    <!-- Statistiques Générales -->
    <div class="row mb-4">
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">
                        <i class="fas fa-faucet me-2 text-primary"></i>Total des Capteurs
                    </h5>
                    <p class="card-text">
                        <span class="badge bg-primary fs-5">${diagnostics.totalCapteurs}</span>
                    </p>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">
                        <i class="fas fa-exclamation-triangle me-2 text-danger"></i>Valeurs Enum Invalides
                    </h5>
                    <p class="card-text">
                        <c:choose>
                            <c:when test="${diagnostics.invalidEnumCount == 0}">
                                <span class="badge bg-success fs-5">✓ Aucune erreur</span>
                            </c:when>
                            <c:when test="${diagnostics.invalidEnumCount > 0}">
                                <span class="badge bg-danger fs-5">${diagnostics.invalidEnumCount} erreur(s)</span>
                                <div class="alert alert-warning mt-2 mb-0">
                                    <small>
                                        <strong>Action requise:</strong> Des capteurs contiennent des types invalides.
                                        Veuillez exécuter le script SQL de correction.
                                    </small>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-info fs-5">${diagnostics.invalidEnumCount}</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- Répartition par Type -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-chart-bar me-2"></i>Répartition par Type de Capteur
                    </h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty diagnostics.typeStats && diagnostics.typeStats.size() > 0}">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Type de Capteur</th>
                                        <th>Nombre</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="stat" items="${diagnostics.typeStats}">
                                        <tr>
                                            <td>
                                                <span class="badge bg-info">${stat[0]}</span>
                                            </td>
                                            <td>
                                                <span class="badge bg-secondary">${stat[1]}</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i>
                                Aucun capteur trouvé ou erreur lors de la récupération des données.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Types Enum Valides -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-check-circle me-2"></i>Types Enum Valides
                    </h5>
                </div>
                <div class="card-body">
                    <p class="text-muted">Les types suivants sont autorisés dans la base de données:</p>
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Types par Usage:</h6>
                            <ul class="list-unstyled">
                                <li><span class="badge bg-light text-dark">RESIDENTIEL</span> - Usage résidentiel</li>
                                <li><span class="badge bg-light text-dark">INDUSTRIEL</span> - Usage industriel</li>
                                <li><span class="badge bg-light text-dark">AGRICOLE</span> - Usage agricole</li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <h6>Types par Fonction:</h6>
                            <ul class="list-unstyled">
                                <li><span class="badge bg-light text-dark">DEBIT_EAU</span> - Mesure du débit</li>
                                <li><span class="badge bg-light text-dark">QUALITE_EAU</span> - Mesure de la qualité</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Actions -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card border-warning">
                <div class="card-header bg-warning">
                    <h5 class="mb-0">
                        <i class="fas fa-tools me-2"></i>Actions de Maintenance
                    </h5>
                </div>
                <div class="card-body">
                    <p>Pour corriger les données de la base de données, exécutez le script SQL suivant:</p>
                    <div class="alert alert-light border">
                        <code>
                            UPDATE capteurs SET `type` = 'DEBIT' WHERE `type` NOT IN
                            ('DEBIT', 'TEMPERATURE', 'PRESSION', 'QUALITE_EAU', 'RESIDENTIEL', 'INDUSTRIEL', 'AGRICOLE');
                        </code>
                    </div>
                    <p class="text-muted small">
                        Ce script remplace toutes les valeurs enum invalides par la valeur par défaut 'DEBIT'.
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- Retour -->
    <div class="row">
        <div class="col-12">
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-primary">
                <i class="fas fa-arrow-left me-1"></i>Retour au dashboard
            </a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

