<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Liste des Capteurs IoT</title>
</head>
<body>
    <h1>Liste des Capteurs IoT</h1>

    <p>
        <a href="${pageContext.request.contextPath}/capteurs?action=new">Créer un nouveau capteur</a>
    </p>

    <table border="1">
        <thead>
            <tr>
                <th>ID</th>
                <th>Référence</th>
                <th>Type</th>
                <th>Emplacement</th>
                <th>Propriétaire</th>
                <th>État</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="capteur" items="${capteurs}">
                <tr>
                    <td><c:out value="${capteur.idCapteur}"/></td>
                    <td><c:out value="${capteur.reference}"/></td>
                    <td><c:out value="${capteur.type}"/></td>
                    <td><c:out value="${capteur.emplacement}"/></td>
                    <td><c:out value="${capteur.utilisateur.nom}"/></td>
                    <td>${capteur.etat ? 'Actif' : 'Inactif'}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/capteurs?action=edit&id=${capteur.idCapteur}">Modifier</a>
                        &nbsp;|&nbsp;
                        <a href="${pageContext.request.contextPath}/capteurs?action=delete&id=${capteur.idCapteur}" onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce capteur ?')">Supprimer</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <p><a href="${pageContext.request.contextPath}/">Retour à l'accueil</a></p>
</body>
</html>
