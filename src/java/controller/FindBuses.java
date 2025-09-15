package controller;

import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import util.DatabaseUtil;
import java.util.List;
import java.util.ArrayList;
import model.Bus;

public class FindBuses extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet FindBuses</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FindBuses at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        RequestDispatcher dispatcher;
        
        if(session == null || session.getAttribute("user") == null){
            response.sendRedirect("login.jsp");
            return;
        }

        PrintWriter out = response.getWriter();
        Connection connection = null;
        String source = request.getParameter("source");
        String destination = request.getParameter("destination");
        String departureTimeStr = request.getParameter("departureTime");
        String passengers = request.getParameter("passengers");
       
        List<Bus> buses = new ArrayList<>();

        Timestamp departureTimeStart = null;
        Timestamp departureTimeEnd = null;
        try {
            if (departureTimeStr != null && !departureTimeStr.isEmpty()) {
                // Parse as LocalDate and convert to LocalDateTime at start of day
                LocalDate localDate = LocalDate.parse(departureTimeStr, DateTimeFormatter.ISO_LOCAL_DATE);
                LocalDateTime startOfDay = localDate.atStartOfDay(); // 00:00:00
                LocalDateTime endOfDay = localDate.atTime(23, 59, 59); // 23:59:59

                departureTimeStart = Timestamp.valueOf(startOfDay);
                departureTimeEnd = Timestamp.valueOf(endOfDay);
            } else {
                out.println("<h3>Error: Departure time is required.</h3>");
                return;
            }
        } catch (Exception e) {
            out.println("<h3>Error parsing departure time: " + e.getMessage() + "</h3>");
            return;
        }

        try {
            connection = DatabaseUtil.getConnection();
        } catch (SQLException ex) {
            out.print("error : " + ex.getMessage());
        }

        if (connection != null) {
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                String query = "SELECT * FROM buses WHERE source = ? AND destination = ? "
                        + "AND DepartureDateTime >= ? AND DepartureDateTime < ?";
                pstmt = connection.prepareStatement(query);
                pstmt.setString(1, source);
                pstmt.setString(2, destination);
                pstmt.setTimestamp(3, departureTimeStart);
                pstmt.setTimestamp(4, departureTimeEnd);

                rs = pstmt.executeQuery();
                
                PreparedStatement intermediateStmt = null;
                ResultSet intermediateRs = null;

                while (rs.next()) {
                    List<String> intermediateBusList = new ArrayList<>();
                    intermediateStmt = connection.prepareStatement("select * from Intermediate_Stations where BusId = ?");
                    intermediateStmt.setInt(1, rs.getInt("BusId"));

                    intermediateRs = intermediateStmt.executeQuery();

                    while (intermediateRs.next()) {
                        intermediateBusList.add(intermediateRs.getString("StationName"));
                    }

                    buses.add(new Bus(rs.getInt("BusId"), rs.getString("BusNumber"), rs.getString("BusType"), rs.getString("Source"), rs.getString("Destination"), rs.getTimestamp("DepartureDateTime").toLocalDateTime(), rs.getTimestamp("ArrivalDateTime").toLocalDateTime(), rs.getInt("TotalSeats"), rs.getInt("AvailableSeats"), rs.getDouble("TicketPrice"), intermediateBusList));
                    intermediateBusList = null;
                }

                
                if(buses.size() > 0){
                    request.setAttribute("ListOfBus", buses);
                }else{
                    request.setAttribute("notFound", "No Buses are found on this route");
                }
                
                
                request.setAttribute("passengers",passengers);
                dispatcher = request.getRequestDispatcher("displayBuses.jsp");
                dispatcher.forward(request, response);
                

            } catch (SQLException ex) {
                out.print("Error : " + ex.getMessage());
            }
        } else {
            out.print("Connection Error");
        }

    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
