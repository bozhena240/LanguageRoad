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

@WebServlet("/editWord")
public class EditWordServlet extends HttpServlet {
	
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
        
        
        String idString = request.getParameter("id");
        String lang = request.getParameter("language");
        String updatedTarget = request.getParameter("targetWord");
        String updatedPron = request.getParameter("pronunciation");
        String updatedEng = request.getParameter("englishMeaning");

        if (idString != null && !idString.isEmpty()) {
            try {
                int idToEdit = Integer.parseInt(idString);
                
                Class.forName("com.mysql.cj.jdbc.Driver"); 
                Properties props = getDbProperties();
                Connection conn = DriverManager.getConnection(props.getProperty("db.url"), props.getProperty("db.user"), props.getProperty("db.password"));
                
               
                String sql = "UPDATE vocabulary SET target_word = ?, pronunciation = ?, english_meaning = ? WHERE id = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, updatedTarget);
                pstmt.setString(2, updatedPron);
                pstmt.setString(3, updatedEng);
                pstmt.setInt(4, idToEdit);
                
                pstmt.executeUpdate(); 
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
      
        response.sendRedirect("app?lang=" + lang);
    }
}
