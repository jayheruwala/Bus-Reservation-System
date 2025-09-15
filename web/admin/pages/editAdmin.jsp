<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.AdminModel,dao.AdminDAO,java.util.*" %>
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
    <title>Update Admin Profile</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/editAdmin.css"/>
</head>

<%
    String adminId = request.getParameter("id");
    List<AdminModel> adminInfo = new ArrayList<>();
    AdminDAO adminDAO = new AdminDAO();
    adminInfo = adminDAO.getAdminById(adminId);
    AdminModel adminModel = null;
    
    if (adminInfo != null && adminInfo.size() > 0) {
        adminModel = adminInfo.getFirst();
    } else {
        // Handle case where admin is not found
        session.setAttribute("errorMessage", "Admin not found");
    }
    
    // Get error or success message from session
    String errorMessage = (String) session.getAttribute("errorMessage");
    String successMessage = (String) session.getAttribute("successMessage");
%>

<body>
    <div class="container">
        <div class="card">
            <div class="card-header">
                <h2>Update Admin Profile</h2>
                <p>Modify administrator details and permissions</p>
            </div>
            
            <div class="card-body">
                <% if (errorMessage != null) { %>
                    <div style="color: red; margin-bottom: 10px; text-align: center;">
                        <%= errorMessage %>
                    </div>
                    <% session.removeAttribute("errorMessage"); %>
                <% } %>
                <% if (successMessage != null) { %>
                    <div style="color: green; margin-bottom: 10px; text-align: center;">
                        <%= successMessage %>
                    </div>
                    <% session.removeAttribute("successMessage"); %>
                <% } %>

                <% if (adminModel != null) { %>
                    <form id="editAdminForm" action="${pageContext.request.contextPath}/UpdateAdmin" method="POST">
                        <input type="hidden" id="admin_id" twor name="admin_id" value="<%= adminModel.getAdmin_id() %>">
                        
                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="username">Username</label>
                                    <input type="text" class="form-control" id="username" name="username" 
                                           value="<%= request.getParameter("username") != null ? request.getParameter("username") : adminModel.getUsername() %>" 
                                           required autocomplete="username">
                                    <i class="fas fa-user form-icon"></i>
                                </div>
                            </div>
                            
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="email">Email Address</label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           value="<%= request.getParameter("email") != null ? request.getParameter("email") : adminModel.getEmail() %>" 
                                           required autocomplete="email">
                                    <i class="fas fa-envelope form-icon"></i>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="full_name">Full Name</label>
                            <input type="text" class="form-control" id="full_name" name="full_name" 
                                   value="<%= request.getParameter("full_name") != null ? request.getParameter("full_name") : adminModel.getFull_name() %>" 
                                   required autocomplete="name">
                            <i class="fas fa-id-card form-icon"></i>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="mobile_no">Mobile Number</label>
                                    <input type="tel" class="form-control" id="mobile_no" name="mobile_no" 
                                           value="<%= request.getParameter("mobile_no") != null ? request.getParameter("mobile_no") : adminModel.getMobile_no() %>" 
                                           required pattern="[0-9]{10}" title="Please enter a 10-digit mobile number">
                                    <i class="fas fa-phone form-icon"></i>
                                    <p class="form-note">Format: 10-digit number without spaces or dashes</p>
                                </div>
                            </div>
                            
                            <div class="form-col">
                                <div class="form-group">
                                    <label for="role">Administrative Role</label>
                                    <select class="form-control" id="role" name="role" required>
                                        <option value="">Select a role</option>
                                        <option value="super_admin" <%= "super_admin".equalsIgnoreCase(request.getParameter("role") != null ? request.getParameter("role") : adminModel.getRole()) ? "selected" : "" %>>Super Admin</option>
                                        <option value="moderator" <%= "moderator".equalsIgnoreCase(request.getParameter("role") != null ? request.getParameter("role") : adminModel.getRole()) ? "selected" : "" %>>Moderator</option>
                                        <option value="support" <%= "support".equalsIgnoreCase(request.getParameter("role") != null ? request.getParameter("role") : adminModel.getRole()) ? "selected" : "" %>>Support</option>
                                    </select>
                                    <i class="fas fa-shield-alt form-icon"></i>
                                </div>
                            </div>
                        </div>
                        
                        <div class="card-footer">
                            <button type="button" class="btn btn-danger" id="cancelBtn">
                                <i class="fas fa-times"></i> Cancel
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Save Changes
                            </button>
                        </div>
                    </form>
                <% } else { %>
                    <div style="color: red; text-align: center;">
                        Unable to load admin data. Please try again.
                    </div>
                <% } %>
            </div>
        </div>
    </div>
            <% 
                session.removeAttribute("errorMessage");
            %>

    <script src="JS/editAdmin.js"></script>
</body>
</html>