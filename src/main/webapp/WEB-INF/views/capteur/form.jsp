<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty capteur ? 'Créer un nouveau' : 'Modifier le'} Capteur - Smart Water Monitoring</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .form-container {
            max-width: 800px;
            margin: 0 auto;
        }
        .header-section {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        .form-card {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .btn-primary {
            background-color: #3498db;
            border-color: #3498db;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <div class="form-container">
            <!-- En-tête -->
            <div class="header-section">
                <h1 class="mb-1">
                    <i class="fas ${empty capteur ? 'fa-plus' : 'fa-edit'} me-2"></i>
                    ${empty capteur ? 'Créer un nouveau' : 'Modifier le'} Capteur
                </h1>
                <p class="text-muted mb-0">Configuration d'un capteur IoT</p>
            </div>

            <!-- Formulaire -->
            <div class="form-card">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show">
                        <i class="fas fa-exclamation-triangle me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/capteurs" method="post">
                    <!-- ✅ CORRECTION : Utiliser le bon nom de champ "id" -->
                    <c:if test="${not empty capteur}">
                        <input type="hidden" name="id" value="${capteur.idCapteur}"/>
                    </c:if>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="reference" class="form-label">Référence *</label>
                            <input type="text" class="form-control" id="reference" name="reference"
                                   value="${capteur.reference}" required
                                   placeholder="Ex: CAP-001">
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="type" class="form-label">Type *</label>
                            <select class="form-select" id="type" name="type" required>
                                <option value="">Sélectionner un type</option>
                                <c:forEach var="type" items="${typesCapteur}">
                                    <option value="${type}"
                                        ${capteur.type == type ? 'selected' : ''}>
                                        ${type}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="emplacement" class="form-label">Emplacement</label>
                            <input type="text" class="form-control" id="emplacement" name="emplacement"
                                   value="${capteur.emplacement}"
                                   placeholder="Ex: Salon, Cuisine, Jardin...">
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="seuilAlerte" class="form-label">Seuil d'alerte *</label>
                            <input type="number" step="0.1" class="form-control" id="seuilAlerte" name="seuilAlerte"
                                   value="${capteur.seuilAlerte}" required
                                   placeholder="Ex: 50.0">
                            <div class="form-text">Valeur déclenchant une alerte</div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="utilisateurId" class="form-label">Propriétaire *</label>
                        <select class="form-select" id="utilisateurId" name="utilisateurId" required>
                            <option value="">Sélectionner un utilisateur</option>
                            <c:forEach var="user" items="${utilisateurs}">
                                <option value="${user.idUtilisateur}"
                                    ${capteur.utilisateur != null && capteur.utilisateur.idUtilisateur == user.idUtilisateur ? 'selected' : ''}>
                                    ${user.nom} (${user.email})
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-4">
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" role="switch"
                                   id="etat" name="etat" value="on"
                                   ${capteur.etat ? 'checked' : ''}>
                            <label class="form-check-label" for="etat">
                                <strong>Capteur actif</strong>
                            </label>
                        </div>
                        <div class="form-text">
                            <c:choose>
                                <c:when test="${capteur.etat}">
                                    <span class="text-success">✅ Le capteur est actuellement actif</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-danger">❌ Le capteur est actuellement inactif</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Informations en mode édition -->
                    <c:if test="${not empty capteur}">
                        <div class="card bg-light mb-4">
                            <div class="card-body">
                                <h6 class="card-title">
                                    <i class="fas fa-info-circle me-2"></i>Informations du capteur
                                </h6>
                                <div class="row">
                                    <div class="col-md-6">
                                        <small class="text-muted">ID:</small>
                                        <div class="fw-bold">${capteur.idCapteur}</div>
                                    </div>
                                    <div class="col-md-6">
                                        <small class="text-muted">Date d'installation:</small>
                                        <div class="fw-bold">${capteur.dateInstallation}</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>
                            ${empty capteur ? 'Créer le capteur' : 'Enregistrer les modifications'}
                        </button>
                        <a href="${pageContext.request.contextPath}/capteurs" class="btn btn-outline-secondary">
                            <i class="fas fa-times me-2"></i>Annuler
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Focus sur le premier champ
            document.getElementById('reference').focus();

            // Validation du formulaire
            const form = document.querySelector('form');
            form.addEventListener('submit', function(e) {
                const reference = document.getElementById('reference').value;
                const type = document.getElementById('type').value;
                const utilisateurId = document.getElementById('utilisateurId').value;
                const seuilAlerte = document.getElementById('seuilAlerte').value;

                if (!reference || !type || !utilisateurId || !seuilAlerte) {
                    e.preventDefault();
                    alert('Veuillez remplir tous les champs obligatoires (*)');
                    return false;
                }
            });
        });
    </script>
</body>
</html>