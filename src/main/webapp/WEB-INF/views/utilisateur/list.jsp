<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Liste des Utilisateurs</title>
</head>
<body>
    <h1>Liste des Utilisateurs</h1>

    <p>
        <a href="${pageContext.request.contextPath}/utilisateurs?action=new">Créer un nouvel utilisateur</a>
    </p>

    <table border="1">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>Email</th>
                <th>Adresse</th>
                <th>Type</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="utilisateur" items="${utilisateurs}">
                <tr>
                    <td><c:out value="${utilisateur.idUtilisateur}"/></td>
                    <td><c:out value="${utilisateur.nom}"/></td>
                    <td><c:out value="${utilisateur.email}"/></td>
                    <td><c:out value="${utilisateur.adresse}"/></td>
                    <td><c:out value="${utilisateur.type}"/></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/utilisateurs?action=edit&id=${utilisateur.idUtilisateur}">Modifier</a>
                        &nbsp;|&nbsp;
                        <a href="${pageContext.request.contextPath}/utilisateurs?action=delete&id=${utilisateur.idUtilisateur}" onclick="return confirm('Êtes-vous sûr de vouloir supprimer cet utilisateur ?')">Supprimer</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <p><a href="${pageContext.request.contextPath}/">Retour à l'accueil</a></p>
</body>
</html>
