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
        .chart-container {
            position: relative;
            height: 300px;
            width: 100%;
            max-width: 100%;
        }
        .stat-card canvas {
            max-height: 300px !important;
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

                <!-- Contrôles de rafraîchissement -->
                <div class="row mb-3">
                    <div class="col-12">
                        <div class="stat-card">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <i class="fas fa-sync-alt me-2"></i>
                                    <span id="lastUpdate">Dernière mise à jour: Maintenant</span>
                                </div>
                                <div>
                                    <button id="refreshBtn" class="btn btn-sm btn-primary" onclick="refreshCharts()">
                                        <i class="fas fa-sync-alt me-1"></i>Rafraîchir
                                    </button>
                                    <div class="form-check form-switch d-inline-block ms-3">
                                        <input class="form-check-input" type="checkbox" id="autoRefreshSwitch" checked>
                                        <label class="form-check-label" for="autoRefreshSwitch">
                                            Auto-refresh (30s)
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Graphiques -->
                <div class="row">
                    <!-- Graphique Consommation Quotidienne -->
                    <div class="col-md-6 mb-4">
                        <div class="stat-card">
                            <h5 class="card-title mb-3">
                                <i class="fas fa-chart-line me-2 text-primary"></i>Consommation Quotidienne
                                <span class="badge bg-primary ms-2">7 derniers jours</span>
                            </h5>
                            <div class="chart-container">
                                <canvas id="dailyChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- Graphique Consommation Mensuelle -->
                    <div class="col-md-6 mb-4">
                        <div class="stat-card">
                            <h5 class="card-title mb-3">
                                <i class="fas fa-chart-bar me-2 text-success"></i>Consommation Mensuelle
                                <span class="badge bg-success ms-2">6 derniers mois</span>
                            </h5>
                            <div class="chart-container">
                                <canvas id="monthlyChart"></canvas>
                            </div>
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
        // Initialisation des graphiques avec les données DYNAMIQUES du serveur
        document.addEventListener('DOMContentLoaded', function() {
            console.log('📊 Initialisation des graphiques avec les données réelles...');
            
            // Initialiser les graphiques
            initializeCharts();
            
            // Configuration de l'auto-refresh
            setupAutoRefresh();
        });

        // Variables globales pour les graphiques
        let dailyChart = null;
        let monthlyChart = null;
        let autoRefreshInterval = null;

        /**
         * Fonction pour rafraîchir les graphiques avec les données en temps réel
         */
        function refreshCharts() {
            console.log('🔄 Rafraîchissement des graphiques...');
            const btn = document.getElementById('refreshBtn');
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Chargement...';

            // Appel AJAX pour récupérer les nouvelles données
            fetch('${pageContext.request.contextPath}/api/consumption/data')
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        console.log('✅ Nouvelles données reçues:', data);

                        // Mettre à jour le graphique quotidien
                        if (dailyChart && data.daily) {
                            dailyChart.data.labels = data.daily.labels;
                            dailyChart.data.datasets[0].data = data.daily.data;
                            dailyChart.update('active');
                            console.log('📈 Graphique quotidien mis à jour');
                        }

                        // Mettre à jour le graphique mensuel
                        if (monthlyChart && data.monthly) {
                            monthlyChart.data.labels = data.monthly.labels;
                            monthlyChart.data.datasets[0].data = data.monthly.data;
                            monthlyChart.update('active');
                            console.log('📊 Graphique mensuel mis à jour');
                        }

                        // Mettre à jour l'heure de la dernière mise à jour
                        updateLastRefreshTime();
                    } else {
                        console.error('❌ Erreur lors du rafraîchissement:', data.error);
                    }
                })
                .catch(error => {
                    console.error('❌ Erreur AJAX:', error);
                })
                .finally(() => {
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fas fa-sync-alt me-1"></i>Rafraîchir';
                });
        }

        /**
         * Met à jour l'heure de la dernière mise à jour
         */
        function updateLastRefreshTime() {
            const now = new Date();
            const timeString = now.toLocaleTimeString('fr-FR');
            document.getElementById('lastUpdate').textContent = 'Dernière mise à jour: ' + timeString;
        }

        /**
         * Configure le système d'auto-refresh
         */
        function setupAutoRefresh() {
            const autoRefreshSwitch = document.getElementById('autoRefreshSwitch');
            
            autoRefreshSwitch.addEventListener('change', function() {
                if (this.checked) {
                    console.log('✅ Auto-refresh activé (toutes les 30 secondes)');
                    autoRefreshInterval = setInterval(refreshCharts, 30000); // 30 secondes
                } else {
                    console.log('❌ Auto-refresh désactivé');
                    if (autoRefreshInterval) {
                        clearInterval(autoRefreshInterval);
                        autoRefreshInterval = null;
                    }
                }
            });

            // Démarrer l'auto-refresh si activé par défaut
            if (autoRefreshSwitch.checked) {
                autoRefreshInterval = setInterval(refreshCharts, 30000);
            }
        }

        /**
         * Réinitialisation des graphiques avec les données initiales
         */
        function initializeCharts() {
            // Cette fonction est appelée au chargement de la page
            const dailyCtx = document.getElementById('dailyChart').getContext('2d');
            const monthlyCtx = document.getElementById('monthlyChart').getContext('2d');

            // Données RÉELLES du serveur
            const dailyDataValues = [
                <c:forEach var="valeur" items="${donneesQuotidiennes}" varStatus="status">
                ${valeur}<c:if test="${!status.last}">, </c:if>
                </c:forEach>
            ];

            const monthlyDataValues = [
                <c:forEach var="valeur" items="${donneesMensuelles}" varStatus="status">
                ${valeur}<c:if test="${!status.last}">, </c:if>
                </c:forEach>
            ];

            // Créer les graphiques
            dailyChart = new Chart(dailyCtx, {
                type: 'line',
                data: {
                    labels: getDailyLabels(),
                    datasets: [{
                        label: 'Consommation (L)',
                        data: dailyDataValues,
                        backgroundColor: 'rgba(54, 162, 235, 0.2)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 2,
                        tension: 0.4,
                        fill: true,
                        pointRadius: 4,
                        pointHoverRadius: 6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    aspectRatio: 2,
                    animation: {
                        duration: 750
                    },
                    interaction: {
                        mode: 'index',
                        intersect: false
                    },
                    plugins: {
                        legend: { 
                            display: true,
                            position: 'top',
                            labels: {
                                boxWidth: 20,
                                padding: 15
                            }
                        },
                        tooltip: {
                            mode: 'index',
                            intersect: false,
                            callbacks: {
                                label: function(context) {
                                    return 'Consommation: ' + context.parsed.y.toFixed(2) + ' L';
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return value + ' L';
                                }
                            },
                            grid: {
                                color: 'rgba(0, 0, 0, 0.05)'
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            }
                        }
                    }
                }
            });

            monthlyChart = new Chart(monthlyCtx, {
                type: 'bar',
                data: {
                    labels: getMonthlyLabels(),
                    datasets: [{
                        label: 'Consommation (L)',
                        data: monthlyDataValues,
                        backgroundColor: 'rgba(75, 192, 192, 0.6)',
                        borderColor: 'rgba(75, 192, 192, 1)',
                        borderWidth: 2,
                        borderRadius: 5,
                        borderSkipped: false
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    aspectRatio: 2,
                    animation: {
                        duration: 750
                    },
                    plugins: {
                        legend: { 
                            display: true,
                            position: 'top',
                            labels: {
                                boxWidth: 20,
                                padding: 15
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return 'Consommation: ' + context.parsed.y.toFixed(2) + ' L';
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return value + ' L';
                                }
                            },
                            grid: {
                                color: 'rgba(0, 0, 0, 0.05)'
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            }
                        }
                    }
                }
            });
        }

        // Fonctions utilitaires pour les labels
        function getDailyLabels() {
            const labels = [];
            const days = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
            const today = new Date();
            
            for (let i = 6; i >= 0; i--) {
                const date = new Date(today);
                date.setDate(today.getDate() - i);
                labels.push(days[date.getDay()]);
            }
            return labels;
        }

        function getMonthlyLabels() {
            const labels = [];
            const months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
            const today = new Date();
            
            for (let i = 5; i >= 0; i--) {
                const date = new Date(today.getFullYear(), today.getMonth() - i, 1);
                labels.push(months[date.getMonth()]);
            }
            return labels;
        }
    </script>
</body>
</html>