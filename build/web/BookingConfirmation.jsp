<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page  import="model.PaymentDetails" %>
<%
    // Retrieve values from session
    String bookingRef = (String) session.getAttribute("bookingReference");
    String busId = (String) session.getAttribute("busId");
    String seatNumbers = (String) session.getAttribute("seatNumbers");
    Map<String, Map<String, String>> passengerMap = 
        (Map<String, Map<String, String>>) session.getAttribute("passengerMap");
    PaymentDetails paymentDetails = (PaymentDetails) session.getAttribute("paymentDetails");
    
    // Format current date
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy HH:mm:ss");
    String bookingDate = sdf.format(new Date());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmed - TransitEase</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.5.1/dist/confetti.browser.min.js"></script>
    <style>
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #34495e;
            --accent-color: #3498db;
            --success-color: #2ecc71;
            --background-color: #ecf0f1;
            --text-color: #2c3e50;
            --border-radius: 12px;
            --box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: var(--background-color);
            color: var(--text-color);
            line-height: 1.6;
        }

        .success-banner {
            background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%);
            color: white;
            padding: 3rem 0;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .success-banner::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, 
                rgba(255,255,255,0.1) 25%, 
                transparent 25%, 
                transparent 50%, 
                rgba(255,255,255,0.1) 50%, 
                rgba(255,255,255,0.1) 75%, 
                transparent 75%, 
                transparent);
            background-size: 50px 50px;
            animation: moveStripes 3s linear infinite;
        }

        @keyframes moveStripes {
            0% { background-position: 0 0; }
            100% { background-position: 50px 50px; }
        }

        .success-icon {
            font-size: 5rem;
            margin-bottom: 1rem;
            animation: bounceIn 1s cubic-bezier(0.68, -0.55, 0.265, 1.55);
        }

        @keyframes bounceIn {
            0% { transform: scale(0); opacity: 0; }
            60% { transform: scale(1.2); }
            100% { transform: scale(1); opacity: 1; }
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 2rem;
            position: relative;
        }

        .ticket-container {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            margin-top: -50px;
            position: relative;
            z-index: 1;
            overflow: hidden;
        }

        .ticket-header {
            background: var(--primary-color);
            color: white;
            padding: 2rem;
            position: relative;
        }

        .ticket-header::after {
            content: '';
            position: absolute;
            bottom: -15px;
            left: 0;
            right: 0;
            height: 30px;
            background: radial-gradient(circle, 
                transparent 0%, 
                transparent 50%, 
                white 50%, 
                white 100%) -15px 0;
            background-size: 30px 30px;
        }

        .booking-ref {
            font-size: 1.2rem;
            opacity: 0;
            animation: slideIn 0.5s ease forwards 0.5s;
        }

        @keyframes slideIn {
            from { transform: translateX(-20px); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }

        .info-section {
            padding: 2rem;
            border-bottom: 1px solid #eee;
        }

        .info-section h3 {
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
        }

        .info-card {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: var(--border-radius);
            transition: transform 0.3s ease;
        }

        .info-card:hover {
            transform: translateY(-5px);
        }

        .passenger-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 1.5rem;
            border-radius: var(--border-radius);
            margin-bottom: 1rem;
            border-left: 4px solid var(--accent-color);
            transition: all 0.3s ease;
        }

        .passenger-card:hover {
            transform: translateX(5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            padding: 2rem;
        }

        .btn {
            flex: 1;
            padding: 1rem;
            border: none;
            border-radius: var(--border-radius);
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: var(--accent-color);
            color: white;
        }

        .btn-secondary {
            background: #e9ecef;
            color: var(--text-color);
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .fare-details {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: var(--border-radius);
        }

        .fare-row {
            display: flex;
            justify-content: space-between;
            padding: 0.8rem 0;
            border-bottom: 1px dashed #dee2e6;
        }

        .fare-row.total {
            border-top: 2px solid #dee2e6;
            border-bottom: none;
            margin-top: 1rem;
            padding-top: 1rem;
            font-weight: 700;
            color: var(--primary-color);
            font-size: 1.2rem;
        }

        @media print {
            .no-print {
                display: none;
            }
            .ticket-container {
                box-shadow: none;
                margin-top: 0;
            }
            body {
                background: white;
            }
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }
            .info-grid {
                grid-template-columns: 1fr;
            }
            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <!-- Success Banner -->
    <div class="success-banner no-print">
        <i class="fas fa-check-circle success-icon"></i>
        <h1>Booking Confirmed!</h1>
        <p>Your journey is all set to begin</p>
    </div>

    <div class="container">
        <!-- Ticket Container -->
        <div class="ticket-container" data-aos="fade-up">
            <div class="ticket-header">
                <h2><i class="fas fa-ticket-alt"></i> TransitEase Bus Ticket</h2>
                <div class="booking-ref">Booking Reference: <%=bookingRef%></div>
            </div>

            <!-- Booking Information -->
            <div class="info-section" data-aos="fade-up" data-aos-delay="100">
                <h3><i class="fas fa-info-circle"></i> Booking Information</h3>
                <div class="info-grid">
                    <div class="info-card" data-aos="fade-up" data-aos-delay="200">
                        <div class="info-label">Booking Date</div>
                        <div class="info-value"><%=bookingDate%></div>
                    </div>
                    <div class="info-card" data-aos="fade-up" data-aos-delay="300">
                        <div class="info-label">Bus ID</div>
                        <div class="info-value"><%=busId%></div>
                    </div>
                    <div class="info-card" data-aos="fade-up" data-aos-delay="400">
                        <div class="info-label">Seat Numbers</div>
                        <div class="info-value"><%=seatNumbers%></div>
                    </div>
                </div>
            </div>

            <!-- Passenger Information -->
            <div class="info-section" data-aos="fade-up" data-aos-delay="500">
                <h3><i class="fas fa-users"></i> Passenger Information</h3>
                <% if(passengerMap != null) {
                    for(Map.Entry<String, Map<String, String>> entry : passengerMap.entrySet()) { %>
                        <div class="passenger-card" data-aos="fade-left">
                            <div class="info-grid">
                                <div class="info-item">
                                    <div class="info-label">Seat Number</div>
                                    <div class="info-value"><%=entry.getKey()%></div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Passenger Name</div>
                                    <div class="info-value"><%=entry.getValue().get("name")%></div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Age</div>
                                    <div class="info-value"><%=entry.getValue().get("age")%></div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Gender</div>
                                    <div class="info-value"><%=entry.getValue().get("gender")%></div>
                                </div>
                            </div>
                        </div>
                    <% }
                } %>
            </div>

            <!-- Fare Details -->
            <div class="info-section" data-aos="fade-up" data-aos-delay="600">
                <h3><i class="fas fa-receipt"></i> Fare Details</h3>
                <div class="fare-details">
                    <div class="fare-row">
                        <span>Base Fare</span>
                        <span>₹<%=String.format("%.2f", paymentDetails.getBaseFare())%></span>
                    </div>
                    <div class="fare-row">
                        <span>Platform Fee</span>
                        <span>₹<%=String.format("%.2f", paymentDetails.getPlatformFee())%></span>
                    </div>
                    <div class="fare-row">
                        <span>Service Tax</span>
                        <span>₹<%=String.format("%.2f", paymentDetails.getServiceTax())%></span>
                    </div>
                    <div class="fare-row">
                        <span>Insurance Fee</span>
                        <span>₹<%=String.format("%.2f", paymentDetails.getInsuranceFee())%></span>
                    </div>
                    <div class="fare-row total">
                        <span>Total Amount</span>
                        <span>₹<%=String.format("%.2f", paymentDetails.getTotalAmount())%></span>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="action-buttons no-print" data-aos="fade-up" data-aos-delay="700">
                <button class="btn btn-primary" onclick="window.print()">
                    <i class="fas fa-print"></i> Print Ticket
                </button>
                <button class="btn btn-primary" onclick="downloadTicket()">
                    <i class="fas fa-download"></i> Download PDF
                </button>
                <button class="btn btn-secondary" onclick="window.location.href='index.jsp'">
                    <i class="fas fa-home"></i> Back to Home
                </button>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <script>
        // Initialize AOS
        AOS.init({
            duration: 1000,
            once: true
        });

        // Confetti effect
        function throwConfetti() {
            confetti({
                particleCount: 100,
                spread: 70,
                origin: { y: 0.6 }
            });
        }

        // Call confetti on page load
        window.onload = function() {
            throwConfetti();
            setTimeout(throwConfetti, 500);
            setTimeout(throwConfetti, 1000);
        };

        function downloadTicket() {
            const element = document.querySelector('.ticket-container');
            const opt = {
                margin: 1,
                filename: 'TransitEase-Ticket-<%=bookingRef%>.pdf',
                image: { type: 'jpeg', quality: 0.98 },
                html2canvas: { scale: 2 },
                jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
            };

            // Remove no-print elements temporarily
            const noPrintElements = document.querySelectorAll('.no-print');
            noPrintElements.forEach(el => el.style.display = 'none');

            html2pdf().set(opt).from(element).save().then(() => {
                // Restore no-print elements
                noPrintElements.forEach(el => el.style.display = 'flex');
            });
        }
    </script>
</body>
</html>