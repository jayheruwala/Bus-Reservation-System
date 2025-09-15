<%-- 
    Document   : addBus
    Created on : 15 Mar 2025, 3:12:47 pm
    Author     : jayhe
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<% 
    if(session.getAttribute("LogedAdminInfo") == null){
        %>  
        <jsp:forward page="AdminLogin.jsp" />

        <%
    }
%>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add New Bus</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                background-color: #f5f7fa;
            }

            .header {
                background: linear-gradient(135deg, #1a3a8f 0%, #0f2557 100%);
                color: white;
                padding: 0.5rem 2rem;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                position: relative;
                overflow: hidden;
            }

            .header-container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                max-width: 1200px;
                margin: 0 auto;
                position: relative;
                z-index: 2;
            }

            .logo {
                display: flex;
                align-items: center;
            }

            .logo-icon {
                font-size: 2.5rem;
                margin-right: 1rem;
                color: #ffdd59;
            }

            .logo-text h1 {
                font-size: 1.8rem;
                font-weight: 700;
                margin-bottom: 0.2rem;
                letter-spacing: 0.5px;
            }

            .logo-text p {
                font-size: 0.9rem;
                opacity: 0.9;
                letter-spacing: 0.5px;
            }

            .nav-menu {
                display: flex;
                list-style: none;
            }

            .nav-item {
                position: relative;
                margin: 0 0.5rem;
            }

            .nav-link {
                color: white;
                text-decoration: none;
                padding: 1.8rem 1rem;
                font-weight: 500;
                display: inline-block;
                transition: all 0.3s ease;
                position: relative;
            }

            .nav-link:hover {
                color: #ffdd59;
            }

            .nav-link.active {
                color: #ffdd59;
            }

            .nav-link.active::after {
                content: '';
                position: absolute;
                bottom: 1.2rem;
                left: 1rem;
                right: 1rem;
                height: 3px;
                background-color: #ffdd59;
                border-radius: 2px;
            }

            .header-buttons {
                display: flex;
                align-items: center;
            }

            .header-btn {
                padding: 0.6rem 1.2rem;
                border-radius: 4px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                font-size: 0.9rem;
                border: none;
                margin-left: 1rem;
                display: flex;
                align-items: center;
            }

            .header-btn.outline {
                background: transparent;
                color: white;
                border: 2px solid rgba(255, 255, 255, 0.5);
            }

            .header-btn.outline:hover {
                border-color: #ffdd59;
                color: #ffdd59;
            }

            .header-btn.primary {
                background-color: #ffdd59;
                color: #0f2557;
            }

            .header-btn.primary:hover {
                background-color: #ffd32a;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            .header-decoration {
                position: absolute;
                right: -50px;
                top: -50px;
                width: 200px;
                height: 200px;
                border-radius: 50%;
                background: rgba(255, 221, 89, 0.1);
                z-index: 1;
            }

            .header-decoration:nth-child(2) {
                left: 30%;
                top: -100px;
                width: 150px;
                height: 150px;
                background: rgba(255, 255, 255, 0.05);
            }

            /* Form Styles */
            .content {
                max-width: 900px;
                margin: 2rem auto;
                padding: 0 1rem;
            }

            .page-title {
                text-align: center;
                margin-bottom: 2rem;
                color: #0f2557;
                position: relative;
            }

            .page-title::after {
                content: '';
                display: block;
                width: 100px;
                height: 4px;
                background: linear-gradient(to right, #1a3a8f, #ffdd59);
                margin: 0.5rem auto 0;
                border-radius: 2px;
            }

            .form-container {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                padding: 2rem;
                position: relative;
                overflow: hidden;
            }

            .form-decoration {
                position: absolute;
                bottom: -80px;
                right: -80px;
                width: 200px;
                height: 200px;
                border-radius: 50%;
                background: rgba(26, 58, 143, 0.03);
                z-index: 0;
            }

            .form-decoration:nth-child(2) {
                top: -80px;
                left: -80px;
                background: rgba(255, 221, 89, 0.03);
            }

            .form-group {
                margin-bottom: 1.5rem;
                position: relative;
                z-index: 1;
            }

            .form-label {
                display: block;
                font-weight: 600;
                font-size: 0.95rem;
                margin-bottom: 0.5rem;
                color: #0f2557;
            }

            .form-required {
                color: #e74c3c;
                margin-left: 0.25rem;
            }

            .form-input {
                width: 100%;
                padding: 0.8rem 1rem;
                border: 1px solid #e1e5eb;
                border-radius: 4px;
                font-size: 0.95rem;
                transition: all 0.3s ease;
            }

            .form-input:focus {
                border-color: #1a3a8f;
                box-shadow: 0 0 0 3px rgba(26, 58, 143, 0.1);
                outline: none;
            }

            .form-select {
                width: 100%;
                padding: 0.8rem 1rem;
                border: 1px solid #e1e5eb;
                border-radius: 4px;
                font-size: 0.95rem;
                transition: all 0.3s ease;
                background-color: white;
                appearance: none;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%230f2557' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M6 9l6 6 6-6'/%3E%3C/svg%3E");
                background-repeat: no-repeat;
                background-position: right 1rem center;
                background-size: 1em;
            }

            .form-select:focus {
                border-color: #1a3a8f;
                box-shadow: 0 0 0 3px rgba(26, 58, 143, 0.1);
                outline: none;
            }

            .form-row {
                display: flex;
                gap: 1.5rem;
                flex-wrap: wrap;
            }

            .form-col {
                flex: 1;
                min-width: 200px;
            }

            .station-container {
                background-color: #f8fafc;
                border: 1px solid #e1e5eb;
                border-radius: 6px;
                padding: 1.2rem;
                margin-bottom: 1rem;
                transition: all 0.3s ease;
            }

            .station-container:hover {
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            }

            .add-station-btn {
                width: 100%;
                padding: 0.8rem;
                background-color: rgba(26, 58, 143, 0.05);
                border: 1px dashed #1a3a8f;
                border-radius: 6px;
                color: #1a3a8f;
                font-weight: 600;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.3s ease;
                margin-bottom: 1.5rem;
            }

            .add-station-btn:hover {
                background-color: rgba(26, 58, 143, 0.1);
            }

            .btn-icon {
                margin-right: 0.5rem;
                font-size: 1rem;
            }

            .form-actions {
                display: flex;
                justify-content: center;
                margin-top: 2rem;
                gap: 1rem;
            }

            .btn {
                padding: 0.8rem 2rem;
                border-radius: 4px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                font-size: 1rem;
                border: none;
                display: flex;
                align-items: center;
            }

            .btn-primary {
                background-color: #1a3a8f;
                color: white;
            }

            .btn-primary:hover {
                background-color: #0f2557;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            .btn-secondary {
                background-color: #e1e5eb;
                color: #4a5568;
            }

            .btn-secondary:hover {
                background-color: #cbd5e0;
                transform: translateY(-2px);
            }

            @media (max-width: 768px) {
                .form-row {
                    flex-direction: column;
                    gap: 0;
                }

                .form-col {
                    min-width: 100%;
                }

                .form-container {
                    padding: 1.5rem;
                }
            }


        </style>
    </head>

    <body>
        <header class="header">
            <!-- Previous header content remains unchanged -->
        </header>

        <div class="content">
            <h2 class="page-title">Add New Bus</h2>

            <%
                java.util.List<String> errors = (java.util.List<String>) request.getAttribute("errors");
                if (errors != null && !errors.isEmpty()) {
            %>
            <div style="color: #e74c3c; background-color: #fee2e2; padding: 1rem; border-radius: 4px; margin-bottom: 1rem;">
                <strong>Please fix the following errors:</strong>
                <ul>
                    <% for (String error : errors) {%>
                    <li><%= error%></li>
                        <% } %>
                </ul>
            </div>
            <% }%>

            <div class="form-container">
                <div class="form-decoration"></div>
                <div class="form-decoration"></div>

                <form id="addBusForm" action="${pageContext.request.contextPath}/AddBus" method="POST">
                    <div class="form-row">
                        <div class="form-col">
                            <div class="form-group">
                                <label class="form-label">Bus Number<span class="form-required">*</span></label>
                                <input type="text" class="form-input" name="busNumber" required>
                            </div>
                        </div>

                        <div class="form-col">
                            <div class="form-group">
                                <label class="form-label">Bus Type<span class="form-required">*</span></label>
                                <select class="form-select" name="busType" required>
                                    <option value="">Select Bus Type</option>
                                    <option value="AC Sleeper">AC Sleeper</option>
                                    <option value="Non-AC Sleeper">Non-AC Sleeper</option>
                                    <option value="AC Seater">AC Seater</option>
                                    <option value="Non-AC Seater">Non-AC Seater</option>
                                    <option value="Deluxe">Deluxe</option>
                                    <option value="Super Deluxe">Super Deluxe</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-col">
                            <div class="form-group">
                                <label class="form-label">Source<span class="form-required">*</span></label>
                                <input type="text" class="form-input" name="source" required>
                            </div>
                        </div>

                        <div class="form-col">
                            <div class="form-group">
                                <label class="form-label">Destination<span class="form-required">*</span></label>
                                <input type="text" class="form-input" name="destination" required>
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-col">
                            <div class="form-group">
                                <label class="form-label">Departure Date & Time<span class="form-required">*</span></label>
                                <input type="datetime-local" class="form-input" name="departureDate" required>
                            </div>
                        </div>

                        <div class="form-col">
                            <div class="form-group">
                                <label class="form-label">Arrival Date & Time<span class="form-required">*</span></label>
                                <input type="datetime-local" class="form-input" name="arrivalDate" required>
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-col">
                            <div class="form-group">
                                <label class="form-label">Total Seats<span class="form-required">*</span></label>
                                <input type="number" class="form-input" name="totalSeats" min="1" required>
                            </div>
                        </div>

                        <div class="form-col">
                            <div class="form-group">
                                <label class="form-label">Available Seats<span class="form-required">*</span></label>
                                <input type="number" class="form-input" name="availableSeats" min="0" required>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Ticket Price (₹)<span class="form-required">*</span></label>
                        <input type="number" class="form-input" name="price" min="0" step="0.01" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Intermediate Stations</label>
                        <div id="stationContainer">
                            <div class="station-container">
                                <div class="form-row">
                                    <div class="form-col">
                                        <input type="text" class="form-input" placeholder="Station Name"
                                               name="stationName[]">
                                    </div>
                                    <div class="form-col">
                                        <input type="datetime-local" class="form-input" placeholder="Arrival Date & Time"
                                               name="stationArrival[]">
                                    </div>
                                    <div class="form-col">
                                        <input type="datetime-local" class="form-input" placeholder="Departure Date & Time"
                                               name="stationDeparture[]">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <button type="button" class="add-station-btn" onclick="addStation()">
                            <span class="btn-icon">+</span> Add Intermediate Station
                        </button>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">Add Bus</button>
                        <button type="button" class="btn btn-secondary"
                                onclick="document.getElementById('addBusForm').reset()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function validateForm(formData) {
                const errors = [];

                // Bus Number validation
                const busNumber = formData.get('busNumber').trim();
                if (!busNumber) {
                    errors.push('Bus Number is required');
                } else if (!/^[A-Za-z0-9-]+$/.test(busNumber)) {
                    errors.push('Bus Number can only contain letters, numbers, and hyphens');
                }

                // Bus Type validation
                if (!formData.get('busType')) {
                    errors.push('Please select a Bus Type');
                }

                // Source and Destination validation
                const source = formData.get('source').trim();
                const destination = formData.get('destination').trim();
                if (!source)
                    errors.push('Source is required');
                else if (source.length < 2)
                    errors.push('Source must be at least 2 characters long');

                if (!destination)
                    errors.push('Destination is required');
                else if (destination.length < 2)
                    errors.push('Destination must be at least 2 characters long');

                if (source.toLowerCase() === destination.toLowerCase() && source && destination) {
                    errors.push('Source and Destination cannot be the same');
                }

                // Date and Time validation
                const departureDate = formData.get('departureDate');
                const arrivalDate = formData.get('arrivalDate');
                if (!departureDate)
                    errors.push('Departure Date & Time is required');
                if (!arrivalDate)
                    errors.push('Arrival Date & Time is required');

                if (departureDate && arrivalDate) {
                    const depTime = new Date(departureDate);
                    const arrTime = new Date(arrivalDate);
                    const now = new Date();

                    if (depTime < now)
                        errors.push('Departure time cannot be in the past');
                    if (arrTime <= depTime)
                        errors.push('Arrival time must be after departure time');
                }

                // Seats validation
                const totalSeats = parseInt(formData.get('totalSeats'));
                const availableSeats = parseInt(formData.get('availableSeats'));

                if (!totalSeats || totalSeats < 1)
                    errors.push('Total Seats must be at least 1');
                if (isNaN(availableSeats) || availableSeats < 0)
                    errors.push('Available Seats cannot be negative');
                if (availableSeats > totalSeats)
                    errors.push('Available Seats cannot exceed Total Seats');

                // Price validation
                const price = parseFloat(formData.get('price'));
                if (!price || price <= 0)
                    errors.push('Ticket Price must be greater than 0');

                // Intermediate Stations validation


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

            document.getElementById('addBusForm').addEventListener('submit', function (e) {
                e.preventDefault(); // Prevent default submission initially

                const formData = new FormData(this);
                const validationErrors = validateForm(formData);

                if (validationErrors.length > 0) {
                    alert('Please fix the following errors:\n- ' + validationErrors.join('\n- '));
                } else {
                    this.submit(); // Submit the form if validation passes
                }
            });
        </script>
    </body>

</html>