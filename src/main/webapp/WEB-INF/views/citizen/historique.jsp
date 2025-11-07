<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historique de Consommation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <style>
        .card {
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            border: none;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .summary-card {
            text-align: center;
            padding: 1rem;
        }
        .summary-value {
            font-size: 1.8rem;
            font-weight: bold;
            color: #2c3e50;
        }
        .summary-label {
            font-size: 0.9rem;
            color: #6c757d;
            text-transform: uppercase;
        }
        .table-hover tbody tr:hover {
            background-color: rgba(0, 123, 255, 0.075);
        }
        .consumption-low { background-color: #d4edda !important; }
        .consumption-medium { background-color: #fff3cd !important; }
        .consumption-high { background-color: #f8d7da !important; }
        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_filter {
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="h3 mb-1"><i class="fas fa-history me-2"></i>Historique de Consommation</h1>
                    <p class="mb-0">Consultation et analyse des données historiques</p>
                </div>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-light">
                    <i class="fas fa-arrow-left me-1"></i>Retour au tableau de bord
                </a>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Cartes de résumé -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card bg-primary text-white">
                    <div class="card-body summary-card">
                        <div class="summary-value" id="totalConsumption">0.00</div>
                        <div class="summary-label">Consommation Totale</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-success text-white">
                    <div class="card-body summary-card">
                        <div class="summary-value" id="averageConsumption">0.00</div>
                        <div class="summary-label">Moyenne Journalière</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-info text-white">
                    <div class="card-body summary-card">
                        <div class="summary-value" id="daysCount">0</div>
                        <div class="summary-label">Jours d'activité</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-warning text-white">
                    <div class="card-body summary-card">
                        <div class="summary-value" id="sensorsCount">0</div>
                        <div class="summary-label">Capteurs Actifs</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filtres -->
        <div class="card mb-4">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0"><i class="fas fa-filter me-2"></i>Filtres de recherche</h5>
            </div>
            <div class="card-body">
                <form id="filterForm" class="row g-3">
                    <div class="col-md-3">
                        <label for="dateDebut" class="form-label">Date de début</label>
                        <input type="date" class="form-control" id="dateDebut" name="dateDebut">
                    </div>
                    <div class="col-md-3">
                        <label for="dateFin" class="form-label">Date de fin</label>
                        <input type="date" class="form-control" id="dateFin" name="dateFin">
                    </div>
                    <div class="col-md-3">
                        <label for="capteurSelect" class="form-label">Capteur</label>
                        <select class="form-select" id="capteurSelect" name="capteur">
                            <option value="all">Tous les capteurs</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label for="typeSelect" class="form-label">Type</label>
                        <select class="form-select" id="typeSelect" name="type">
                            <option value="all">Tous les types</option>
                            <option value="RESIDENTIEL">Résidentiel</option>
                            <option value="INDUSTRIEL">Industriel</option>
                            <option value="AGRICOLE">Agricole</option>
                        </select>
                    </div>
                    <div class="col-12">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search me-1"></i>Appliquer les filtres
                        </button>
                        <button type="reset" class="btn btn-outline-secondary">
                            <i class="fas fa-undo me-1"></i>Réinitialiser
                        </button>
                        <button type="button" class="btn btn-success" onclick="exportToCSV()">
                            <i class="fas fa-download me-1"></i>Exporter CSV
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Tableau des données -->
        <div class="card">
            <div class="card-header bg-light d-flex justify-content-between align-items-center">
                <h5 class="card-title mb-0"><i class="fas fa-table me-2"></i>Données historiques</h5>
                <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" id="groupByDay">
                    <label class="form-check-label" for="groupByDay">Grouper par jour</label>
                </div>
            </div>
            <div class="card-body">
                <table id="historiqueTable" class="table table-striped table-hover" style="width:100%">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Capteur</th>
                            <th>Type</th>
                            <th>Emplacement</th>
                            <th>Consommation</th>
                            <th>Unité</th>
                            <th>Statut</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Les données seront chargées dynamiquement -->
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Graphique de tendance -->
        <div class="card mt-4">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0"><i class="fas fa-chart-line me-2"></i>Tendance de consommation</h5>
            </div>
            <div class="card-body">
                <canvas id="trendChart" height="100"></canvas>
            </div>
        </div>
    </div>

    <!-- Modal pour les détails -->
    <div class="modal fade" id="detailModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Détails de la consommation</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="detailModalBody">
                    <!-- Contenu chargé dynamiquement -->
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script>
        // Données simulées - À remplacer par des appels à votre backend
        const simulatedData = {
            donneesCapteurs: [
                {
                    idDonnee: 1,
                    horodatage: '2024-01-15 08:00:00',
                    valeurConsommation: 2.5,
                    unite: 'kWh',
                    capteur: {
                        idCapteur: 1,
                        reference: 'CAP-001',
                        type: 'RESIDENTIEL',
                        emplacement: 'Salon',
                        seuilAlerte: 3.0
                    }
                },
                {
                    idDonnee: 2,
                    horodatage: '2024-01-15 09:00:00',
                    valeurConsommation: 3.2,
                    unite: 'kWh',
                    capteur: {
                        idCapteur: 1,
                        reference: 'CAP-001',
                        type: 'RESIDENTIEL',
                        emplacement: 'Salon',
                        seuilAlerte: 3.0
                    }
                },
                {
                    idDonnee: 3,
                    horodatage: '2024-01-15 10:00:00',
                    valeurConsommation: 45.8,
                    unite: 'kW',
                    capteur: {
                        idCapteur: 2,
                        reference: 'CAP-002',
                        type: 'INDUSTRIEL',
                        emplacement: 'Atelier',
                        seuilAlerte: 50.0
                    }
                },
                {
                    idDonnee: 4,
                    horodatage: '2024-01-14 14:00:00',
                    valeurConsommation: 12.3,
                    unite: 'm³',
                    capteur: {
                        idCapteur: 3,
                        reference: 'CAP-003',
                        type: 'AGRICOLE',
                        emplacement: 'Serre',
                        seuilAlerte: 15.0
                    }
                },
                {
                    idDonnee: 5,
                    horodatage: '2024-01-14 15:00:00',
                    valeurConsommation: 16.8,
                    unite: 'm³',
                    capteur: {
                        idCapteur: 3,
                        reference: 'CAP-003',
                        type: 'AGRICOLE',
                        emplacement: 'Serre',
                        seuilAlerte: 15.0
                    }
                },
                {
                    idDonnee: 6,
                    horodatage: '2024-01-13 11:00:00',
                    valeurConsommation: 1.8,
                    unite: 'kWh',
                    capteur: {
                        idCapteur: 4,
                        reference: 'CAP-004',
                        type: 'RESIDENTIEL',
                        emplacement: 'Cuisine',
                        seuilAlerte: 2.5
                    }
                }
            ],
            historiques: [
                {
                    date: '2024-01-15',
                    volumeTotal: 51.5,
                    consommationMoyenne: 17.2,
                    coutEstime: 25.75
                },
                {
                    date: '2024-01-14',
                    volumeTotal: 29.1,
                    consommationMoyenne: 14.55,
                    coutEstime: 14.55
                },
                {
                    date: '2024-01-13',
                    volumeTotal: 1.8,
                    consommationMoyenne: 1.8,
                    coutEstime: 0.9
                }
            ]
        };

        let dataTable;
        let trendChart;

        // Fonction pour formater la date
        function formatDateTime(dateString) {
            const date = new Date(dateString);
            return date.toLocaleString('fr-FR');
        }

        function formatDate(dateString) {
            const date = new Date(dateString);
            return date.toLocaleDateString('fr-FR');
        }

        // Fonction pour déterminer la classe de consommation
        function getConsumptionClass(valeur, seuil) {
            if (valeur > seuil * 1.2) return 'consumption-high';
            if (valeur > seuil) return 'consumption-medium';
            return 'consumption-low';
        }

        // Fonction pour obtenir le statut
        function getStatus(valeur, seuil) {
            if (valeur > seuil * 1.2) return '<span class="badge bg-danger">Dépassement</span>';
            if (valeur > seuil) return '<span class="badge bg-warning">Alerte</span>';
            return '<span class="badge bg-success">Normal</span>';
        }

        // Fonction pour calculer les statistiques
        function calculateStatistics(data) {
            const total = data.reduce((sum, item) => sum + item.valeurConsommation, 0);
            const days = [...new Set(data.map(item => item.horodatage.split(' ')[0]))].length;
            const average = days > 0 ? total / days : 0;
            const sensors = [...new Set(data.map(item => item.capteur.reference))].length;

            return { total, average, days, sensors };
        }

        // Fonction pour afficher les données dans le tableau
        function displayDataInTable(data) {
            const tableBody = $('#historiqueTable tbody');
            tableBody.empty();

            data.forEach(item => {
                const row = `
                    <tr class="${getConsumptionClass(item.valeurConsommation, item.capteur.seuilAlerte)}">
                        <td>${formatDateTime(item.horodatage)}</td>
                        <td>${item.capteur.reference}</td>
                        <td><span class="badge bg-secondary">${item.capteur.type}</span></td>
                        <td>${item.capteur.emplacement}</td>
                        <td><strong>${item.valeurConsommation.toFixed(2)}</strong></td>
                        <td>${item.unite}</td>
                        <td>${getStatus(item.valeurConsommation, item.capteur.seuilAlerte)}</td>
                        <td>
                            <button class="btn btn-sm btn-outline-primary" onclick="showDetails(${item.idDonnee})">
                                <i class="fas fa-info-circle"></i>
                            </button>
                        </td>
                    </tr>
                `;
                tableBody.append(row);
            });

            // Mettre à jour DataTables
            if (dataTable) {
                dataTable.destroy();
            }
            dataTable = $('#historiqueTable').DataTable({
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/fr-FR.json'
                },
                pageLength: 10,
                order: [[0, 'desc']]
            });
        }

        // Fonction pour afficher les données groupées par jour
        function displayGroupedData(data) {
            const groupedData = {};

            data.forEach(item => {
                const date = item.horodatage.split(' ')[0];
                if (!groupedData[date]) {
                    groupedData[date] = {
                        date: date,
                        capteurs: {},
                        total: 0,
                        count: 0
                    };
                }

                if (!groupedData[date].capteurs[item.capteur.reference]) {
                    groupedData[date].capteurs[item.capteur.reference] = {
                        total: 0,
                        count: 0
                    };
                }

                groupedData[date].capteurs[item.capteur.reference].total += item.valeurConsommation;
                groupedData[date].capteurs[item.capteur.reference].count++;
                groupedData[date].total += item.valeurConsommation;
                groupedData[date].count++;
            });

            const tableBody = $('#historiqueTable tbody');
            tableBody.empty();

            Object.values(groupedData).forEach(dayData => {
                const row = `
                    <tr>
                        <td><strong>${formatDate(dayData.date)}</strong></td>
                        <td>${Object.keys(dayData.capteurs).length} capteur(s)</td>
                        <td>-</td>
                        <td>-</td>
                        <td><strong>${dayData.total.toFixed(2)}</strong></td>
                        <td>-</td>
                        <td><span class="badge bg-info">Résumé journalier</span></td>
                        <td>
                            <button class="btn btn-sm btn-outline-info" onclick="showDayDetails('${dayData.date}')">
                                <i class="fas fa-chart-bar"></i>
                            </button>
                        </td>
                    </tr>
                `;
                tableBody.append(row);
            });

            if (dataTable) {
                dataTable.destroy();
            }
            dataTable = $('#historiqueTable').DataTable({
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/fr-FR.json'
                },
                pageLength: 10,
                order: [[0, 'desc']]
            });
        }

        // Fonction pour mettre à jour le graphique de tendance
        function updateTrendChart(data) {
            const groupedByDate = {};

            data.forEach(item => {
                const date = item.horodatage.split(' ')[0];
                if (!groupedByDate[date]) {
                    groupedByDate[date] = 0;
                }
                groupedByDate[date] += item.valeurConsommation;
            });

            const dates = Object.keys(groupedByDate).sort();
            const values = dates.map(date => groupedByDate[date]);

            const ctx = document.getElementById('trendChart').getContext('2d');

            if (trendChart) {
                trendChart.destroy();
            }

            trendChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: dates.map(date => formatDate(date)),
                    datasets: [{
                        label: 'Consommation totale par jour',
                        data: values,
                        borderColor: '#667eea',
                        backgroundColor: 'rgba(102, 126, 234, 0.1)',
                        borderWidth: 2,
                        fill: true,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'top',
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Consommation'
                            }
                        }
                    }
                }
            });
        }

        // Fonction pour appliquer les filtres
        function applyFilters() {
            let filteredData = [...simulatedData.donneesCapteurs];

            // Filtre par date
            const dateDebut = document.getElementById('dateDebut').value;
            const dateFin = document.getElementById('dateFin').value;

            if (dateDebut) {
                filteredData = filteredData.filter(item => item.horodatage >= dateDebut + ' 00:00:00');
            }
            if (dateFin) {
                filteredData = filteredData.filter(item => item.horodatage <= dateFin + ' 23:59:59');
            }

            // Filtre par capteur
            const capteurFilter = document.getElementById('capteurSelect').value;
            if (capteurFilter !== 'all') {
                filteredData = filteredData.filter(item => item.capteur.reference === capteurFilter);
            }

            // Filtre par type
            const typeFilter = document.getElementById('typeSelect').value;
            if (typeFilter !== 'all') {
                filteredData = filteredData.filter(item => item.capteur.type === typeFilter);
            }

            // Calculer et afficher les statistiques
            const stats = calculateStatistics(filteredData);
            document.getElementById('totalConsumption').textContent = stats.total.toFixed(2);
            document.getElementById('averageConsumption').textContent = stats.average.toFixed(2);
            document.getElementById('daysCount').textContent = stats.days;
            document.getElementById('sensorsCount').textContent = stats.sensors;

            // Afficher les données
            const groupByDay = document.getElementById('groupByDay').checked;
            if (groupByDay) {
                displayGroupedData(filteredData);
            } else {
                displayDataInTable(filteredData);
            }

            // Mettre à jour le graphique
            updateTrendChart(filteredData);
        }

        // Fonction pour peupler la liste des capteurs
        function populateSensorsList() {
            const capteurSelect = document.getElementById('capteurSelect');
            const sensors = [...new Set(simulatedData.donneesCapteurs.map(item => item.capteur.reference))];

            sensors.forEach(sensor => {
                const option = document.createElement('option');
                option.value = sensor;
                option.textContent = sensor;
                capteurSelect.appendChild(option);
            });
        }

        // Fonction pour afficher les détails
        function showDetails(donneeId) {
            const donnee = simulatedData.donneesCapteurs.find(item => item.idDonnee === donneeId);
            if (donnee) {
                const modalBody = document.getElementById('detailModalBody');
                modalBody.innerHTML = `
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Informations du capteur</h6>
                            <p><strong>Référence:</strong> ${donnee.capteur.reference}</p>
                            <p><strong>Type:</strong> ${donnee.capteur.type}</p>
                            <p><strong>Emplacement:</strong> ${donnee.capteur.emplacement}</p>
                            <p><strong>Seuil d'alerte:</strong> ${donnee.capteur.seuilAlerte} ${donnee.unite}</p>
                        </div>
                        <div class="col-md-6">
                            <h6>Donnée de consommation</h6>
                            <p><strong>Valeur:</strong> ${donnee.valeurConsommation} ${donnee.unite}</p>
                            <p><strong>Date et heure:</strong> ${formatDateTime(donnee.horodatage)}</p>
                            <p><strong>Statut:</strong> ${getStatus(donnee.valeurConsommation, donnee.capteur.seuilAlerte)}</p>
                            <p><strong>Pourcentage du seuil:</strong> ${((donnee.valeurConsommation / donnee.capteur.seuilAlerte) * 100).toFixed(1)}%</p>
                        </div>
                    </div>
                `;
                new bootstrap.Modal(document.getElementById('detailModal')).show();
            }
        }

        // Fonction pour exporter en CSV
        function exportToCSV() {
            let csvContent = "Date,Heure,Capteur,Type,Emplacement,Consommation,Unité,Statut\n";

            simulatedData.donneesCapteurs.forEach(item => {
                const dateTime = new Date(item.horodatage);
                const date = dateTime.toLocaleDateString('fr-FR');
                const time = dateTime.toLocaleTimeString('fr-FR');
                const statut = item.valeurConsommation > item.capteur.seuilAlerte * 1.2 ? 'Dépassement' :
                             item.valeurConsommation > item.capteur.seuilAlerte ? 'Alerte' : 'Normal';

                csvContent += `"${date}","${time}","${item.capteur.reference}","${item.capteur.type}","${item.capteur.emplacement}",${item.valeurConsommation},"${item.unite}","${statut}"\n`;
            });

            const blob = new Blob([csvContent], { type: 'text/csv' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'historique_consommation.csv';
            a.click();
            window.URL.revokeObjectURL(url);
        }

        // Initialisation
        document.addEventListener('DOMContentLoaded', function() {
            // Définir les dates par défaut (derniers 7 jours)
            const today = new Date();
            const oneWeekAgo = new Date();
            oneWeekAgo.setDate(today.getDate() - 7);

            document.getElementById('dateFin').value = today.toISOString().split('T')[0];
            document.getElementById('dateDebut').value = oneWeekAgo.toISOString().split('T')[0];

            // Peupler la liste des capteurs
            populateSensorsList();

            // Appliquer les filtres initiaux
            applyFilters();

            // Écouter les changements de filtres
            document.getElementById('filterForm').addEventListener('submit', function(e) {
                e.preventDefault();
                applyFilters();
            });

            document.getElementById('groupByDay').addEventListener('change', applyFilters);
        });
    </script>
</body>
</html>