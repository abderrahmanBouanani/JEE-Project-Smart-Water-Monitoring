<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Redirection vers login si l'utilisateur n'est pas connecté
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Water Monitoring - Accueil Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #3498db;
            --secondary: #2980b9;
            --success: #27ae60;
            --warning: #f39c12;
            --danger: #e74c3c;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }

        .admin-container {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
        }

        .welcome-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            border: none;
            margin-top: 2rem;
        }

        .management-section {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-top: 2rem;
            padding: 2rem;
        }

        .management-card {
            background: #f8f9fa;
            border: none;
            border-radius: 10px;
            transition: all 0.3s ease;
            text-decoration: none;
            color: inherit;
            display: block;
            padding: 1.5rem;
            margin-bottom: 1rem;
        }

        .management-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            text-decoration: none;
            color: inherit;
            background: #e9ecef;
        }

        .card-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }

        .user-badge {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border-radius: 10px;
            padding: 1rem;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg">
            <div class="container">
                <a class="navbar-brand fw-bold text-primary" href="#">
                    <i class="fas fa-tint me-2"></i>SmartWater Admin
                </a>
                <c:if test="${not empty sessionScope.user}">
                    <div class="navbar-nav ms-auto">
                        <div class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle text-dark" href="#" role="button" data-bs-toggle="dropdown">
                                <i class="fas fa-user-circle me-1"></i>${sessionScope.user.nom}
                            </a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/profil">
                                    <i class="fas fa-user me-2"></i>Mon Profil
                                </a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/auth?action=logout">
                                    <i class="fas fa-sign-out-alt me-2"></i>Se déconnecter
                                </a></li>
                            </ul>
                        </div>
                    </div>
                </c:if>
            </div>
        </nav>

        <!-- Main Content -->
        <div class="container flex-grow-1">
            <!-- Welcome Section -->
            <div class="welcome-card">
                <div class="card-body p-4">
                    <c:if test="${not empty sessionScope.user}">
                        <div class="user-badge mb-4">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h2 class="mb-2">Bienvenue, ${sessionScope.user.nom} !</h2>
                                    <p class="mb-0 opacity-90">
                                        <i class="fas fa-shield-alt me-1"></i>
                                        Connecté en tant que <strong>${sessionScope.user.type}</strong>
                                    </p>
                                </div>
                                <div class="col-md-4 text-end">
                                    <div class="bg-white text-primary rounded-pill px-3 py-2 d-inline-block">
                                        <i class="fas fa-calendar-day me-2"></i>
                                        <span id="current-date"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <h3 class="fw-bold mb-4 text-center">
                        <i class="fas fa-tachometer-alt me-2 text-primary"></i>Tableau de Bord Administrateur
                    </h3>
                </div>
            </div>

            <!-- Management Section -->
            <div class="management-section">
                <h4 class="fw-bold mb-4">
                    <i class="fas fa-cogs me-2 text-primary"></i>Gestion du Système
                </h4>

                <div class="row">
                    <!-- Gestion des Alertes -->
                    <div class="col-md-6 col-lg-4">
                        <a href="${pageContext.request.contextPath}/alertes" class="management-card">
                            <div class="card-icon bg-danger bg-opacity-10 text-danger">
                                <i class="fas fa-bell"></i>
                            </div>
                            <h5 class="fw-bold mb-2">Gérer les Alertes</h5>
                            <p class="text-muted mb-0 small">
                                Surveillance et gestion des alertes système
                            </p>
                        </a>
                    </div>

                    <!-- Gestion des Utilisateurs -->
                    <div class="col-md-6 col-lg-4">
                        <a href="${pageContext.request.contextPath}/utilisateurs" class="management-card">
                            <div class="card-icon bg-success bg-opacity-10 text-success">
                                <i class="fas fa-users"></i>
                            </div>
                            <h5 class="fw-bold mb-2">Gérer les Utilisateurs</h5>
                            <p class="text-muted mb-0 small">
                                Administration des comptes utilisateurs
                            </p>
                        </a>
                    </div>

                    <!-- Gestion des Capteurs IoT -->
                    <div class="col-md-6 col-lg-4">
                        <a href="${pageContext.request.contextPath}/capteurs" class="management-card">
                            <div class="card-icon bg-info bg-opacity-10 text-info">
                                <i class="fas fa-microchip"></i>
                            </div>
                            <h5 class="fw-bold mb-2">Gérer les Capteurs IoT</h5>
                            <p class="text-muted mb-0 small">
                                Configuration des capteurs connectés
                            </p>
                        </a>
                    </div>

                    <!-- Agrégation des Données -->
                    <div class="col-md-6 col-lg-4">
                        <a href="${pageContext.request.contextPath}/admin/aggregation" class="management-card">
                            <div class="card-icon bg-primary bg-opacity-10 text-primary">
                                <i class="fas fa-database"></i>
                            </div>
                            <h5 class="fw-bold mb-2">Agrégation des Données</h5>
                            <p class="text-muted mb-0 small">
                                Gestion de l'agrégation automatique
                            </p>
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <footer class="bg-dark text-white text-center py-3 mt-5">
            <div class="container">
                <p class="mb-0">
                    <i class="fas fa-tint me-2"></i>SmartWater Monitoring System
                    &copy; 2025 - Tous droits réservés
                </p>
            </div>
        </footer>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Date actuelle
        document.getElementById('current-date').textContent = new Date().toLocaleDateString('fr-FR', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
    </script>
</body>
</html>