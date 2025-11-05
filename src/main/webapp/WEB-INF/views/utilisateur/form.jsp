<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>${empty utilisateur ? 'Créer un nouvel' : 'Modifier l\''} Utilisateur</title>
</head>
<body>
    <h1>${empty utilisateur ? 'Créer un nouvel' : 'Modifier l\''} Utilisateur</h1>

    <form action="${pageContext.request.contextPath}/utilisateurs" method="post">
        <c:if test="${not empty utilisateur}">
            <input type="hidden" name="id" value="<c:out value='${utilisateur.idUtilisateur}'/>"/>
        </c:if>

        <fieldset>
            <legend>Détails de l'Utilisateur</legend>
            <div>
                <label for="nom">Nom :</label>
                <input type="text" id="nom" name="nom" value="<c:out value='${utilisateur.nom}'/>" required size="30">
            </div>
            <div>
                <label for="email">Email :</label>
                <input type="email" id="email" name="email" value="<c:out value='${utilisateur.email}'/>" required size="30">
            </div>
            <div>
                <label for="motDePasse">Mot de passe :</label>
                <input type="password" id="motDePasse" name="motDePasse" placeholder="${not empty utilisateur ? 'Laisser vide pour ne pas changer' : ''}" size="30">
            </div>
            <div>
                <label for="adresse">Adresse :</label>
                <input type="text" id="adresse" name="adresse" value="<c:out value='${utilisateur.adresse}'/>" size="50">
            </div>
            <div>
                <label for="type">Type :</label>
                <select id="type" name="type">
                    <c:forEach var="type" items="${typesUtilisateur}">
                        <option value="${type}" ${utilisateur.type == type ? 'selected' : ''}>${type}</option>
                    </c:forEach>
                </select>
            </div>
        </fieldset>

        <div>
            <button type="submit">Enregistrer</button>
            <a href="${pageContext.request.contextPath}/utilisateurs">Annuler</a>
        </div>
    </form>
</body>
</html>
