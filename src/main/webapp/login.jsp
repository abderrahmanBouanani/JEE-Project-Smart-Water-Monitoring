<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Connexion - Smart Water Monitoring</title>
</head>
<body>
    <h1>Connexion</h1>

    <c:if test="${not empty error}">
        <p style="color:red;">${error}</p>
    </c:if>

    <c:if test="${param.signup == 'success'}">
        <p style="color:green;">Inscription réussie ! Vous pouvez maintenant vous connecter.</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/auth" method="post">
        <input type="hidden" name="action" value="login">
        <div>
            <label for="email">Email :</label>
            <input type="email" id="email" name="email" required>
        </div>
        <div>
            <label for="password">Mot de passe :</label>
            <input type="password" id="password" name="password" required>
        </div>
        <div>
            <button type="submit">Se connecter</button>
        </div>
    </form>

    <p>Pas encore de compte ? <a href="signup.jsp">Inscrivez-vous</a>.</p>

</body>
</html>
