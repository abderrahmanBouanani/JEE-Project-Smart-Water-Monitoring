<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Alertes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .card {
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            border: none;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .alert-card {
            border-left: 4px solid #dc3545;
            transition: transform 0.2s;
        }
        .alert-card:hover {
            transform: translateY(-2px);
        }
        .alert-card.read {
            border-left-color: #6c757d;
            opacity: 0.8;
        }
        .alert-card.critical {
            border-left-color: #dc3545;
            background-color: #f8d7da;
        }
        .alert-card.warning {
            border-left-color: #ffc107;
            background-color: #fff3cd;
        }
        .alert-card.info {
            border-left-color: #0dcaf0;
            background-color: #d1ecf1;
        }
        .badge-urgence {
            font-size: 0.75rem;
        }
        .alert-icon {
            font-size: 1.5rem;
            margin-right: 10px;
        }
        .alert-date {
            font-size: 0.85rem;
            color: #6c757d;
        }
        .action-buttons {
            opacity: 1; /* Toujours visible pour éviter les problèmes */
        }
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }
        .notification-toast {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1050;
            min-width: 300px;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="h3 mb-1"><i class="fas fa-bell me-2"></i>Mes Alertes</h1>
                    <p class="mb-0">Gestion des notifications et alertes de consommation</p>
                </div>
                <a href="dashboard" class="btn btn-light">
                    <i class="fas fa-arrow-left me-1"></i>Retour au tableau de bord
                </a>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Statistiques rapides -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card bg-danger text-white">
                    <div class="card-body text-center">
                        <h4 id="totalAlertesCount">0</h4>
                        <small>Alertes totales</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-warning text-white">
                    <div class="card-body text-center">
                        <h4 id="nonLuesCount">0</h4>
                        <small>Non lues</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-info text-white">
                    <div class="card-body text-center">
                        <h4 id="critiquesCount">0</h4>
                        <small>Critiques</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-success text-white">
                    <div class="card-body text-center">
                        <h4 id="resoluesCount">0</h4>
                        <small>Résolues</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filtres -->
        <div class="card mb-4">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0"><i class="fas fa-filter me-2"></i>Filtres</h5>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label for="filterType" class="form-label">Type d'alerte</label>
                        <select class="form-select" id="filterType">
                            <option value="all">Tous les types</option>
                            <option value="SEUIL_DEPASSE">Seuil dépassé</option>
                            <option value="FUITE_DETECTEE">Fuite détectée</option>
                            <option value="CAPTEUR_OFFLINE">Capteur offline</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label for="filterUrgence" class="form-label">Niveau d'urgence</label>
                        <select class="form-select" id="filterUrgence">
                            <option value="all">Tous les niveaux</option>
                            <option value="CRITIQUE">Critique</option>
                            <option value="ELEVE">Élevé</option>
                            <option value="MOYEN">Moyen</option>
                            <option value="FAIBLE">Faible</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label for="filterStatut" class="form-label">Statut</label>
                        <select class="form-select" id="filterStatut">
                            <option value="all">Tous les statuts</option>
                            <option value="non-lu">Non lues</option>
                            <option value="lu">Lues</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Actions</label>
                        <div>
                            <button type="button" class="btn btn-outline-primary btn-sm" onclick="markAllAsRead()">
                                <i class="fas fa-check-double me-1"></i>Tout marquer comme lu
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Liste des alertes -->
        <div id="alertesContainer">
            <!-- Les alertes seront chargées dynamiquement ici -->
        </div>

        <!-- État vide -->
        <div id="emptyState" class="empty-state d-none">
            <i class="fas fa-bell-slash fa-4x mb-3"></i>
            <h4>Aucune alerte</h4>
            <p class="text-muted">Vous n'avez aucune alerte pour le moment.</p>
        </div>
    </div>

    <!-- Modal de détails -->
    <div class="modal fade" id="detailAlerteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Détails de l'alerte</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="detailAlerteBody">
                    <!-- Contenu chargé dynamiquement -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                    <button type="button" class="btn btn-primary" id="markAsReadBtn">Marquer comme lu</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Données simulées - À remplacer par des appels à votre backend
        const simulatedAlertes = [
            {
                idAlerte: 1,
                type: "SEUIL_DEPASSE",
                message: "Consommation électrique anormalement élevée dans le salon. Dépassement de 25% du seuil autorisé.",
                niveauUrgence: "CRITIQUE",
                dateCreation: "2024-01-15T14:30:00",
                estLue: false,
                capteur: "CAP-001",
                valeur: 3.8,
                seuil: 3.0,
                unite: "kWh"
            },
            {
                idAlerte: 2,
                type: "FUITE_DETECTEE",
                message: "Débit d'eau anormal détecté dans la salle de bain. Possible fuite.",
                niveauUrgence: "ELEVE",
                dateCreation: "2024-01-15T10:15:00",
                estLue: false,
                capteur: "CAP-002",
                valeur: 0.8,
                seuil: 0.1,
                unite: "L/min"
            },
            {
                idAlerte: 3,
                type: "CAPTEUR_OFFLINE",
                message: "Le capteur de la cuisine est hors ligne depuis 2 heures.",
                niveauUrgence: "MOYEN",
                dateCreation: "2024-01-14T18:45:00",
                estLue: true,
                capteur: "CAP-003",
                valeur: null,
                seuil: null,
                unite: null
            },
            {
                idAlerte: 4,
                type: "SEUIL_DEPASSE",
                message: "Consommation de gaz légèrement au-dessus du seuil dans la cuisine.",
                niveauUrgence: "FAIBLE",
                dateCreation: "2024-01-14T12:20:00",
                estLue: true,
                capteur: "CAP-004",
                valeur: 2.2,
                seuil: 2.0,
                unite: "m³"
            }
        ];

        // Fonction pour obtenir les classes CSS selon le type et l'urgence
        function getAlertClasses(alerte) {
            let classes = 'alert-card ';

            if (alerte.estLue) {
                classes += 'read ';
            }

            if (alerte.niveauUrgence === 'CRITIQUE') {
                classes += 'critical';
            } else if (alerte.niveauUrgence === 'ELEVE') {
                classes += 'warning';
            } else {
                classes += 'info';
            }

            return classes;
        }

        // Fonction pour obtenir l'icône selon le type
        function getAlertIcon(type) {
            const icons = {
                'SEUIL_DEPASSE': 'fa-exclamation-triangle',
                'FUITE_DETECTEE': 'fa-tint',
                'CAPTEUR_OFFLINE': 'fa-wifi-slash'
            };
            return icons[type] || 'fa-bell';
        }

        // Fonction pour obtenir la couleur du badge d'urgence
        function getUrgenceBadgeColor(niveauUrgence) {
            const colors = {
                'CRITIQUE': 'bg-danger',
                'ELEVE': 'bg-warning',
                'MOYEN': 'bg-info',
                'FAIBLE': 'bg-secondary'
            };
            return colors[niveauUrgence] || 'bg-secondary';
        }

        // Fonction pour formater la date
        function formatDateTime(dateString) {
            const date = new Date(dateString);
            return date.toLocaleString('fr-FR', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });
        }

        // Fonction pour formater le type d'alerte
        function formatTypeAlerte(type) {
            const types = {
                'SEUIL_DEPASSE': 'Seuil dépassé',
                'FUITE_DETECTEE': 'Fuite détectée',
                'CAPTEUR_OFFLINE': 'Capteur offline'
            };
            return types[type] || type;
        }

        // Fonction pour générer le HTML des détails du capteur
        function generateCapteurDetails(alerte) {
            if (!alerte.capteur) {
                return '';
            }

            let html = '<div class="row mt-3"><div class="col-md-6"><small class="text-muted">Capteur:</small><div><strong>' + alerte.capteur + '</strong></div></div>';

            if (alerte.valeur !== null) {
                html += '<div class="col-md-6"><small class="text-muted">Valeur:</small><div><strong>' + alerte.valeur + ' ' + alerte.unite + '</strong>';

                if (alerte.seuil) {
                    html += ' / ' + alerte.seuil + ' ' + alerte.unite;
                }

                html += '</div></div>';
            }

            html += '</div>';
            return html;
        }

        // Fonction pour générer le HTML des boutons d'action
        function generateActionButtons(alerte) {
            let buttons = '<div class="action-buttons mt-3"><div class="btn-group btn-group-sm">';
            buttons += '<button class="btn btn-outline-primary" onclick="showAlerteDetails(' + alerte.idAlerte + ')"><i class="fas fa-info-circle me-1"></i>Détails</button>';

            if (!alerte.estLue) {
                buttons += '<button class="btn btn-outline-success" onclick="markAsRead(' + alerte.idAlerte + ')"><i class="fas fa-check me-1"></i>Marquer comme lu</button>';
            }

            buttons += '<button class="btn btn-outline-secondary" onclick="archiveAlerte(' + alerte.idAlerte + ')"><i class="fas fa-archive me-1"></i>Archiver</button>';
            buttons += '</div></div>';

            return buttons;
        }

        // Fonction pour afficher les alertes
        function displayAlertes(alertes) {
            const container = document.getElementById('alertesContainer');
            const emptyState = document.getElementById('emptyState');

            container.innerHTML = '';

            if (alertes.length === 0) {
                emptyState.classList.remove('d-none');
                return;
            } else {
                emptyState.classList.add('d-none');
            }

            let totalCount = alertes.length;
            let nonLuesCount = alertes.filter(a => !a.estLue).length;
            let critiquesCount = alertes.filter(a => a.niveauUrgence === 'CRITIQUE').length;
            let resoluesCount = alertes.filter(a => a.estLue).length;

            // Mettre à jour les compteurs
            document.getElementById('totalAlertesCount').textContent = totalCount;
            document.getElementById('nonLuesCount').textContent = nonLuesCount;
            document.getElementById('critiquesCount').textContent = critiquesCount;
            document.getElementById('resoluesCount').textContent = resoluesCount;

            alertes.forEach(alerte => {
                const alerteElement = document.createElement('div');
                alerteElement.className = getAlertClasses(alerte);

                const capteurDetails = generateCapteurDetails(alerte);
                const actionButtons = generateActionButtons(alerte);

                const badgeLu = alerte.estLue ?
                    '<span class="badge bg-success badge-urgence ms-1">LU</span>' :
                    '<span class="badge bg-warning badge-urgence ms-1">NON LU</span>';

                const iconColor = alerte.estLue ? 'text-secondary' : 'text-primary';

                alerteElement.innerHTML =
                    '<div class="card">' +
                        '<div class="card-body">' +
                            '<div class="d-flex justify-content-between align-items-start mb-2">' +
                                '<div class="d-flex align-items-center">' +
                                    '<i class="fas ' + getAlertIcon(alerte.type) + ' alert-icon ' + iconColor + '"></i>' +
                                    '<div>' +
                                        '<h6 class="card-title mb-0">' + formatTypeAlerte(alerte.type) + '</h6>' +
                                        '<small class="alert-date">' + formatDateTime(alerte.dateCreation) + '</small>' +
                                    '</div>' +
                                '</div>' +
                                '<div>' +
                                    '<span class="badge ' + getUrgenceBadgeColor(alerte.niveauUrgence) + ' badge-urgence">' +
                                        alerte.niveauUrgence +
                                    '</span>' +
                                    badgeLu +
                                '</div>' +
                            '</div>' +
                            '<p class="card-text">' + alerte.message + '</p>' +
                            capteurDetails +
                            actionButtons +
                        '</div>' +
                    '</div>';

                container.appendChild(alerteElement);
            });
        }

        // Fonction pour appliquer les filtres
        function applyFilters() {
            let filteredAlertes = [...simulatedAlertes];

            const typeFilter = document.getElementById('filterType').value;
            const urgenceFilter = document.getElementById('filterUrgence').value;
            const statutFilter = document.getElementById('filterStatut').value;

            if (typeFilter !== 'all') {
                filteredAlertes = filteredAlertes.filter(alerte => alerte.type === typeFilter);
            }

            if (urgenceFilter !== 'all') {
                filteredAlertes = filteredAlertes.filter(alerte => alerte.niveauUrgence === urgenceFilter);
            }

            if (statutFilter !== 'all') {
                filteredAlertes = filteredAlertes.filter(alerte =>
                    statutFilter === 'non-lu' ? !alerte.estLue : alerte.estLue
                );
            }

            // Trier par date (les plus récentes en premier) et par statut (non lues d'abord)
            filteredAlertes.sort((a, b) => {
                if (a.estLue !== b.estLue) {
                    return a.estLue ? 1 : -1;
                }
                return new Date(b.dateCreation) - new Date(a.dateCreation);
            });

            displayAlertes(filteredAlertes);
        }

        // Fonction pour afficher les détails d'une alerte
        function showAlerteDetails(alerteId) {
            const alerte = simulatedAlertes.find(a => a.idAlerte === alerteId);
            if (alerte) {
                const modalBody = document.getElementById('detailAlerteBody');

                let detailsTechniques = '';
                if (alerte.capteur) {
                    detailsTechniques += '<p><strong>Capteur:</strong> ' + alerte.capteur + '</p>';
                }
                if (alerte.valeur !== null) {
                    detailsTechniques += '<p><strong>Valeur mesurée:</strong> ' + alerte.valeur + ' ' + alerte.unite + '</p>';
                    if (alerte.seuil) {
                        detailsTechniques += '<p><strong>Seuil:</strong> ' + alerte.seuil + ' ' + alerte.unite + '</p>';
                        detailsTechniques += '<p><strong>Dépassement:</strong> ' + ((alerte.valeur / alerte.seuil - 1) * 100).toFixed(1) + '%</p>';
                    }
                }

                modalBody.innerHTML =
                    '<div class="row">' +
                        '<div class="col-md-6">' +
                            '<h6>Informations générales</h6>' +
                            '<p><strong>Type:</strong> ' + formatTypeAlerte(alerte.type) + '</p>' +
                            '<p><strong>Niveau d\'urgence:</strong> ' +
                                '<span class="badge ' + getUrgenceBadgeColor(alerte.niveauUrgence) + '">' +
                                    alerte.niveauUrgence +
                                '</span>' +
                            '</p>' +
                            '<p><strong>Date:</strong> ' + formatDateTime(alerte.dateCreation) + '</p>' +
                            '<p><strong>Statut:</strong> ' +
                                '<span class="badge ' + (alerte.estLue ? 'bg-success' : 'bg-warning') + '">' +
                                    (alerte.estLue ? 'Lu' : 'Non lu') +
                                '</span>' +
                            '</p>' +
                        '</div>' +
                        '<div class="col-md-6">' +
                            '<h6>Détails techniques</h6>' +
                            detailsTechniques +
                        '</div>' +
                    '</div>' +
                    '<div class="row mt-3">' +
                        '<div class="col-12">' +
                            '<h6>Message</h6>' +
                            '<div class="alert alert-info">' +
                                alerte.message +
                            '</div>' +
                        '</div>' +
                    '</div>';

                // Configurer le bouton "Marquer comme lu"
                const markAsReadBtn = document.getElementById('markAsReadBtn');
                if (alerte.estLue) {
                    markAsReadBtn.style.display = 'none';
                } else {
                    markAsReadBtn.style.display = 'inline-block';
                    markAsReadBtn.onclick = function() {
                        markAsRead(alerteId);
                        bootstrap.Modal.getInstance(document.getElementById('detailAlerteModal')).hide();
                    };
                }

                new bootstrap.Modal(document.getElementById('detailAlerteModal')).show();
            }
        }

        // Fonction pour marquer une alerte comme lue
        function markAsRead(alerteId) {
            const alerte = simulatedAlertes.find(a => a.idAlerte === alerteId);
            if (alerte && !alerte.estLue) {
                alerte.estLue = true;
                // Ici, vous ajouterez un appel AJAX vers votre backend
                console.log('Alerte ' + alerteId + ' marquée comme lue');
                applyFilters(); // Recharger l'affichage

                // Afficher une notification
                showNotification('Alerte marquée comme lue', 'success');
            }
        }

        // Fonction pour marquer toutes les alertes comme lues
        function markAllAsRead() {
            const nonLues = simulatedAlertes.filter(a => !a.estLue);
            if (nonLues.length === 0) {
                showNotification('Toutes les alertes sont déjà lues', 'info');
                return;
            }

            if (confirm('Voulez-vous vraiment marquer ' + nonLues.length + ' alerte(s) comme lue(s) ?')) {
                nonLues.forEach(alerte => {
                    alerte.estLue = true;
                });
                // Ici, vous ajouterez un appel AJAX vers votre backend
                console.log('Toutes les alertes marquées comme lues');
                applyFilters(); // Recharger l'affichage

                showNotification(nonLues.length + ' alerte(s) marquée(s) comme lue(s)', 'success');
            }
        }

        // Fonction pour archiver une alerte
        function archiveAlerte(alerteId) {
            if (confirm('Voulez-vous archiver cette alerte ?')) {
                // Ici, vous ajouterez un appel AJAX vers votre backend
                console.log('Alerte ' + alerteId + ' archivée');

                // Simuler la suppression de l'affichage
                const index = simulatedAlertes.findIndex(a => a.idAlerte === alerteId);
                if (index !== -1) {
                    simulatedAlertes.splice(index, 1);
                    applyFilters(); // Recharger l'affichage
                    showNotification('Alerte archivée avec succès', 'success');
                }
            }
        }

        // Fonction pour afficher des notifications
        function showNotification(message, type) {
            // Créer une notification toast
            const toast = document.createElement('div');
            toast.className = 'alert alert-' + type + ' alert-dismissible fade show notification-toast';
            toast.innerHTML = message + '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
            document.body.appendChild(toast);

            // Supprimer automatiquement après 3 secondes
            setTimeout(function() {
                if (toast.parentNode) {
                    toast.parentNode.removeChild(toast);
                }
            }, 3000);
        }

        // Initialisation
        document.addEventListener('DOMContentLoaded', function() {
            // Appliquer les filtres initiaux
            applyFilters();

            // Écouter les changements de filtres
            document.getElementById('filterType').addEventListener('change', applyFilters);
            document.getElementById('filterUrgence').addEventListener('change', applyFilters);
            document.getElementById('filterStatut').addEventListener('change', applyFilters);
        });
    </script>
</body>
</html>