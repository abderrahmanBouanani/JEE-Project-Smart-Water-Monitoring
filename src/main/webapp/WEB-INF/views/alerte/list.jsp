<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Liste des Alertes</title>
</head>
<body>
    <h1>Liste des Alertes</h1>

    <p>
        <a href="${pageContext.request.contextPath}/alertes?action=new">Créer une nouvelle alerte</a>
    </p>

    <table border="1">
        <thead>
            <tr>
                <th>ID</th>
                <th>Type</th>
                <th>Message</th>
                <th>Date</th>
                <th>Niveau</th>
                <th>Lue</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="alerte" items="${alertes}">
                <tr>
                    <td><c:out value="${alerte.idAlerte}"/></td> <%-- Correction: Utiliser idAlerte --%>
                    <td><c:out value="${alerte.type}"/></td>
                    <td><c:out value="${alerte.message}"/></td>
                    <td><c:out value="${alerte.dateCreation}"/></td> <%-- Correction: Utiliser dateCreation --%>
                    <td><c:out value="${alerte.niveauUrgence}"/></td> <%-- Correction: Utiliser niveauUrgence --%>
                    <td><c:out value="${alerte.estLue}"/></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/alertes?action=edit&id=${alerte.idAlerte}">Modifier</a>
                        &nbsp;|&nbsp;
                        <a href="${pageContext.request.contextPath}/alertes?action=delete&id=${alerte.idAlerte}" onclick="return confirm('Êtes-vous sûr de vouloir supprimer cette alerte ?')">Supprimer</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <p><a href="${pageContext.request.contextPath}/">Retour à l'accueil</a></p>
</body>
</html>
