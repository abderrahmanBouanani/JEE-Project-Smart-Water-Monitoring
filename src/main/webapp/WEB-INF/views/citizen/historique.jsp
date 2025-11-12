<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historique de Consommation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h1>Historique de Consommation</h1>

        <!-- Debug Info -->
        <div class="alert alert-info">
            <strong>Debug:</strong>
            Historiques size: ${historiques.size()} |
            TotalVolume: ${totalVolume} |
            TotalCout: ${totalCout} |
            UserId: ${userId}
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <strong>Erreur:</strong> ${error}
            </div>
        </c:if>

        <c:choose>
            <c:when test="${not empty historiques && historiques.size() > 0}">
                <!-- Tableau des données -->
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Volume Total (L)</th>
                            <th>Coût Estimé (€)</th>
                            <th>Consommation Moyenne</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="h" items="${historiques}">
                            <tr>
                                <td>${h.date}</td>
                                <td>${h.volumeTotal}</td>
                                <td>${h.coutEstime}</td>
                                <td>${h.consommationMoyenne}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- Résumé -->
                <div class="card mt-4">
                    <div class="card-header">
                        <h5>Résumé</h5>
                    </div>
                    <div class="card-body">
                        <p><strong>Volume Total:</strong> ${totalVolume} L</p>
                        <p><strong>Coût Total:</strong> ${totalCout} €</p>
                        <p><strong>Moyenne Journalière:</strong> ${moyenneVolume} L</p>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-warning">
                    <h4>📭 Aucune donnée trouvée</h4>
                    <p>La base de données ne contient pas de données pour cet utilisateur.</p>
                </div>
            </c:otherwise>
        </c:choose>

        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary mt-3">
            ← Retour au tableau de bord
        </a>
    </div>
</body>
</html>