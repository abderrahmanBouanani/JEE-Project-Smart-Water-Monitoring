<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Visualisation de la Consommation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
        .status-indicator {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 8px;
        }
        .status-normal { background-color: #28a745; }
        .status-warning { background-color: #ffc107; }
        .status-danger { background-color: #dc3545; }
        .status-inactive { background-color: #6c757d; }
        .sensor-card {
            transition: transform 0.2s;
        }
        .sensor-card:hover {
            transform: translateY(-2px);
        }
        .value-display {
            font-size: 1.5rem;
            font-weight: bold;
            color: #2c3e50;
        }
        .unit {
            font-size: 0.9rem;
            color: #6c757d;
        }
        .threshold-exceeded {
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.5; }
            100% { opacity: 1; }
        }
        .sensor-inactive {
            opacity: 0.6;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="h3 mb-1"><i class="fas fa-chart-line me-2"></i>Visualisation de la Consommation</h1>
                    <p class="mb-0">Surveillance en temps réel de vos objets connectés</p>
                </div>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-light">
                    <i class="fas fa-arrow-left me-1"></i>Retour au tableau de bord
                </a>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Résumé global -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card bg-primary text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">Capteurs Actifs</h6>
                                <h3 id="activeSensorsCount">0</h3>
                            </div>
                            <i class="fas fa-microchip fa-2x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-success text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">Dans les seuils</h6>
                                <h3 id="normalSensorsCount">0</h3>
                            </div>
                            <i class="fas fa-check-circle fa-2x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-warning text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">Alertes</h6>
                                <h3 id="warningSensorsCount">0</h3>
                            </div>
                            <i class="fas fa-exclamation-triangle fa-2x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-danger text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h6 class="card-title">Dépassements</h6>
                                <h3 id="dangerSensorsCount">0</h3>
                            </div>
                            <i class="fas fa-times-circle fa-2x opacity-50"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filtres -->
        <div class="card mb-4">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0"><i class="fas fa-filter me-2"></i>Filtres</h5>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label for="filterType" class="form-label">Type de capteur</label>
                        <select class="form-select" id="filterType">
                            <option value="all">Tous les types</option>
                            <option value="RESIDENTIEL">Résidentiel</option>
                            <option value="INDUSTRIEL">Industriel</option>
                            <option value="AGRICOLE">Agricole</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label for="filterStatus" class="form-label">Statut</label>
                        <select class="form-select" id="filterStatus">
                            <option value="all">Tous les statuts</option>
                            <option value="normal">Normal</option>
                            <option value="warning">Alerte</option>
                            <option value="danger">Dépassement</option>
                            <option value="inactive">Inactif</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label for="filterEtat" class="form-label">État</label>
                        <select class="form-select" id="filterEtat">
                            <option value="all">Tous</option>
                            <option value="active">Actifs seulement</option>
                            <option value="inactive">Inactifs seulement</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>

        <!-- Liste des capteurs -->
        <div class="row" id="sensorsContainer">
            <!-- Les capteurs seront chargés dynamiquement ici -->
        </div>

        <!-- Message si aucun capteur -->
        <div id="noSensorsMessage" class="text-center d-none">
            <div class="card">
                <div class="card-body">
                    <i class="fas fa-microchip-slash fa-3x text-muted mb-3"></i>
                    <h5>Aucun capteur trouvé</h5>
                    <p class="text-muted">Aucun capteur ne correspond aux filtres sélectionnés.</p>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Données simulées - À remplacer par des appels à votre backend
        const simulatedSensors = [
            {
                id: 1,
                reference: "CAP-001",
                type: "RESIDENTIEL",
                emplacement: "Salon - Rue principale",
                etat: true,
                seuilAlerte: 2.5,
                currentValue: 1.8,
                unite: "kWh",
                lastUpdate: new Date().toISOString()
            },
            {
                id: 2,
                reference: "CAP-002",
                type: "RESIDENTIEL",
                emplacement: "Cuisine - Rue principale",
                etat: true,
                seuilAlerte: 3.0,
                currentValue: 3.2,
                unite: "kWh",
                lastUpdate: new Date().toISOString()
            },
            {
                id: 3,
                reference: "CAP-003",
                type: "INDUSTRIEL",
                emplacement: "Atelier de production",
                etat: true,
                seuilAlerte: 50.0,
                currentValue: 35.5,
                unite: "kW",
                lastUpdate: new Date().toISOString()
            },
            {
                id: 4,
                reference: "CAP-004",
                type: "AGRICOLE",
                emplacement: "Serre principale",
                etat: true,
                seuilAlerte: 15.0,
                currentValue: 16.2,
                unite: "m³",
                lastUpdate: new Date().toISOString()
            },
            {
                id: 5,
                reference: "CAP-005",
                type: "RESIDENTIEL",
                emplacement: "Chambre - Rue secondaire",
                etat: false,
                seuilAlerte: 1.5,
                currentValue: 0.0,
                unite: "kWh",
                lastUpdate: new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString()
            }
        ];

        // Fonction pour déterminer le statut d'un capteur
        function getSensorStatus(sensor) {
            if (!sensor.etat) return 'inactive';
            if (sensor.currentValue === 0) return 'inactive';
            if (sensor.currentValue > sensor.seuilAlerte * 1.2) return 'danger';
            if (sensor.currentValue > sensor.seuilAlerte) return 'warning';
            return 'normal';
        }

        // Fonction pour obtenir les classes CSS selon le statut
        function getStatusClasses(status) {
            const classes = {
                normal: 'status-normal',
                warning: 'status-warning',
                danger: 'status-danger',
                inactive: 'status-inactive'
            };
            return classes[status] || 'status-inactive';
        }

        // Fonction pour obtenir le texte du statut
        function getStatusText(status) {
            const texts = {
                normal: 'Normal',
                warning: 'Alerte',
                danger: 'Dépassement',
                inactive: 'Inactif'
            };
            return texts[status] || 'Inconnu';
        }

        // Fonction pour formater la date
        function formatDate(dateString) {
            try {
                const date = new Date(dateString);
                return date.toLocaleString('fr-FR');
            } catch (e) {
                return 'Date inconnue';
            }
        }

        // Fonction pour afficher les capteurs
        function displaySensors(sensors) {
            const container = document.getElementById('sensorsContainer');
            const noSensorsMessage = document.getElementById('noSensorsMessage');

            container.innerHTML = '';

            if (sensors.length === 0) {
                noSensorsMessage.classList.remove('d-none');
                return;
            } else {
                noSensorsMessage.classList.add('d-none');
            }

            let activeCount = 0;
            let normalCount = 0;
            let warningCount = 0;
            let dangerCount = 0;

            sensors.forEach(sensor => {
                const status = getSensorStatus(sensor);

                // Mettre à jour les compteurs
                if (sensor.etat && sensor.currentValue > 0) activeCount++;
                if (status === 'normal') normalCount++;
                if (status === 'warning') warningCount++;
                if (status === 'danger') dangerCount++;

                // Créer la carte du capteur
                const sensorCard = document.createElement('div');
                sensorCard.className = 'col-md-6 col-lg-4 mb-4';

                let borderClass = '';
                let alertHtml = '';

                if (status === 'warning') {
                    borderClass = 'border-warning';
                    alertHtml = `
                        <small class="text-warning">
                            <i class="fas fa-exclamation-triangle me-1"></i>
                            Seuil d'alerte dépassé
                        </small>
                    `;
                } else if (status === 'danger') {
                    borderClass = 'border-danger';
                    const exceedPercentage = ((sensor.currentValue / sensor.seuilAlerte - 1) * 100).toFixed(1);
                    alertHtml = `
                        <small class="text-danger threshold-exceeded">
                            <i class="fas fa-times-circle me-1"></i>
                            Seuil critique dépassé de ${exceedPercentage}%
                        </small>
                    `;
                } else if (status === 'inactive') {
                    borderClass = 'border-secondary';
                    alertHtml = `
                        <small class="text-secondary">
                            <i class="fas fa-power-off me-1"></i>
                            Capteur inactif
                        </small>
                    `;
                }

                sensorCard.innerHTML = `
                    <div class="card sensor-card h-100 ${borderClass} ${!sensor.etat ? 'sensor-inactive' : ''}">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h6 class="card-title mb-0">${sensor.reference}</h6>
                            <div>
                                <span class="status-indicator ${getStatusClasses(status)}"></span>
                                <small>${getStatusText(status)}</small>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-12">
                                    <span class="value-display">${sensor.currentValue.toFixed(2)}</span>
                                    <span class="unit">${sensor.unite}</span>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-6">
                                    <small class="text-muted">Seuil d'alerte:</small>
                                    <div>${sensor.seuilAlerte.toFixed(2)} ${sensor.unite}</div>
                                </div>
                                <div class="col-6">
                                    <small class="text-muted">Type:</small>
                                    <div><span class="badge bg-secondary">${sensor.type}</span></div>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col-12">
                                    <small class="text-muted">Emplacement:</small>
                                    <div>${sensor.emplacement}</div>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col-12">
                                    <small class="text-muted">Dernière mise à jour:</small>
                                    <div>${formatDate(sensor.lastUpdate)}</div>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer bg-transparent">
                            ${alertHtml}
                        </div>
                    </div>
                `;

                container.appendChild(sensorCard);
            });

            // Mettre à jour les compteurs globaux
            document.getElementById('activeSensorsCount').textContent = activeCount;
            document.getElementById('normalSensorsCount').textContent = normalCount;
            document.getElementById('warningSensorsCount').textContent = warningCount;
            document.getElementById('dangerSensorsCount').textContent = dangerCount;
        }

        // Fonction de filtrage
        function filterSensors() {
            const typeFilter = document.getElementById('filterType').value;
            const statusFilter = document.getElementById('filterStatus').value;
            const etatFilter = document.getElementById('filterEtat').value;

            const filtered = simulatedSensors.filter(sensor => {
                // Filtre par type
                if (typeFilter !== 'all' && sensor.type !== typeFilter) return false;

                // Filtre par statut
                if (statusFilter !== 'all') {
                    const status = getSensorStatus(sensor);
                    if (status !== statusFilter) return false;
                }

                // Filtre par état
                if (etatFilter === 'active' && !sensor.etat) return false;
                if (etatFilter === 'inactive' && sensor.etat) return false;

                return true;
            });

            displaySensors(filtered);
        }

        // Initialisation
        document.addEventListener('DOMContentLoaded', function() {
            // Afficher tous les capteurs au départ
            filterSensors();

            // Écouter les changements de filtres
            document.getElementById('filterType').addEventListener('change', filterSensors);
            document.getElementById('filterStatus').addEventListener('change', filterSensors);
            document.getElementById('filterEtat').addEventListener('change', filterSensors);

            // Simuler des mises à jour en temps réel (optionnel)
            setInterval(() => {
                simulatedSensors.forEach(sensor => {
                    if (sensor.etat && Math.random() > 0.7) {
                        // Variation aléatoire de ±15%
                        const variation = (Math.random() - 0.5) * sensor.currentValue * 0.3;
                        sensor.currentValue = Math.max(0, sensor.currentValue + variation);
                        sensor.lastUpdate = new Date().toISOString();
                    }
                });
                filterSensors();
            }, 15000); // Mise à jour toutes les 15 secondes
        });
    </script>
</body>
</html>