/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UpdateAdmin extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.getRequestDispatcher("/updateAdminForm.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to the form page for GET requests
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("LogedAdminInfo") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/AdminLogin.jsp");
            return;
        }else{
            String URL = request.getContextPath()+"/admin/index.jsp";
            response.sendRedirect(URL);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        
        String adminIdStr = request.getParameter("admin_id");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String fullName = request.getParameter("full_name");
        String mobileNoStr = request.getParameter("mobile_no");
        String role = request.getParameter("role");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        System.out.println("000");

        try {
            // Validate input
            if (adminIdStr == null || username == null || email == null || fullName == null ||
                mobileNoStr == null || role == null ||
                adminIdStr.trim().isEmpty() || username.trim().isEmpty() || email.trim().isEmpty() ||
                fullName.trim().isEmpty() || mobileNoStr.trim().isEmpty() || role.trim().isEmpty()) {
                session.setAttribute("errorMessage", "All fields are required");
              response.sendRedirect("admin/pages/editAdmin.jsp?id="+adminIdStr);
                return;
            }

            int adminId;
            long mobileNo;
            try {
                adminId = Integer.parseInt(adminIdStr);
                mobileNo = Long.parseLong(mobileNoStr);
                if (mobileNoStr.length() != 10) {
                    session.setAttribute("errorMessage", "Mobile number must be exactly 10 digits");
                 response.sendRedirect("admin/pages/editAdmin.jsp?id="+adminIdStr);
                    return;
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid admin ID or mobile number format");
                response.sendRedirect("admin/pages/editAdmin.jsp?id="+adminIdStr);
                return;
            }

            // Validate role
            if (!role.equals("super_admin") && !role.equals("moderator") && !role.equals("support")) {
                session.setAttribute("errorMessage", "Invalid role");
                response.sendRedirect("admin/pages/editAdmin.jsp?id="+adminIdStr);
                return;
            }

            // Validate full_name (max 100 chars, letters and spaces only, as per client-side)
            if (fullName.length() > 100) {
                session.setAttribute("errorMessage", "Full name must not exceed 100 characters");
            response.sendRedirect("admin/pages/editAdmin.jsp?id="+adminIdStr);
                return;
            }
            if (!fullName.matches("^[A-Za-z\\s]{1,25}$")) {
                session.setAttribute("errorMessage", "Full name must contain only letters and spaces, max 25 characters");
             response.sendRedirect("admin/pages/editAdmin.jsp?id="+adminIdStr);
                return;
            }

            // Validate username length (max 50 chars)
            if (username.length() > 50) {
                session.setAttribute("errorMessage", "Username must not exceed 50 characters");
                response.sendRedirect("admin/pages/editAdmin.jsp?id="+adminIdStr);
                return;
            }

            // Validate email (max 100 chars, basic email format)
            if (email.length() > 100) {
                session.setAttribute("errorMessage", "Email must not exceed 100 characters");
               response.sendRedirect("admin/pages/editAdmin.jsp?id="+adminIdStr);
                return;
            }
            if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
                session.setAttribute("errorMessage", "Invalid email format");
               response.sendRedirect("admin/pages/editAdmin.jsp?id="+adminIdStr);
                return;
            }

            // Establish database connection
            conn = util.DatabaseUtil.getConnection();

            // Check if username is unique (excluding current admin)
            String checkUsernameQuery = "SELECT admin_id FROM Admin WHERE username = ? AND admin_id != ?";
            pstmt = conn.prepareStatement(checkUsernameQuery);
            pstmt.setString(1, username);
            pstmt.setInt(2, adminId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                session.setAttribute("errorMessage", "Username already exists");
                response.sendRedirect("admin/pages/editAdmin.jsp?id="+adminIdStr);
                return;
            }

            System.out.println("111");
            // Check if email is unique (excluding current admin)
            String checkEmailQuery = "SELECT admin_id FROM Admin WHERE email = ? AND admin_id != ?";
            pstmt.close();
            pstmt = conn.prepareStatement(checkEmailQuery);
            pstmt.setString(1, email);
            pstmt.setInt(2, adminId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                session.setAttribute("errorMessage", "Email already exists");
                response.sendRedirect("admin/pages/editAdmin.jsp?id="+adminIdStr);
                return;
            }

            
            
            String updateQuery = "UPDATE Admin SET username = ?, email = ?, full_name = ?, mobile_no = ?, role = ? WHERE admin_id = ?";
            pstmt.close();
            pstmt = conn.prepareStatement(updateQuery);
            pstmt.setString(1, username);
            pstmt.setString(2, email);
            pstmt.setString(3, fullName);
            pstmt.setLong(4, mobileNo);
            pstmt.setString(5, role);
            pstmt.setInt(6, adminId);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                String URL = "admin/index.jsp?param=adminInfo";
                response.sendRedirect(URL); // Redirect to admin list or dashboard
            } else {
                session.setAttribute("errorMessage", "Admin not found");
                response.sendRedirect("admin/pages/editAdmin.jsp?id="+adminIdStr);
            }

            System.out.println("222");
        } catch (SQLException e) {
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
            response.sendRedirect("admin/pages/editAdmin.jsp?id="+adminIdStr);
            e.printStackTrace();
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Server error: " + e.getMessage());
            response.sendRedirect("admin/pages/editAdmin.jsp?id="+adminIdStr);
            e.printStackTrace();
        } finally {
            // Clean up resources
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet to update admin details";
    }
}