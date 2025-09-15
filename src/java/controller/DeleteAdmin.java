
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;

public class DeleteAdmin extends HttpServlet {

  
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet DeleteAdmin</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DeleteAdmin at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

  
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Invalid user ID.");
            response.sendRedirect(request.getContextPath() + "/admin/index.jsp?param=adminInfo");
            return;
        }
        
        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid user ID format.");
            response.sendRedirect(request.getContextPath() + "/admin/index.jsp?param=adminInfo");
            return;
        }
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = util.DatabaseUtil.getConnection();
            String sql = "DELETE FROM Admin WHERE admin_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                request.getSession().setAttribute("successMessage", "User deleted successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "User not found.");
            }
        } catch (SQLException  e) {
            request.getSession().setAttribute("errorMessage", "Database error: " + e.getMessage());
        } finally {
            // Close resources
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            
            String URL = request.getContextPath()+"/admin/index.jsp?param=adminInfo";
                response.sendRedirect(URL);
        }
    }

  
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

   
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
