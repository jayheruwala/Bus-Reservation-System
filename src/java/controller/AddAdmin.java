package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.DatabaseUtil;
import java.sql.*;

public class AddAdmin extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddAdmin</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddAdmin at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String fullName = request.getParameter("full_name");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String mobileNo = request.getParameter("mobile_no");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (fullName == null || username == null || email == null || mobileNo == null || password == null || role == null
                || fullName.trim().isEmpty() || username.trim().isEmpty() || email.trim().isEmpty() || mobileNo.trim().isEmpty()
                || password.trim().isEmpty() || role.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("/admin/pages/addAdmin.jsp").forward(request, response);
            return;
        }

        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
        if (!email.matches(emailRegex)) {
            session.setAttribute("errorMessage", "Invalid email format.");
            response.sendRedirect(request.getContextPath() + "/admin/pages/addAdmin.jsp");
            return;
        }
        String mobileRegex = "[0-9]{10,}";
        if (!mobileNo.matches(mobileRegex)) {
            session.setAttribute("errorMessage", "Invalid mobile number. Must be at least 10 digits.");
            response.sendRedirect(request.getContextPath() + "/admin/pages/addAdmin.jsp");
            return;
        }
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {

            conn = DatabaseUtil.getConnection();

            String checkUsernameSql = "SELECT COUNT(*) FROM Admin WHERE username = ?";
            stmt = conn.prepareStatement(checkUsernameSql);
            stmt.setString(1, username);
            rs = stmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                session.setAttribute("errorMessage", "Username already exists.");
                response.sendRedirect(request.getContextPath() + "/admin/pages/addAdmin.jsp");
                return;
            }

            rs.close();
            stmt.close();

            String checkEmailSql = "SELECT COUNT(*) FROM Admin WHERE email = ?";
            stmt = conn.prepareStatement(checkEmailSql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                session.setAttribute("errorMessage", "Email already exists.");
                response.sendRedirect(request.getContextPath() + "/admin/pages/addAdmin.jsp");
                return;
            }

            rs.close();
            stmt.close();

            String insertSql = "INSERT INTO Admin (username, password, mobile_no, email, full_name, role) VALUES (?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(insertSql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            stmt.setLong(3, Long.parseLong(mobileNo));
            stmt.setString(4, email);
            stmt.setString(5, fullName);
            stmt.setString(6, role);

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
            } else {
                session.setAttribute("errorMessage", "Failed to create admin. Please try again.");
                response.sendRedirect(request.getContextPath() + "/admin/pages/addAdmin.jsp");
            }

        } catch (SQLException exception) {
            session.setAttribute("errorMessage", "Database error: " + exception.getMessage());
            response.sendRedirect(request.getContextPath() + "admin/pages/addAdmin.jsp");

        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
