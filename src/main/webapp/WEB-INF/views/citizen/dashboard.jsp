<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Tableau de Bord - ${sessionScope.user.nom}</title>
    <style>
        body { font-family: sans-serif; display: flex; margin: 0; }
        .sidebar { width: 250px; background: #f4f4f4; min-height: 100vh; padding: 20px; }
        .sidebar h2 { margin-top: 0; }
        .sidebar ul { list-style: none; padding: 0; }
        .sidebar ul li a { display: block; padding: 10px; text-decoration: none; color: #333; border-radius: 5px; }
        .sidebar ul li a:hover, .sidebar ul li a.active { background: #ddd; }
        .main-content { flex-grow: 1; padding: 20px; }
    </style>
</head>
<body>

    <div class="sidebar">
        <h2>Bonjour, ${sessionScope.user.nom}</h2>
        <ul>
            <li><a href="${pageContext.request.contextPath}/dashboard">Accueil</a></li>
            <li><a href="${pageContext.request.contextPath}/profil">Mon Profil</a></li>
            <li><a href="${pageContext.request.contextPath}/consommation/stats">Statistiques</a></li>
            <li><a href="${pageContext.request.contextPath}/consommation/visualisation">Visualisation</a></li>
            <li><a href="${pageContext.request.contextPath}/consommation/historique">Historique</a></li>
            <li><a href="${pageContext.request.contextPath}/mes-alertes">Mes Alertes</a></li>
        </ul>
        <hr>
        <a href="${pageContext.request.contextPath}/auth?action=logout">Se déconnecter</a>
    </div>

    <div class="main-content">
        <c:if test="${empty contentPage}">
            <h1>Bienvenue sur votre tableau de bord</h1>
            <p>Sélectionnez une option dans le menu pour commencer.</p>
        </c:if>
        
        <c:if test="${not empty contentPage}">
            <h1>${pageTitle}</h1>
            <jsp:include page="${contentPage}" />
        </c:if>
    </div>

</body>
</html>
