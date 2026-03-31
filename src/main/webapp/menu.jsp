<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("loggedUser") == null) {
        response.sendRedirect("index.jsp");
        return; 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>LanguageRoad - Start Your Journey</title>
    <style>
      
        :root {
            --bg-color: #FDF0D5; /* Varden (Creamy background) */
            --text-color: #003049; /* Cosmos Blue */
            --card-bg: #FFFFFF; /* Clean white */
            --primary-accent: #C1121F; /* Crimson Blaze */
            --secondary-accent: #669BBC; /* Blue Marble (Soft blue for borders) */
            --shadow: 0 4px 15px rgba(0, 48, 73, 0.1); /* Cosmos blue tinted shadow */
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
            padding: 40px;
        }

        .container {
            text-align: center;
            max-width: 800px;
        }

        .intro-card {
            background-color: var(--card-bg);
            padding: 60px;
            border-radius: 20px;
            box-shadow: var(--shadow);
            margin-bottom: 50px;
            border-top: 8px solid var(--primary-accent); /* Crimson Blaze accent line */
        }

        h1 {
            font-size: 3.5rem;
            margin-bottom: 20px;
            color: var(--text-color);
        }

        p.lead {
            font-size: 1.5rem;
            margin-bottom: 40px;
            color: var(--secondary-accent); /* Blue Marble for the subtitle */
        }

        .language-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            width: 100%;
            max-width: 600px;
            margin: 0 auto;
        }

        .lang-button {
            background-color: var(--card-bg);
            border: 2px solid var(--secondary-accent);
            border-radius: 12px;
            padding: 25px;
            text-decoration: none;
            color: var(--text-color);
            display: flex;
            flex-direction: column;
            align-items: center;
            transition: all 0.3s ease;
            box-shadow: var(--shadow);
        }

        .lang-button:hover {
            transform: translateY(-5px);
            border-color: var(--primary-accent);
            background-color: #FFF9F9; /* Very slight red tint */
            box-shadow: 0 8px 25px rgba(193, 18, 31, 0.2); /* Crimson shadow */
        }

        .lang-button:active {
            transform: translateY(2px);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .flag-icon {
            font-size: 4rem;
            margin-bottom: 15px;
        }

        .lang-name {
            font-size: 1.4rem;
            font-weight: bold;
        }
    </style>
</head>
<body>

    <div class="container">
        
        <div style="text-align: right; margin-bottom: 20px;">
            <a href="logout" style="color: var(--primary-accent); text-decoration: none; font-weight: bold; border: 2px solid var(--primary-accent); padding: 8px 16px; border-radius: 8px;">Log Out</a>
        </div>
        <div class="intro-card">
            <h1>Welcome to LanguageRoad</h1>
            <p class="lead">Your journey to fluency starts here. Choose your path below.</p>
        </div>

        <div class="language-grid">
            <a href="app?lang=chinese" class="lang-button">
                <span class="flag-icon">🇨🇳</span>
                <span class="lang-name">Chinese</span>
            </a>
            <a href="app?lang=russian" class="lang-button">
                <span class="flag-icon">🇷🇺</span>
                <span class="lang-name">Russian</span>
            </a>
            <a href="app?lang=turkish" class="lang-button">
                <span class="flag-icon">🇹🇷</span>
                <span class="lang-name">Turkish</span>
            </a>
            <a href="app?lang=italian" class="lang-button">
                <span class="flag-icon">🇮🇹</span>
                <span class="lang-name">Italian</span>
            </a>
        </div>
    </div>

</body>
</html>