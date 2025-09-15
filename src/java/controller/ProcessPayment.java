package controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.DatabaseUtil;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.List;
import model.PaymentDetails;
import model.User;

public class ProcessPayment extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        HttpSession session = request.getSession();
        Map<String, Map<String, String>> passengerMap = null;
        String busId = null;
        
        if(session.getAttribute("user") == null){
            response.sendRedirect("login.jsp");
        }
        
        User user =(User) session.getAttribute("user");
        long userId = user.getUser_id();
        System.out.println("user id : " + userId);
        
        
        try {
            // Get payment method and validate
            String paymentMethod = request.getParameter("paymentMethod");
            if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
                throw new ServletException("Payment method is required");
            }

            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Retrieve form parameters
            busId = request.getParameter("busId");
            String seatNumbers = request.getParameter("seatNumbers");
            Double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
            String passengerDetails = request.getParameter("passengerDetails");
            
            // Debug print
            System.out.println("Processing Payment:");
            System.out.println("BusID: " + busId);
            System.out.println("Seat Numbers: " + seatNumbers);
            System.out.println("Total Amount: " + totalAmount);
            System.out.println("Payment Method: " + paymentMethod);
            
            // Parse passenger details
            passengerMap = new HashMap<>();
            if (passengerDetails != null && !passengerDetails.trim().isEmpty()) {
                String[] passengers = passengerDetails.split(";");
                for (String passenger : passengers) {
                    if (!passenger.trim().isEmpty()) {
                        String[] parts = passenger.split(":");
                        Map<String, String> details = new HashMap<>();
                        details.put("name", parts[1]);
                        details.put("age", parts[2]);
                        details.put("gender", parts[3]);
                        passengerMap.put(parts[0], details);
                    }
                }
            }

            // Validate required parameters
            if (busId == null || seatNumbers == null || passengerMap.isEmpty()) {
                throw new ServletException("Missing required booking information");
            }

            // Verify available seats
            if (!verifyAvailableSeats(conn, busId, passengerMap.size())) {
                throw new ServletException("Not enough seats available");
            }

            // 1. Verify seat availability
            List<String> unavailableSeats = checkSeatAvailability(conn, busId, seatNumbers);
            if (!unavailableSeats.isEmpty()) {
                throw new ServletException("Seats no longer available: " + String.join(", ", unavailableSeats));
            }

            // 2. Calculate fare and charges
            PaymentDetails paymentDetails = calculatePaymentDetails(conn, busId, seatNumbers, passengerMap);
            
            // Validate total amount
            if (Math.abs(paymentDetails.getTotalAmount() - totalAmount) > 0.01) {
                throw new ServletException("Payment amount mismatch");
            }
            
            // Generate booking reference
            String bookingRef = generateBookingReference();
            
            // Debug print
            System.out.println("Booking Reference: " + bookingRef);
            System.out.println("Calculated Total: " + paymentDetails.getTotalAmount());
            
            // 3. Process payment based on method
            String transactionId = processPaymentMethod(paymentMethod, request);
            
                        System.out.println("Booking table ");

            // 4. Create booking record
            int bookingId = createBookingRecord(conn, bookingRef, busId, paymentDetails.getTotalAmount(),userId); 
            System.out.println("Booking table ");
            
            // 5. Create payment record
            createPaymentRecord(conn, bookingId, paymentDetails.getTotalAmount(), paymentMethod, transactionId);
            
            // 6. Process passengers and update seats
            processPassengersAndSeats(conn, bookingId, busId, passengerMap);
            
            // 7. Store payment breakdown
            storePaymentBreakdown(conn, bookingId, paymentDetails);
            
            // Commit transaction
            conn.commit();
            
            // Store booking details in session
            session.setAttribute("bookingReference", bookingRef);
            session.setAttribute("paymentDetails", paymentDetails);
            session.setAttribute("passengerMap", passengerMap);
            session.setAttribute("transactionId", transactionId);
            
            // Debug print
            System.out.println("Payment processed successfully");
            
            // Redirect to confirmation page
            response.sendRedirect("BookingConfirmation.jsp");
            
        } catch (Exception e) {
            try {
                if (conn != null) {
                    // Rollback the transaction
                    conn.rollback();
                    
                    // If we got far enough to update seats, try to restore them
                    if (passengerMap != null && !passengerMap.isEmpty() && busId != null) {
                        rollbackSeatAvailability(conn, busId, passengerMap.size());
                    }
                }
            } catch (SQLException se) {
                se.printStackTrace();
            }
            
            request.setAttribute("errorMessage", "Payment failed: " + e.getMessage());
            request.getRequestDispatcher("payment.jsp").forward(request, response);
            
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private String generateBookingReference() {
        return "BK" + System.currentTimeMillis() % 100000000;
    }

    private boolean verifyAvailableSeats(Connection conn, String busId, int requiredSeats) 
            throws SQLException {
        String sql = "SELECT AvailableSeats FROM Buses WHERE BusID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, Integer.parseInt(busId));
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                int availableSeats = rs.getInt("AvailableSeats");
                return availableSeats >= requiredSeats;
            }
            return false;
        }
    }

    private String processPaymentMethod(String method, HttpServletRequest request) 
            throws ServletException {
        // Simulate payment processing
        switch (method.toLowerCase()) {
            case "upi":
                String upiId = request.getParameter("upiId");
                if (upiId == null || !upiId.contains("@")) {
                    throw new ServletException("Invalid UPI ID");
                }
                break;
                
            case "card":
                String cardNumber = request.getParameter("cardNumber");
                String expiryDate = request.getParameter("expiryDate");
                String cvv = request.getParameter("cvv");
                if (cardNumber == null || cardNumber.length() != 16 ||
                    expiryDate == null || !expiryDate.matches("(0[1-9]|1[0-2])/[0-9]{2}") ||
                    cvv == null || !cvv.matches("[0-9]{3,4}")) {
                    throw new ServletException("Invalid card details");
                }
                break;
                
            case "netbanking":
                String bankCode = request.getParameter("bankCode");
                if (bankCode == null || bankCode.trim().isEmpty()) {
                    throw new ServletException("Invalid bank selection");
                }
                break;
                
            default:
                throw new ServletException("Invalid payment method");
        }
        
        return "TXN" + System.currentTimeMillis();
    }

    private List<String> checkSeatAvailability(Connection conn, String busId, String seatNumbers) 
            throws SQLException {
        List<String> unavailableSeats = new ArrayList<>();
        String[] seatArray = seatNumbers.split(",");
        
        String sql = "SELECT SeatNumber FROM Seats WHERE BusID = ? AND SeatNumber = ? AND IsAvailable = false";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        
        for (String seatNumber : seatArray) {
            pstmt.setInt(1, Integer.parseInt(busId));
            pstmt.setString(2, seatNumber.trim());
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                unavailableSeats.add(seatNumber.trim());
            }
            rs.close();
        }
        
        pstmt.close();
        return unavailableSeats;
    }

    private PaymentDetails calculatePaymentDetails(Connection conn, String busId, 
            String seatNumbers, Map<String, Map<String, String>> passengerMap) throws SQLException {
        PaymentDetails details = new PaymentDetails();
        
        String sql = "SELECT TicketPrice FROM Buses WHERE BusID = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(busId));
        ResultSet rs = pstmt.executeQuery();
        
        double baseFarePerSeat = 0.0;
        if (rs.next()) {
            baseFarePerSeat = rs.getDouble("TicketPrice");
        }
        rs.close();
        pstmt.close();

        double totalBaseFare = 0.0;
        for (Map.Entry<String, Map<String, String>> entry : passengerMap.entrySet()) {
            int age = Integer.parseInt(entry.getValue().get("age"));
            totalBaseFare += (age < 12) ? baseFarePerSeat * 0.5 : baseFarePerSeat;
        }

        details.setBaseFare(totalBaseFare);
        details.setPlatformFee(20.0);
        details.setServiceTax(totalBaseFare * 0.05);
        details.setInsuranceFee(15.0);
        details.calculateTotal();
        
        return details;
    }

    private int createBookingRecord(Connection conn, String bookingRef, String busId, 
            double totalAmount,long userId) throws SQLException {
        String sql = "INSERT INTO Bookings (BookingReference, BusID, TotalAmount,user_id, BookingDateTime, PaymentStatus) " +
                    "VALUES (?, ?, ?,?, NOW(), 'CONFIRMED')";
        PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        pstmt.setString(1, bookingRef);
        pstmt.setInt(2, Integer.parseInt(busId));
        pstmt.setDouble(3, totalAmount);
        pstmt.setLong(4, userId);
        pstmt.executeUpdate();
        
        
        ResultSet rs = pstmt.getGeneratedKeys();
        int bookingId = 0;
        if (rs.next()) {
            bookingId = rs.getInt(1);
        }
        rs.close();
        pstmt.close();
        
        return bookingId;
    }

    private void createPaymentRecord(Connection conn, int bookingId, double amount, 
            String paymentMethod, String transactionId) throws SQLException {
        String sql = "INSERT INTO Payments (BookingID, Amount, PaymentMethod, PaymentDateTime, TransactionID, PaymentStatus) " +
                    "VALUES (?, ?, ?, NOW(), ?, 'SUCCESS')";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, bookingId);
        pstmt.setDouble(2, amount);
        pstmt.setString(3, paymentMethod.toUpperCase());
        pstmt.setString(4, transactionId);
        pstmt.executeUpdate();
        pstmt.close();
    }

    private void processPassengersAndSeats(Connection conn, int bookingId, String busId, 
            Map<String, Map<String, String>> passengerMap) throws SQLException {
        String passengerSql = "INSERT INTO Passengers (BookingID, Name, Age, Gender, SeatNumber) " +
                             "VALUES (?, ?, ?, ?, ?)";
        String updateSeatSql = "UPDATE Seats SET IsAvailable = false WHERE BusID = ? AND SeatNumber = ?";
        String updateBusSql = "UPDATE Buses SET AvailableSeats = AvailableSeats - ? WHERE BusID = ?";
        
        PreparedStatement passengerStmt = conn.prepareStatement(passengerSql);
        PreparedStatement seatStmt = conn.prepareStatement(updateSeatSql);
        PreparedStatement busStmt = conn.prepareStatement(updateBusSql);
        
        try {
            // First, update the bus's available seats
            int numberOfPassengers = passengerMap.size();
            busStmt.setInt(1, numberOfPassengers);
            busStmt.setInt(2, Integer.parseInt(busId));
            int updatedRows = busStmt.executeUpdate();
            
            if (updatedRows != 1) {
                throw new SQLException("Failed to update bus available seats");
            }
            
            // Then process each passenger and their seats
            for (Map.Entry<String, Map<String, String>> entry : passengerMap.entrySet()) {
                String seatNumber = entry.getKey();
                Map<String, String> passenger = entry.getValue();
                
                // Insert passenger
                passengerStmt.setInt(1, bookingId);
                passengerStmt.setString(2, passenger.get("name"));
                passengerStmt.setInt(3, Integer.parseInt(passenger.get("age")));
                passengerStmt.setString(4, passenger.get("gender"));
                passengerStmt.setString(5, seatNumber);
                passengerStmt.executeUpdate();
                
                // Update seat status
                seatStmt.setInt(1, Integer.parseInt(busId));
                seatStmt.setString(2, seatNumber);
                seatStmt.executeUpdate();
            }
        } finally {
            if (busStmt != null) busStmt.close();
            if (passengerStmt != null) passengerStmt.close();
            if (seatStmt != null) seatStmt.close();
        }
    }

    private void storePaymentBreakdown(Connection conn, int bookingId, PaymentDetails details) 
            throws SQLException {
        String sql = "INSERT INTO PaymentBreakdown (BookingID, BaseFare, PlatformFee, ServiceTax, InsuranceFee) " +
                    "VALUES (?, ?, ?, ?, ?)";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, bookingId);
        pstmt.setDouble(2, details.getBaseFare());
        pstmt.setDouble(3, details.getPlatformFee());
        pstmt.setDouble(4, details.getServiceTax());
        pstmt.setDouble(5, details.getInsuranceFee());
        pstmt.executeUpdate();
        pstmt.close();
    }

    private void rollbackSeatAvailability(Connection conn, String busId, int numberOfSeats) {
        try {
            String sql = "UPDATE Buses SET AvailableSeats = AvailableSeats + ? WHERE BusID = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, numberOfSeats);
                pstmt.setInt(2, Integer.parseInt(busId));
                pstmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}