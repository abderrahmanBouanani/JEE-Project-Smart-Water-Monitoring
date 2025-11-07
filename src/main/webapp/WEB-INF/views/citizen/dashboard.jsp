<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord - ${sessionScope.user.nom}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary: #3498db;
            --secondary: #2980b9;
            --success: #27ae60;
            --warning: #f39c12;
            --danger: #e74c3c;
            --info: #17a2b8;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 280px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            padding: 0;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }

        .sidebar-header {
            padding: 2rem 1.5rem;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .sidebar-header h2 {
            margin: 0;
            font-size: 1.4rem;
            font-weight: 600;
        }

        .sidebar-header p {
            margin: 0.5rem 0 0 0;
            opacity: 0.8;
            font-size: 0.9rem;
        }

        .sidebar-nav {
            padding: 1.5rem 0;
        }

        .nav-item {
            margin-bottom: 0.5rem;
        }

        .nav-link {
            color: rgba(255,255,255,0.9);
            padding: 0.8rem 1.5rem;
            text-decoration: none;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
        }

        .nav-link:hover {
            background-color: rgba(255,255,255,0.1);
            color: white;
            border-left-color: rgba(255,255,255,0.5);
        }

        .nav-link.active {
            background-color: rgba(255,255,255,0.15);
            color: white;
            border-left-color: white;
        }

        .nav-link i {
            width: 20px;
            margin-right: 10px;
            text-align: center;
        }

        .sidebar-footer {
            padding: 1.5rem;
            border-top: 1px solid rgba(255,255,255,0.1);
            margin-top: auto;
        }

        .main-content {
            flex: 1;
            padding: 2rem;
            overflow-y: auto;
        }

        .welcome-banner {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            padding: 2rem;
            border-radius: 15px;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            border: none;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .widget {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin-bottom: 1.5rem;
            border: none;
        }

        .widget-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .widget-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin: 0;
            color: #2c3e50;
        }

        .quick-action {
            background: white;
            border: 2px dashed #e9ecef;
            border-radius: 12px;
            padding: 1.5rem;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .quick-action:hover {
            border-color: var(--primary);
            background-color: #f0f8ff;
        }

        .quick-action i {
            font-size: 2rem;
            color: var(--primary);
            margin-bottom: 1rem;
        }

        .alert-badge {
            position: absolute;
            top: -8px;
            right: -8px;
            background: var(--danger);
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            font-size: 0.7rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .consumption-chart {
            height: 200px;
        }

        .progress {
            height: 8px;
            margin-top: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar d-flex flex-column">
            <div class="sidebar-header">
                <h2><i class="fas fa-tint me-2"></i>SmartWater</h2>
                <p>Bonjour, ${sessionScope.user.nom}</p>
            </div>

            <div class="sidebar-nav flex-grow-1">
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/dashboard" class="nav-link active">
                        <i class="fas fa-home"></i>Tableau de Bord
                    </a>
                </div>
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/consommation/stats" class="nav-link">
                        <i class="fas fa-chart-bar"></i>Statistiques
                    </a>
                </div>
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/consommation/visualisation" class="nav-link">
                        <i class="fas fa-eye"></i>Visualisation
                    </a>
                </div>
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/consommation/historique" class="nav-link">
                        <i class="fas fa-history"></i>Historique
                    </a>
                </div>
                <div class="nav-item position-relative">
                    <a href="${pageContext.request.contextPath}/mes-alertes" class="nav-link">
                        <i class="fas fa-bell"></i>Mes Alertes
                        <span class="alert-badge">3</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="${pageContext.request.contextPath}/profil" class="nav-link">
                        <i class="fas fa-user"></i>Mon Profil
                    </a>
                </div>
            </div>

            <div class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-outline-light w-100">
                    <i class="fas fa-sign-out-alt me-2"></i>Se déconnecter
                </a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <c:if test="${empty contentPage}">
                <!-- Welcome Banner -->
                <div class="welcome-banner">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h1 class="display-6 fw-bold">Bonjour, ${sessionScope.user.nom} !</h1>
                            <p class="lead mb-0">Surveillance intelligente de votre consommation d'eau</p>
                        </div>
                        <div class="col-md-4 text-end">
                            <div class="bg-white text-dark rounded-pill px-3 py-2 d-inline-block">
                                <i class="fas fa-calendar-day me-2 text-primary"></i>
                                <span id="current-date"></span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-md-3 mb-3">
                        <div class="stat-card">
                            <div class="stat-icon bg-primary bg-opacity-10 text-primary">
                                <i class="fas fa-tint"></i>
                            </div>
                            <div class="stat-value text-primary" id="currentConsumption">125 L</div>
                            <div class="stat-label">Consommation actuelle</div>
                            <div class="progress">
                                <div class="progress-bar bg-primary" style="width: 65%"></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="stat-card">
                            <div class="stat-icon bg-warning bg-opacity-10 text-warning">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                            <div class="stat-value text-warning" id="activeAlerts">3</div>
                            <div class="stat-label">Alertes en cours</div>
                            <div class="progress">
                                <div class="progress-bar bg-warning" style="width: 30%"></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="stat-card">
                            <div class="stat-icon bg-success bg-opacity-10 text-success">
                                <i class="fas fa-faucet"></i>
                            </div>
                            <div class="stat-value text-success" id="activeSensors">8</div>
                            <div class="stat-label">Compteurs actifs</div>
                            <div class="progress">
                                <div class="progress-bar bg-success" style="width: 80%"></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="stat-card">
                            <div class="stat-icon bg-info bg-opacity-10 text-info">
                                <i class="fas fa-euro-sign"></i>
                            </div>
                            <div class="stat-value text-info" id="dailyCost">2.15€</div>
                            <div class="stat-label">Coût journalier</div>
                            <div class="progress">
                                <div class="progress-bar bg-info" style="width: 45%"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Main Widgets -->
                <div class="row">
                    <!-- Consommation en temps réel -->
                    <div class="col-md-8">
                        <div class="widget">
                            <div class="widget-header">
                                <h3 class="widget-title"><i class="fas fa-chart-line me-2 text-primary"></i>Consommation en temps réel</h3>
                                <div class="btn-group">
                                    <button class="btn btn-sm btn-outline-primary active">24h</button>
                                    <button class="btn btn-sm btn-outline-primary">7j</button>
                                    <button class="btn btn-sm btn-outline-primary">30j</button>
                                </div>
                            </div>
                            <div class="consumption-chart">
                                <canvas id="realtimeChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- Alertes récentes -->
                    <div class="col-md-4">
                        <div class="widget">
                            <div class="widget-header">
                                <h3 class="widget-title"><i class="fas fa-bell me-2 text-warning"></i>Alertes récentes</h3>
                                <span class="badge bg-warning">3 nouvelles</span>
                            </div>
                            <div id="recentAlerts">
                                <!-- Alertes chargées dynamiquement -->
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions & Capteurs -->
                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="widget">
                            <div class="widget-header">
                                <h3 class="widget-title"><i class="fas fa-rocket me-2 text-success"></i>Accès rapide</h3>
                            </div>
                            <div class="row g-3">
                                <div class="col-6">
                                    <div class="quick-action" onclick="location.href='${pageContext.request.contextPath}/consommation/stats'">
                                        <i class="fas fa-chart-pie"></i>
                                        <h6>Rapports détaillés</h6>
                                        <small class="text-muted">Analyses de consommation</small>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="quick-action" onclick="location.href='${pageContext.request.contextPath}/consommation/visualisation'">
                                        <i class="fas fa-water"></i>
                                        <h6>Réseau d'eau</h6>
                                        <small class="text-muted">Vue du système</small>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="quick-action" onclick="location.href='${pageContext.request.contextPath}/mes-alertes'">
                                        <i class="fas fa-bell"></i>
                                        <h6>Gestion alertes</h6>
                                        <small class="text-muted">Surveillance</small>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="quick-action" onclick="location.href='${pageContext.request.contextPath}/profil'">
                                        <i class="fas fa-user-cog"></i>
                                        <h6>Mon Compte</h6>
                                        <small class="text-muted">Préférences</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="widget">
                            <div class="widget-header">
                                <h3 class="widget-title"><i class="fas fa-faucet me-2 text-info"></i>État des compteurs</h3>
                                <span class="badge bg-success">8/10 actifs</span>
                            </div>
                            <div id="sensorsStatus">
                                <!-- État des compteurs chargé dynamiquement -->
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty contentPage}">
                <h1>${pageTitle}</h1>
                <jsp:include page="${contentPage}" />
            </c:if>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Initialisation de la date actuelle
        document.getElementById('current-date').textContent = new Date().toLocaleDateString('fr-FR', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });

        // Données simulées pour SmartWater
        const dashboardData = {
            recentAlerts: [
                {
                    type: 'SEUIL_DEPASSE',
                    message: 'Débit anormal dans la salle de bain',
                    time: 'Il y a 15 min',
                    critical: true
                },
                {
                    type: 'COMPTEUR_OFFLINE',
                    message: 'Compteur cuisine hors ligne',
                    time: 'Il y a 2h',
                    critical: false
                },
                {
                    type: 'FUITE_DETECTEE',
                    message: 'Fuite possible détectée au garage',
                    time: 'Il y a 5h',
                    critical: true
                }
            ],
            sensors: [
                { name: 'COMP-001', location: 'Salle de bain', status: 'active', consumption: 45 },
                { name: 'COMP-002', location: 'Cuisine', status: 'inactive', consumption: 0 },
                { name: 'COMP-003', location: 'Jardin', status: 'active', consumption: 28 },
                { name: 'COMP-004', location: 'Buanderie', status: 'active', consumption: 32 },
                { name: 'COMP-005', location: 'Garage', status: 'active', consumption: 20 }
            ]
        };

        // Fonction pour obtenir la classe CSS selon le statut
        function getStatusClass(status) {
            return status === 'active' ? 'text-success' : 'text-secondary';
        }

        // Fonction pour obtenir la classe badge selon le statut
        function getBadgeClass(status) {
            return status === 'active' ? 'bg-success' : 'bg-secondary';
        }

        // Fonction pour obtenir le texte du statut
        function getStatusText(status) {
            return status === 'active' ? 'Actif' : 'Inactif';
        }

        // Fonction pour afficher les alertes récentes
        function displayRecentAlerts() {
            const container = document.getElementById('recentAlerts');
            container.innerHTML = '';

            dashboardData.recentAlerts.forEach(alert => {
                const alertClass = alert.critical ? 'alert-danger' : 'alert-warning';
                const alertElement = document.createElement('div');
                alertElement.className = 'alert ' + alertClass + ' alert-dismissible fade show mb-2';
                alertElement.innerHTML =
                    '<div class="d-flex justify-content-between align-items-start">' +
                        '<div>' +
                            '<strong>' + alert.type.replace('_', ' ') + '</strong><br>' +
                            '<small>' + alert.message + '</small>' +
                        '</div>' +
                        '<small class="text-muted">' + alert.time + '</small>' +
                    '</div>';
                container.appendChild(alertElement);
            });
        }

        // Fonction pour afficher l'état des compteurs
        function displaySensorsStatus() {
            const container = document.getElementById('sensorsStatus');
            container.innerHTML = '';

            dashboardData.sensors.forEach(sensor => {
                const statusClass = getStatusClass(sensor.status);
                const badgeClass = getBadgeClass(sensor.status);
                const statusText = getStatusText(sensor.status);

                const sensorElement = document.createElement('div');
                sensorElement.className = 'd-flex justify-content-between align-items-center mb-3 p-2 border rounded';
                sensorElement.innerHTML =
                    '<div class="d-flex align-items-center">' +
                        '<div class="me-3">' +
                            '<i class="fas fa-faucet ' + statusClass + '"></i>' +
                        '</div>' +
                        '<div>' +
                            '<strong>' + sensor.name + '</strong><br>' +
                            '<small class="text-muted">' + sensor.location + '</small>' +
                        '</div>' +
                    '</div>' +
                    '<div class="text-end">' +
                        '<div class="fw-bold">' + sensor.consumption + ' L</div>' +
                        '<span class="badge ' + badgeClass + '">' + statusText + '</span>' +
                    '</div>';
                container.appendChild(sensorElement);
            });
        }

        // Graphique de consommation en temps réel
        function initRealtimeChart() {
            const ctx = document.getElementById('realtimeChart').getContext('2d');
            const chart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: ['00h', '04h', '08h', '12h', '16h', '20h', '24h'],
                    datasets: [{
                        label: 'Consommation (L)',
                        data: [25, 18, 45, 125, 85, 60, 35],
                        borderColor: '#3498db',
                        backgroundColor: 'rgba(52, 152, 219, 0.1)',
                        borderWidth: 2,
                        fill: true,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Litres (L)'
                            },
                            grid: {
                                drawBorder: false
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

        // Simulation de mises à jour en temps réel
        function simulateRealTimeUpdates() {
            setInterval(function() {
                // Mettre à jour la consommation actuelle
                const currentConsumption = document.getElementById('currentConsumption');
                const randomValue = (100 + Math.random() * 50).toFixed(0);
                currentConsumption.textContent = randomValue + ' L';

                // Mettre à jour le coût journalier (environ 0.003€/L)
                const dailyCost = document.getElementById('dailyCost');
                const cost = (parseFloat(randomValue) * 0.003).toFixed(2);
                dailyCost.textContent = cost + '€';
            }, 5000);
        }

        // Initialisation
        document.addEventListener('DOMContentLoaded', function() {
            // Ne charger les widgets que si on est sur la page d'accueil (pas de contentPage)
            if (document.getElementById('currentConsumption')) {
                displayRecentAlerts();
                displaySensorsStatus();
                initRealtimeChart();
                simulateRealTimeUpdates();

                // Gestion des boutons de période
                document.querySelectorAll('.btn-group .btn').forEach(function(btn) {
                    btn.addEventListener('click', function() {
                        document.querySelectorAll('.btn-group .btn').forEach(function(b) {
                            b.classList.remove('active');
                        });
                        this.classList.add('active');
                    });
                });
            }
        });
    </script>
</body>
</html>