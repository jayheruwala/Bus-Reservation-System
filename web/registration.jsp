<%-- 
    Document   : registration
    Created on : 12 Mar 2025, 4:33:39 pm
    Author     : jayhe
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Register - TransitEase Bus Reservation</title>
        <link rel="stylesheet" href="css/registration.css"/>
    </head>
    <body>
        <div class="registration-container">
            <div class="form-header">
                <div class="header-decoration"></div>
                <div class="header-icon">
                    <i class="fas fa-user-plus"></i>
                </div>
                <h2>Create Your Account</h2>
                <p>Join TransitEase today for seamless bus travel</p>
            </div>

            <div class="form-body">
                <form id="registrationForm" action="Registration" method="POST"  >
                    <!-- Full Name Field -->
                    <div class="form-group">
                        <label for="name" class="form-label">Full Name</label>
                        <input type="text" id="name" name="name" class="form-input" placeholder="Enter your full name"
                               required>
                        <i class="fas fa-user input-icon"></i>
                        <div class="error-message" id="nameError">Please enter your full name</div>
                    </div>

                    <!-- Contact Number Field -->
                    <div class="form-group">
                        <label for="contact" class="form-label">Contact Number</label>
                        <input type="tel" id="contact" name="contact" class="form-input"
                               placeholder="Enter your phone number" required>
                        <i class="fas fa-phone input-icon"></i>
                        <div class="error-message" id="contactError">Please enter a valid phone number</div>
                         <% if(request.getAttribute("duplicateContact") != null) { %>
                        <div class="s_error"> <%= request.getAttribute("duplicateContact") != null ? request.getAttribute("duplicateContact") : ""%></div>
                        <% } %>
                    </div>

                    <!-- Email Field -->
                    <div class="form-group">
                        <label for="email" class="form-label">Email Address</label>
                        <input type="email" id="email" name="email" class="form-input"
                               placeholder="Enter your email address" required>
                        <i class="fas fa-envelope input-icon"></i>
                        <div class="error-message" id="emailError">Please enter a valid email address</div>
                          <% if(request.getAttribute("duplicateEmail") != null) { %>
                        <div class="s_error"> <%= request.getAttribute("duplicateEmail") != null ? request.getAttribute("duplicateEmail") : ""%></div>
                        <% } %>
                    </div>

                    <!-- Password Field -->
                    <div class="form-group">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" id="password" name="password" class="form-input"
                               placeholder="Create a password" required>
                        <button type="button" class="password-toggle" id="passwordToggle">
                            <i class="fas fa-eye"></i>
                        </button>
                        <div class="error-message" id="passwordError">Password must be at least 8 characters with letters
                            and numbers</div>
                    </div>

                    <!-- Confirm Password Field -->
                    <div class="form-group">
                        <label for="confirmPassword" class="form-label">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-input"
                               placeholder="Confirm your password" required>
                        <button type="button" class="password-toggle" id="confirmPasswordToggle">
                            <i class="fas fa-eye"></i>
                        </button>
                        <div class="error-message" id="confirmPasswordError">Passwords do not match</div>
                    </div>

                    <!-- Terms and Conditions -->
                    <div class="terms-container">
                        <input type="checkbox" id="terms" name="terms" class="terms-checkbox" required>
                        <label for="terms" class="terms-label">
                            I agree to the <span class="terms-link" id="termsLink">Terms and Conditions</span> of
                            TransitEase Bus Reservation System
                        </label>
                    </div>
                    <div class="error-message" id="termsError">You must accept the terms and conditions</div>
                    <% if(request.getAttribute("errors") != null) { %>
                        <div class="s_error"><%= request.getAttribute("errors") %></div>
                        <% } %>
                    <!-- Submit Button -->
                    <button type="submit" class="register-btn" id="registerBtn">Create Account</button>

                    <!-- Login Prompt -->
                    <p class="login-prompt">
                        Already have an account? <a href="login.jsp" class="login-link">Login here</a>
                    </p>
                </form>
            </div>
        </div>

        <!-- Terms and Conditions Modal -->
        <div id="termsModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">Terms and Conditions</h2>
                    <button class="close-btn" id="closeModal">&times;</button>
                </div>

                <div class="terms-section">
                    <h3>1. Account Registration and Security</h3>
                    <p>When you register for an account with TransitEase Bus Reservation System:</p>
                    <ul>
                        <li>You must provide accurate, current, and complete information.</li>
                        <li>You are responsible for maintaining the confidentiality of your account credentials.</li>
                        <li>You agree to notify us immediately of any unauthorized use of your account.</li>
                        <li>We reserve the right to suspend or terminate accounts with inaccurate information.</li>
                    </ul>
                </div>

                <div class="terms-section">
                    <h3>2. Booking and Reservation Policies</h3>
                    <p>When booking bus tickets through our system:</p>
                    <ul>
                        <li>Reservations are confirmed only after complete payment is processed.</li>
                        <li>Seat assignments are subject to availability and may change due to operational requirements.
                        </li>
                        <li>A valid ID matching the name on the booking is required at the time of boarding.</li>
                        <li>Children under 5 years travel free when not occupying a separate seat. Children between 5-12
                            years may be eligible for discounted fares.</li>
                        <li>Special assistance requirements must be specified at the time of booking.</li>
                    </ul>
                </div>

                <div class="terms-section">
                    <h3>3. Cancellation and Refund Policy</h3>
                    <ul>
                        <li>Cancellations made more than 48 hours before departure are eligible for a 90% refund.</li>
                        <li>Cancellations made 24-48 hours before departure are eligible for a 70% refund.</li>
                        <li>Cancellations made 12-24 hours before departure are eligible for a 50% refund.</li>
                        <li>Cancellations made less than 12 hours before departure are not eligible for a refund.</li>
                        <li>Administrative fees may apply to all refunds.</li>
                        <li>Refunds will be processed within 7-14 business days to the original payment method.</li>
                    </ul>
                </div>

                <div class="terms-section">
                    <h3>4. Luggage Policy</h3>
                    <ul>
                        <li>Each passenger is allowed one piece of luggage (up to 20kg) to be stored in the luggage
                            compartment.</li>
                        <li>One small handbag or laptop bag is allowed on board.</li>
                        <li>Oversized or additional luggage may incur extra charges.</li>
                        <li>Prohibited items include flammable materials, weapons, illegal substances, and unpackaged food
                            with strong odors.</li>
                        <li>TransitEase is not responsible for any loss, damage, or theft of belongings.</li>
                    </ul>
                </div>

                <div class="terms-section">
                    <h3>5. Travel Rules and Regulations</h3>
                    <ul>
                        <li>Passengers must arrive at the boarding point at least 15 minutes before the scheduled departure.
                        </li>
                        <li>The bus operator may refuse boarding to passengers who appear intoxicated or disruptive.</li>
                        <li>Smoking, consumption of alcohol, and use of illegal substances are strictly prohibited on all
                            buses.</li>
                        <li>Pets are not allowed on board, except for certified service animals.</li>
                    </ul>
                </div>

                <div class="terms-section">
                    <h3>6. Modifications to Bookings</h3>
                    <ul>
                        <li>Changes to travel dates or routes may be allowed up to 24 hours before departure, subject to
                            availability.</li>
                        <li>Modification fees may apply based on the timing of the request.</li>
                        <li>Name changes on tickets are not permitted. A new booking must be made.</li>
                    </ul>
                </div>

                <div class="terms-section">
                    <h3>7. Service Disruptions</h3>
                    <p>In the event of service disruptions:</p>
                    <ul>
                        <li>TransitEase will make reasonable efforts to notify passengers of delays or cancellations.</li>
                        <li>For delays exceeding 2 hours, passengers may choose to wait or cancel their booking for a full
                            refund.</li>
                        <li>If a service is canceled by TransitEase, passengers will receive a full refund or the option to
                            rebook at no additional cost.</li>
                        <li>TransitEase is not liable for delays caused by traffic, weather conditions, or other
                            circumstances beyond our control.</li>
                    </ul>
                </div>

                <div class="terms-section">
                    <h3>8. Privacy Policy</h3>
                    <p>We collect and process personal information in accordance with our Privacy Policy. By accepting these
                        terms, you acknowledge that you have read and understand our Privacy Policy.</p>
                </div>

                <div class="terms-section">
                    <h3>9. Modification of Terms</h3>
                    <p>TransitEase reserves the right to modify these terms at any time. Continued use of our service after
                        changes constitutes acceptance of the updated terms.</p>
                </div>

                <div style="text-align: center; margin-top: 2rem;">
                    <button class="accept-btn" id="acceptTerms">I Accept the Terms</button>
                </div>
            </div>
        </div>

        <!-- Registration Success Modal -->
        <div id="successModal" class="modal">
            <div class="modal-content confirmation-modal">
                <div class="success-checkmark">
                    <div class="check-icon">
                        <span class="icon-line line-tip"></span>
                        <span class="icon-line line-long"></span>
                        <div class="icon-circle"></div>
                        <div class="icon-fix"></div>
                    </div>
                </div>
                <h2 class="confirmation-title">Registration Successful!</h2>
                <p class="confirmation-message">Your account has been created successfully. You can now login to book your
                    bus tickets.</p>
                <button class="back-to-login">Go to Login</button>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/js/all.min.js"></script>
        <script src="js/registration.js"></script>
    </body>

    
</html>
