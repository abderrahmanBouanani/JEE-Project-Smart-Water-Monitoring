<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Mes Alertes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h1>📢 Mes Alertes</h1>
        <p class="text-muted">Gestion de vos alertes de consommation</p>

        <!-- Message d'erreur -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <!-- Statistiques -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card text-white bg-primary">
                    <div class="card-body text-center">
                        <h5>Total</h5>
                        <h2>${totalAlertes}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-white bg-warning">
                    <div class="card-body text-center">
                        <h5>Non lues</h5>
                        <h2>${nonLuesCount}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-white bg-danger">
                    <div class="card-body text-center">
                        <h5>Critiques</h5>
                        <h2>${critiquesCount}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-white bg-success">
                    <div class="card-body text-center">
                        <h5>Résolues</h5>
                        <h2>${resoluesCount}</h2>
                    </div>
                </div>
            </div>
        </div>

        <!-- Liste des alertes -->
        <c:choose>
            <c:when test="${empty alertes || alertes.size() == 0}">
                <div class="text-center py-5">
                    <div class="alert alert-info">
                        <h4>📭 Aucune alerte</h4>
                        <p>Vous n'avez aucune alerte pour le moment.</p>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                            Retour à l'accueil
                        </a>
                    </div>
                </div>
            </c:when>

            <c:otherwise>
                <!-- Tableau simple des alertes -->
                <div class="card">
                    <div class="card-header">
                        <h5>Liste de vos alertes</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Type</th>
                                        <th>Message</th>
                                        <th>Urgence</th>
                                        <th>Date</th>
                                        <th>Statut</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="alerte" items="${alertes}">
                                        <tr>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${alerte.type == 'SEUIL_DEPASSE'}">
                                                        <span class="badge bg-warning">Seuil dépassé</span>
                                                    </c:when>
                                                    <c:when test="${alerte.type == 'FUITE_DETECTEE'}">
                                                        <span class="badge bg-danger">Fuite détectée</span>
                                                    </c:when>
                                                    <c:when test="${alerte.type == 'CAPTEUR_OFFLINE'}">
                                                        <span class="badge bg-secondary">Capteur offline</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-info">${alerte.type}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${alerte.message}</td>
                                            <td>
                                                <span class="badge
                                                    ${alerte.niveauUrgence == 'CRITIQUE' ? 'bg-danger' :
                                                      alerte.niveauUrgence == 'ELEVE' ? 'bg-warning' :
                                                      alerte.niveauUrgence == 'MOYEN' ? 'bg-info' : 'bg-secondary'}">
                                                    ${alerte.niveauUrgence}
                                                </span>
                                            </td>
                                            <td>${alerte.dateCreation}</td>
                                            <td>
                                                <c:if test="${alerte.estLue}">
                                                    <span class="badge bg-success">Lue</span>
                                                </c:if>
                                                <c:if test="${!alerte.estLue}">
                                                    <span class="badge bg-warning">Non lue</span>
                                                </c:if>
                                            </td>
                                            <td>
                                                <div class="btn-group btn-group-sm">
                                                    <c:if test="${!alerte.estLue}">
                                                        <button class="btn btn-success btn-sm" onclick="markAsRead(${alerte.idAlerte})">
                                                            ✓ Lire
                                                        </button>
                                                    </c:if>
                                                    <button class="btn btn-danger btn-sm" onclick="archiveAlerte(${alerte.idAlerte})">
                                                        ✗ Archiver
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Bouton pour tout marquer comme lu -->
                <div class="mt-3 text-center">
                    <button class="btn btn-primary" onclick="markAllAsRead()">
                        📨 Tout marquer comme lu
                    </button>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Navigation -->
        <div class="mt-4 text-center">
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                ← Retour à l'accueil
            </a>
        </div>
    </div>

    <!-- Dans la section JavaScript, remplace les données simulées par : -->
    <script>
        // Utiliser les données réelles du serveur
        const serverAlertes = [
            <c:forEach var="alerte" items="${alertes}" varStatus="status">
            {
                idAlerte: ${alerte.idAlerte},
                type: "${alerte.type}",
                message: "${alerte.message}",
                niveauUrgence: "${alerte.niveauUrgence}",
                dateCreation: "${alerte.dateCreation}",
                estLue: ${alerte.estLue}
            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        // Mettre à jour l'affichage avec les vraies données
        function updateAlertesDisplay() {
            const totalAlertesCount = serverAlertes.length;
            const nonLuesCount = serverAlertes.filter(a => !a.estLue).length;
            const critiquesCount = serverAlertes.filter(a => a.niveauUrgence === 'CRITIQUE').length;
            const resoluesCount = serverAlertes.filter(a => a.estLue).length;

            // Mettre à jour les compteurs
            document.getElementById('totalAlertesCount').textContent = totalAlertesCount;
            document.getElementById('nonLuesCount').textContent = nonLuesCount;
            document.getElementById('critiquesCount').textContent = critiquesCount;
            document.getElementById('resoluesCount').textContent = resoluesCount;

            // Afficher les données réelles
            displayAlertes(serverAlertes);
        }

        // Au chargement de la page
        document.addEventListener('DOMContentLoaded', function() {
            updateAlertesDisplay();

            // Écouter les changements de filtres
            document.getElementById('filterType').addEventListener('change', applyFilters);
            document.getElementById('filterUrgence').addEventListener('change', applyFilters);
            document.getElementById('filterStatut').addEventListener('change', applyFilters);
        });
    </script>
</body>
</html>