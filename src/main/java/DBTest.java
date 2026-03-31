import java.sql.*;

public class DBTest {
    public static void main(String[] args) {
        
        String url = "jdbc:mysql://localhost:3306/LanguageLearnerDB";
        String user = "root";
        String password = "Biruni@2024";

        try {
            Connection conn = DriverManager.getConnection(url, user, password);
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM vocabulary");

            while (rs.next()) {
                System.out.println("Chinese: " + rs.getString("chinese_word") + 
                                   " | English: " + rs.getString("english_meaning"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}