<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>${empty capteur ? 'Créer un nouveau' : 'Modifier le'} Capteur IoT</title>
</head>
<body>
    <h1>${empty capteur ? 'Créer un nouveau' : 'Modifier le'} Capteur IoT</h1>

    <form action="${pageContext.request.contextPath}/capteurs" method="post">
        <c:if test="${not empty capteur}">
            <input type="hidden" name="id" value="<c:out value='${capteur.idCapteur}'/>"/>
        </c:if>

        <fieldset>
            <legend>Détails du Capteur</legend>
            <div>
                <label for="reference">Référence :</label>
                <input type="text" id="reference" name="reference" value="<c:out value='${capteur.reference}'/>" required>
            </div>
            <div>
                <label for="type">Type :</label>
                <select id="type" name="type">
                    <c:forEach var="type" items="${typesCapteur}">
                        <option value="${type}" ${capteur.type == type ? 'selected' : ''}>${type}</option>
                    </c:forEach>
                </select>
            </div>
            <div>
                <label for="emplacement">Emplacement :</label>
                <input type="text" id="emplacement" name="emplacement" value="<c:out value='${capteur.emplacement}'/>">
            </div>
            <div>
                <label for="seuilAlerte">Seuil d'alerte :</label>
                <input type="number" step="0.1" id="seuilAlerte" name="seuilAlerte" value="<c:out value='${capteur.seuilAlerte}'/>">
            </div>
            <div>
                <label for="utilisateurId">Propriétaire :</label>
                <select id="utilisateurId" name="utilisateurId">
                    <c:forEach var="user" items="${utilisateurs}">
                        <option value="${user.idUtilisateur}" ${capteur.utilisateur.idUtilisateur == user.idUtilisateur ? 'selected' : ''}>${user.nom}</option>
                    </c:forEach>
                </select>
            </div>
            <div>
                <label for="etat">État (Actif) :</label>
                <input type="checkbox" id="etat" name="etat" ${capteur.etat ? 'checked' : ''}>
            </div>
        </fieldset>

        <div>
            <button type="submit">Enregistrer</button>
            <a href="${pageContext.request.contextPath}/capteurs">Annuler</a>
        </div>
    </form>
</body>
</html>
