<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.BusesDAO"%>
<%@page import="model.BusesModel"%>
<%@page import="model.IntermediateStationsModel"%>
<%@page import="java.util.List"%>

<% 
    if(session.getAttribute("LogedAdminInfo") == null){
        %>  
        <jsp:forward page="AdminLogin.jsp" />

        <%
    }
%>

<%
    String busId = request.getParameter("busId");
    BusesDAO busDAO = new BusesDAO();
    BusesModel bus = null;
    if (busId != null) {
        bus = busDAO.getBusById(Integer.parseInt(busId));
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Bus</title>
    <!-- Keep all your existing styles -->
    <link rel="stylesheet" href="css/BusForm.css"/>
</head>
<body>
    <header class="header">
        <!-- Your existing header content -->
    </header>

    <div class="content">
        <h2 class="page-title">Update Bus</h2>

        <%
            java.util.List<String> errors = (java.util.List<String>) request.getAttribute("errors");
            if (errors != null && !errors.isEmpty()) {
        %>
        <div style="color: #e74c3c; background-color: #fee2e2; padding: 1rem; border-radius: 4px; margin-bottom: 1rem;">
            <strong>Please fix the following errors:</strong>
            <ul>
                <% for (String error : errors) { %>
                <li><%= error %></li>
                <% } %>
            </ul>
        </div>
        <% } %>

        <div class="form-container">
            <div class="form-decoration"></div>
            <div class="form-decoration"></div>

            <form id="updateBusForm" action="${pageContext.request.contextPath}/UpdateDeleteBuses" method="POST">
                <input type="hidden" name="busId" value="<%= bus != null ? bus.getBusID() : "" %>">

                <div class="form-row">
                    <div class="form-col">
                        <div class="form-group">
                            <label class="form-label">Bus Number<span class="form-required">*</span></label>
                            <input type="text" class="form-input" name="busNumber" 
                                   value="<%= bus != null ? bus.getBusNumber() : "" %>" required>
                        </div>
                    </div>

                    <div class="form-col">
                        <div class="form-group">
                            <label class="form-label">Bus Type<span class="form-required">*</span></label>
                            <select class="form-select" name="busType" required>
                                <option value="">Select Bus Type</option>
                                <option value="AC Sleeper" <%= bus != null && "AC Sleeper".equals(bus.getBusType()) ? "selected" : "" %>>AC Sleeper</option>
                                <option value="Non-AC Sleeper" <%= bus != null && "Non-AC Sleeper".equals(bus.getBusType()) ? "selected" : "" %>>Non-AC Sleeper</option>
                                <option value="AC Seater" <%= bus != null && "AC Seater".equals(bus.getBusType()) ? "selected" : "" %>>AC Seater</option>
                                <option value="Non-AC Seater" <%= bus != null && "Non-AC Seater".equals(bus.getBusType()) ? "selected" : "" %>>Non-AC Seater</option>
                                <option value="Deluxe" <%= bus != null && "Deluxe".equals(bus.getBusType()) ? "selected" : "" %>>Deluxe</option>
                                <option value="Super Deluxe" <%= bus != null && "Super Deluxe".equals(bus.getBusType()) ? "selected" : "" %>>Super Deluxe</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-col">
                        <div class="form-group">
                            <label class="form-label">Source<span class="form-required">*</span></label>
                            <input type="text" class="form-input" name="source" 
                                   value="<%= bus != null ? bus.getSource() : "" %>" required>
                        </div>
                    </div>

                    <div class="form-col">
                        <div class="form-group">
                            <label class="form-label">Destination<span class="form-required">*</span></label>
                            <input type="text" class="form-input" name="destination" 
                                   value="<%= bus != null ? bus.getDestination() : "" %>" required>
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-col">
                        <div class="form-group">
                            <label class="form-label">Departure Date & Time<span class="form-required">*</span></label>
                            <input type="datetime-local" class="form-input" name="departureDate" 
                                   value="<%= bus != null && bus.getDepartureDateTime() != null ? 
                                            bus.getDepartureDateTime().toString().substring(0, 16) : "" %>" required>
                        </div>
                    </div>

                    <div class="form-col">
                        <div class="form-group">
                            <label class="form-label">Arrival Date & Time<span class="form-required">*</span></label>
                            <input type="datetime-local" class="form-input" name="arrivalDate" 
                                   value="<%= bus != null && bus.getArrivalDateTime() != null ? 
                                            bus.getArrivalDateTime().toString().substring(0, 16) : "" %>" required>
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-col">
                        <div class="form-group">
                            <label class="form-label">Total Seats<span class="form-required">*</span></label>
                            <input type="number" class="form-input" name="totalSeats" min="1" 
                                   value="<%= bus != null ? bus.getTotalSeats() : "" %>" required>
                        </div>
                    </div>

                    <div class="form-col">
                        <div class="form-group">
                            <label class="form-label">Available Seats<span class="form-required">*</span></label>
                            <input type="number" class="form-input" name="availableSeats" min="0" 
                                   value="<%= bus != null ? bus.getAvailableSeats() : "" %>" required>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Ticket Price (₹)<span class="form-required">*</span></label>
                    <input type="number" class="form-input" name="price" min="0" step="0.01" 
                           value="<%= bus != null ? bus.getTicketPrice() : "" %>" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Intermediate Stations</label>
                    <div id="stationContainer">
                        <% if (bus != null && bus.getStations() != null && !bus.getStations().isEmpty()) {
                            for (IntermediateStationsModel station : bus.getStations()) { %>
                            <div class="station-container">
                                <div class="form-row">
                                    <div class="form-col">
                                        <input type="text" class="form-input" placeholder="Station Name" 
                                               name="stationName[]" value="<%= station.getStationName() != null ? station.getStationName() : "" %>">
                                    </div>
                                    <div class="form-col">
                                        <input type="datetime-local" class="form-input" placeholder="Arrival Date & Time" 
                                               name="stationArrival[]" 
                                               value="<%= station.getArrivalDateTime() != null ? 
                                                        station.getArrivalDateTime().toString().substring(0, 16) : "" %>">
                                    </div>
                                    <div class="form-col">
                                        <input type="datetime-local" class="form-input" placeholder="Departure Date & Time" 
                                               name="stationDeparture[]" 
                                               value="<%= station.getDepartureDateTime() != null ? 
                                                        station.getDepartureDateTime().toString().substring(0, 16) : "" %>">
                                    </div>
                                </div>
                            </div>
                        <% } } else { %>
                            <div class="station-container">
                                <div class="form-row">
                                    <div class="form-col">
                                        <input type="text" class="form-input" placeholder="Station Name" name="stationName[]">
                                    </div>
                                    <div class="form-col">
                                        <input type="datetime-local" class="form-input" placeholder="Arrival Date & Time" name="stationArrival[]">
                                    </div>
                                    <div class="form-col">
                                        <input type="datetime-local" class="form-input" placeholder="Departure Date & Time" name="stationDeparture[]">
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                    <button type="button" class="add-station-btn" onclick="addStation()">
                        <span class="btn-icon">+</span> Add Intermediate Station
                    </button>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Update Bus</button>
                    <button type="button" class="btn btn-secondary" 
                            onclick="window.location.href='${pageContext.request.contextPath}/pages/busManagement.jsp'">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Keep your existing validateForm function
        function validateForm(formData) {
            const errors = [];

            // Your existing validation logic remains unchanged
            const busNumber = formData.get('busNumber').trim();
            if (!busNumber) {
                errors.push('Bus Number is required');
            } else if (!/^[A-Za-z0-9-]+$/.test(busNumber)) {
                errors.push('Bus Number can only contain letters, numbers, and hyphens');
            }

            if (!formData.get('busType')) {
                errors.push('Please select a Bus Type');
            }

            const source = formData.get('source').trim();
            const destination = formData.get('destination').trim();
            if (!source) errors.push('Source is required');
            else if (source.length < 2) errors.push('Source must be at least 2 characters long');

            if (!destination) errors.push('Destination is required');
            else if (destination.length < 2) errors.push('Destination must be at least 2 characters long');

            if (source.toLowerCase() === destination.toLowerCase() && source && destination) {
                errors.push('Source and Destination cannot be the same');
            }

            const departureDate = formData.get('departureDate');
            const arrivalDate = formData.get('arrivalDate');
            if (!departureDate) errors.push('Departure Date & Time is required');
            if (!arrivalDate) errors.push('Arrival Date & Time is required');

            if (departureDate && arrivalDate) {
                const depTime = new Date(departureDate);
                const arrTime = new Date(arrivalDate);
                const now = new Date();

                if (depTime < now) errors.push('Departure time cannot be in the past');
                if (arrTime <= depTime) errors.push('Arrival time must be after departure time');
            }

            const totalSeats = parseInt(formData.get('totalSeats'));
            const availableSeats = parseInt(formData.get('availableSeats'));
            if (!totalSeats || totalSeats < 1) errors.push('Total Seats must be at least 1');
            if (isNaN(availableSeats) || availableSeats < 0) errors.push('Available Seats cannot be negative');
            if (availableSeats > totalSeats) errors.push('Available Seats cannot exceed Total Seats');

            const price = parseFloat(formData.get('price'));
            if (!price || price <= 0) errors.push('Ticket Price must be greater than 0');

            const stationNames = formData.getAll('stationName[]');
            const stationArrivals = formData.getAll('stationArrival[]');
            const stationDepartures = formData.getAll('stationDeparture[]');

            stationNames.forEach((name, index) => {
                if (name.trim()) {
                    if (!stationArrivals[index])
                        errors.push(`Arrival date & time is required for station: ${name}`);
                    if (!stationDepartures[index])
                        errors.push(`Departure date & time is required for station: ${name}`);

                    if (stationArrivals[index] && stationDepartures[index] && departureDate && arrivalDate) {
                        const depDate = new Date(departureDate);
                        const arrDate = new Date(arrivalDate);
                        const stationArrTime = new Date(stationArrivals[index]);
                        const stationDepTime = new Date(stationDepartures[index]);

                        if (stationArrTime < depDate) {
                            errors.push(`Arrival time for ${name} must be after departure time`);
                        }
                        if (stationArrTime > arrDate) {
                            errors.push(`Arrival time for ${name} cannot be after final arrival time`);
                        }
                        if (stationDepTime < stationArrTime) {
                            errors.push(`Departure time for ${name} must be after its arrival time`);
                        }
                        if (stationDepTime > arrDate) {
                            errors.push(`Departure time for ${name} cannot be after final arrival time`);
                        }
                    }
                }
            });

            return errors;
        }

        // Keep your existing addStation function
        function addStation() {
            const container = document.getElementById('stationContainer');
            const newStation = document.createElement('div');
            newStation.className = 'station-container';
            newStation.innerHTML = `
                <div class="form-row">
                    <div class="form-col">
                        <input type="text" class="form-input" placeholder="Station Name" name="stationName[]">
                    </div>
                    <div class="form-col">
                        <input type="datetime-local" class="form-input" placeholder="Arrival Date & Time" name="stationArrival[]">
                    </div>
                    <div class="form-col">
                        <input type="datetime-local" class="form-input" placeholder="Departure Date & Time" name="stationDeparture[]">
                    </div>
                </div>
            `;
            container.appendChild(newStation);
        }

        // Update the form submission handler
        document.getElementById('updateBusForm').addEventListener('submit', function (e) {
            e.preventDefault();
            const formData = new FormData(this);
            const validationErrors = validateForm(formData);

            if (validationErrors.length > 0) {
                alert('Please fix the following errors:\n- ' + validationErrors.join('\n- '));
            } else {
                this.submit();
            }
        });
    </script>
</body>
</html>