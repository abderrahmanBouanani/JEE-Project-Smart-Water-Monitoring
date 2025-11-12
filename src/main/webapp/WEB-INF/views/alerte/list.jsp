<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Alertes - Smart Water Monitoring</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
        }

        .header-section {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            border: 1px solid #e9ecef;
        }

        .system-name {
            color: #2c3e50;
            margin-bottom: 1rem;
        }

        .system-name h1 {
            font-size: 1.8rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .system-name p {
            color: #7f8c8d;
            margin: 0;
        }

        .content-card {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border: 1px solid #e9ecef;
        }

        .btn-primary {
            background-color: #3498db;
            border-color: #3498db;
            border-radius: 5px;
            font-weight: 500;
        }

        .btn-primary:hover {
            background-color: #2980b9;
            border-color: #2980b9;
        }

        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }

        .table {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0 0 1px #e9ecef;
        }

        .table thead th {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 1rem;
            font-weight: 500;
        }

        .table tbody td {
            padding: 1rem;
            vertical-align: middle;
            border-color: #e9ecef;
        }

        .actions-column {
            white-space: nowrap;
        }

        .badge-urgence-critique {
            background-color: #e74c3c;
            color: white;
        }

        .badge-urgence-elevee {
            background-color: #e67e22;
            color: white;
        }

        .badge-urgence-moyenne {
            background-color: #f39c12;
            color: white;
        }

        .badge-urgence-faible {
            background-color: #27ae60;
            color: white;
        }

        .badge-lue {
            background-color: #27ae60;
            color: white;
        }

        .badge-non-lue {
            background-color: #e74c3c;
            color: white;
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .alerte-non-lue {
            background-color: #fff5f5;
            font-weight: 500;
        }

        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
            margin-bottom: 1rem;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            margin: 0.5rem 0;
        }

        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- En-tête avec nom du système -->
        <div class="header-section">
            <div class="system-name">
                <h1>Smart Water Monitoring</h1>
                <p>Gestion des alertes système</p>
            </div>

            <div class="d-flex justify-content-between align-items-center">
                <h2 class="mb-0">Liste des Alertes</h2>
                <a href="${pageContext.request.contextPath}/alertes?action=new" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>Créer une alerte
                </a>
            </div>
        </div>

        <!-- Statistiques -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="text-primary">
                        <i class="fas fa-bell fa-2x"></i>
                    </div>
                    <div class="stat-number text-primary">
                        <c:set var="totalAlertes" value="0" />
                        <c:forEach var="alerte" items="${alertes}">
                            <c:set var="totalAlertes" value="${totalAlertes + 1}" />
                        </c:forEach>
                        ${totalAlertes}
                    </div>
                    <div class="stat-label">Total Alertes</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="text-warning">
                        <i class="fas fa-exclamation-triangle fa-2x"></i>
                    </div>
                    <div class="stat-number text-warning">
                        <c:set var="alertesNonLues" value="0" />
                        <c:forEach var="alerte" items="${alertes}">
                            <c:if test="${!alerte.estLue}">
                                <c:set var="alertesNonLues" value="${alertesNonLues + 1}" />
                            </c:if>
                        </c:forEach>
                        ${alertesNonLues}
                    </div>
                    <div class="stat-label">Non Lues</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="text-danger">
                        <i class="fas fa-fire fa-2x"></i>
                    </div>
                    <div class="stat-number text-danger">
                        <c:set var="alertesCritiques" value="0" />
                        <c:forEach var="alerte" items="${alertes}">
                            <c:if test="${alerte.niveauUrgence == 'CRITIQUE'}">
                                <c:set var="alertesCritiques" value="${alertesCritiques + 1}" />
                            </c:if>
                        </c:forEach>
                        ${alertesCritiques}
                    </div>
                    <div class="stat-label">Critiques</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="text-success">
                        <i class="fas fa-check-circle fa-2x"></i>
                    </div>
                    <div class="stat-number text-success">
                        <c:set var="alertesLues" value="0" />
                        <c:forEach var="alerte" items="${alertes}">
                            <c:if test="${alerte.estLue}">
                                <c:set var="alertesLues" value="${alertesLues + 1}" />
                            </c:if>
                        </c:forEach>
                        ${alertesLues}
                    </div>
                    <div class="stat-label">Résolues</div>
                </div>
            </div>
        </div>

        <!-- Contenu principal -->
        <div class="content-card">
            <!-- Messages -->
            <c:if test="${param.success != null}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>
                    Opération réalisée avec succès.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${param.error != null}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    Une erreur est survenue lors de l'opération.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Filtres -->
            <div class="row mb-4">
                <div class="col-md-12">
                    <div class="card">
                        <div class="card-header bg-light">
                            <h6 class="card-title mb-0">
                                <i class="fas fa-filter me-2"></i>Filtres
                            </h6>
                        </div>
                        <div class="card-body">
                            <div class="row g-3">
                                <div class="col-md-3">
                                    <label class="form-label">Statut</label>
                                    <select class="form-select" onchange="filtrerAlertes()" id="filtreStatut">
                                        <option value="all">Tous les statuts</option>
                                        <option value="non-lue">Non lues</option>
                                        <option value="lue">Lues</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Niveau d'urgence</label>
                                    <select class="form-select" onchange="filtrerAlertes()" id="filtreUrgence">
                                        <option value="all">Tous les niveaux</option>
                                        <option value="CRITIQUE">Critique</option>
                                        <option value="ELEVE">Élevé</option>
                                        <option value="MOYEN">Moyen</option>
                                        <option value="FAIBLE">Faible</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Type</label>
                                    <select class="form-select" onchange="filtrerAlertes()" id="filtreType">
                                        <option value="all">Tous les types</option>
                                        <option value="SEUIL_DEPASSE">Seuil dépassé</option>
                                        <option value="FUITE_DETECTEE">Fuite détectée</option>
                                        <option value="CAPTEUR_OFFLINE">Capteur offline</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Actions</label>
                                    <div>
                                        <button type="button" class="btn btn-outline-secondary btn-sm" onclick="reinitialiserFiltres()">
                                            <i class="fas fa-undo me-1"></i>Réinitialiser
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tableau des alertes -->
            <div class="table-responsive">
                <table class="table table-hover" id="tableAlertes">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Type</th>
                            <th>Message</th>
                            <th>Utilisateur</th>
                            <th>Date</th>
                            <th>Niveau</th>
                            <th>Statut</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="alerte" items="${alertes}">
                            <tr class="${alerte.estLue ? '' : 'alerte-non-lue'}"
                                data-statut="${alerte.estLue ? 'lue' : 'non-lue'}"
                                data-urgence="${alerte.niveauUrgence}"
                                data-type="${alerte.type != null ? alerte.type : 'NON_DEFINI'}">
                                <td><strong>#${alerte.idAlerte}</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${alerte.type == null}">
                                            <span class="badge bg-secondary">Type non défini</span>
                                        </c:when>
                                        <c:when test="${alerte.type == 'SEUIL_DEPASSE'}">
                                            <span class="badge bg-warning">Seuil dépassé</span>
                                        </c:when>
                                        <c:when test="${alerte.type == 'FUITE_DETECTEE'}">
                                            <span class="badge bg-danger">Fuite détectée</span>
                                        </c:when>
                                        <c:when test="${alerte.type == 'CAPTEUR_OFFLINE'}">
                                            <span class="badge bg-secondary">Capteur offline</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-info">${alerte.type}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="fw-semibold">${alerte.message}</div>
                                    <c:if test="${alerte.donneeCapteur != null}">
                                        <small class="text-muted">
                                            Capteur: ${alerte.donneeCapteur.capteur.reference}
                                        </small>
                                    </c:if>
                                </td>
                                <td>
                                    <c:if test="${alerte.utilisateur != null}">
                                        <div class="fw-medium">${alerte.utilisateur.nom}</div>
                                        <small class="text-muted">${alerte.utilisateur.email}</small>
                                    </c:if>
                                    <c:if test="${alerte.utilisateur == null}">
                                        <span class="text-muted">-</span>
                                    </c:if>
                                </td>
                                <td>
                                    <div class="fw-medium">
                                        <c:if test="${not empty alerte.dateCreation}">
                                            ${alerte.dateCreation.toLocalDate()}
                                        </c:if>
                                    </div>
                                    <small class="text-muted">
                                        <c:if test="${not empty alerte.dateCreation}">
                                            ${alerte.dateCreation.toLocalTime()}
                                        </c:if>
                                    </small>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${alerte.niveauUrgence == 'CRITIQUE'}">
                                            <span class="badge badge-urgence-critique">
                                                <i class="fas fa-fire me-1"></i>Critique
                                            </span>
                                        </c:when>
                                        <c:when test="${alerte.niveauUrgence == 'ELEVE'}">
                                            <span class="badge badge-urgence-elevee">
                                                <i class="fas fa-exclamation-triangle me-1"></i>Élevé
                                            </span>
                                        </c:when>
                                        <c:when test="${alerte.niveauUrgence == 'MOYEN'}">
                                            <span class="badge badge-urgence-moyenne">
                                                <i class="fas fa-exclamation-circle me-1"></i>Moyen
                                            </span>
                                        </c:when>
                                        <c:when test="${alerte.niveauUrgence == 'FAIBLE'}">
                                            <span class="badge badge-urgence-faible">
                                                <i class="fas fa-info-circle me-1"></i>Faible
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">${alerte.niveauUrgence}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${alerte.estLue}">
                                            <span class="badge badge-lue">
                                                <i class="fas fa-check me-1"></i>Lue
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-non-lue">
                                                <i class="fas fa-clock me-1"></i>Non lue
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="actions-column">
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/alertes?action=edit&id=${alerte.idAlerte}"
                                           class="btn btn-outline-primary btn-sm"
                                           title="Modifier">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/alertes?action=delete&id=${alerte.idAlerte}"
                                           class="btn btn-outline-danger btn-sm"
                                           onclick="return confirm('Êtes-vous sûr de vouloir supprimer cette alerte ?')"
                                           title="Supprimer">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Message si aucune alerte -->
            <c:if test="${empty alertes}">
                <div class="text-center text-muted py-5">
                    <i class="fas fa-bell-slash fa-3x mb-3"></i>
                    <h4>Aucune alerte trouvée</h4>
                    <p class="mb-4">Aucune alerte n'a été créée pour le moment.</p>
                    <a href="${pageContext.request.contextPath}/alertes?action=new" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Créer la première alerte
                    </a>
                </div>
            </c:if>

            <!-- Navigation -->
            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Retour à l'accueil
                </a>
            </div>


        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Filtrage des alertes
        function filtrerAlertes() {
            const filtreStatut = document.getElementById('filtreStatut').value;
            const filtreUrgence = document.getElementById('filtreUrgence').value;
            const filtreType = document.getElementById('filtreType').value;

            const lignes = document.querySelectorAll('#tableAlertes tbody tr');

            lignes.forEach(ligne => {
                const statut = ligne.getAttribute('data-statut');
                const urgence = ligne.getAttribute('data-urgence');
                const type = ligne.getAttribute('data-type');

                let afficher = true;

                // Filtre par statut
                if (filtreStatut !== 'all' && statut !== filtreStatut) {
                    afficher = false;
                }

                // Filtre par urgence
                if (filtreUrgence !== 'all' && urgence !== filtreUrgence) {
                    afficher = false;
                }

                // Filtre par type
                if (filtreType !== 'all' && type !== filtreType) {
                    afficher = false;
                }

                ligne.style.display = afficher ? '' : 'none';
            });
        }

        // Réinitialisation des filtres
        function reinitialiserFiltres() {
            document.getElementById('filtreStatut').value = 'all';
            document.getElementById('filtreUrgence').value = 'all';
            document.getElementById('filtreType').value = 'all';
            filtrerAlertes();
        }

        // Auto-refresh toutes les 30 secondes (optionnel)
        function autoRefresh() {
            setTimeout(() => {
                window.location.reload();
            }, 30000);
        }

        // Initialisation
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Page alertes chargée - ${alertes.size()} alertes trouvées');
            autoRefresh(); // Décommenter si besoin d'auto-refresh
        });
    </script>
</body>
</html>