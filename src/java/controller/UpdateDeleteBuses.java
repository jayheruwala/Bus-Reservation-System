package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import util.DatabaseUtil;
import java.sql.*;
import dao.BusesDAO;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import model.BusesModel;
import model.IntermediateStationsModel;


public class UpdateDeleteBuses extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private BusesDAO busesDAO;

    @Override
    public void init() throws ServletException {
        busesDAO = new BusesDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        String action = request.getParameter("action").toLowerCase();
        switch (action) {
            case "delete":
                deleteBus(request, response);
                break;
            case "update":
                System.out.println("");
                break;
            default:
                throw new AssertionError();
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
    try {
        // Extract and validate parameters
        int busId = parseIntParameter(request, "busId", "Bus ID is required.");
        String busNumber = validateStringParameter(request, "busNumber", "Bus Number is required.");
        String busType = validateStringParameter(request, "busType", "Bus Type is required.");
        String source = validateStringParameter(request, "source", "Source is required.");
        String destination = validateStringParameter(request, "destination", "Destination is required.");
        String departureDateTimeStr = request.getParameter("departureDate");
        String arrivalDateTimeStr = request.getParameter("arrivalDate");
        int totalSeats = parseIntParameter(request, "totalSeats", "Total Seats is required.");
        int availableSeats = parseIntParameter(request, "availableSeats", "Available Seats is required.");
        String ticketPriceStr = request.getParameter("price");
        double ticketPrice;
        if (ticketPriceStr == null || ticketPriceStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Ticket Price is required.");
        }
        try {
            ticketPrice = Double.parseDouble(ticketPriceStr);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid Ticket Price format.");
        }

        // Parse date-time fields
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
        LocalDateTime departureDateTime = departureDateTimeStr != null && !departureDateTimeStr.isEmpty()
                ? LocalDateTime.parse(departureDateTimeStr, formatter)
                : null;
        LocalDateTime arrivalDateTime = arrivalDateTimeStr != null && !arrivalDateTimeStr.isEmpty()
                ? LocalDateTime.parse(arrivalDateTimeStr, formatter)
                : null;

        // Create BusesModel
        BusesModel bus = new BusesModel();
        bus.setBusID(busId);
        bus.setBusNumber(busNumber);
        bus.setBusType(busType);
        bus.setSource(source);
        bus.setDestination(destination);
        bus.setDepartureDateTime(departureDateTime);
        bus.setArrivalDateTime(arrivalDateTime);
        bus.setTotalSeats(totalSeats);
        bus.setAvailableSeats(availableSeats);
        bus.setTicketPrice(ticketPrice);

        // Handle intermediate stations (simplified)
        List<IntermediateStationsModel> stations = new ArrayList<>();
        String[] stationNames = request.getParameterValues("stationName[]");
        if (stationNames != null) {
            String[] stationArrivalTimes = request.getParameterValues("stationArrival[]");
            String[] stationDepartureTimes = request.getParameterValues("stationDeparture[]");
            for (int i = 0; i < stationNames.length; i++) {
                if (stationNames[i] != null && !stationNames[i].trim().isEmpty()) {
                    IntermediateStationsModel station = new IntermediateStationsModel();
                    station.setBusID(busId);
                    station.setStationName(stationNames[i]);
                    if (stationArrivalTimes[i] != null && !stationArrivalTimes[i].isEmpty()) {
                        station.setArrivalDateTime(LocalDateTime.parse(stationArrivalTimes[i], formatter));
                    }
                    if (stationDepartureTimes[i] != null && !stationDepartureTimes[i].isEmpty()) {
                        station.setDepartureDateTime(LocalDateTime.parse(stationDepartureTimes[i], formatter));
                    }
                    stations.add(station);
                }
            }
        }

        // Update database
        BusesDAO busesDAO = new BusesDAO();
        boolean busUpdated = busesDAO.updateBus(bus);
        boolean stationsUpdated = busesDAO.updateIntermediateStations(busId, stations);

        if (busUpdated && stationsUpdated) {
            String URL = "admin/index.jsp?param=buses";
            response.sendRedirect(URL);
        } else {
            throw new Exception("Failed to update bus or stations.");
        }
    } catch (IllegalArgumentException e) {
        System.out.println(e.getMessage());
        request.setAttribute("error", e.getMessage());
        request.getRequestDispatcher("/error.jsp").forward(request, response);
    } catch (Exception e) {
        e.printStackTrace();
                System.out.println(e.getMessage());

        request.setAttribute("error", "An error occurred: " + e.getMessage());
         request.getRequestDispatcher("/error.jsp").forward(request, response);
    }
}

private int parseIntParameter(HttpServletRequest request, String paramName, String errorMessage) {
    String param = request.getParameter(paramName);
    if (param == null || param.trim().isEmpty()) {
        throw new IllegalArgumentException(errorMessage);
    }
    try {
        return Integer.parseInt(param);
    } catch (NumberFormatException e) {
        throw new IllegalArgumentException("Invalid " + paramName + " format.");
    }
}

private String validateStringParameter(HttpServletRequest request, String paramName, String errorMessage) {
    String param = request.getParameter(paramName);
    if (param == null || param.trim().isEmpty()) {
        throw new IllegalArgumentException(errorMessage);
    }
    return param;
}

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private void deleteBus(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");

        try {
            Connection connection = DatabaseUtil.getConnection();

            PreparedStatement preparedStatementI = connection.prepareStatement("delete from Intermediate_Stations where BusId = ?");
            preparedStatementI.setInt(1, Integer.parseInt(id));
            int Ideleted = preparedStatementI.executeUpdate();
            if (Ideleted > 0) {

                PreparedStatement preparedStatement = connection.prepareStatement("delete from Buses where BusId = ?");
                preparedStatement.setInt(1, Integer.parseInt(id));
                int rowsAffected = preparedStatement.executeUpdate();
                if (rowsAffected > 0) {
                    String URL = "admin/index.jsp?param=buses";
                    response.sendRedirect(URL);
                } else {
                    System.out.println("Error");
                }
            }

        } catch (Exception e) {
            System.out.println("Error : " + e.getMessage());
        }

    }
}
