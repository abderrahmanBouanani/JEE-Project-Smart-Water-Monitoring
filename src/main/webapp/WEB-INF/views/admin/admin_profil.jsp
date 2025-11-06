<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Mon Profil Administrateur</title>
</head>
<body>
    <h1>Mon Profil Administrateur</h1>

    <c:if test="${param.success == 'true'}">
        <p style="color:green;">Profil mis à jour avec succès !</p>
    </c:if>

    <c:if test="${not empty error}">
        <p style="color:red;">${error}</p>
    </c:if>

    <c:choose>
        <c:when test="${editMode}">
            <!-- Mode Édition -->
            <form action="${pageContext.request.contextPath}/admin/profil" method="post">
                <fieldset>
                    <legend>Modifier mon Profil</legend>
                    <div>
                        <label for="nom">Nom :</label>
                        <input type="text" id="nom" name="nom" value="<c:out value='${adminUser.nom}'/>" required size="30">
                    </div>
                    <div>
                        <label for="email">Email :</label>
                        <input type="email" id="email" name="email" value="<c:out value='${adminUser.email}'/>" required size="30">
                    </div>
                    <div>
                        <label for="adresse">Adresse :</label>
                        <input type="text" id="adresse" name="adresse" value="<c:out value='${adminUser.adresse}'/>" size="50">
                    </div>
                    <div>
                        <label for="motDePasse">Nouveau mot de passe :</label>
                        <input type="password" id="motDePasse" name="motDePasse" placeholder="Laisser vide pour ne pas changer" size="30">
                    </div>
                </fieldset>

                <div>
                    <button type="submit">Enregistrer les modifications</button>
                    <a href="${pageContext.request.contextPath}/admin/profil">Annuler</a>
                </div>
            </form>
        </c:when>
        <c:otherwise>
            <!-- Mode Lecture -->
            <div class="profile-details">
                <p><strong>Nom :</strong> <c:out value="${adminUser.nom}"/></p>
                <p><strong>Email :</strong> <c:out value="${adminUser.email}"/></p>
                <p><strong>Adresse :</strong> <c:out value="${adminUser.adresse}"/></p>
                <p><strong>Type de compte :</strong> <c:out value="${adminUser.type}"/></p>
                <p><strong>Date d'inscription :</strong> <c:out value="${adminUser.dateInscription}"/></p>
            </div>

            <p><a href="${pageContext.request.contextPath}/admin/profil?action=edit">Modifier mon profil</a></p>
        </c:otherwise>
    </c:choose>

    <p><a href="${pageContext.request.contextPath}/index.jsp">Retour à l'accueil Admin</a></p>
</body>
</html>
