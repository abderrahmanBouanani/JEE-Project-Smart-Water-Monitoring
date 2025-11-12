<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- The main layout is handled by dashboard.jsp, this is just the content --%>

<style>
    /* Styles specific to the profile page */
    .profile-details p {
        font-size: 1.1rem;
        margin-bottom: 1rem;
        color: #495057;
    }
    .profile-details p strong {
        color: #343a40;
        min-width: 150px;
        display: inline-block;
    }
    .form-label {
        font-weight: 600;
        color: #495057;
    }
</style>

<div class="widget">
    <div class="widget-header d-flex justify-content-between align-items-center">
        <h1 class="widget-title">Mon Profil</h1>
        <c:if test="${!editMode}">
            <a href="${pageContext.request.contextPath}/profil?action=edit" class="btn btn-primary"><i class="fas fa-pencil-alt me-2"></i>Modifier</a>
        </c:if>
    </div>

    <c:if test="${param.success == 'true'}">
        <div class="alert alert-success" role="alert">
            <i class="fas fa-check-circle me-2"></i>Profil mis à jour avec succès !
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger" role="alert">
            <i class="fas fa-exclamation-triangle me-2"></i>${error}
        </div>
    </c:if>

    <c:choose>
        <c:when test="${editMode}">
            <!-- Edit Mode -->
            <form action="${pageContext.request.contextPath}/profil" method="post">
                <div class="mb-3">
                    <label for="nom" class="form-label">Nom</label>
                    <input type="text" class="form-control form-control-lg" id="nom" name="nom" value="<c:out value='${sessionScope.user.nom}'/>" required>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control form-control-lg" id="email" name="email" value="<c:out value='${sessionScope.user.email}'/>" required>
                </div>
                <div class="mb-3">
                    <label for="adresse" class="form-label">Adresse</label>
                    <input type="text" class="form-control form-control-lg" id="adresse" name="adresse" value="<c:out value='${sessionScope.user.adresse}'/>">
                </div>
                <div class="mb-4">
                    <label for="motDePasse" class="form-label">Nouveau mot de passe</label>
                    <input type="password" class="form-control form-control-lg" id="motDePasse" name="motDePasse" placeholder="Laisser vide pour ne pas changer">
                    <div class="form-text">Pour des raisons de sécurité, votre mot de passe actuel n'est pas affiché.</div>
                </div>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary btn-lg"><i class="fas fa-save me-2"></i>Enregistrer</button>
                    <a href="${pageContext.request.contextPath}/profil" class="btn btn-secondary btn-lg">Annuler</a>
                </div>
            </form>
        </c:when>
        <c:otherwise>
            <!-- Read Mode -->
            <div class="profile-details">
                <p><strong>Nom :</strong> <c:out value="${sessionScope.user.nom}"/></p>
                <p><strong>Email :</strong> <c:out value="${sessionScope.user.email}"/></p>
                <p><strong>Adresse :</strong> <c:out value="${sessionScope.user.adresse != null ? sessionScope.user.adresse : 'Non renseignée'}"/></p>
                <p><strong>Type de compte :</strong> <span class="badge bg-info text-dark"><c:out value="${sessionScope.user.type}"/></span></p>
                <p><strong>Date d'inscription :</strong> <c:out value="${sessionScope.user.dateInscription}"/></p>
            </div>
        </c:otherwise>
    </c:choose>
</div>
