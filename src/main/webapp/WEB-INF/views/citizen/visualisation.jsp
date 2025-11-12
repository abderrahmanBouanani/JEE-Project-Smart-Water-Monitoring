<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Visualisation du Réseau d'Eau</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .network-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .sensor-status {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 8px;
        }
        .sensor-active { background-color: #28a745; }
        .sensor-inactive { background-color: #dc3545; }
    </style>
</head>
<body>


            <!-- Main Content -->
            <main class="px-md-4">
                <!-- Header -->
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">
                        <i class="fas fa-water me-2"></i>Visualisation du Réseau d'Eau
                    </h1>
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-primary">
                        <i class="fas fa-arrow-left me-1"></i>Retour au dashboard
                    </a>
                </div>

                <!-- Debug Info -->
                <div class="alert alert-info">
                    <small>
                        <strong>Debug:</strong>
                        User ID: ${userId} |
                        Capteurs: ${capteurs.size()} |
                        Dernières données: ${dernieresDonnees.size()}
                    </small>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <strong>Erreur:</strong> ${error}
                    </div>
                </c:if>

                <!-- Vue d'ensemble du réseau -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="network-card">
                            <h5 class="card-title mb-3">
                                <i class="fas fa-network-wired me-2 text-primary"></i>
                                Vue d'ensemble du Réseau
                            </h5>

                            <div class="row">
                                <!-- Résumé -->
                                <div class="col-md-3">
                                    <div class="text-center p-3 border rounded">
                                        <div class="text-primary mb-2">
                                            <i class="fas fa-faucet fa-2x"></i>
                                        </div>
                                        <h4 class="text-primary">${capteurs.size()}</h4>
                                        <p class="text-muted mb-0">Capteurs installés</p>
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="text-center p-3 border rounded">
                                        <div class="text-success mb-2">
                                            <i class="fas fa-check-circle fa-2x"></i>
                                        </div>
                                        <h4 class="text-success">
                                            <c:set var="capteursActifs" value="0" />
                                            <c:forEach var="capteur" items="${capteurs}">
                                                <c:if test="${capteur.etat}">
                                                    <c:set var="capteursActifs" value="${capteursActifs + 1}" />
                                                </c:if>
                                            </c:forEach>
                                            ${capteursActifs}
                                        </h4>
                                        <p class="text-muted mb-0">Capteurs actifs</p>
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="text-center p-3 border rounded">
                                        <div class="text-info mb-2">
                                            <i class="fas fa-tint fa-2x"></i>
                                        </div>
                                        <h4 class="text-info">${dernieresDonnees.size()}</h4>
                                        <p class="text-muted mb-0">Points de mesure</p>
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="text-center p-3 border rounded">
                                        <div class="text-warning mb-2">
                                            <i class="fas fa-sync-alt fa-2x"></i>
                                        </div>
                                        <h4 class="text-warning">En temps réel</h4>
                                        <p class="text-muted mb-0">Surveillance active</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Liste des Capteurs -->
                <div class="row">
                    <div class="col-12">
                        <div class="network-card">
                            <h5 class="card-title mb-3">
                                <i class="fas fa-microchip me-2 text-success"></i>
                                Mes Capteurs (${capteurs.size()})
                            </h5>

                            <c:choose>
                                <c:when test="${not empty capteurs && capteurs.size() > 0}">
                                    <div class="row">
                                        <c:forEach var="capteur" items="${capteurs}">
                                            <div class="col-md-6 col-lg-4 mb-3">
                                                <div class="card h-100">
                                                    <div class="card-body">
                                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                                            <h6 class="card-title mb-0">
                                                                <span class="sensor-status ${capteur.etat ? 'sensor-active' : 'sensor-inactive'}"></span>
                                                                ${capteur.reference}
                                                            </h6>
                                                            <span class="badge ${capteur.etat ? 'bg-success' : 'bg-secondary'}">
                                                                ${capteur.etat ? 'Actif' : 'Inactif'}
                                                            </span>
                                                        </div>
                                                        <p class="card-text text-muted mb-2">
                                                            <i class="fas fa-map-marker-alt me-1"></i>
                                                            ${capteur.emplacement}
                                                        </p>
                                                        <p class="card-text text-muted mb-2">
                                                            <i class="fas fa-tag me-1"></i>
                                                            ${capteur.type}
                                                        </p>
                                                        <p class="card-text text-muted mb-2">
                                                            <i class="fas fa-calendar me-1"></i>
                                                            Installé le ${capteur.dateInstallation}
                                                        </p>

                                                        <!-- Dernière mesure -->
                                                        <c:set var="derniereDonnee" value="${null}" />
                                                        <c:forEach var="donnee" items="${dernieresDonnees}">
                                                            <c:if test="${donnee.capteur.idCapteur == capteur.idCapteur}">
                                                                <c:set var="derniereDonnee" value="${donnee}" />
                                                            </c:if>
                                                        </c:forEach>

                                                        <c:if test="${not empty derniereDonnee}">
                                                            <div class="mt-3 p-2 bg-light rounded">
                                                                <small class="text-muted">Dernière mesure:</small>
                                                                <div class="fw-bold text-primary">
                                                                    ${derniereDonnee.valeurConsommation} ${derniereDonnee.unite}
                                                                </div>
                                                                <small class="text-muted">
                                                                    ${derniereDonnee.horodatage}
                                                                </small>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center text-muted py-4">
                                        <i class="fas fa-microchip fa-3x mb-3"></i>
                                        <h5>Aucun capteur configuré</h5>
                                        <p>Votre réseau de surveillance n'est pas encore configuré.</p>
                                        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">
                                            Configurer le système
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>


            </main>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>