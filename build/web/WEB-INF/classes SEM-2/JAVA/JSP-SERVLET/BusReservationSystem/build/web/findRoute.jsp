<%-- 
    Document   : searchBus
    Created on : 16 Mar 2025, 11:59:41 am
    Author     : jayhe
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <title>Bus Booking System - Search</title>
        <style>
            /* Same CSS as original, but keeping only what's relevant for search */
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

            .search-form {
                background-color: white;
                padding: 25px;
                border-radius: 5px;
                box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
                margin-bottom: 30px;
                border: 1px solid rgba(26, 58, 143, 0.1);
            }

            .form-row {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
                margin-bottom: 20px;
            }

            .form-group {
                flex: 1;
                min-width: 200px;
            }

            label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #0f2557;
            }

            input, select {
                width: 100%;
                padding: 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 16px;
                background-color: #fff;
                transition: border-color 0.3s ease;
            }

            input:focus, select:focus {
                border-color: #1a3a8f;
                outline: none;
                box-shadow: 0 0 5px rgba(26, 58, 143, 0.2);
            }

            button {
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

            button:hover {
                background: linear-gradient(135deg, #0f2557 0%, #1a3a8f 100%);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            }

            .error-message {
                color: #ff4444;
                font-size: 14px;
                margin-top: 5px;
                display: none;
            }

            .form-group.error input,
            .form-group.error select {
                border-color: #ff4444;
            }

            @media (max-width: 768px) {
                .form-row {
                    flex-direction: column;
                    gap: 15px;
                }

                .form-group {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <%@ include file="header.jsp" %>

        <div class="container">
            <div class="search-form">
                <h2>Search for Buses</h2>
                <form id="busSearchForm" action="FindBuses" method="POST">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="source">From</label>
                            <input type="text" id="source" name="source" placeholder="Enter source city" required>
                            <div class="error-message" id="sourceError">Please enter a valid source city</div>
                        </div>

                        <div class="form-group">
                            <label for="destination">To</label>
                            <input type="text" id="destination" name="destination" placeholder="Enter destination city" required>
                            <div class="error-message" id="destinationError">Please enter a valid destination city</div>
                        </div>

                        <div class="form-group">
                            <label for="travelDate">Date of Journey</label>
                            <input type="date" id="travelDate" name="departureTime" required>
                            <div class="error-message" id="dateError">Please select a valid date (today or future)</div>
                        </div>

                        <div class="form-group">
                            <label for="passengers">Passengers</label>
                            <select id="passengers" name="passengers">
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                            </select>
                            <div class="error-message" id="passengersError">Please select number of passengers</div>
                        </div>
                    </div>

                    <button type="submit" id="searchButton">Search Buses</button>
                </form>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const busSearchForm = document.getElementById('busSearchForm');
                const sourceInput = document.getElementById('source');
                const destinationInput = document.getElementById('destination');
                const travelDateInput = document.getElementById('travelDate');
                const passengersSelect = document.getElementById('passengers');

                busSearchForm.addEventListener('submit', function (e) {
                    let isValid = true;

                    [sourceInput, destinationInput, travelDateInput, passengersSelect].forEach(input => {
                        const formGroup = input.closest('.form-group');
                        formGroup.classList.remove('error');
                        formGroup.querySelector('.error-message').style.display = 'none';
                    });

                    if (!sourceInput.value.trim()) {
                        showError(sourceInput, 'sourceError');
                        isValid = false;
                    }

                    if (!destinationInput.value.trim()) {
                        showError(destinationInput, 'destinationError');
                        isValid = false;
                    }

                    const today = new Date();
                    today.setHours(0, 0, 0, 0);
                    const selectedDate = new Date(travelDateInput.value);
                    if (!travelDateInput.value || selectedDate < today) {
                        showError(travelDateInput, 'dateError');
                        isValid = false;
                    }

                    if (!passengersSelect.value) {
                        showError(passengersSelect, 'passengersError');
                        isValid = false;
                    }

                    if (!isValid) {
                        e.preventDefault();
                    }
                });

                function showError(input, errorId) {
                    const formGroup = input.closest('.form-group');
                    formGroup.classList.add('error');
                    const errorElement = document.getElementById(errorId);
                    errorElement.style.display = 'block';
                }
            });
        </script>
    </body>
</html>