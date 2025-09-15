package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;
import java.text.SimpleDateFormat;
import util.DatabaseUtil;
import java.util.List;
import java.util.ArrayList;
import java.util.Date;
import jakarta.servlet.http.HttpSession;

public class AddBus extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddBus</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddBus at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("LogedAdminInfo") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/AdminLogin.jsp");
            return;
        }else{
            String URL = request.getContextPath()+"/admin/index.jsp?param=buses";
            response.sendRedirect(URL);
        }
        
//        if(session == null){
//            response.sendRedirect("AdminLogin.jsp");
//        }
//        
//        if( session.getAttribute("LogedAdminInfo") == null){
//            response.sendRedirect("AdminLogin.jsp");
//        }else{
//            String URL = "admin/index.jsp?param=buses";
//            response.sendRedirect(URL);
//        }
    }

   @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    Connection connection = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String busNumber = request.getParameter("busNumber").trim();
    String busType = request.getParameter("busType");
    String source = request.getParameter("source").trim();
    String destination = request.getParameter("destination").trim();
    String departureDate = request.getParameter("departureDate");
    String arrivalDate = request.getParameter("arrivalDate");
    int totalSeats = Integer.parseInt(request.getParameter("totalSeats"));
    int availableSeats = Integer.parseInt(request.getParameter("availableSeats"));
    double ticketPrice = Double.parseDouble(request.getParameter("price"));

    String[] stationNames = request.getParameterValues("stationName[]");
    String[] stationArrivals = request.getParameterValues("stationArrival[]");
    String[] stationDepartures = request.getParameterValues("stationDeparture[]");

    List<String> errors = validateFormData(busNumber, busType, source, destination,
            departureDate, arrivalDate, totalSeats, availableSeats, ticketPrice,
            stationNames, stationArrivals, stationDepartures);

    if (!errors.isEmpty()) {
        request.setAttribute("errors", errors);
        request.getRequestDispatcher("/addBus.jsp").forward(request, response);
        return;
    }

    try {
        connection = DatabaseUtil.getConnection();

        String busSql = "INSERT INTO Buses (BusNumber, BusType, Source, Destination, " +
                "DepartureDateTime, ArrivalDateTime, TotalSeats, AvailableSeats, TicketPrice) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        pstmt = connection.prepareStatement(busSql, Statement.RETURN_GENERATED_KEYS);
        pstmt.setString(1, busNumber);
        pstmt.setString(2, busType);
        pstmt.setString(3, source);
        pstmt.setString(4, destination);
        // Fix timestamp by appending seconds
        String fixedDepartureDate = departureDate.replace("T", " ") + ":00";
        String fixedArrivalDate = arrivalDate.replace("T", " ") + ":00";
        pstmt.setTimestamp(5, Timestamp.valueOf(fixedDepartureDate));
        pstmt.setTimestamp(6, Timestamp.valueOf(fixedArrivalDate));
        pstmt.setInt(7, totalSeats);
        pstmt.setInt(8, availableSeats);
        pstmt.setDouble(9, ticketPrice);

        int affectedRows = pstmt.executeUpdate();
        if (affectedRows == 0) {
            throw new SQLException("Creating bus failed, no rows affected.");
        }

        rs = pstmt.getGeneratedKeys();
        int busId;
        if (rs.next()) {
            busId = rs.getInt(1);
        } else {
            throw new SQLException("Creating bus failed, no ID obtained.");
        }

        if (stationNames != null && stationNames.length > 0) {
            String stationSql = "INSERT INTO Intermediate_Stations (BusID, StationName, " +
                    "ArrivalDateTime, DepartureDateTime) VALUES (?, ?, ?, ?)";

            pstmt = connection.prepareStatement(stationSql);
            int validStations = 0;

            for (int i = 0; i < stationNames.length; i++) {
                if (stationNames[i] != null && !stationNames[i].trim().isEmpty() &&
                    stationArrivals[i] != null && !stationArrivals[i].trim().isEmpty() &&
                    stationDepartures[i] != null && !stationDepartures[i].trim().isEmpty()) {

                    pstmt.setInt(1, busId);
                    pstmt.setString(2, stationNames[i].trim());
                    // Fix timestamp for stations
                    String fixedStationArrival = stationArrivals[i].replace("T", " ") + ":00";
                    String fixedStationDeparture = stationDepartures[i].replace("T", " ") + ":00";
                    pstmt.setTimestamp(3, Timestamp.valueOf(fixedStationArrival));
                    pstmt.setTimestamp(4, Timestamp.valueOf(fixedStationDeparture));
                    pstmt.addBatch();
                    validStations++;
                }
            }
            if (validStations > 0) {
                int[] batchResults = pstmt.executeBatch();
                for (int result : batchResults) {
                    if (result == Statement.EXECUTE_FAILED) {
                        throw new SQLException("Failed to insert one or more intermediate stations");
                    }
                }
            }
        }
        
        String createSeatQuery = "INSERT INTO Seats (BusID, SeatNumber, IsAvailable) VALUES (?, ?, ?)";
        PreparedStatement createSeatStatement = connection.prepareStatement(createSeatQuery);
        for (int i = 1; i <= totalSeats; i++) {
                createSeatStatement.setInt(1, busId);
                createSeatStatement.setString(2, "S" + i); // Seat number like S1, S2, etc.
                createSeatStatement.setBoolean(3, true);   // Initially all seats are available
                createSeatStatement.addBatch();
        }
        createSeatStatement.executeBatch();
        
        

//        response.sendRedirect("seatLayout.jsp?busId=" + busId);
            String URL = "admin/index.jsp?param=buses";
            response.sendRedirect(URL);
//        response.sendRedirect("index.jsp");

    } catch (SQLException e) {
        
        System.out.println("SQL Error: " + e.getMessage());
        request.setAttribute("error", "Database error: " + e.getMessage());
        request.getRequestDispatcher("/error.jsp").forward(request, response);
    } catch (Exception e) {
        System.out.println("General Error: " + e.getMessage());
        request.setAttribute("error", "Error: " + e.getMessage());
        request.getRequestDispatcher("/error.jsp").forward(request, response);
    } finally {
        // Close resources
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
    
    private List<String> validateFormData(String busNumber, String busType, String source, 
            String destination, String departureDate, String arrivalDate, int totalSeats, 
            int availableSeats, double ticketPrice, String[] stationNames, 
            String[] stationArrivals, String[] stationDepartures) {
        
        List<String> errors = new ArrayList<>();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");

        // Basic field validations
        if (!busNumber.matches("^[A-Za-z0-9-]+$")) {
            errors.add("Bus Number can only contain letters, numbers, and hyphens");
        }

        String[] validBusTypes = {"AC Sleeper", "Non-AC Sleeper", "AC Seater", 
                                "Non-AC Seater", "Deluxe", "Super Deluxe"};
        boolean validType = false;
        for (String type : validBusTypes) {
            if (type.equals(busType)) {
                validType = true;
                break;
            }
        }
        if (!validType) errors.add("Invalid Bus Type");

        if (source.length() < 2) errors.add("Source must be at least 2 characters long");
        if (destination.length() < 2) errors.add("Destination must be at least 2 characters long");
        if (source.equalsIgnoreCase(destination)) errors.add("Source and Destination cannot be the same");

        if (totalSeats < 1) errors.add("Total Seats must be at least 1");
        if (availableSeats < 0) errors.add("Available Seats cannot be negative");
        if (availableSeats > totalSeats) errors.add("Available Seats cannot exceed Total Seats");

        if (ticketPrice <= 0) errors.add("Ticket Price must be greater than 0");

        // Date validations
        try {
            Date depDate = dateFormat.parse(departureDate.replace("T", " "));
            Date arrDate = dateFormat.parse(arrivalDate.replace("T", " "));
            Date now = new Date();

            if (depDate.before(now)) errors.add("Departure time cannot be in the past");
            if (arrDate.before(depDate) || arrDate.equals(depDate)) {
                errors.add("Arrival time must be after departure time");
            }

            // Multiple intermediate stations validation
            if (stationNames != null && stationArrivals != null && stationDepartures != null) {
                List<String> uniqueStations = new ArrayList<>();
                Date previousStationDep = depDate;

                for (int i = 0; i < stationNames.length; i++) {
                    if (stationNames[i] != null && !stationNames[i].trim().isEmpty()) {
                        // Check for duplicate station names
                        if (uniqueStations.contains(stationNames[i].trim().toLowerCase())) {
                            errors.add("Duplicate station name found: " + stationNames[i]);
                        } else {
                            uniqueStations.add(stationNames[i].trim().toLowerCase());
                        }

                        // Check if station matches source or destination
                        if (stationNames[i].trim().equalsIgnoreCase(source) || 
                            stationNames[i].trim().equalsIgnoreCase(destination)) {
                            errors.add("Intermediate station " + stationNames[i] + 
                                    " cannot match source or destination");
                        }

                        // Validate station times
                        if (stationArrivals[i] == null || stationDepartures[i] == null) {
                            errors.add("Arrival and Departure times required for station: " + stationNames[i]);
                            continue;
                        }

                        Date stationArr = dateFormat.parse(stationArrivals[i].replace("T", " "));
                        Date stationDep = dateFormat.parse(stationDepartures[i].replace("T", " "));

                        if (stationArr.before(depDate)) {
                            errors.add("Station " + stationNames[i] + 
                                    ": Arrival time must be after bus departure");
                        }
                        if (stationDep.after(arrDate)) {
                            errors.add("Station " + stationNames[i] + 
                                    ": Departure time cannot be after bus arrival");
                        }
                        if (stationDep.before(stationArr)) {
                            errors.add("Station " + stationNames[i] + 
                                    ": Departure time must be after arrival time");
                        }
                        if (stationArr.before(previousStationDep)) {
                            errors.add("Station " + stationNames[i] + 
                                    ": Arrival time must be after previous station's departure");
                        }

                        previousStationDep = stationDep;
                    }
                }
            }
        } catch (Exception e) {
            errors.add("Invalid date format: " + e.getMessage());
        }
        return errors;
    }
    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
