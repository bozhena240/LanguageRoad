<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Grab the language the user clicked on from the Servlet
    String currentLang = (String) request.getAttribute("activeLanguage");
    if (currentLang == null) { currentLang = "chinese"; } // Fallback just in case
%>
<!DOCTYPE html>
<html data-theme="<%= currentLang %>">
<head>
    <meta charset="UTF-8">
    <title>LanguageRoad - <%= currentLang.substring(0, 1).toUpperCase() + currentLang.substring(1) %></title>
    <style>
        
        /* 1. CHINESE */
        [data-theme="chinese"] {
            --bg-color: #FDF0D5; 
            --primary: #930014;    /* Deep Red */
            --secondary: #E7BD8A;  /* Soft Gold */
            --accent: #DB4B3A;     /* Bright Red */
            --text-dark: #5B000B;
            --card-bg: #FFFFFF;
        }

        /* 2. RUSSIAN */
        [data-theme="russian"] {
            --bg-color: #F7EFE0;   /* Ethereal Ivory */
            --primary: #0A1D49;    /* Regal Navy */
            --secondary: #CC8E4A;  /* Opulent Gold */
            --accent: #8E0018;     /* Deep Crimson */
            --text-dark: #171721;  /* Velvet Obsidian */
            --card-bg: #FFFFFF;
        }

        /* 3. TURKISH */
        [data-theme="turkish"] {
            --bg-color: #D1C4CE;   /* Soft Cream/Grey */
            --primary: #223857;    /* Navy */
            --secondary: #E8A121;  /* Orange */
            --accent: #A12E24;     /* Deep Red */
            --text-dark: #223857;
            --card-bg: #FFFFFF;
        }

        /* 4. ITALIAN */
        [data-theme="italian"] {
            --bg-color: #F0F8FF;   /* Soft Sky Blue */
            --primary: #004B7D;    /* Deep Sea Blue */
            --secondary: #FF9F00;  /* Orange/Citrus */
            --accent: #008A72;     /* Leaf Green */
            --text-dark: #004B7D;
            --card-bg: #FFFFFF;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-dark);
            margin: 0;
            padding: 40px;
            display: flex;
            flex-direction: column;
            align-items: center;
            transition: background-color 0.5s ease; 
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
        }

        h1 {
            color: var(--primary);
            font-size: 3rem;
            text-transform: capitalize;
            border-bottom: 4px solid var(--secondary);
            padding-bottom: 10px;
            display: inline-block;
        }

        .card {
            background-color: var(--card-bg);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 600px;
            border-top: 8px solid var(--accent);
            text-align: center;
        }

        .back-btn {
            display: inline-block;
            margin-top: 30px;
            padding: 10px 20px;
            background-color: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            transition: opacity 0.3s;
        }

        .back-btn:hover {
            opacity: 0.8;
        }
    </style>
</head>
<body>

    <div class="header">
        <h1><%= currentLang %> Dashboard</h1>
        <p>Your custom learning environment.</p>
    </div>

    <div class="card">
        <h2>Placeholder for <%= currentLang %> Vocabulary</h2>
        <p>In the next step, we will connect this specific card back to your MySQL database to show the words you add!</p>
        
        <a href="app" class="back-btn">← Back to LanguageRoad</a>
    </div>

</body>
</html>