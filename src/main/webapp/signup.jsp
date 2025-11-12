<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - Smart Water Monitoring</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            padding: 2rem 0;
        }

        .signup-container {
            max-width: 500px;
            margin: 0 auto;
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

        .signup-card {
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
            width: 100%;
        }

        .btn-primary:hover {
            background-color: #2980b9;
            border-color: #2980b9;
        }

        .alert {
            border-radius: 5px;
            border: none;
        }

        .login-link {
            text-align: center;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid #e9ecef;
        }

        .form-section {
            margin-bottom: 1.5rem;
        }

        .form-section legend {
            font-size: 1.1rem;
            font-weight: 500;
            color: #2c3e50;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #3498db;
            width: 100%;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Nom du système BIEN VISIBLE -->
        <div class="system-name">
            <h1>Smart Water Monitoring</h1>
            <p>Système de surveillance intelligente de l'eau</p>
        </div>

        <!-- Carte d'inscription -->
        <div class="signup-container">
            <div class="signup-card">
                <h4 class="text-center mb-4">Créer un compte</h4>

                <!-- Messages d'erreur -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger mb-3">
                        ${error}
                    </div>
                </c:if>

                <!-- Formulaire d'inscription -->
                <form action="${pageContext.request.contextPath}/signup" method="post">
                    <fieldset class="form-section">
                        <legend>Vos informations</legend>

                        <div class="mb-3">
                            <label for="nom" class="form-label">Nom complet</label>
                            <input type="text"
                                   id="nom"
                                   name="nom"
                                   class="form-control"
                                   placeholder="Votre nom complet"
                                   required
                                   value="${param.nom}">
                        </div>

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

                        <div class="mb-3">
                            <label for="password" class="form-label">Mot de passe</label>
                            <input type="password"
                                   id="password"
                                   name="password"
                                   class="form-control"
                                   placeholder="Votre mot de passe"
                                   required>
                        </div>

                        <div class="mb-3">
                            <label for="adresse" class="form-label">Adresse</label>
                            <input type="text"
                                   id="adresse"
                                   name="adresse"
                                   class="form-control"
                                   placeholder="Votre adresse complète"
                                   required
                                   value="${param.adresse}">
                        </div>
                    </fieldset>

                    <button type="submit" class="btn btn-primary mb-3">
                        S'inscrire
                    </button>
                </form>

                <!-- Lien de connexion -->
                <div class="login-link">
                    <p class="mb-2">Déjà un compte ?</p>
                    <a href="login.jsp">Connectez-vous</a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>