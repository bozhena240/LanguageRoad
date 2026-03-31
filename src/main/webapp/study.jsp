<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.Properties" %>
<%
    
    String currentLang = request.getParameter("lang");
    if (currentLang == null) { currentLang = "chinese"; } 
    String displayLang = currentLang.substring(0, 1).toUpperCase() + currentLang.substring(1);

    
    Properties props = new Properties();
    java.io.InputStream inStream = Thread.currentThread().getContextClassLoader().getResourceAsStream("db.properties");
    if (inStream != null) { props.load(inStream); }
%>
<!DOCTYPE html>
<html data-theme="<%= currentLang %>">
<head>
    <meta charset="UTF-8">
    <title>Study <%= displayLang %></title>
    <style>
        /* --- THE SHAPE-SHIFTING COLOR THEMES --- */
        [data-theme="chinese"] { --bg-color: #FDF0D5; --primary: #930014; --secondary: #E7BD8A; --accent: #DB4B3A; --text-dark: #5B000B; --card-bg: #FFFFFF; }
        [data-theme="russian"] { --bg-color: #F7EFE0; --primary: #0A1D49; --secondary: #CC8E4A; --accent: #8E0018; --text-dark: #171721; --card-bg: #FFFFFF; }
        [data-theme="turkish"] { --bg-color: #D1C4CE; --primary: #223857; --secondary: #E8A121; --accent: #A12E24; --text-dark: #223857; --card-bg: #FFFFFF; }
        [data-theme="italian"] { --bg-color: #F0F8FF; --primary: #004B7D; --secondary: #FF9F00; --accent: #008A72; --text-dark: #004B7D; --card-bg: #FFFFFF; }

        body { font-family: 'Segoe UI', Tahoma, sans-serif; background-color: var(--bg-color); color: var(--text-dark); margin: 0; padding: 40px; display: flex; flex-direction: column; align-items: center; min-height: 100vh;}
        
        .header { text-align: center; margin-bottom: 40px; }
        h1 { color: var(--primary); font-size: 3rem; border-bottom: 4px solid var(--secondary); padding-bottom: 10px; margin-bottom: 0;}

        /* --- FLASHCARD CSS --- */
        .flashcard {
            background-color: var(--card-bg);
            width: 100%;
            max-width: 500px;
            height: 300px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            border: 4px solid var(--secondary);
            cursor: pointer;
            transition: transform 0.3s ease, border-color 0.3s ease;
            position: relative;
        }

        .flashcard:hover {
            transform: translateY(-10px);
            border-color: var(--accent);
        }

        .word-front { font-size: 3rem; font-weight: bold; color: var(--text-dark); }
        .word-back { font-size: 3.5rem; font-weight: bold; color: var(--primary); display: none; margin-bottom: 10px;}
        .pron-back { font-size: 1.5rem; color: #7f8c8d; display: none; }
        
        .hint-text { position: absolute; bottom: 20px; font-size: 0.9rem; color: #bdc3c7; }

        .controls { margin-top: 40px; display: flex; gap: 20px; }
        button { background-color: var(--primary); color: white; padding: 15px 30px; border: none; border-radius: 8px; cursor: pointer; font-size: 1.2rem; font-weight: bold; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        button:hover { opacity: 0.9; transform: scale(1.05); }
        .back-btn { display: block; margin-top: 40px; padding: 10px 20px; background-color: var(--text-dark); color: white; text-decoration: none; border-radius: 8px; font-weight: bold; }
    </style>
</head>
<body>

    <div class="header">
        <h1><%= displayLang %> Practice</h1>
        <p>Test your memory.</p>
    </div>

    <div class="flashcard" onclick="flipCard()">
        <div id="front" class="word-front">Loading...</div>
        <div id="back" class="word-back"></div>
        <div id="pron" class="pron-back"></div>
        <div class="hint-text">Click card to reveal</div>
    </div>

    <div class="controls">
        <button onclick="nextCard()">Next Word ➔</button>
    </div>

    <a href="app?lang=<%= currentLang %>" class="back-btn">← Back to Dashboard</a>

    <script>
      
        let vocabularyList = [
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver"); 
                Connection conn = DriverManager.getConnection(props.getProperty("db.url"), props.getProperty("db.user"), props.getProperty("db.password"));
                
                PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM vocabulary WHERE language = ? ORDER BY RAND()");
                pstmt.setString(1, currentLang); 
                ResultSet rs = pstmt.executeQuery();

                while (rs.next()) {
                    
                    String eng = rs.getString("english_meaning").replace("'", "\\'");
                    String target = rs.getString("target_word").replace("'", "\\'");
                    String pron = rs.getString("pronunciation");
                    if(pron == null) pron = "";
                    pron = pron.replace("'", "\\'");
                    
                   
                    out.println("{ english: '" + eng + "', target: '" + target + "', pron: '" + pron + "' },");
                }
                conn.close();
            } catch (Exception e) {
                out.println("console.error('DB Error: " + e.getMessage() + "');");
            }
        %>
        ];

        let currentIndex = 0;

        
        function loadCard() {
            if (vocabularyList.length === 0) {
                document.getElementById('front').innerText = "No words added yet!";
                document.getElementById('back').style.display = 'none';
                document.getElementById('pron').style.display = 'none';
                return;
            }

            document.getElementById('front').style.display = 'block';
            document.getElementById('back').style.display = 'none';
            document.getElementById('pron').style.display = 'none';

            
            let currentWord = vocabularyList[currentIndex];
            document.getElementById('front').innerText = currentWord.english;
            document.getElementById('back').innerText = currentWord.target;
            
            if(currentWord.pron !== "") {
                document.getElementById('pron').innerText = currentWord.pron;
            } else {
                document.getElementById('pron').innerText = "";
            }
        }

        function flipCard() {
            if (vocabularyList.length === 0) return;
            
            document.getElementById('front').style.display = 'none';
            document.getElementById('back').style.display = 'block';
            
            if(document.getElementById('pron').innerText !== "") {
                document.getElementById('pron').style.display = 'block';
            }
        }

        function nextCard() {
            if (vocabularyList.length === 0) return;
            
            currentIndex++;
            if (currentIndex >= vocabularyList.length) {
                currentIndex = 0;
            }
            loadCard();
        }

        loadCard();
    </script>
</body>
</html>