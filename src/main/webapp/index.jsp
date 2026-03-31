<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome to LanguageRoad</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background-color: #2c3e50; color: white; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .auth-container { background: white; color: #333; padding: 40px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.3); width: 100%; max-width: 400px; text-align: center; }
        h1 { color: #2980b9; margin-bottom: 5px; }
        p { color: #7f8c8d; margin-bottom: 30px; }
        input[type='text'], input[type='password'] { width: 100%; padding: 12px; margin-bottom: 15px; border: 2px solid #ecf0f1; border-radius: 6px; box-sizing: border-box; font-size: 16px; }
        button { width: 100%; background-color: #2980b9; color: white; padding: 15px; border: none; border-radius: 6px; cursor: pointer; font-size: 16px; font-weight: bold; margin-bottom: 10px; transition: 0.3s; }
        button:hover { background-color: #34495e; }
        .error { color: #e74c3c; font-weight: bold; margin-bottom: 15px; }
    </style>
</head>
<body>

    <div class="auth-container">
        <h1>LanguageRoad</h1>
        <p>Your personal polyglot database.</p>
        
        <% if(request.getParameter("error") != null) { %>
            <div class="error">Invalid username or password.</div>
        <% } %>

        <form action="auth" method="POST">
            <input type="hidden" name="action" value="login">
            <input type="text" name="username" required placeholder="Username">
            <input type="password" name="password" required placeholder="Password">
            <button type="submit">Log In</button>
        </form>

        <hr style="border: 1px solid #ecf0f1; margin: 20px 0;">

        <form action="auth" method="POST">
            <input type="hidden" name="action" value="register">
            <input type="text" name="username" required placeholder="New Username">
            <input type="password" name="password" required placeholder="New Password">
            <button type="submit" style="background-color: #27ae60;">Create Account</button>
        </form>
    </div>

</body>
</html>