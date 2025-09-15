<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="util.DatabaseUtil" %>

<% 

    if(session.getAttribute("user") == null){
        response.sendRedirect("login.jsp");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Bus Seat Layout</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f7fa;
                margin: 0;
                padding: 20px;
            }
            h2 {
                text-align: center;
                color: #0f2557;
                margin-bottom: 20px;
            }
            .seat-container {
                width: 500px;
                margin: 0 auto;
                padding: 20px;
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }
            .seat-row {
                display: flex;
                gap: 15px;
                justify-content: center;
                margin-bottom: 15px;
            }
            .seat {
                width: 50px;
                height: 50px;
                text-align: center;
                line-height: 50px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 16px;
                cursor: pointer;
                transition: all 0.3s ease;
            }
            .available {
                background-color: #90ee90;
            }
            .available:hover {
                background-color: #7ed87e;
            }
            .booked {
                background-color: #ff6347;
                pointer-events: none;
            }
            .selected {
                background-color: #1a3a8f;
                color: white;
            }
            .aisle {
                width: 30px;
                background-color: transparent;
                border: none;
            }
            .book-button {
                background: linear-gradient(135deg, #1a3a8f 0%, #0f2557 100%);
                color: white;
                border: none;
                padding: 14px 30px;
                border-radius: 8px;
                cursor: pointer;
                font-size: 18px;
                transition: all 0.3s ease;
                font-weight: bold;
            }
            .book-button:hover {
                background: linear-gradient(135deg, #0f2557 0%, #1a3a8f 100%);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            }
            .error-message {
                color: #ff0000;
                font-size: 14px;
                text-align: center;
                margin-top: 10px;
                display: none;
            }
            .legend {
                display: flex;
                justify-content: center;
                gap: 20px;
                margin-bottom: 20px;
            }
            .legend-item {
                display: flex;
                align-items: center;
                gap: 5px;
            }
            .legend-box {
                width: 20px;
                height: 20px;
                border-radius: 4px;
            }
        </style>
    </head>
    <body>
        <h2>Select Your Seats</h2>
        
        <div class="legend">
            <div class="legend-item">
                <div class="legend-box" style="background-color: #90ee90;"></div>
                <span>Available</span>
            </div>
            <div class="legend-item">
                <div class="legend-box" style="background-color: #ff6347;"></div>
                <span>Booked</span>
            </div>
            <div class="legend-item">
                <div class="legend-box" style="background-color: #1a3a8f;"></div>
                <span>Selected</span>
            </div>
        </div>

        <%
            int busId = Integer.parseInt(request.getParameter("busId"));
            int passengers = Integer.parseInt(request.getParameter("passengers"));
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                conn = DatabaseUtil.getConnection();
                String sql = "SELECT SeatID, SeatNumber, IsAvailable FROM Seats WHERE BusID = ? ORDER BY CAST(SUBSTRING(SeatNumber, 2) AS UNSIGNED)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, busId);
                rs = pstmt.executeQuery();

                List<String> seatList = new ArrayList<>();
                while (rs.next()) {
                    seatList.add(rs.getInt("SeatID") + ":" + rs.getString("SeatNumber") + ":" + rs.getBoolean("IsAvailable"));
                }
        %>
        <div class="seat-container">
            <form id="bookingForm">
                <input type="hidden" name="busId" value="<%=busId%>">
                <input type="hidden" name="selectedSeats" id="selectedSeatsInput" value="">
                <%
                    for (int i = 0; i < seatList.size(); i += 4) {
                %>
                <div class="seat-row">
                    <% for (int j = 0; j < 2; j++) {
                            if (i + j < seatList.size()) {
                                String[] seatData = seatList.get(i + j).split(":");
                                int seatId = Integer.parseInt(seatData[0]);
                                String seatNumber = seatData[1];
                                boolean isAvailable = Boolean.parseBoolean(seatData[2]);
                    %>
                    <div class="seat <%= isAvailable ? "available" : "booked"%>" 
                         data-seat-id="<%=seatId%>" 
                         data-seat-number="<%=seatNumber%>"
                         <% if (isAvailable) { %> onclick="toggleSeat(this)" <% }%>>
                        <%=seatNumber%>
                    </div>
                    <% }
                        } %>
                    <div class="seat aisle"></div>
                    <% for (int j = 2; j < 4; j++) {
                            if (i + j < seatList.size()) {
                                String[] seatData = seatList.get(i + j).split(":");
                                int seatId = Integer.parseInt(seatData[0]);
                                String seatNumber = seatData[1];
                                boolean isAvailable = Boolean.parseBoolean(seatData[2]);
                    %>
                    <div class="seat <%= isAvailable ? "available" : "booked"%>" 
                         data-seat-id="<%=seatId%>" 
                         data-seat-number="<%=seatNumber%>"
                         <% if (isAvailable) { %> onclick="toggleSeat(this)" <% }%>>
                        <%=seatNumber%>
                    </div>
                    <% }
                        } %>
                </div>
                <% }%>
                <div style="text-align: center; margin-top: 20px;">
                    <input type="button" class="book-button" value="Proceed to Enter Details" onclick="redirectToPassengerForm()">
                    <div class="error-message" id="errorMessage">Please select <%= passengers%> seats before proceeding.</div>
                </div>
            </form>
        </div>
        <%
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Error loading seats: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        %>

        <script>
            let selectedSeats = [];
            let selectedSeatNumbers = [];
            const maxSeats = <%= passengers%>;

            function toggleSeat(seatElement) {
                const seatId = seatElement.getAttribute("data-seat-id");
                const seatNumber = seatElement.getAttribute("data-seat-number");

                if (seatElement.classList.contains("selected")) {
                    // Deselect seat
                    seatElement.classList.remove("selected");
                    selectedSeats = selectedSeats.filter(id => id !== seatId);
                    selectedSeatNumbers = selectedSeatNumbers.filter(num => num !== seatNumber);
                } else if (selectedSeats.length < maxSeats) {
                    // Select seat only if under limit
                    seatElement.classList.add("selected");
                    selectedSeats.push(seatId);
                    selectedSeatNumbers.push(seatNumber);
                } else {
                    // Show error when exceeding selection
                    document.getElementById("errorMessage").style.display = "block";
                    setTimeout(() => {
                        document.getElementById("errorMessage").style.display = "none";
                    }, 3000);
                }

                // Debug information
                console.log("Selected Seat IDs:", selectedSeats);
                console.log("Selected Seat Numbers:", selectedSeatNumbers);
            }

            function redirectToPassengerForm() {
                if (selectedSeats.length !== maxSeats) {
                    document.getElementById("errorMessage").style.display = "block";
                    setTimeout(() => {
                        document.getElementById("errorMessage").style.display = "none";
                    }, 3000);
                    return false;
                }

                const busId = <%= busId%>;
                const seatIds = selectedSeats.join(',');
                const seatNumbers = selectedSeatNumbers.join(',');

                try {
                    const url = 'PassengerDetails.jsp?' + 
                               'busId=' + encodeURIComponent(busId) + 
                               '&seatIds=' + encodeURIComponent(seatIds) + 
                               '&seatNumbers=' + encodeURIComponent(seatNumbers);
                    
                    console.log("Redirect URL:", url);
                    window.location.href = url;
                } catch (error) {
                    console.error("Redirect Error:", error);
                    alert("Error during redirect. Please try again.");
                }
            }
        </script>
    </body>
</html>