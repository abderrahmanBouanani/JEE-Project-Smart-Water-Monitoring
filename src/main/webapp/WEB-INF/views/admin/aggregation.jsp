<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion de l'Agrégation - Smart Water Monitoring</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px;
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
            margin-bottom: 1.5rem;
        }
        .action-card {
            background: white;
            border-radius: 10px;
            padding: 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
        }
        .status-badge {
            font-size: 0.9rem;
            padding: 0.5rem 1rem;
            border-radius: 20px;
        }
        .btn-action {
            width: 100%;
            padding: 1rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
        }
        .text-purple {
            color: #6f42c1;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- En-tête -->
        <div class="header-section">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="mb-1">📊 Gestion de l'Agrégation des Données</h1>
                    <p class="text-muted mb-0">Administration de l'agrégation automatique</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Retour
                    </a>
                </div>
            </div>
        </div>

        <!-- Messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="fas fa-check-circle me-2"></i>${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="fas fa-exclamation-triangle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty info}">
            <div class="alert alert-info alert-dismissible fade show">
                <i class="fas fa-info-circle me-2"></i>${info}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Statut du Job -->
        <div class="stat-card">
            <h5 class="mb-3"><i class="fas fa-robot me-2"></i>Statut du Job Automatique</h5>
            <div class="d-flex align-items-center">
                <c:choose>
                    <c:when test="${jobActif}">
                        <span class="status-badge bg-success text-white">
                            <i class="fas fa-check-circle me-2"></i>Actif
                        </span>
                        <span class="ms-3 text-muted">Le job d'agrégation s'exécute automatiquement chaque nuit à 00h30</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-badge bg-danger text-white">
                            <i class="fas fa-times-circle me-2"></i>Inactif
                        </span>
                        <span class="ms-3 text-muted">Le job d'agrégation n'est pas démarré</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Statistiques Historiques -->
        <h5 class="mt-4 mb-3"><i class="fas fa-chart-line me-2"></i>Agrégation des Historiques</h5>
        <div class="row">
            <div class="col-md-4">
                <div class="stat-card text-center">
                    <div class="text-primary mb-2">
                        <i class="fas fa-database fa-3x"></i>
                    </div>
                    <h3 class="text-primary">${stats.nbHistoriques}</h3>
                    <p class="text-muted mb-0">Historiques Créés</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card text-center">
                    <div class="text-warning mb-2">
                        <i class="fas fa-clock fa-3x"></i>
                    </div>
                    <h3 class="text-warning">${stats.nbDonneesNonAggregees}</h3>
                    <p class="text-muted mb-0">Données en Attente</p>
                    <small class="text-muted">(plus de 2 jours)</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card text-center">
                    <div class="text-success mb-2">
                        <i class="fas fa-calendar-check fa-3x"></i>
                    </div>
                    <h3 class="text-success">${stats.derniereDate}</h3>
                    <p class="text-muted mb-0">Dernière Date Agrégée</p>
                </div>
            </div>
        </div>

        <!-- Statistiques des Statistiques -->
        <h5 class="mt-4 mb-3"><i class="fas fa-chart-bar me-2"></i>Génération des Statistiques</h5>
        <div class="row">
            <div class="col-md-6">
                <div class="stat-card text-center">
                    <div class="text-info mb-2">
                        <i class="fas fa-chart-pie fa-3x"></i>
                    </div>
                    <h3 class="text-info">${stats.nbStatistiques}</h3>
                    <p class="text-muted mb-0">Statistiques Générées</p>
                    <small class="text-muted">(tous types confondus)</small>
                </div>
            </div>
            <div class="col-md-6">
                <div class="stat-card text-center">
                    <div class="text-purple mb-2">
                        <i class="fas fa-calendar-day fa-3x"></i>
                    </div>
                    <h3 class="text-purple">${stats.dernierePeriodeStats}</h3>
                    <p class="text-muted mb-0">Dernière Période Statistiques</p>
                </div>
            </div>
        </div>

        <!-- Actions manuelles supprimées : interface en lecture seule -->
        <div class="alert alert-secondary mt-3">
            <i class="fas fa-lock me-2"></i>Les actions d'agrégation manuelle et par période ont été désactivées. Le système effectue désormais l'agrégation automatiquement chaque nuit et réalise un rattrapage automatique des jours manquants.
        </div>

        <!-- Rafraîchir les statistiques -->
        <div class="text-center">
            <a href="${pageContext.request.contextPath}/admin/aggregation" class="btn btn-outline-primary">
                <i class="fas fa-sync-alt me-2"></i>Rafraîchir les Statistiques
            </a>
        </div>

        <!-- Informations -->
        <div class="mt-4">
            <div class="alert alert-info">
                <h6><i class="fas fa-info-circle me-2"></i>Informations</h6>
                <ul class="mb-0">
                    <li><strong>Agrégation automatique :</strong> S'exécute tous les jours à 00h30</li>
                    <li><strong>Données agrégées :</strong> Toutes les mesures des capteurs sont résumées par jour et par utilisateur</li>
                    <li><strong>Historiques :</strong> Un enregistrement est créé dans la table <code>historiques_consommation</code></li>
                    <li><strong>Statistiques :</strong> Génération automatique de 4 statistiques par utilisateur et par jour :
                        <ul>
                            <li><code>CONSOMMATION_TOTALE</code> : Volume total de la journée</li>
                            <li><code>CONSOMMATION_MOYENNE</code> : Moyenne sur les 7 derniers jours</li>
                            <li><code>PIC_CONSOMMATION</code> : Consommation maximale sur 7 jours</li>
                            <li><code>TENDANCE</code> : Variation par rapport à la moyenne (en %)</li>
                        </ul>
                    </li>
                    <li><strong>Prévention de doublons :</strong> Si un historique ou une statistique existe déjà pour une date, il n'est pas recréé</li>
                    <li><strong>Rattrapage automatique :</strong> Le système agrège automatiquement les jours manquants</li>
                    <li><strong>Données en attente :</strong> Indique les mesures de plus de 2 jours qui ne sont pas encore agrégées</li>
                </ul>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function validerPeriode() {
            const dateDebut = document.getElementById('dateDebut').value;
            const dateFin = document.getElementById('dateFin').value;
            
            if (!dateDebut || !dateFin) {
                alert('Veuillez sélectionner les deux dates');
                return false;
            }
            
            if (new Date(dateDebut) > new Date(dateFin)) {
                alert('La date de début doit être antérieure à la date de fin');
                return false;
            }
            
            const jours = Math.ceil((new Date(dateFin) - new Date(dateDebut)) / (1000 * 60 * 60 * 24)) + 1;
            
            return confirm('Agréger les données pour ' + jours + ' jour(s) ?\nDu ' + dateDebut + ' au ' + dateFin);
        }
        
        // Pas d'actions JS supplémentaires nécessaires (interface lecture seule)
        window.onload = function() {};
    </script>
</body>
</html>
