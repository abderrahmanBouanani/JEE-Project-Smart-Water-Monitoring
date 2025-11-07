<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistiques de Consommation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .card {
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .filter-section {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .export-buttons {
            margin-top: 20px;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <h1 class="h3 mb-0">📊 Statistiques de Consommation</h1>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-light">← Retour au tableau de bord</a>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Section Filtres -->
        <div class="filter-section">
            <h5 class="mb-3">🔍 Filtres</h5>
            <form id="filterForm" class="row g-3">
                <div class="col-md-3">
                    <label for="periode" class="form-label">Période</label>
                    <select class="form-select" id="periode" name="periode">
                        <option value="jour">Quotidienne</option>
                        <option value="semaine">Hebdomadaire</option>
                        <option value="mois" selected>Mensuelle</option>
                        <option value="annee">Annuelle</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="objet" class="form-label">Type de consommation</label>
                    <select class="form-select" id="objet" name="objet">
                        <option value="tous">Tous</option>
                        <option value="eau">Eau</option>
                        <option value="electricite">Électricité</option>
                        <option value="gaz">Gaz</option>
                        <option value="dechets">Déchets</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="dateDebut" class="form-label">Date de début</label>
                    <input type="date" class="form-control" id="dateDebut" name="dateDebut">
                </div>
                <div class="col-md-3">
                    <label for="dateFin" class="form-label">Date de fin</label>
                    <input type="date" class="form-control" id="dateFin" name="dateFin">
                </div>
                <div class="col-12">
                    <button type="submit" class="btn btn-primary">Appliquer les filtres</button>
                    <button type="reset" class="btn btn-outline-secondary">Réinitialiser</button>
                </div>
            </form>
        </div>

        <!-- Section Graphiques -->
        <div class="row">
            <!-- Graphique Consommation Quotidienne -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="card-title mb-0">📈 Consommation Quotidienne</h5>
                    </div>
                    <div class="card-body">
                        <canvas id="dailyChart" height="250"></canvas>
                    </div>
                </div>
            </div>

            <!-- Graphique Consommation Mensuelle -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="card-title mb-0">📊 Consommation Mensuelle</h5>
                    </div>
                    <div class="card-body">
                        <canvas id="monthlyChart" height="250"></canvas>
                    </div>
                </div>
            </div>

            <!-- Graphique Consommation Moyenne -->
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="card-title mb-0">⚡ Consommation Moyenne</h5>
                    </div>
                    <div class="card-body">
                        <canvas id="averageChart" height="150"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Section Export -->
        <div class="export-buttons text-center">
            <h5 class="mb-3">💾 Exporter les données</h5>
            <button type="button" class="btn btn-success me-2" onclick="exportData('csv')">
                📄 Exporter en CSV
            </button>
            <button type="button" class="btn btn-danger" onclick="exportData('pdf')">
                📑 Exporter en PDF
            </button>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Initialisation des dates
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date();
            const oneMonthAgo = new Date();
            oneMonthAgo.setDate(today.getDate() - 30);

            document.getElementById('dateFin').value = today.toISOString().split('T')[0];
            document.getElementById('dateDebut').value = oneMonthAgo.toISOString().split('T')[0];

            initializeCharts();
        });

        function initializeCharts() {
            // Données simulées pour la consommation d'électricité
            const dailyData = {
                labels: ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'],
                datasets: [{
                    label: 'Consommation (kWh)',
                    data: [12.5, 19.2, 8.7, 15.3, 12.8, 18.6, 14.1],
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 2,
                    tension: 0.4,
                    fill: true
                }]
            };

            const monthlyData = {
                labels: ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun'],
                datasets: [{
                    label: 'Consommation (kWh)',
                    data: [450, 420, 380, 350, 320, 300],
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 2
                }]
            };

            const averageData = {
                labels: ['Moyenne Journalière', 'Moyenne Mensuelle', 'Moyenne Annuelle'],
                datasets: [{
                    label: 'Consommation Moyenne (kWh)',
                    data: [15.2, 350, 4200],
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.8)',
                        'rgba(54, 162, 235, 0.8)',
                        'rgba(255, 205, 86, 0.8)'
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 205, 86, 1)'
                    ],
                    borderWidth: 1
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
                        legend: {
                            position: 'top',
                            labels: { font: { size: 12 } }
                        },
                        tooltip: {
                            mode: 'index',
                            intersect: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'kWh',
                                font: { weight: 'bold' }
                            }
                        },
                        x: {
                            title: {
                                display: true,
                                text: 'Jours de la semaine',
                                font: { weight: 'bold' }
                            }
                        }
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
                        legend: {
                            position: 'top',
                            labels: { font: { size: 12 } }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'kWh',
                                font: { weight: 'bold' }
                            }
                        },
                        x: {
                            title: {
                                display: true,
                                text: 'Mois',
                                font: { weight: 'bold' }
                            }
                        }
                    }
                }
            });

            // Graphique moyenne
            const averageCtx = document.getElementById('averageChart').getContext('2d');
            new Chart(averageCtx, {
                type: 'bar',
                data: averageData,
                options: {
                    responsive: true,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return `Consommation: ${context.parsed.y} kWh`;
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'kWh',
                                font: { weight: 'bold' }
                            }
                        }
                    }
                }
            });
        }

        // Gestion des filtres
        document.getElementById('filterForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const filters = {
                periode: document.getElementById('periode').value,
                objet: document.getElementById('objet').value,
                dateDebut: document.getElementById('dateDebut').value,
                dateFin: document.getElementById('dateFin').value
            };

            console.log('Filtres appliqués:', filters);

            // Simulation du rechargement des données
            alert('Filtres appliqués avec succès!\n\n' +
                  'Période: ' + filters.periode + '\n' +
                  'Type: ' + filters.objet + '\n' +
                  'Du: ' + filters.dateDebut + '\n' +
                  'Au: ' + filters.dateFin);

            // Ici vous ajouterez un appel AJAX pour recharger les données
            // fetch('/api/statistiques/filtres', { ... })
        });

        // Fonction d'export
        function exportData(format) {
            const filters = {
                periode: document.getElementById('periode').value,
                objet: document.getElementById('objet').value,
                dateDebut: document.getElementById('dateDebut').value,
                dateFin: document.getElementById('dateFin').value
            };

            if (format === 'csv') {
                alert('📄 Export CSV initié avec les filtres actuels\n\nCette fonctionnalité sera connectée au backend.');
                // window.location.href = '/api/export/csv?periode=' + filters.periode + '&objet=' + filters.objet;
            } else if (format === 'pdf') {
                alert('📑 Export PDF initié avec les filtres actuels\n\nCette fonctionnalité sera connectée au backend.');
                // window.location.href = '/api/export/pdf?periode=' + filters.periode + '&objet=' + filters.objet;
            }
        }

        // Réinitialiser les graphiques quand les filtres changent
        document.getElementById('periode').addEventListener('change', function() {
            console.log('Période changée:', this.value);
        });

        document.getElementById('objet').addEventListener('change', function() {
            console.log('Type de consommation changé:', this.value);
        });
    </script>
</body>
</html>