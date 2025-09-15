package controller;

import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;
import util.DatabaseUtil;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.zip.CheckedInputStream;
import java.util.regex.Pattern;

public class Registration extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Registration</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Registration at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    public static boolean checkEmpty(String info) {
        return info.isEmpty();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        RequestDispatcher dispatcher = null;
        Connection connection = null;
        String duplicateEmail = "", dupliucateContact = "";

        // Get form parameters
        String fullName = request.getParameter("name");
        String contact = request.getParameter("contact");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String terms = request.getParameter("terms");

        // Validation flags
        boolean isValid = true;
        StringBuilder errorMessage = new StringBuilder();

        // Validate Full Name
        if (fullName == null || fullName.trim().isEmpty()) {
            isValid = false;
            errorMessage.append("Full Name cannot be empty.<br>");
        } else if (!fullName.matches("^[a-zA-Z\\s]{2,50}$")) {
            isValid = false;
            errorMessage.append("Full Name must contain only letters and spaces (2-50 characters).<br>");
        }

        // Validate Contact Number
        if (contact == null || contact.trim().isEmpty()) {
            isValid = false;
            errorMessage.append("Contact Number cannot be empty.<br>");
        } else if (!contact.matches("^\\d{10}$")) {
            isValid = false;
            errorMessage.append("Contact Number must be exactly 10 digits.<br>");
        }

        // Validate Email
        if (email == null || email.trim().isEmpty()) {
            isValid = false;
            errorMessage.append("Email Address cannot be empty.<br>");
        } else if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            isValid = false;
            errorMessage.append("Please enter a valid email address.<br>");
        }

        // Validate Password
        if (password == null || password.trim().isEmpty()) {
            isValid = false;
            errorMessage.append("Password cannot be empty.<br>");
        } else if (!password.matches("^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$")) {
            isValid = false;
            errorMessage.append("Password must be at least 8 characters long and contain letters and numbers.<br>");
        }

        // Validate Confirm Password
        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            isValid = false;
            errorMessage.append("Confirm Password cannot be empty.<br>");
        } else if (!confirmPassword.equals(password)) {
            isValid = false;
            errorMessage.append("Passwords do not match.<br>");
        }

        // Validate Terms and Conditions
        if (terms == null || !terms.equals("on")) {
            isValid = false;
            errorMessage.append("You must accept the Terms and Conditions.<br>");
        }

        if (!isValid) {
            // Return errors to user
            System.out.println("Error Message :" + errorMessage);
            request.setAttribute("errors", errorMessage);
            request.setAttribute("name", fullName);
            request.setAttribute("contact", contact);
            request.setAttribute("email", email);
            dispatcher = request.getRequestDispatcher("registration.jsp");
            dispatcher.forward(request, response);
        }

        try {
            connection = DatabaseUtil.getConnection();
        } catch (SQLException ex) {
            out.print("Error : " + ex.getMessage());
            System.out.println("Error : " + ex.getMessage());
            return;
        }

        //Check the email is exists or not
        if (connection != null) {
            PreparedStatement checkEmailExists;
            PreparedStatement checkContactExists;
            try {
                checkEmailExists = connection.prepareStatement("select count(*) from users where email = ?");
                checkEmailExists.setString(1, email);

                ResultSet emailFound = checkEmailExists.executeQuery();

                emailFound.next();

                int email_found = emailFound.getInt(1);

                if (email_found > 0) {
                    duplicateEmail += "Use another Email Id";
                    request.setAttribute("duplicateEmail", duplicateEmail);

                    dispatcher = request.getRequestDispatcher("registration.jsp");
                    dispatcher.forward(request, response);
                }

            } catch (SQLException ex) {
                out.print("Error : " + ex.getMessage());
                System.out.println("Error : " + ex.getMessage());
                return;
            }

            try {
                checkContactExists = connection.prepareStatement("select count(*) from users where contact_number = ? ");
                checkContactExists.setString(1, contact);

                ResultSet contactFound = checkContactExists.executeQuery();
                contactFound.next();

                int contact_found = contactFound.getInt(1);

                if (contact_found > 0) {
                    dupliucateContact += "Use another Contact number";
                    request.setAttribute("duplicateContact", dupliucateContact);
                    dispatcher = request.getRequestDispatcher("registration.jsp");
                    dispatcher.forward(request, response);
                }

            } catch (SQLException ex) {
                out.print("Error : " + ex.getMessage());
                System.out.println("Error : " + ex.getMessage());
                return;
            }
            
            long user_id = Long.parseLong(TimestampIdGenerator.generateUniqueId());
            
            
            PreparedStatement addUserData = null;
            try {
                addUserData = connection.prepareStatement("Insert into users values(? , ? , ? , ? , ?)");
                
                addUserData.setLong(1, user_id);
                addUserData.setString(2, fullName);
                addUserData.setString(3, contact);
                addUserData.setString(4, email);
                addUserData.setString(5, confirmPassword);
                
                int insertUserInfo = addUserData.executeUpdate();
                
                if(insertUserInfo == 1){
                    response.sendRedirect("login.jsp");
                }
                
                
            } catch (SQLException ex) {
                out.print("Error : " + ex.getMessage());
                System.out.println("Error : " + ex.getMessage());
                return;
            }

        }

    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}

class TimestampIdGenerator {

    private static final DateTimeFormatter formatter
            = DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS"); // Includes milliseconds

    public static String generateUniqueId() {
        return LocalDateTime.now().format(formatter);
    }
}
