<%-- 
    Document   : AdminLogin
    Created on : 3 Apr 2025, 9:48:29 pm
    Author     : jayhe
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Login</title>
        <link rel="stylesheet" href="CSS/AdminLogin.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"/>
        
    </head>
    <body>
        <div class="login-container">
            <div class="form-header">
                <div class="header-decoration"></div>
                <div class="header-icon">
                    <i class="fas fa-user-shield"></i>
                </div>
                <h2>Admin Panel</h2>
                <p>Enter your credentials to access the dashboard</p>
            </div>

            <div class="form-body">
                <!-- Display server-side error message -->
                <% 
                    String errorMessage = (String) session.getAttribute("errorMessage");
                    if (errorMessage != null) {
                %>
                    <div class="error-container">
                        <i class="fas fa-exclamation-circle"></i>
                        <%= errorMessage %>
                    </div>
                <% 
                        session.removeAttribute("errorMessage"); // Clear after display
                    } 
                %>

                <form id="loginForm" action="${pageContext.request.contextPath}/AdminLogin" method="post">
                    <!-- Email Field -->
                    <div class="form-group">
                        <label for="email" class="form-label">Email Address</label>
                        <input type="email" id="email" name="email" class="form-input" 
                               placeholder="Enter your email address" 
                               value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>" 
                               required>
                        <i class="fas fa-envelope input-icon"></i>
                        <div class="error-message" id="emailError">${emailError}</div>
                    </div>

                    <!-- Password Field -->
                    <div class="form-group">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" id="password" name="password" class="form-input" 
                               placeholder="Enter your password" required>
                        <button type="button" class="password-toggle" id="passwordToggle">
                            <i class="fas fa-eye"></i>
                        </button>
                        <div class="error-message" id="passwordError">${passwordError}</div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="login-btn" id="loginBtn">Sign In</button>

                    <!-- Forgot Password Link (Commented Out) -->
                    <!--
                    <p class="forgot-password">
                        <a href="#" class="forgot-link">Forgot Password?</a>
                    </p>
                    -->
                </form>
            </div>
        </div>

        <script src="JS/AdminLogin.js"></script>
    </body>
</html>