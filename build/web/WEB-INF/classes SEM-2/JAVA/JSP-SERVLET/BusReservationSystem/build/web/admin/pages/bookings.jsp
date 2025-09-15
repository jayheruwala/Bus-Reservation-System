<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List" %>
<%@page import="dao.BookingDetailsDAO" %>
<%@page import="model.BookingDetails" %>

<% 
    if(session.getAttribute("LogedAdminInfo") == null){
        %>  
        <jsp:forward page="AdminLogin.jsp" />

        <%
    }
%>

<%
    BookingDetailsDAO bookingDAO = new BookingDetailsDAO();
    List<BookingDetails> bookings = bookingDAO.getAllBookingDetails();
%>

<div class="content-table">
    <div class="table-header">
        <h3>All Bookings</h3>
        <div>
            <input type="text" class="search-input" placeholder="Search bookings...">
            <button class="action-button">
                <i class="fas fa-filter"></i> Filter
            </button>
        </div>
    </div>
    <div class="table-responsive">
        <table>
            <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>Reference</th>
                    <th>Booking Date</th>
                    <th>Bus ID</th>
                    <th>Route</th>
                    <th>Departure</th>
                    <th>Arrival</th>
                    <th>Passenger</th>
                    <th>Seat</th>
                    <th>Age</th>
                    <th>Gender</th>
                    <th>Payment ID</th>
                    <th>Breakdown ID</th>
                    <th>Status</th>
                    <th>Actions</th>    
                </tr>
            </thead>
            <tbody>
                <% for (BookingDetails booking : bookings) { %>
                <tr>
                    <td>#<%= booking.getBookingID() %></td>
                    <td><%= booking.getBookingReference() %></td>
                    <td><%= booking.getBookingDateTime() %></td>
                    <td><%= booking.getBusID() %></td>
                    <td><%= booking.getSourceDestination() %></td>
                    <td><%= booking.getDepartureDateTime() %></td>
                    <td><%= booking.getArrivalDateTime() %></td>
                    <td><%= booking.getPassengerName()%></td>
                    <td><%= booking.getSeatNumber() %></td>
                    <td><%= booking.getAge() %></td>
                    <td><%= booking.getGender() %></td>
                    <td><%= booking.getPaymentID() %></td>
                    <td><%= booking.getBreakdownID() %></td>
                    <td><span class="status-badge <%= booking.getPaymentStatus().equals("SUCCESS") ? "status-active" : booking.getPaymentStatus().equals("PENDING") ? "status-pending" : "status-cancelled" %> " ><%= booking.getPaymentStatus() %></span></td>
                    <td class="action-icons">
<!--                        <a href="Demo">
                        <i class="fas fa-edit" title="Edit"></i></a>
                        <i class="fas fa-trash" title="Delete"></i>-->
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>
