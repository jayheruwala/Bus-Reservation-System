<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<% 

    if(session.getAttribute("user") == null){
        response.sendRedirect("login.jsp");
    }
%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Passenger Details</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        :root {
            --primary-color: #2c3e50;
            --secondary-color: #34495e;
            --accent-color: #3498db;
            --error-color: #e74c3c;
            --success-color: #27ae60;
            --background-color: #ecf0f1;
        }

        body {
            background-color: var(--background-color);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 900px;
            margin: 0 auto;
            padding: 30px;
        }

        .form-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--background-color);
        }

        .form-header h1 {
            color: var(--primary-color);
            font-size: 28px;
            margin-bottom: 10px;
        }

        .form-header p {
            color: var(--secondary-color);
            font-size: 16px;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
            animation: fadeIn 0.5s;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }

        .validation-summary {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f8f9fa;
            border-left: 4px solid #dc3545;
            display: none;
        }

        .validation-summary h4 {
            color: #dc3545;
            margin-bottom: 10px;
        }

        .validation-summary ul {
            margin: 0;
            padding-left: 20px;
            color: #dc3545;
        }

        .passenger-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            background-color: #f8f9fa;
            transition: transform 0.3s ease;
        }

        .passenger-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .passenger-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #ddd;
        }

        .passenger-title {
            color: var(--primary-color);
            font-weight: 500;
            font-size: 18px;
        }

        .seat-number {
            background-color: var(--accent-color);
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--primary-color);
            font-weight: 500;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .form-group input:focus,
        .form-group select:focus {
            border-color: var(--accent-color);
            outline: none;
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
        }

        .invalid-input {
            border-color: var(--error-color) !important;
            background-color: #fff8f8;
        }

        .error {
            color: var(--error-color);
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }

        .required::after {
            content: "*";
            color: var(--error-color);
            margin-left: 4px;
        }

        .buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
            gap: 20px;
        }

        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            flex: 1;
            font-size: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-primary {
            background-color: var(--accent-color);
            color: white;
        }

        .btn-secondary {
            background-color: #95a5a6;
            color: white;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        @media (max-width: 600px) {
            .container {
                padding: 15px;
            }

            .buttons {
                flex-direction: column;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <%
        // Get and validate parameters
        String busId = request.getParameter("busId");
        String seatIds = request.getParameter("seatIds");
        String seatNumbers = request.getParameter("seatNumbers");
        
        if (busId == null || seatIds == null || seatNumbers == null || 
            busId.trim().isEmpty() || seatIds.trim().isEmpty() || seatNumbers.trim().isEmpty()) {
    %>
        <div class="container">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <div>
                    <h3>Error: Missing Parameters</h3>
                    <p>Please return to the seat selection page and try again.</p>
                </div>
            </div>
            <button class="btn btn-secondary" onclick="history.back()">
                <i class="fas fa-arrow-left"></i> Go Back
            </button>
        </div>
    <%
        } else {
            String[] seatNumberArray = seatNumbers.split(",");
    %>
    <div class="container">
        <div class="form-header">
            <h1>Passenger Details</h1>
            <p>Bus ID: <%= busId %> | Selected Seats: <%= seatNumbers %></p>
        </div>

        <!-- Server-side error messages -->
        <% 
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null && !errorMessage.isEmpty()) { 
        %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <%= errorMessage %>
            </div>
        <% } %>

        <!-- Client-side validation summary -->
        <div id="validationSummary" class="validation-summary">
            <h4><i class="fas fa-exclamation-triangle"></i> Please correct the following errors:</h4>
            <ul id="validationList"></ul>
        </div>

        <form id="passengerForm" action="ValidateAllInformations" method="post" onsubmit="return validateForm()">
            <input type="hidden" name="busId" value="<%= busId %>">
            <input type="hidden" name="seatIds" value="<%= seatIds %>">
            <input type="hidden" name="seatNumbers" value="<%= seatNumbers %>">
            
            <% for(String seatNumber : seatNumberArray) { %>
            <div class="passenger-card">
                <div class="passenger-header">
                    <div class="passenger-title">
                        <i class="fas fa-user"></i> Passenger Details
                    </div>
                    <div class="seat-number">
                        <i class="fas fa-chair"></i> Seat <%= seatNumber %>
                    </div>
                </div>
                <div class="form-grid">
                    <div class="form-group">
                        <label class="required" for="name_<%= seatNumber %>">
                            <i class="fas fa-user"></i> Full Name
                        </label>
                        <input type="text" 
                               id="name_<%= seatNumber %>" 
                               name="name_<%= seatNumber %>" 
                               placeholder="Enter full name"
                               onkeyup="validateName(this)"
                               onblur="validateName(this)">
                        <span class="error" id="nameError_<%= seatNumber %>"></span>
                    </div>
                    <div class="form-group">
                        <label class="required" for="age_<%= seatNumber %>">
                            <i class="fas fa-birthday-cake"></i> Age
                        </label>
                        <input type="number" 
                               id="age_<%= seatNumber %>" 
                               name="age_<%= seatNumber %>" 
                               placeholder="Enter age"
                               onkeyup="validateAge(this)"
                               onblur="validateAge(this)">
                        <span class="error" id="ageError_<%= seatNumber %>"></span>
                    </div>
                    <div class="form-group">
                        <label class="required" for="gender_<%= seatNumber %>">
                            <i class="fas fa-venus-mars"></i> Gender
                        </label>
                        <select id="gender_<%= seatNumber %>" 
                                name="gender_<%= seatNumber %>" 
                                onchange="validateGender(this)">
                            <option value="">Select gender</option>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                        <span class="error" id="genderError_<%= seatNumber %>"></span>
                    </div>
                </div>
            </div>
            <% } %>

            <div class="buttons">
                <button type="button" class="btn btn-secondary" onclick="history.back()">
                    <i class="fas fa-arrow-left"></i> Back
                </button>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-arrow-right"></i> Proceed to Payment
                </button>
            </div>
        </form>
    </div>

    <script>
        let formErrors = [];

        function validateName(input) {
            const errorSpan = document.getElementById('nameError_' + input.id.split('_')[1]);
            const nameRegex = /^[A-Za-z ]{2,50}$/;
            input.value = input.value.trim();
            
            if (!input.value) {
                showError(input, errorSpan, 'Name is required');
                return false;
            }
            if (!nameRegex.test(input.value)) {
                showError(input, errorSpan, 'Please enter a valid name (letters only)');
                return false;
            }
            
            hideError(input, errorSpan);
            return true;
        }

        function validateAge(input) {
            const errorSpan = document.getElementById('ageError_' + input.id.split('_')[1]);
            const age = parseInt(input.value);
            
            if (!input.value) {
                showError(input, errorSpan, 'Age is required');
                return false;
            }
            if (isNaN(age) || age < 1 || age > 120) {
                showError(input, errorSpan, 'Please enter a valid age (1-120)');
                return false;
            }
            
            hideError(input, errorSpan);
            return true;
        }

        function validateGender(select) {
            const errorSpan = document.getElementById('genderError_' + select.id.split('_')[1]);
            
            if (!select.value) {
                showError(select, errorSpan, 'Please select a gender');
                return false;
            }
            
            hideError(select, errorSpan);
            return true;
        }

        function showError(element, errorSpan, message) {
            element.classList.add('invalid-input');
            errorSpan.textContent = message;
            errorSpan.style.display = 'block';
            const seatNumber = element.id.split('_')[1];
            const errorMsg = `Seat ${seatNumber}: ${message}`;
            if (!formErrors.includes(errorMsg)) {
                formErrors.push(errorMsg);
            }
        }

        function hideError(element, errorSpan) {
            element.classList.remove('invalid-input');
            errorSpan.style.display = 'none';
            const seatNumber = element.id.split('_')[1];
            formErrors = formErrors.filter(error => !error.includes(`Seat ${seatNumber}:`));
        }

        function updateValidationSummary() {
            const validationSummary = document.getElementById('validationSummary');
            const validationList = document.getElementById('validationList');
            validationList.innerHTML = '';

            if (formErrors.length > 0) {
                formErrors.forEach(error => {
                    const li = document.createElement('li');
                    li.textContent = error;
                    validationList.appendChild(li);
                });
                validationSummary.style.display = 'block';
                validationSummary.scrollIntoView({ behavior: 'smooth' });
            } else {
                validationSummary.style.display = 'none';
            }
        }

        function validateForm() {
            formErrors = [];
            let isValid = true;
            const seatNumbers = "<%= seatNumbers %>".split(",");
            
            seatNumbers.forEach(seatNumber => {
                const nameInput = document.getElementById(`name_${seatNumber}`);
                const ageInput = document.getElementById(`age_${seatNumber}`);
                const genderSelect = document.getElementById(`gender_${seatNumber}`);
                
                const nameValid = validateName(nameInput);
                const ageValid = validateAge(ageInput);
                const genderValid = validateGender(genderSelect);
                
                if (!nameValid || !ageValid || !genderValid) {
                    isValid = false;
                }
            });

            updateValidationSummary();
            return isValid;
        }

        // Add event listeners for real-time validation
        document.addEventListener('DOMContentLoaded', function() {
            const seatNumbers = "<%= seatNumbers %>".split(",");
            
            seatNumbers.forEach(seatNumber => {
                const nameInput = document.getElementById(`name_${seatNumber}`);
                const ageInput = document.getElementById(`age_${seatNumber}`);
                const genderSelect = document.getElementById(`gender_${seatNumber}`);
                
                nameInput.addEventListener('input', () => {
                    validateName(nameInput);
                    updateValidationSummary();
                });
                
                ageInput.addEventListener('input', () => {
                    validateAge(ageInput);
                    updateValidationSummary();
                });
                
                genderSelect.addEventListener('change', () => {
                    validateGender(genderSelect);
                    updateValidationSummary();
                });
            });
        });
    </script>
    <% } %>
</body>
</html>