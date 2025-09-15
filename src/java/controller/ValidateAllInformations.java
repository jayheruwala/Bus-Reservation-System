package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;
import util.DatabaseUtil;
import jakarta.servlet.http.HttpSession;

public class ValidateAllInformations extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ValidateAllInformations</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ValidateAllInformations at " + request.getContextPath() + "</h1>");
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

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        HttpSession session = request.getSession();

        try {
            String busId = request.getParameter("busId");
            String seatNumbers = request.getParameter("seatNumbers");

            // Validate required parameters
            if (busId == null || seatNumbers == null) {
                throw new ServletException("Missing required parameters");
            }

            String[] seatNumberArray = seatNumbers.split(",");

            // First validate passenger details
            if (!validatePassengerDetails(request, seatNumberArray)) {
                request.setAttribute("errorMessage", "Invalid passenger details. Please check all fields.");
                request.getRequestDispatcher("PassengerDetails.jsp").forward(request, response);
                return;
            }

            conn = DatabaseUtil.getConnection();
            double totalAmount = validateSeatsAndGetFare(request,conn, busId, seatNumberArray);
            
            if (totalAmount == -1) {
                request.setAttribute("errorMessage", "One or more selected seats are no longer available.");
                request.getRequestDispatcher("PassengerDetails.jsp").forward(request, response);
                return;
            }
            
            // Store booking information in session for payment page
            session.setAttribute("busId", busId);
            session.setAttribute("seatNumbers", seatNumbers);
            session.setAttribute("totalAmount", totalAmount);
            
            // Store passenger details in session
            StringBuilder passengerDetails = new StringBuilder();
            for (String seatNumber : seatNumberArray) {
                passengerDetails.append(seatNumber).append(":")
                              .append(request.getParameter("name_" + seatNumber)).append(":")
                              .append(request.getParameter("age_" + seatNumber)).append(":")
                              .append(request.getParameter("gender_" + seatNumber)).append(";");
            }
            session.setAttribute("passengerDetails", passengerDetails.toString());
            
            // Redirect to payment page
            response.sendRedirect("payment.jsp");

         } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("PassengerDetails.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

    }

    private boolean validatePassengerDetails(HttpServletRequest request, String[] seatNumbers) {
        for (String seatNumber : seatNumbers) {
            String name = request.getParameter("name_" + seatNumber);
            String ageStr = request.getParameter("age_" + seatNumber);
            String gender = request.getParameter("gender_" + seatNumber);

            // Validate name (2-50 characters, letters and spaces only)
            if (name == null || !name.matches("^[A-Za-z ]{2,50}$")) {
                return false;
            }

            // Validate age
            try {
                int age = Integer.parseInt(ageStr);
                if (age < 1 || age > 120) {
                    return false;
                }
            } catch (NumberFormatException e) {
                return false;
            }

            // Validate gender
            if (gender == null || !(gender.equals("Male") || gender.equals("Female") || gender.equals("Other"))) {
                return false;
            }
        }
        return true;
    }

    private double validateSeatsAndGetFare(HttpServletRequest request,Connection conn, String busId, String[] seatNumbers)
            throws SQLException {
        double totalFare = 0.0;
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // Check seat availability and get fare
        String sql = "SELECT s.IsAvailable, b.TicketPrice "
                + "FROM Seats s "
                + "JOIN Buses b ON s.BusID = b.BusID "
                + "WHERE s.BusID = ? AND s.SeatNumber = ?";

        pstmt = conn.prepareStatement(sql);

        for (String seatNumber : seatNumbers) {
            pstmt.setString(1, busId);
            pstmt.setString(2, seatNumber);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                boolean isAvailable = rs.getBoolean("IsAvailable");
                double fare = rs.getDouble("TicketPrice");

                if (!isAvailable) {
                    return -1; // Seat not available
                }

                // Apply any discounts based on age if needed
                String ageStr = request.getParameter("age_" + seatNumber);
                int age = Integer.parseInt(ageStr);

                if (age < 12) {
                    // 50% discount for children under 12
                    totalFare += fare * 0.5;
                }  else {
                    totalFare += fare;
                }
            } else {
                return -1; // Seat not found
            }
        }

        return totalFare;
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
