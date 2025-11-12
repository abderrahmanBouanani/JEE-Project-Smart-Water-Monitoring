<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Smart Water Monitoring</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            height: 100vh;
            display: flex;
            align-items: center;
        }

        .login-container {
            max-width: 400px;
            margin: 0 auto;
            padding: 2rem;
        }

        .system-name {
            text-align: center;
            margin-bottom: 2rem;
            color: #2c3e50;
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

        .login-card {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border: 1px solid #e9ecef;
        }

        .form-control {
            border-radius: 5px;
            padding: 0.75rem;
        }

        .btn-primary {
            background-color: #3498db;
            border-color: #3498db;
            padding: 0.75rem;
            border-radius: 5px;
            font-weight: 500;
        }

        .btn-primary:hover {
            background-color: #2980b9;
            border-color: #2980b9;
        }

        .alert {
            border-radius: 5px;
            border: none;
        }

        .signup-link {
            text-align: center;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid #e9ecef;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="login-container">
            <!-- Nom du système -->
            <div class="system-name">
                <h1>Smart Water Monitoring</h1>
                <p>Système de surveillance intelligente de l'eau</p>
            </div>

            <!-- Carte de connexion -->
            <div class="login-card">
                <h4 class="text-center mb-4">Connexion</h4>

                <!-- Messages d'alerte -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger mb-3">
                        ${error}
                    </div>
                </c:if>

                <c:if test="${param.signup == 'success'}">
                    <div class="alert alert-success mb-3">
                        Inscription réussie ! Vous pouvez maintenant vous connecter.
                    </div>
                </c:if>

                <!-- Formulaire de connexion -->
                <form action="${pageContext.request.contextPath}/auth" method="post">
                    <input type="hidden" name="action" value="login">

                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email"
                               id="email"
                               name="email"
                               class="form-control"
                               placeholder="votre@email.com"
                               required
                               value="${param.email}">
                    </div>

                    <div class="mb-4">
                        <label for="password" class="form-label">Mot de passe</label>
                        <input type="password"
                               id="password"
                               name="password"
                               class="form-control"
                               placeholder="Votre mot de passe"
                               required>
                    </div>

                    <button type="submit" class="btn btn-primary w-100">
                        Se connecter
                    </button>
                </form>

                <!-- Lien d'inscription -->
                <div class="signup-link">
                    <p class="mb-2">Pas encore de compte ?</p>
                    <a href="signup.jsp">Inscrivez-vous</a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>