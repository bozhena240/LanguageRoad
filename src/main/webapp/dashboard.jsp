<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.Properties" %>
<%
    String currentLang = (String) request.getAttribute("activeLanguage");
    if (currentLang == null) { currentLang = "chinese"; } 
    String displayLang = currentLang.substring(0, 1).toUpperCase() + currentLang.substring(1);

    String wordLabel = ""; String wordPlaceholder = ""; String pronLabel = ""; String pronPlaceholder = ""; String pronRequired = "required"; String engPlaceholder = "";

    switch(currentLang) {
        case "chinese": wordLabel = "Chinese Character:"; wordPlaceholder = "e.g., 猫"; pronLabel = "Pinyin:"; pronPlaceholder = "e.g., māo"; engPlaceholder = "e.g., Cat"; break;
        case "russian": wordLabel = "Russian Word (Cyrillic):"; wordPlaceholder = "e.g., Спасибо"; pronLabel = "Pronunciation:"; pronPlaceholder = "e.g., spa-SI-bo"; engPlaceholder = "e.g., Thank you"; break;
        case "turkish": wordLabel = "Turkish Word:"; wordPlaceholder = "e.g., Merhaba"; pronLabel = "Pronunciation (Optional):"; pronPlaceholder = "e.g., mer-ha-ba"; pronRequired = ""; engPlaceholder = "e.g., Hello"; break;
        case "italian": wordLabel = "Italian Word:"; wordPlaceholder = "e.g., Gatto"; pronLabel = "Pronunciation (Optional):"; pronPlaceholder = "e.g., gah-toh"; pronRequired = ""; engPlaceholder = "e.g., Cat"; break;
        default: wordLabel = "Target Word:"; wordPlaceholder = "e.g., Word"; pronLabel = "Pronunciation:"; pronPlaceholder = "e.g., Pronunciation"; engPlaceholder = "e.g., Meaning";
    }

    Properties props = new Properties();
    java.io.InputStream inStream = Thread.currentThread().getContextClassLoader().getResourceAsStream("db.properties");
    if (inStream != null) { props.load(inStream); }
    String dbUrl = props.getProperty("db.url"); String dbUser = props.getProperty("db.user"); String dbPass = props.getProperty("db.password");
