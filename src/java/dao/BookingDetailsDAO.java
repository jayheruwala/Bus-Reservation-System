
package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DatabaseUtil;
import model.BookingDetails;


public class BookingDetailsDAO {
    public List<BookingDetails> getAllBookingDetails() {
        List<BookingDetails> bookingList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection(); 

            String query = """
                SELECT 
                    b.BookingID, 
                    b.BookingReference, 
                    b.BookingDateTime, 
                    b.BusID, 
                    CONCAT(bus.Source, ' - ', bus.Destination) AS SourceDestination,
                    bus.DepartureDateTime, 
                    bus.ArrivalDateTime, 
                    p.PassengerID, 
                    p.SeatNumber, 
                    p.Name, 
                    p.Age, 
                    p.Gender, 
                    pay.PaymentID, 
                    pb.BreakdownID, 
                    pay.PaymentStatus
                FROM Bookings b
                LEFT JOIN Buses bus ON b.BusID = bus.BusID
                LEFT JOIN Passengers p ON b.BookingID = p.BookingID
                LEFT JOIN Payments pay ON b.BookingID = pay.BookingID
                LEFT JOIN PaymentBreakdown pb ON b.BookingID = pb.BookingID;
            """;

            stmt = conn.prepareStatement(query);
            rs = stmt.executeQuery();

            while (rs.next()) {
                BookingDetails booking = new BookingDetails();
                booking.setBookingID(rs.getLong("BookingID"));
                booking.setBookingReference(rs.getString("BookingReference"));
                booking.setBookingDateTime(rs.getTimestamp("BookingDateTime").toLocalDateTime());
                booking.setBusID(rs.getLong("BusID"));
                booking.setSourceDestination(rs.getString("SourceDestination"));
                booking.setDepartureDateTime(rs.getTimestamp("DepartureDateTime").toLocalDateTime());
                booking.setArrivalDateTime(rs.getTimestamp("ArrivalDateTime").toLocalDateTime());
                booking.setPassengerID(rs.getLong("PassengerID"));
                booking.setSeatNumber(rs.getString("SeatNumber"));
                booking.setPassengerName(rs.getString("Name"));
                booking.setAge(rs.getInt("Age"));
                booking.setGender(rs.getString("Gender"));
                booking.setPaymentID(rs.getLong("PaymentID"));
                booking.setBreakdownID(rs.getLong("BreakdownID"));
                booking.setPaymentStatus(rs.getString("PaymentStatus"));

                bookingList.add(booking);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (stmt != null) stmt.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
        return bookingList;
    }
}


