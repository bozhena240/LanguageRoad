import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
	
    private Properties getDbProperties() {
        Properties props = new Properties();
        try {
            java.io.InputStream in = Thread.currentThread().getContextClassLoader().getResourceAsStream("db.properties");
            if (in != null) { props.load(in); }
        } catch (Exception e) { e.printStackTrace(); }
        return props;
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); 
            Properties props = getDbProperties();
            Connection conn = DriverManager.getConnection(props.getProperty("db.url"), props.getProperty("db.user"), props.getProperty("db.password"));
            
            if ("register".equals(action)) {
                
                String sql = "INSERT INTO users (username, password) VALUES (?, ?)";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, user);
                pstmt.setString(2, pass);
                pstmt.executeUpdate();
                
                
                HttpSession session = request.getSession();
                session.setAttribute("loggedUser", user);
                response.sendRedirect("menu.jsp"); 
                
            } else if ("login".equals(action)) {
                
                String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, user);
                pstmt.setString(2, pass);
                ResultSet rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    
                    HttpSession session = request.getSession();
                    session.setAttribute("loggedUser", user);
                    response.sendRedirect("menu.jsp"); 
                } else {
                   
                    response.sendRedirect("index.jsp?error=1");
                }
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=1");
        }
    }
}