%>
<!DOCTYPE html>
<html data-theme="<%= currentLang %>">
<head>
    <meta charset="UTF-8">
    <title>LanguageRoad - <%= displayLang %></title>
    <style>
        [data-theme="chinese"] { --bg-color: #FDF0D5; --primary: #930014; --secondary: #E7BD8A; --accent: #DB4B3A; --text-dark: #5B000B; --card-bg: #FFFFFF; }
        [data-theme="russian"] { --bg-color: #F7EFE0; --primary: #0A1D49; --secondary: #CC8E4A; --accent: #8E0018; --text-dark: #171721; --card-bg: #FFFFFF; }
        [data-theme="turkish"] { --bg-color: #D1C4CE; --primary: #223857; --secondary: #E8A121; --accent: #A12E24; --text-dark: #223857; --card-bg: #FFFFFF; }
        [data-theme="italian"] { --bg-color: #F0F8FF; --primary: #004B7D; --secondary: #FF9F00; --accent: #008A72; --text-dark: #004B7D; --card-bg: #FFFFFF; }

        body { font-family: 'Segoe UI', Tahoma, sans-serif; background-color: var(--bg-color); color: var(--text-dark); margin: 0; padding: 40px; display: flex; flex-direction: column; align-items: center; transition: background-color 0.5s ease; }
        .header { text-align: center; margin-bottom: 20px; }
        h1 { color: var(--primary); font-size: 3rem; border-bottom: 4px solid var(--secondary); padding-bottom: 10px; display: inline-block; margin-bottom: 0;}
        .card { background-color: var(--card-bg); padding: 30px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); width: 100%; max-width: 600px; border-top: 8px solid var(--accent); text-align: center; margin-bottom: 30px; }
        
        form { display: flex; flex-direction: column; text-align: left; margin-top: 20px; }
        label { font-weight: bold; margin-bottom: 5px; color: var(--text-dark); }
        input[type='text'] { width: 100%; padding: 12px; margin-bottom: 20px; border: 2px solid var(--bg-color); border-radius: 6px; box-sizing: border-box; font-size: 16px; }
        button { background-color: var(--primary); color: white; padding: 15px; border: none; border-radius: 6px; cursor: pointer; font-size: 16px; font-weight: bold; transition: opacity 0.3s; }
        button:hover { opacity: 0.8; }
        
        ul { list-style-type: none; padding: 0; }
        li { background: var(--bg-color); margin: 10px 0; padding: 15px; border-radius: 8px; font-size: 18px; display: flex; flex-direction: column; border-left: 5px solid var(--secondary); text-align: left;}
        
        .list-row { display: flex; align-items: center; justify-content: space-between; width: 100%; }
        .word-info { flex-grow: 1; display: flex; justify-content: space-between; margin-right: 15px; }
        
        .action-buttons { display: flex; gap: 5px; }
        .action-btn { background-color: transparent; padding: 5px 10px; font-size: 14px; margin: 0; border-radius: 4px; cursor: pointer;}
        .edit-btn { color: var(--primary); border: 1px solid var(--primary); }
        .edit-btn:hover { background-color: var(--primary); color: white; }
        .delete-btn { color: var(--accent); border: 1px solid var(--accent); }
        .delete-btn:hover { background-color: var(--accent); color: white; }
        
        .inline-edit-form { display: none; width: 100%; margin-top: 15px; background: white; padding: 15px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .inline-edit-form input[type='text'] { margin-bottom: 10px; padding: 8px; }
        .inline-edit-form .save-edit-btn { padding: 10px; background-color: var(--secondary); }
        
        .back-btn { display: inline-block; padding: 10px 20px; background-color: var(--text-dark); color: white; text-decoration: none; border-radius: 8px; font-weight: bold; }
    </style>
</head>
<body>

    <div class="header"><h1><%= displayLang %></h1></div>

    <div class="card">
        <h2>Add a New Word</h2>
        <form action="addWord" method="POST">
            <input type="hidden" name="language" value="<%= currentLang %>">
            <label><%= wordLabel %></label> <input type="text" name="targetWord" required placeholder="<%= wordPlaceholder %>">
            <label><%= pronLabel %></label> <input type="text" name="pronunciation" <%= pronRequired %> placeholder="<%= pronPlaceholder %>">
            <label>English Meaning:</label> <input type="text" name="englishMeaning" required placeholder="<%= engPlaceholder %>">
            <button type="submit">Save to <%= displayLang %> Dictionary</button>
        </form>
    </div>

    <div class="card">
        <h2>My <%= displayLang %> Dictionary</h2>
        <ul>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver"); 
                Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM vocabulary WHERE language = ? ORDER BY id DESC");
                pstmt.setString(1, currentLang); 
                ResultSet rs = pstmt.executeQuery();

                while (rs.next()) {
                    int wordId = rs.getInt("id");
                    String target = rs.getString("target_word");
                    String pronRaw = rs.getString("pronunciation");
                    String eng = rs.getString("english_meaning");
                    
                    String pronOutput = pronRaw;
                    if (pronOutput != null && !pronOutput.trim().isEmpty()) { pronOutput = " (" + pronOutput + ")"; } else { pronOutput = ""; }
                    if (pronRaw == null) pronRaw = ""; 

                    out.println("<li>");
                    
                    
                    out.println("<div class='list-row' id='view-" + wordId + "'>");
                    out.println("  <div class='word-info'>");
                    out.println("    <span><strong>" + target + "</strong>" + pronOutput + "</span>");
                    out.println("    <span>" + eng + "</span>");
                    out.println("  </div>");
                    out.println("  <div class='action-buttons'>");
                    
                    out.println("    <button type='button' class='action-btn edit-btn' onclick='toggleEdit(" + wordId + ")'>Edit</button>");
                    out.println("    <form action='deleteWord' method='POST' style='margin:0; padding:0;'>");
                    out.println("      <input type='hidden' name='id' value='" + wordId + "'>");
                    out.println("      <input type='hidden' name='language' value='" + currentLang + "'>");
                    out.println("      <button type='submit' class='action-btn delete-btn'>Delete</button>");
                    out.println("    </form>");
                    out.println("  </div>");
                    out.println("</div>");
                    
                    
                    out.println("<form action='editWord' method='POST' class='inline-edit-form' id='edit-" + wordId + "'>");
                    out.println("  <input type='hidden' name='id' value='" + wordId + "'>");
                    out.println("  <input type='hidden' name='language' value='" + currentLang + "'>");
                    out.println("  <input type='text' name='targetWord' value='" + target + "' required>");
                    out.println("  <input type='text' name='pronunciation' value='" + pronRaw + "' " + pronRequired + ">");
                    out.println("  <input type='text' name='englishMeaning' value='" + eng + "' required>");
                    out.println("  <div style='display:flex; gap:10px;'>");
                    out.println("    <button type='submit' class='save-edit-btn' style='flex:1;'>Save Changes</button>");
                    out.println("    <button type='button' class='action-btn' style='flex:1;' onclick='toggleEdit(" + wordId + ")'>Cancel</button>");
                    out.println("  </div>");
                    out.println("</form>");

                    out.println("</li>");
                }
                conn.close();
            } catch (Exception e) { out.println("<p style='color:red;'>DB Error: " + e.getMessage() + "</p>"); }
        %>
        </ul>
        <br>
        <div style="display: flex; justify-content: space-between; gap: 10px;">
            <a href="app" class="back-btn">← Back to LanguageRoad</a>
            <a href="study.jsp?lang=<%= currentLang %>" class="back-btn" style="background-color: var(--primary);">🧠 Enter Study Mode</a>
        </div>
    </div>

    <script>
        function toggleEdit(id) {
            let viewDiv = document.getElementById('view-' + id);
            let editForm = document.getElementById('edit-' + id);
            
            if (editForm.style.display === 'block') {
                editForm.style.display = 'none';
                viewDiv.style.display = 'flex';
            } else {
                editForm.style.display = 'block';
                viewDiv.style.display = 'none';
            }
        }
    </script>
</body>
</html>