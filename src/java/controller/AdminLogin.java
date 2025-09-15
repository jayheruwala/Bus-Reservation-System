/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.AdminModel;
import dao.AdminDAO;

public class AdminLogin extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Basic validation (replace with your actual authentication logic)
        boolean isValid = true;

        if (email == null || email.trim().isEmpty() || !isValidEmail(email)) {
            request.setAttribute("emailError", "Please enter a valid email address");
            isValid = false;
        }

        HttpSession session = request.getSession();
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("passwordError", "Please enter your password");
            isValid = false;
        }

        if (isValid) {

            AdminDAO adminDAO = new AdminDAO();

            AdminModel adminModel = adminDAO.makeUserLogin(request);
            if (adminModel != null) {
                session.setAttribute("LogedAdminInfo", adminModel);
                response.sendRedirect("admin/index.jsp");
            } else {
                session.setAttribute("errorMessage", "Invali Email id and Password");
                response.sendRedirect("admin/AdminLogin.jsp");
            }

        } else {
            session.setAttribute("errorMessage", "Invali Email id and Password");
            response.sendRedirect("admin/AdminLogin.jsp");
        }
    }

    private boolean isValidEmail(String email) {
        String regex = "^(([^<>()\\[\\]\\\\.,;:\\s@\"]+(\\.[^<>()\\[\\]\\\\.,;:\\s@\"]+)*)|(\".+\"))@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$";
        return email.matches(regex);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
