<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.AdminModel,dao.AdminDAO,java.util.*" %>

<%
    if (session.getAttribute("LogedAdminInfo") == null) {
%>  
<jsp:forward page="AdminLogin.jsp" />

<%
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Management</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    </head>

    <%
        List<AdminModel> adminModels = new ArrayList<>();
        AdminDAO adminDAO = new AdminDAO();

        adminModels = adminDAO.getAllAdminInfo();

        AdminModel adminModel1 = (AdminModel) session.getAttribute("LogedAdminInfo");
    %>
    <body>
        <div class="content-table">
            <div class="table-header">
                <h3>Admin Info</h3>
                <div>
                    <input type="text" class="search-input" placeholder="Search admin user...">
                    <% if(adminModel1.getRole().equals("super_admin")) { %>
                    <button class="action-button">
                        <a href="pages/addAdmin.jsp">
                            <i class="fas fa-plus"></i> Add Admin
                        </a>
                    </button>
                    <% } %>
                </div>
            </div>
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Admin ID</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Full Name</th>
                            <th>Mobile No</th>
                            <th>Role</th>
                            <th>Created At</th>
                            <th>Updated At</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%                            if (adminModels.size() > 0) {
                                for (AdminModel adminModel : adminModels) {
                        %>
                        <tr>
                            <td><%= adminModel.getAdmin_id()%></td>
                            <td><%= adminModel.getUsername()%></td>
                            <td><%= adminModel.getEmail()%></td>
                            <td><%= adminModel.getFull_name()%></td>
                            <td><%= adminModel.getMobile_no()%></td>
                            <td><%= adminModel.getRole()%></td>
                            <td><%= adminModel.getCreated_at()%></td>
                            <td><%= adminModel.getUpdated_at()%></td>

                            <td class="action-icons">
                                <% 
                                    if (adminModel1.getRole().equalsIgnoreCase("super_admin")) {
                                %>
                                <a href="pages/editAdmin.jsp?id=<%= adminModel.getAdmin_id()%>"><i class="fas fa-edit" title="Edit"></i></a>
                                <a href="${pageContext.request.contextPath}/DeleteAdmin?id=<%= adminModel.getAdmin_id() %>"><i class="fas fa-trash" title="Delete"></i></a>
                                <% } else {
                                %>
                                No Authority
                                <%
    }   %>
                            </td>



                        </tr>
                        <%
                            }
                        } else {
                        %>
                    <h3>No Content found</h3>
                    <%
                        }
                    %>



                    </tbody>
                </table>
            </div>
        </div>



    </body>
</html>