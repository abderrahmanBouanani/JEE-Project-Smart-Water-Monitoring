<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistiques Administrateur - SmartWater</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 2rem 0;
        }

        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
        }

        .stats-container {
            max-width: 1400px;
            margin: 2rem auto;
        }

        .stats-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
            transition: transform 0.3s ease;
        }

        .stats-card:hover {
            transform: translateY(-5px);
        }

        .stat-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 10px;
            padding: 1.5rem;
            text-align: center;
            margin-bottom: 1rem;
        }

        .stat-box.users {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .stat-box.sensors {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
        }

        .stat-box.alerts {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
        }

        .stat-box.data {
            background: linear-gradient(135deg, #28a745 0%, #218838 100%);
        }

        .stat-box.consumption {
            background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin: 0;
        }

        .stat-label {
            font-size: 0.9rem;
            opacity: 0.9;
            margin-top: 0.5rem;
        }

        .stat-icon {
            font-size: 3rem;
            opacity: 0.2;
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
        }

        .section-title {
            color: white;
            font-weight: bold;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 0.5rem;
        }

        .detail-stat {
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            padding: 1rem;
            margin-bottom: 1rem;
            border-radius: 5px;
        }

        .detail-stat h6 {
            margin: 0;
            color: #667eea;
            font-weight: bold;
        }

        .detail-stat p {
            margin: 0.5rem 0 0 0;
            font-size: 1.5rem;
            font-weight: bold;
        }

        .back-button {
            background: white;
            color: #667eea;
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 10px;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }

        .back-button:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .percentage-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: bold;
            margin-left: 0.5rem;
        }

        .percentage-badge.success {
            background: #d4edda;
            color: #155724;
        }

        .percentage-badge.warning {
            background: #fff3cd;
            color: #856404;
        }

        .percentage-badge.danger {
            background: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg fixed-top">
        <div class="container">
            <a class="navbar-brand fw-bold text-primary" href="${pageContext.request.contextPath}/adminDashboard">
                <i class="fas fa-tint me-2"></i>SmartWater Admin
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link text-dark" href="${pageContext.request.contextPath}/adminDashboard">
                    <i class="fas fa-arrow-left me-1"></i>Retour au Dashboard
                </a>
            </div>
        </div>
    </nav>

    <div class="container stats-container" style="margin-top: 80px;">
        <h2 class="section-title">
            <i class="fas fa-chart-line"></i>
            Statistiques Globales du Système
        </h2>

        <!-- Statistiques Utilisateurs -->
        <div class="stats-card">
            <h4 class="mb-4"><i class="fas fa-users text-primary me-2"></i>Utilisateurs</h4>
            <div class="row">
                <div class="col-md-4">
                    <div class="stat-box users position-relative">
                        <i class="fas fa-users stat-icon"></i>
                        <p class="stat-number">${totalUtilisateurs}</p>
                        <p class="stat-label">Total Utilisateurs</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-box users position-relative">
                        <i class="fas fa-user stat-icon"></i>
                        <p class="stat-number">${totalCitoyens}</p>
                        <p class="stat-label">Citoyens</p>
                        <c:if test="${totalUtilisateurs > 0}">
                            <span class="percentage-badge success">
                                <fmt:formatNumber value="${(totalCitoyens / totalUtilisateurs) * 100}" maxFractionDigits="1"/>%
                            </span>
                        </c:if>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-box users position-relative">
                        <i class="fas fa-user-shield stat-icon"></i>
                        <p class="stat-number">${totalAdmins}</p>
                        <p class="stat-label">Administrateurs</p>
                        <c:if test="${totalUtilisateurs > 0}">
                            <span class="percentage-badge warning">
                                <fmt:formatNumber value="${(totalAdmins / totalUtilisateurs) * 100}" maxFractionDigits="1"/>%
                            </span>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Statistiques Capteurs -->
        <div class="stats-card">
            <h4 class="mb-4"><i class="fas fa-microchip text-info me-2"></i>Capteurs IoT</h4>
            <div class="row">
                <div class="col-md-4">
                    <div class="stat-box sensors position-relative">
                        <i class="fas fa-microchip stat-icon"></i>
                        <p class="stat-number">${totalCapteurs}</p>
                        <p class="stat-label">Total Capteurs</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-box sensors position-relative">
                        <i class="fas fa-check-circle stat-icon"></i>
                        <p class="stat-number">${capteursActifs}</p>
                        <p class="stat-label">Capteurs Actifs</p>
                        <c:if test="${totalCapteurs > 0}">
                            <span class="percentage-badge success">
                                <fmt:formatNumber value="${(capteursActifs / totalCapteurs) * 100}" maxFractionDigits="1"/>%
                            </span>
                        </c:if>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-box sensors position-relative">
                        <i class="fas fa-times-circle stat-icon"></i>
                        <p class="stat-number">${capteursInactifs}</p>
                        <p class="stat-label">Capteurs Inactifs</p>
                        <c:if test="${totalCapteurs > 0}">
                            <span class="percentage-badge ${capteursInactifs > 0 ? 'danger' : 'success'}">
                                <fmt:formatNumber value="${(capteursInactifs / totalCapteurs) * 100}" maxFractionDigits="1"/>%
                            </span>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Statistiques Alertes -->
        <div class="stats-card">
            <h4 class="mb-4"><i class="fas fa-bell text-danger me-2"></i>Alertes</h4>
            <div class="row">
                <div class="col-md-6">
                    <div class="stat-box alerts position-relative">
                        <i class="fas fa-bell stat-icon"></i>
                        <p class="stat-number">${totalAlertes}</p>
                        <p class="stat-label">Total Alertes</p>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="stat-box alerts position-relative">
                        <i class="fas fa-exclamation-circle stat-icon"></i>
                        <p class="stat-number">${alertesNonLues}</p>
                        <p class="stat-label">Alertes Non Lues</p>
                        <c:if test="${totalAlertes > 0}">
                            <span class="percentage-badge ${alertesNonLues > 0 ? 'danger' : 'success'}">
                                <fmt:formatNumber value="${(alertesNonLues / totalAlertes) * 100}" maxFractionDigits="1"/>%
                            </span>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Statistiques Données et Consommation -->
        <div class="row">
            <div class="col-md-6">
                <div class="stats-card">
                    <h4 class="mb-4"><i class="fas fa-database text-success me-2"></i>Données Collectées</h4>
                    <div class="stat-box data position-relative">
                        <i class="fas fa-database stat-icon"></i>
                        <p class="stat-number">
                            <fmt:formatNumber value="${totalDonnees}" groupingUsed="true"/>
                        </p>
                        <p class="stat-label">Enregistrements Totaux</p>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="stats-card">
                    <h4 class="mb-4"><i class="fas fa-tint text-warning me-2"></i>Consommation d'Eau</h4>
                    <div class="row">
                        <div class="col-12 mb-3">
                            <div class="stat-box consumption position-relative">
                                <i class="fas fa-tint stat-icon"></i>
                                <p class="stat-number">
                                    <fmt:formatNumber value="${consommationTotale}" maxFractionDigits="2"/>
                                </p>
                                <p class="stat-label">Consommation Totale (L)</p>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="stat-box consumption position-relative">
                                <i class="fas fa-chart-bar stat-icon"></i>
                                <p class="stat-number">
                                    <fmt:formatNumber value="${consommationMoyenne}" maxFractionDigits="2"/>
                                </p>
                                <p class="stat-label">Consommation Moyenne (L)</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bouton Retour -->
        <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/adminDashboard" class="back-button">
                <i class="fas fa-arrow-left me-2"></i>Retour au Dashboard
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
