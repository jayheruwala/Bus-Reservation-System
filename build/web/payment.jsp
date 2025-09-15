<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<% 

    if(session.getAttribute("user") == null){
        response.sendRedirect("login.jsp");
    }
%>

<%
    // Retrieve values from session
    String busId = (String) session.getAttribute("busId");
    String seatNumbers = (String) session.getAttribute("seatNumbers");
    Double totalAmount = (Double) session.getAttribute("totalAmount");
    String passengerDetails = (String) session.getAttribute("passengerDetails");
    
    // Validate session attributes
    if (busId == null || seatNumbers == null || totalAmount == null || passengerDetails == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Parse passenger details
    Map<String, Map<String, String>> passengers = new HashMap<>();
    if (passengerDetails != null) {
        String[] details = passengerDetails.split(";");
        for (String detail : details) {
            if (!detail.trim().isEmpty()) {
                String[] parts = detail.split(":");
                Map<String, String> passenger = new HashMap<>();
                passenger.put("name", parts[1]);
                passenger.put("age", parts[2]);
                passenger.put("gender", parts[3]);
                passengers.put(parts[0], passenger);
            }
        }
    }

    // Calculate charges
    double baseFare = totalAmount != null ? totalAmount : 0.0;
    double platformFee = 20.00;
    double serviceTax = baseFare * 0.05;
    double insuranceFee = 15.00;
    double finalTotal = baseFare + platformFee + serviceTax + insuranceFee;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - TransitEase Bus Booking</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #1a3a8f;
            --secondary-color: #0f2557;
            --accent-color: #3949ab;
            --success-color: #43a047;
            --warning-color: #fdd835;
            --danger-color: #e53935;
            --light-gray: #f5f6fa;
            --border-radius: 10px;
            --box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #e8eaf6;
            color: #333;
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 20px;
        }

        .payment-wrapper {
            display: grid;
            grid-template-columns: 1fr 1.5fr;
            gap: 2rem;
        }

        .booking-summary, .payment-options {
            background: white;
            padding: 2rem;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
        }

        .section-header {
            color: var(--primary-color);
            font-size: 1.5rem;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--light-gray);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .passenger-card {
            background-color: #f8f9fa;
            padding: 1.5rem;
            border-radius: var(--border-radius);
            margin-bottom: 1rem;
            border-left: 4px solid var(--accent-color);
        }

        .fare-breakdown-section {
            background: white;
            border-radius: var(--border-radius);
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .fare-details {
            background-color: #f8f9fa;
            border-radius: var(--border-radius);
            padding: 1.5rem;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 0.8rem 0;
            border-bottom: 1px solid #e0e0e0;
        }

        .charges-section {
            margin-top: 1.5rem;
            padding-top: 1rem;
            border-top: 2px dashed #e0e0e0;
        }

        .total-section {
            margin-top: 1.5rem;
            padding-top: 1rem;
            border-top: 2px solid #e0e0e0;
        }

        .payment-method {
            border: 2px solid #e0e0e0;
            border-radius: var(--border-radius);
            padding: 1.5rem;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 1rem;
        }

        .payment-method:hover {
            border-color: var(--accent-color);
            background-color: #f8f9fa;
        }

        .payment-method.selected {
            border-color: var(--accent-color);
            background-color: #e8eaf6;
        }

        .payment-method-header {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .payment-icon {
            font-size: 1.8rem;
            color: var(--accent-color);
        }

        .payment-details {
            display: none;
            margin-top: 1rem;
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .form-control {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: var(--border-radius);
            font-size: 1rem;
            transition: all 0.3s ease;
            margin-bottom: 1rem;
        }

        .form-control:focus {
            border-color: var(--accent-color);
            outline: none;
            box-shadow: 0 0 0 3px rgba(57, 73, 171, 0.1);
        }

        .btn-pay {
            width: 100%;
            padding: 1.2rem;
            border: none;
            border-radius: var(--border-radius);
            background-color: var(--success-color);
            color: white;
            font-size: 1.2rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 2rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-pay:hover {
            background-color: #388e3c;
            transform: translateY(-2px);
        }

        .btn-pay:disabled {
            background-color: #9e9e9e;
            cursor: not-allowed;
        }

        .secure-badge {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            color: #666;
            margin-top: 1rem;
            font-size: 0.9rem;
            padding: 0.5rem;
            background-color: #f8f9fa;
            border-radius: var(--border-radius);
        }

        .spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255,255,255,.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 1s ease-in-out infinite;
            margin-right: 10px;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        @media (max-width: 768px) {
            .payment-wrapper {
                grid-template-columns: 1fr;
            }

            .container {
                padding: 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="payment-wrapper">
            <!-- Booking Summary Section -->
            <div class="booking-summary">
                <h2 class="section-header">
                    <i class="fas fa-receipt"></i> Booking Summary
                </h2>

                <!-- Journey Details -->
                <div class="journey-details">
                    <h3><i class="fas fa-bus"></i> Journey Details</h3>
                    <div class="detail-row">
                        <span class="detail-label">Bus ID</span>
                        <span class="detail-value"><%=busId%></span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Selected Seats</span>
                        <span class="detail-value"><%=seatNumbers%></span>
                    </div>
                </div>

                <!-- Passenger Details -->
                <div class="passenger-details">
                    <h3><i class="fas fa-users"></i> Passenger Details</h3>
                    <% for (Map.Entry<String, Map<String, String>> entry : passengers.entrySet()) { %>
                        <div class="passenger-card">
                            <div class="detail-row">
                                <span class="detail-label">Seat Number</span>
                                <span class="detail-value"><%=entry.getKey()%></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Name</span>
                                <span class="detail-value"><%=entry.getValue().get("name")%></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Age</span>
                                <span class="detail-value"><%=entry.getValue().get("age")%></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Gender</span>
                                <span class="detail-value"><%=entry.getValue().get("gender")%></span>
                            </div>
                        </div>
                    <% } %>
                </div>

                <!-- Fare Breakdown -->
                <div class="fare-breakdown-section">
                    <h3><i class="fas fa-calculator"></i> Fare Breakdown</h3>
                    <div class="fare-details">
                        <div class="detail-row">
                            <span class="detail-label">Base Fare</span>
                            <span class="detail-value">₹<%=String.format("%.2f", baseFare)%></span>
                        </div>
                        <div class="charges-section">
                            <div class="detail-row">
                                <span class="detail-label">Platform Fee</span>
                                <span class="detail-value">₹<%=String.format("%.2f", platformFee)%></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Service Tax (5%)</span>
                                <span class="detail-value">₹<%=String.format("%.2f", serviceTax)%></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Insurance Fee</span>
                                <span class="detail-value">₹<%=String.format("%.2f", insuranceFee)%></span>
                            </div>
                        </div>
                        <div class="total-section">
                            <div class="detail-row">
                                <span class="detail-label">Total Amount</span>
                                <span class="detail-value">₹<%=String.format("%.2f", finalTotal)%></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Payment Options Section -->
            <div class="payment-options">
                <h2 class="section-header">
                    <i class="fas fa-credit-card"></i> Select Payment Method
                </h2>

                <form id="paymentForm" action="ProcessPayment" method="POST">
                    <!-- Hidden fields for booking details -->
                    <input type="hidden" name="busId" value="<%=busId%>">
                    <input type="hidden" name="seatNumbers" value="<%=seatNumbers%>">
                    <input type="hidden" name="totalAmount" value="<%=finalTotal%>">
                    <input type="hidden" name="passengerDetails" value="<%=passengerDetails%>">
                    <input type="hidden" name="paymentMethod" id="paymentMethodInput">

                    <!-- UPI Payment -->
                    <div class="payment-method" onclick="selectPaymentMethod(this, 'upi')">
                        <div class="payment-method-header">
                            <i class="fas fa-mobile-alt payment-icon"></i>
                            <div>
                                <h3>UPI Payment</h3>
                                <p>Pay using GPay, PhonePe, Paytm, or any UPI app</p>
                            </div>
                        </div>
                        <div class="payment-details">
                            <input type="text" class="form-control" name="upiId" 
                                   placeholder="Enter UPI ID (example@upi)"
                                   pattern="[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}"
                                   title="Please enter a valid UPI ID">
                        </div>
                    </div>

                    <!-- Credit/Debit Card -->
                    <div class="payment-method" onclick="selectPaymentMethod(this, 'card')">
                        <div class="payment-method-header">
                            <i class="fas fa-credit-card payment-icon"></i>
                            <div>
                                <h3>Credit/Debit Card</h3>
                                <p>Secure card payment</p>
                            </div>
                        </div>
                        <div class="payment-details">
                            <input type="text" class="form-control" name="cardNumber" 
                                   placeholder="Card Number" pattern="[0-9]{16}"
                                   title="Please enter a valid 16-digit card number">
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                                <input type="text" class="form-control" name="expiryDate" 
                                       placeholder="MM/YY" pattern="(0[1-9]|1[0-2])\/([0-9]{2})"
                                       title="Please enter a valid expiry date (MM/YY)">
                                <input type="password" class="form-control" name="cvv" 
                                       placeholder="CVV" pattern="[0-9]{3,4}"
                                       title="Please enter a valid CVV">
                            </div>
                            <input type="text" class="form-control" name="cardHolderName" 
                                   placeholder="Card Holder Name">
                        </div>
                    </div>

                    <!-- Net Banking -->
                    <div class="payment-method" onclick="selectPaymentMethod(this, 'netbanking')">
                        <div class="payment-method-header">
                            <i class="fas fa-university payment-icon"></i>
                            <div>
                                <h3>Net Banking</h3>
                                <p>All major banks available</p>
                            </div>
                        </div>
                        <div class="payment-details">
                            <select class="form-control" name="bankCode">
                                <option value="">Select Bank</option>
                                <option value="SBI">State Bank of India</option>
                                <option value="HDFC">HDFC Bank</option>
                                <option value="ICICI">ICICI Bank</option>
                                <option value="AXIS">Axis Bank</option>
                                <option value="KOTAK">Kotak Mahindra Bank</option>
                            </select>
                        </div>
                    </div>

                    <button type="submit" class="btn-pay" id="payButton">
                        Pay ₹<%=String.format("%.2f", finalTotal)%>
                    </button>
                </form>

                <div class="secure-badge">
                    <i class="fas fa-lock"></i>
                    Your payment is secured with 256-bit encryption
                </div>
            </div>
        </div>
    </div>

    <script>
        let selectedMethod = '';

        function selectPaymentMethod(element, method) {
            // Remove selected class from all payment methods
            document.querySelectorAll('.payment-method').forEach(el => {
                el.classList.remove('selected');
                el.querySelector('.payment-details').style.display = 'none';
                
                // Reset all inputs in other payment methods
                el.querySelectorAll('input, select').forEach(input => {
                    input.required = false;
                });
            });
            
            // Add selected class to clicked method
            element.classList.add('selected');
            element.querySelector('.payment-details').style.display = 'block';
            
            // Set required fields for selected method
            element.querySelectorAll('input, select').forEach(input => {
                input.required = true;
            });
            
            // Update hidden payment method input
            selectedMethod = method;
            document.getElementById('paymentMethodInput').value = method;
        }

        // Form submission handling
        document.getElementById('paymentForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            if (!selectedMethod) {
                alert('Please select a payment method');
                return;
            }

            const button = document.getElementById('payButton');
            const originalText = button.innerHTML;
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
            button.disabled = true;

            // Validate form based on selected payment method
            let isValid = true;
            const form = this;

            switch(selectedMethod) {
                case 'upi':
                    const upiId = form.querySelector('[name="upiId"]').value;
                    if (!upiId.includes('@')) {
                        alert('Please enter a valid UPI ID');
                        isValid = false;
                    }
                    break;
                case 'card':
                    const cardNumber = form.querySelector('[name="cardNumber"]').value;
                    const expiryDate = form.querySelector('[name="expiryDate"]').value;
                    if (cardNumber.length !== 16 || !expiryDate.match(/^(0[1-9]|1[0-2])\/([0-9]{2})$/)) {
                        alert('Please enter valid card details');
                        isValid = false;
                    }
                    break;
                case 'netbanking':
                    const bank = form.querySelector('[name="bankCode"]').value;
                    if (!bank) {
                        alert('Please select a bank');
                        isValid = false;
                    }
                    break;
            }

            if (isValid) {
                // Submit the form
                this.submit();
            } else {
                button.innerHTML = originalText;
                button.disabled = false;
            }
        });

        // Initialize the first payment method as selected
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelector('.payment-method').click();
        });
    </script>
</body>
</html>