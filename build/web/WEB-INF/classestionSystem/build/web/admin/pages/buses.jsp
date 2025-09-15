<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dao.BusesDAO"%>
<%@page import="model.BusesModel"%>
<%@page import="model.IntermediateStationsModel"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>


<%
    if (session.getAttribute("LogedAdminInfo") == null) {
%>  
<jsp:forward page="${pageContext.request.contextPath}/admin/index.jsp" />

<%
    }
%>
<%
    BusesDAO busDAO = new BusesDAO();
    List<BusesModel> busList = busDAO.getAllBusesWithStations();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    LocalDateTime now = LocalDateTime.now();
%>



<div class="content-table">
    <div class="table-header">
        <h3>Bus Management</h3>
        <div>
            <input type="text" class="search-input" placeholder="Search buses...">
            <button class="action-button">
                <a href="pages/addBus.jsp">
                    <i class="fas fa-plus"></i> Add New Bus</a>
            </button>
        </div>
    </div>
    <div class="table-responsive">
        <table>
            <thead>
                <tr>
                    <th>Bus ID</th>
                    <th>Bus Number</th>
                    <th>Type</th>
                    <th>Route</th>
                    <th>Departure</th>
                    <th>Arrival</th>
                    <th>Total Seats</th>
                    <th>Available Seats</th>
                    <th>Price</th>
                    <th>Intermediate Stations</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% for (BusesModel bus : busList) {
                  
                        boolean isEditable = true;
                        try {
                            // Handle departureDateTime based on its type
                            Object departureObj = bus.getDepartureDateTime();
                            LocalDateTime departureDateTime;

                            if (departureObj instanceof String) {
                                // If it's a String, parse it
                                departureDateTime = LocalDateTime.parse((String) departureObj, formatter);
                            } else if (departureObj instanceof LocalDateTime) {
                                // If it's already a LocalDateTime, use it directly
                                departureDateTime = (LocalDateTime) departureObj;
                            } else if (departureObj instanceof java.sql.Timestamp) {
                                // If it's a Timestamp, convert to LocalDateTime
                                departureDateTime = ((java.sql.Timestamp) departureObj).toLocalDateTime();
                            } else {
                                // Handle unexpected type (log or skip)
                                departureDateTime = now; // Fallback to now to avoid errors
                                isEditable = false; // Disable editing if date is invalid
                            }

                            // Check if departure time has passed
                            isEditable = now.isBefore(departureDateTime);
                        } catch (Exception e) {
                            // Handle parsing errors
                            isEditable = false; // Disable editing if parsing fails
                        }
                %>

                <tr>
                    <td><%= bus.getBusID()%></td>
                    <td><%= bus.getBusNumber()%></td>
                    <td><%= bus.getBusType()%></td>
                    <td><%= bus.getSource()%> - <%= bus.getDestination()%></td>
                    <td><%= bus.getDepartureDateTime()%></td>
                    <td><%= bus.getArrivalDateTime()%></td>
                    <td><%= bus.getTotalSeats()%></td>
                    <td><%= bus.getAvailableSeats()%></td>
                    <td>₹<%= bus.getTicketPrice()%></td>
                    <td>
                        <%
                            if (!bus.getStations().isEmpty()) {
                                for (IntermediateStationsModel station : bus.getStations()) {%>
                        <div>
                            <strong><%= station.getStationName()%></strong>
                            <br>Arr: <%= station.getArrivalDateTime()%> | Dep: <%= station.getDepartureDateTime()%>
                        </div>
                        <%
                            }
                        } else {
                        %>
                        <div>
                            <strong>No Intermediate Stations are available</strong>
                        </div>
                        <%
                            }
                        %>
                    </td>
                    <td class="action-icons">
                        <% if (isEditable) { %>
                            <a href="${pageContext.request.contextPath}/admin/pages/updateBus.jsp?busId=<%= bus.getBusID() %>">
                                <i class="fas fa-edit" title="Edit"></i>
                            </a>
                        <% } else { %>
                            
                        <% } %>
                        
                    </td>
                </tr>
                <% }%>
            </tbody>
        </table>
    </div>
</div>
