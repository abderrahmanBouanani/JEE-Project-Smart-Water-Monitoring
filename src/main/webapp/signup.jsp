<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Inscription - Smart Water Monitoring</title>
</head>
<body>
    <h1>Créer un compte</h1>

    <c:if test="${not empty error}">
        <p style="color:red;">${error}</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/signup" method="post">
        <fieldset>
            <legend>Vos informations</legend>
            <div>
                <label for="nom">Nom complet :</label>
                <input type="text" id="nom" name="nom" required size="30">
            </div>
            <div>
                <label for="email">Email :</label>
                <input type="email" id="email" name="email" required size="30">
            </div>
            <div>
                <label for="password">Mot de passe :</label>
                <input type="password" id="password" name="password" required size="30">
            </div>
            <div>
                <label for="adresse">Adresse :</label>
                <input type="text" id="adresse" name="adresse" required size="50">
            </div>
        </fieldset>

        <div>
            <button type="submit">S'inscrire</button>
            <p>Déjà un compte ? <a href="login.jsp">Connectez-vous</a>.</p>
        </div>
    </form>
</body>
</html>
