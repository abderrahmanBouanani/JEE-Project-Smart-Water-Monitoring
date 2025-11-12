<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistiques de Consommation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .debug-info {
            font-size: 0.8rem;
        }
    </style>
</head>
<body>

            <!-- Main Content -->
            <main class=" px-md-4">
                <!-- Header -->
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">
                        <i class="fas fa-chart-bar me-2"></i>Statistiques de Consommation
                    </h1>
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-primary">
                        <i class="fas fa-arrow-left me-1"></i>Retour au dashboard
                    </a>
                </div>

                <!-- Debug Info -->
                <div class="alert alert-info debug-info">
                    <strong>Debug:</strong>
                    User ID: ${userId} |
                    Statistiques: ${statistiques.size()} |
                    Moyenne: ${consommationMoyenne}L |
                    Totale: ${consommationTotale}L
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <strong>Erreur:</strong> ${error}
                    </div>
                </c:if>

                <!-- Statistiques Résumées -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="stat-card text-center">
                            <div class="text-primary mb-2">
                                <i class="fas fa-tint fa-2x"></i>
                            </div>
                            <h3 class="text-primary">
                                <c:choose>
                                    <c:when test="${not empty consommationMoyenne}">
                                        ${consommationMoyenne}L
                                    </c:when>
                                    <c:otherwise>
                                        -
                                    </c:otherwise>
                                </c:choose>
                            </h3>
                            <p class="text-muted mb-0">Consommation Moyenne</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-card text-center">
                            <div class="text-success mb-2">
                                <i class="fas fa-chart-line fa-2x"></i>
                            </div>
                            <h3 class="text-success">
                                <c:choose>
                                    <c:when test="${not empty consommationTotale}">
                                        ${consommationTotale}L
                                    </c:when>
                                    <c:otherwise>
                                        -
                                    </c:otherwise>
                                </c:choose>
                            </h3>
                            <p class="text-muted mb-0">Consommation Totale</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-card text-center">
                            <div class="text-info mb-2">
                                <i class="fas fa-database fa-2x"></i>
                            </div>
                            <h3 class="text-info">${statistiques.size()}</h3>
                            <p class="text-muted mb-0">Analyses Stockées</p>
                        </div>
                    </div>
                </div>

                <!-- Graphiques -->
                <div class="row">
                    <!-- Graphique Consommation Quotidienne -->
                    <div class="col-md-6">
                        <div class="stat-card">
                            <h5 class="card-title">
                                <i class="fas fa-chart-line me-2 text-primary"></i>Consommation Quotidienne
                            </h5>
                            <canvas id="dailyChart" height="250"></canvas>
                        </div>
                    </div>

                    <!-- Graphique Consommation Mensuelle -->
                    <div class="col-md-6">
                        <div class="stat-card">
                            <h5 class="card-title">
                                <i class="fas fa-chart-bar me-2 text-success"></i>Consommation Mensuelle
                            </h5>
                            <canvas id="monthlyChart" height="250"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Liste des Statistiques Détaillées -->
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="stat-card">
                            <h5 class="card-title">
                                <i class="fas fa-table me-2 text-info"></i>Statistiques Détaillées
                            </h5>

                            <c:choose>
                                <c:when test="${not empty statistiques && statistiques.size() > 0}">
                                    <div class="table-responsive">
                                        <table class="table table-striped">
                                            <thead>
                                                <tr>
                                                    <th>Type</th>
                                                    <th>Valeur</th>
                                                    <th>Période</th>
                                                    <th>Date de Génération</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="stat" items="${statistiques}">
                                                    <tr>
                                                        <td>${stat.type}</td>
                                                        <td>
                                                            <strong>${stat.valeur}</strong>
                                                            <c:if test="${stat.type.contains('CONSOMMATION')}">L</c:if>
                                                            <c:if test="${stat.type.contains('COUT')}">€</c:if>
                                                        </td>
                                                        <td>${stat.periode}</td>
                                                        <td>${stat.dateGeneration}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center text-muted py-4">
                                        <i class="fas fa-chart-bar fa-3x mb-3"></i>
                                        <h5>Aucune statistique disponible</h5>
                                        <p>Les statistiques seront générées automatiquement avec l'utilisation du système.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Initialisation des graphiques avec les données du serveur
        document.addEventListener('DOMContentLoaded', function() {
            // Données du serveur (passées depuis le Servlet)
            const dailyData = {
                labels: ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'],
                datasets: [{
                    label: 'Consommation (L)',
                    data: [
                        <c:forEach var="valeur" items="${donneesQuotidiennes}" varStatus="status">
                        ${valeur}<c:if test="${!status.last}">, </c:if>
                        </c:forEach>
                    ],
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 2,
                    tension: 0.4
                }]
            };

            const monthlyData = {
                labels: ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun'],
                datasets: [{
                    label: 'Consommation (L)',
                    data: [
                        <c:forEach var="valeur" items="${donneesMensuelles}" varStatus="status">
                        ${valeur}<c:if test="${!status.last}">, </c:if>
                        </c:forEach>
                    ],
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 2
                }]
            };

            // Graphique quotidien
            const dailyCtx = document.getElementById('dailyChart').getContext('2d');
            new Chart(dailyCtx, {
                type: 'line',
                data: dailyData,
                options: {
                    responsive: true,
                    plugins: {
                        legend: { display: false }
                    }
                }
            });

            // Graphique mensuel
            const monthlyCtx = document.getElementById('monthlyChart').getContext('2d');
            new Chart(monthlyCtx, {
                type: 'bar',
                data: monthlyData,
                options: {
                    responsive: true,
                    plugins: {
                        legend: { display: false }
                    }
                }
            });
        });
    </script>
</body>
</html>