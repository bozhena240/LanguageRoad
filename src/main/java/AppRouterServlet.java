import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/app")
public class AppRouterServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String requestedLang = request.getParameter("lang");
        
        if (requestedLang == null || requestedLang.isEmpty()) {          
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } else {    
            request.setAttribute("activeLanguage", requestedLang.toLowerCase());
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        }
    }
}