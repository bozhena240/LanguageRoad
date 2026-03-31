import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/vocabulary")
public class VocabularyServlet extends HttpServlet {
	
	private Properties getDbProperties() {
        Properties props = new Properties();
        try {
            java.io.InputStream in = Thread.currentThread().getContextClassLoader().getResourceAsStream("db.properties");
            if (in != null) {
                props.load(in);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return props;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html><html><head><title>Language Dashboard</title>");
        out.println("<style>");
        out.println("body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; color: #333; display: flex; flex-direction: column; align-items: center; padding: 40px; }");
        out.println(".card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 100%; max-width: 500px; margin-bottom: 20px; }");
        out.println("h1 { color: #2c3e50; text-align: center; }");
        out.println("ul { list-style-type: none; padding: 0; }");
        out.println("li { background: #ecf0f1; margin: 8px 0; padding: 12px; border-radius: 6px; font-size: 18px; display: flex; justify-content: space-between;}");
        out.println("input[type='text'] { width: 100%; padding: 10px; margin: 8px 0 20px 0; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; }");
        out.println("button { width: 100%; background-color: #3498db; color: white; padding: 12px; border: none; border-radius: 6px; cursor: pointer; font-size: 16px; font-weight: bold; }");
        out.println("button:hover { background-color: #2980b9; }");
        out.println("</style></head><body>");

        out.println("<div class='card'>");
        out.println("<h1>Add a New Word</h1>");
        out.println("<form method='POST' action='vocabulary'>");
        out.println("<label>Chinese Character:</label> <input type='text' name='chinese' required>");
        out.println("<label>Pinyin:</label> <input type='text' name='pinyin' required>");
        out.println("<label>English Meaning:</label> <input type='text' name='english' required>");
        out.println("<button type='submit'>Save to Database</button>");
        out.println("</form>");
        out.println("</div>");

        out.println("<div class='card'>");
        out.println("<h1>My Chinese Vocabulary</h1>");
        out.println("<ul>");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); 
            Properties props = getDbProperties();
            Connection conn = DriverManager.getConnection(props.getProperty("db.url"), props.getProperty("db.user"), props.getProperty("db.password"));
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM vocabulary ORDER BY id DESC");

            while (rs.next()) {
                out.println("<li><span><strong>" + rs.getString("chinese_word") + "</strong> (" + rs.getString("pinyin") + ")</span> <span>" + rs.getString("english_meaning") + "</span></li>");
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Database Error: " + e.getMessage() + "</p>");
        }

        out.println("</ul></div></body></html>");
    }

   
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       
        request.setCharacterEncoding("UTF-8"); 
        
        String newChinese = request.getParameter("chinese");
        String newPinyin = request.getParameter("pinyin");
        String newEnglish = request.getParameter("english");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); 
            Properties props = getDbProperties();
            Connection conn = DriverManager.getConnection(props.getProperty("db.url"), props.getProperty("db.user"), props.getProperty("db.password"));
            
            String sql = "INSERT INTO vocabulary (chinese_word, pinyin, english_meaning) VALUES (?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newChinese);
            pstmt.setString(2, newPinyin);
            pstmt.setString(3, newEnglish);
            pstmt.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("vocabulary");
    }
}