<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Les Capteurs</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h1>📡 Les Capteurs</h1>
        <p class="text-muted">Gestion des capteurs connectés</p>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <!-- Statistiques -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card text-white bg-primary">
                    <div class="card-body text-center">
                        <h5>Total Capteurs</h5>
                        <h2>${totalCapteurs}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-white bg-success">
                    <div class="card-body text-center">
                        <h5>Capteurs Actifs</h5>
                        <h2>${capteursActifs}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-white bg-info">
                    <div class="card-body text-center">
                        <h5>Données Collectées</h5>
                        <h2>${totalDonnees}</h2>
                    </div>
                </div>
            </div>
        </div>

        <!-- Liste des capteurs -->
        <c:choose>
            <c:when test="${empty capteurs || capteurs.size() == 0}">
                <div class="alert alert-info text-center">
                    <h4>📭 Aucun capteur</h4>
                    <p>Vous n'avez aucun capteur configuré.</p>
                    <a href="#" class="btn btn-primary">➕ Ajouter un capteur</a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="card">
                    <div class="card-header">
                        <h5>Liste des capteurs</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Référence</th>
                                        <th>Type</th>
                                        <th>Emplacement</th>
                                        <th>État</th>
                                        <th>Seuil Alerte</th>
                                        <th>Date Installation</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="capteur" items="${capteurs}">
                                        <tr>
                                            <td><strong>${capteur.reference}</strong></td>
                                            <td>
                                                <span class="badge bg-info">${capteur.type}</span>
                                            </td>
                                            <td>${capteur.emplacement}</td>
                                            <td>
                                                <c:if test="${capteur.etat}">
                                                    <span class="badge bg-success">🟢 Actif</span>
                                                </c:if>
                                                <c:if test="${!capteur.etat}">
                                                    <span class="badge bg-danger">🔴 Inactif</span>
                                                </c:if>
                                            </td>
                                            <td>${capteur.seuilAlerte}</td>
                                            <td>${capteur.dateInstallation}</td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary">
                                                    📊 Données
                                                </button>
                                                <button class="btn btn-sm btn-outline-warning">
                                                    ⚙️ Config
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Dernières données -->
                <div class="card mt-4">
                    <div class="card-header">
                        <h5>📈 Dernières mesures</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-sm">
                                <thead>
                                    <tr>
                                        <th>Capteur</th>
                                        <th>Valeur</th>
                                        <th>Unité</th>
                                        <th>Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="donnee" items="${donnees}" end="10">
                                        <tr>
                                            <td>${donnee.capteur.reference}</td>
                                            <td>
                                                <span class="badge
                                                    <c:if test="${donnee.valeurConsommation > donnee.capteur.seuilAlerte}">
                                                        bg-danger
                                                    </c:if>
                                                    <c:if test="${donnee.valeurConsommation <= donnee.capteur.seuilAlerte}">
                                                        bg-success
                                                    </c:if>
                                                ">
                                                    ${donnee.valeurConsommation}
                                                </span>
                                            </td>
                                            <td>${donnee.unite}</td>
                                            <td>${donnee.horodatage}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Navigation -->
        <div class="mt-4 text-center">
            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
                ← Retour à l'accueil
            </a>
        </div>
    </div>
</body>
</html>