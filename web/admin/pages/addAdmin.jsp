<%-- 
    Document   : addAdmin
    Created on : 13 Apr 2025, 6:54:31 pm
    Author     : jayhe
--%>

<%@page import="model.AdminModel"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    AdminModel adminModel1 = null;
    if (session.getAttribute("LogedAdminInfo") == null) {
%>  
<jsp:forward page="../index.jsp" />
<%
    } else {
        adminModel1 = (AdminModel) session.getAttribute("LogedAdminInfo");
    }
    if (!(adminModel1.getRole().equals("super_admin"))) {
%>
<jsp:forward page="../index.jsp" />
<%
    }
%>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create Admin</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <link rel="stylesheet" href="css/editAdmin.css"/>
        <style>
            :root {
                --primary: #6366f1;
                --primary-dark: #4f46e5;
                --danger: #dc2626;
                --danger-dark: #b91c1c;
                --success: #059669;
                --success-dark: #047857;
                --text: #1f2937;
                --text-light: #6b7280;
                --background: #f3f4f6;
                --card: #ffffff;
                --border: #e5e7eb;
                --input-bg: #f9fafb;
            }

            .fa-phone.form-icon {
                top: calc(50% + 15px);
                transform: translateY(-50%) rotate(90deg);
            }

            .message-container {
                margin: 10px;
                display: flex;
                justify-content: center;
                align-items: center;
                margin: 10px 10px;
                padding: 12px 16px;
                border-radius: 6px;
                font-size: 0.9rem;
                gap: 10px;
                min-height: 20px;
                transition: opacity 0.3s ease;
                opacity: 1;
            }

            .error-message {
                background-color: rgba(220, 38, 38, 0.1);
                border: 1px solid var(--danger);
                color: var(--danger);
                text-align: center;
            }

            .success-message {
                background-color: rgba(5, 150, 105, 0.1);
                border: 1px solid var(--success);
                color: var(--success);
                text-align: center;
            }

            .message-container i {
                font-size: 1.1rem;
            }

            .message-container p {
                margin: 0;
            }

            .message-container.fade-out {
                opacity: 0;
            }



        </style>
    </head>
    <body>
        <div class="container">
            <div class="card">
                <div class="card-header">
                    <h2>Create New Admin</h2>
                    <p>Add a new administrator to the system</p>
                </div>

                <!-- Improved message display -->
                <%
                    String errorMessage = (String) session.getAttribute("errorMessage");
                    String successMessage = (String) session.getAttribute("successMessage");
                    if (errorMessage != null) {
                %>
                <div class="message-container error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <p><%= errorMessage%></p>
                </div>
                <%
                        session.removeAttribute("errorMessage"); // Clear message after display
                    }
                    if (successMessage != null) {
                %>
                <div class="message-container success-message">
                    <i class="fas fa-check-circle"></i>
                    <p><%= successMessage%></p>
                </div>
                <%
                        session.removeAttribute("successMessage"); // Clear message after display
                    }
                %>

                <form action="${pageContext.request.contextPath}/AddAdmin" method="POST">
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="full_name">Full Name</label>
                                    <i class="fas fa-user form-icon"></i>
                                    <input type="text" class="form-control" id="full_name" name="full_name" 
                                           placeholder="Enter full name" required>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="username">Username</label>
                                    <i class="fas fa-id-badge form-icon"></i>
                                    <input type="text" class="form-control" id="username" name="username" 
                                           placeholder="Enter username" required>
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="email">Email</label>
                                    <i class="fas fa-envelope form-icon"></i>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           placeholder="Enter email" required>
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="mobile_no">Mobile Number</label>
                                    <i class="fas fa-phone form-icon"></i>
                                    <input type="tel" class="form-control" id="mobile_no" name="mobile_no" 
                                           placeholder="Enter mobile number" required 
                                           pattern="[0-9]{10,}" title="Please enter a valid mobile number">
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="password">Password</label>
                                    <i class="fas fa-lock form-icon"></i>
                                    <input type="password" class="form-control" id="password" name="password" 
                                           placeholder="Enter password" required 
                                           minlength="8" title="Password must be at least 8 characters">
                                </div>
                            </div>
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="role">Role</label>
                                    <i class="fas fa-user-shield form-icon"></i>
                                    <select class="form-control" id="role" name="role" required>
                                        <option value="moderator">Moderator</option>
                                        <option value="super_admin">Super Admin</option>
                                        <option value="support">Support</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <p class="form-note">All fields are required. Password must be at least 8 characters long.</p>
                        </div>
                    </div>

                    <div class="card-footer">
                        <button type="reset" class="btn btn-danger">
                            <i class="fas fa-times"></i> Cancel
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Create Admin
                        </button>
                    </div>
                </form>
            </div>
        </div>
        <script src="JS/adminSubmit.js"></script>
        <script>
            // Optional: Auto-fade messages after 5 seconds
            document.querySelectorAll('.message-container').forEach(function (el) {
                setTimeout(function () {
                    el.classList.add('fade-out');
                    setTimeout(function () {
                        el.style.display = 'none';
                    }, 300); // Match transition duration
                }, 5000); // Display for 5 seconds
            });
        </script>
    </body>
</html>