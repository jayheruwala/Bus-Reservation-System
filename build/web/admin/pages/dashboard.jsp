<%-- 
    Document   : deshboard
    Created on : 27 Mar 2025, 4:55:16 pm
    Author     : jayhe
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% 
    if(session.getAttribute("LogedAdminInfo") == null){
        %>  
        <jsp:forward page="AdminLogin.jsp" />

        <%
    }
%>
<div class="dashboard-cards">
    <div class="card">
        <div class="card-title">Total Bookings</div>
        <div class="card-value">1,234</div>
    </div>
    <div class="card">
        <div class="card-title">Active Buses</div>
        <div class="card-value">45</div>
    </div>
    <div class="card">
        <div class="card-title">Total Revenue</div>
        <div class="card-value">₹85,400</div>
    </div>
    <div class="card">
        <div class="card-title">Total Customers</div>
        <div class="card-value">892</div>
    </div>
</div>

<div class="content-table">
    <div class="table-header">
        <h3>Recent Bookings</h3>
        <input type="text" class="search-input" placeholder="Search bookings...">
    </div>
    <div class="table-responsive">
        <table>
            <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>Customer Name</th>
                    <th>Route</th>
                    <th>Date</th>
                    <th>Amount</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>#BK001</td>
                    <td>John Doe</td>
                    <td>Mumbai - Delhi</td>
                    <td>2024-03-15</td>
                    <td>₹1,500</td>
                    <td><span class="status-badge status-active">Confirmed</span></td>
                </tr>
                <tr>
                    <td>#BK002</td>
                    <td>Jane Smith</td>
                    <td>Delhi - Bangalore</td>
                    <td>2024-03-16</td>
                    <td>₹2,000</td>
                    <td><span class="status-badge status-pending">Pending</span></td>
                </tr>
            </tbody>
        </table>
    </div>
</div> 