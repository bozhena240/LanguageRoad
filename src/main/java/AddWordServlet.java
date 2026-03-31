import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession; 

@WebServlet("/addWord")
public class AddWordServlet extends HttpServlet {
	
    private Properties getDbProperties() {
        Properties props = new Properties();
        try {
            java.io.InputStream in = Thread.currentThread().getContextClassLoader().getResourceAsStream("db.properties");
            if (in != null) { props.load(in); }
        } catch (Exception e) { e.printStackTrace(); }
        return props;
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        
        
        HttpSession session = request.getSession();
        String currentUser = (String) session.getAttribute("loggedUser");
        
       
        if (currentUser == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        String lang = request.getParameter("language");
        String targetWord = request.getParameter("targetWord");
        String pron = request.getParameter("pronunciation");
        String eng = request.getParameter("englishMeaning");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); 
            Properties props = getDbProperties();
            Connection conn = DriverManager.getConnection(props.getProperty("db.url"), props.getProperty("db.user"), props.getProperty("db.password"));
            
            
            String sql = "INSERT INTO vocabulary (language, target_word, pronunciation, english_meaning, username) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, lang);
            pstmt.setString(2, targetWord);
            pstmt.setString(3, pron);
            pstmt.setString(4, eng);
            pstmt.setString(5, currentUser); 
            pstmt.executeUpdate();
            
            conn.close();
        } catch (Exception e) { e.printStackTrace(); }

        response.sendRedirect("app?lang=" + lang);
    }
}
