<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Smart Water Monitoring - Accueil Admin</title>
</head>
<body>
    <h1>Bienvenue sur le Tableau de Bord Administrateur</h1>

    <c:if test="${not empty sessionScope.user}">
        <p>Connecté en tant que : <strong>${sessionScope.user.nom}</strong> (${sessionScope.user.type})</p>
        <p><a href="${pageContext.request.contextPath}/admin/profil">Mon Profil</a> | <a href="${pageContext.request.contextPath}/auth?action=logout">Se déconnecter</a></p>
    </c:if>

    <h2>Gestion</h2>
    <ul>
        <li><a href="${pageContext.request.contextPath}/alertes">Gérer les Alertes</a></li>
        <li><a href="${pageContext.request.contextPath}/utilisateurs">Gérer les Utilisateurs</a></li>
        <li><a href="${pageContext.request.contextPath}/capteurs">Gérer les Capteurs IoT</a></li>
    </ul>

</body>
</html>
