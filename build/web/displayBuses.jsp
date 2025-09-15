<%-- 
    Document   : displayBuses
    Created on : 16 Mar 2025, 11:59:41 am
    Author     : jayhe
--%>

<%@page import="java.time.Duration"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="controller.FindBuses, model.Bus, java.util.List" %>


<%

    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Bus Booking System - Available Buses</title>
        <style>
            /* CSS remains unchanged */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Arial', sans-serif;
            }

            header {
                background: linear-gradient(135deg, #1a3a8f 0%, #0f2557 100%);
                color: white;
                padding: 20px 0;
                text-align: center;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
            }

            .container {
                width: 90%;
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
                background-color: #f5f7fa;
            }

            .bus-results {
                margin-top: 30px;
            }

            .bus-results h2 {
                color: #0f2557;
                margin-bottom: 20px;
                border-bottom: 2px solid #ffdd59;
                padding-bottom: 5px;
                font-weight: 600;
            }

            .bus-card {
                background-color: white;
                border: 1px solid #ddd;
                border-radius: 5px;
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                transition: transform 0.3s ease;
            }

            .bus-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            }

            .bus-card-header {
                display: flex;
                justify-content: space-between;
                padding-bottom: 15px;
                border-bottom: 1px solid #eee;
                margin-bottom: 15px;
                color: #0f2557;
            }

            .bus-card-header h3 {
                font-size: 1.3em;
                font-weight: 600;
            }

            .bus-details {
                display: flex;
                justify-content: space-between;
                flex-wrap: wrap;
                gap: 15px;
                color: #333;
            }

            .detail-column {
                flex: 1;
                min-width: 150px;
            }

            .detail-column p {
                margin-bottom: 5px;
            }

            .price-section {
                text-align: right;
                font-weight: 600;
                color: #0f2557;
            }

            .price-section button {
                margin-top: 10px;
                background: linear-gradient(135deg, #1a3a8f 0%, #0f2557 100%);
                color: white;
                border: none;
                padding: 12px 25px;
                border-radius: 4px;
                cursor: pointer;
                font-size: 16px;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .price-section button:hover {
                background: linear-gradient(135deg, #0f2557 0%, #1a3a8f 100%);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            }

            .seats-available {
                color: #1a3a8f;
                font-weight: 600;
            }

            .intermediate-stations {
                margin-top: 15px;
                font-size: 14px;
                color: #666;
                background-color: #f5f7fa;
                padding: 10px;
                border-radius: 4px;
            }

            .no-results {
                text-align: center;
                padding: 25px;
                color: #666;
                font-style: italic;
                background-color: white;
                border-radius: 5px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            }

            @media (max-width: 768px) {
                .bus-details {
                    flex-direction: column;
                }

                .price-section {
                    text-align: left;
                }
            }
        </style>
    </head>
    <body>
        <%@ include file="header.jsp" %>

        <div class="container">
            <%                List<Bus> buses = null;
                if (request.getAttribute("ListOfBus") != null) {
                    buses = (List<Bus>) request.getAttribute("ListOfBus");
                }

                if (buses != null && buses.size() > 0) {
            %>
            <div class="bus-results">
                <h2>Available Buses</h2>
                <div id="resultsContainer">
                    <%
                        for (Bus bus : buses) {
                    %>
                    <div class="bus-card">
                        <div class="bus-card-header">
                            <h3><%= bus.getBusType()%></h3>
                            <span><%= bus.getBusNumber()%></span>
                        </div>
                        <div class="bus-details">
                            <div class="detail-column">
                                <p><strong>From:</strong> <%= bus.getSource()%></p>
                                <p><%= bus.getDepartureTime()%></p>
                            </div>
                            <div class="detail-column" style="text-align: center;">
                                <% Duration duration = Duration.between(bus.getDepartureTime(), bus.getArrivalTime());
                                    long hours = duration.toHours();
                                    long minutes = duration.toMinutes() % 60;

                                    if (duration.isNegative()) {
                                        hours = -hours;
                                        minutes = -minutes;
                                    }

                                %>
                                <p>→ <%= hours%>h <%= minutes%>m →</p>
                            </div>
                            <div class="detail-column">
                                <p><strong>To:</strong> <%= bus.getDestination()%></p>
                                <p><%= bus.getArrivalTime()%></p>
                            </div>
                            <div class="price-section">
                                <p>₹<%= bus.getTicket()%></p>
                                <p class="seats-available"><%= bus.getAvailableSeats()%> seats available</p>
                                <!-- Updated Book Now button with busId -->
                                <form action="seatLayout.jsp" method="get">
                                    <input type="hidden" name="busId" value="<%= bus.getBusId()%>">
                                    <input type="hidden" name="passengers" value="<%= request.getAttribute("passengers")%>">
                                    <button type="submit">Book Now</button>
                                </form>
                            </div>
                        </div>
                        <%
                            List<String> stations = bus.getIntermediateStations();
                            if (stations != null && stations.size() > 0) {
                        %>
                        <div class="intermediate-stations">
                            <strong>Stops:</strong>
                            <%
                                for (String station : stations) {
                            %>
                            <%= station%> 
                            <%
                                }
                            %>
                        </div>
                        <%
                            }

                        %>
                    </div>
                    <%                        }
                    %>
                </div>
            </div>
            <%
            } else {
            %>
            <div class="no-results">
                <p>No buses available for the selected route and date. <a href="findRoute.jsp">Search available bus</a></p>
            </div>
            <%
                }
            %>
        </div>
    </body>
</html>