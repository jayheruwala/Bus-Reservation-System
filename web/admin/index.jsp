<%-- 
    Document   : index
    Created on : 27 Mar 2025, 4:47:07 pm
    Author     : jayhe
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>


<%
    if (session.getAttribute("LogedAdminInfo") == null) {
%>  
<jsp:forward page="AdminLogin.jsp" />

<%
    }
%>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Bus Reservation Admin Panel</title>
        <!-- Font Awesome CDN -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Poppins', sans-serif;
            }

            :root {
                --primary-color: #2563eb;
                --secondary-color: #1e40af;
                --text-color: #1f2937;
                --light-bg: #f3f4f6;
                --sidebar-width: 250px;
            }

            a{
                color: black;
            }

            .container {
                display: flex;
                min-height: 100vh;
            }

            /* Sidebar Styles */
            .sidebar {
                width: var(--sidebar-width);
                background-color: var(--primary-color);
                color: white;
                padding: 1rem;
                position: fixed;
                height: 100vh;
            }

            .logo {
                padding: 1rem;
                font-size: 1.5rem;
                font-weight: 600;
                border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            }

            .nav-links {
                margin-top: 2rem;
                list-style: none;
            }

            .nav-links li {
                margin-bottom: 0.5rem;
            }

            .nav-links a {
                color: white;
                text-decoration: none;
                padding: 0.75rem 1rem;
                display: flex;
                align-items: center;
                border-radius: 0.5rem;
                transition: all 0.3s;
            }

            .nav-links a:hover {
                background-color: var(--secondary-color);
            }

            .nav-links i {
                margin-right: 0.75rem;
                width: 20px;
            }

            /* Header Styles */
            .main-content {
                margin-left: var(--sidebar-width);
                flex: 1;
            }

            .header {
                background-color: white;
                padding: 1rem 2rem;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .header-left h2 {
                color: var(--text-color);
            }

            .header-right {
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            .user-profile {
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            /* Main Content Area */
            .content {
                padding: 2rem;
                background-color: var(--light-bg);
                min-height: calc(100vh - 70px);
            }

            /* Add styles for active link */
            .nav-links a.active {
                background-color: var(--secondary-color);
            }

            /* Add loading indicator styles */
            .loading {
                display: none;
                text-align: center;
                padding: 2rem;
            }

            .loading i {
                color: var(--primary-color);
                font-size: 2rem;
            }

            /* Dashboard Styles */
            .dashboard-cards {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1.5rem;
                margin-bottom: 2rem;
            }

            .card {
                background: white;
                padding: 1.5rem;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .card-title {
                color: #6b7280;
                font-size: 0.875rem;
                margin-bottom: 0.5rem;
            }

            .card-value {
                font-size: 1.875rem;
                font-weight: 600;
                color: var(--text-color);
            }

            /* Table Styles */
            .content-table {
                background: white;
                padding: 1.5rem;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                margin-top: 1.5rem;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th, td {
                padding: 0.75rem;
                text-align: left;
                border-bottom: 1px solid #e5e7eb;

            }



            th {
                background-color: #f9fafb;
                font-weight: 500;
            }

            /* Button Styles */
            .action-button {
                background: var(--primary-color);
                color: white;
                padding: 0.5rem 1rem;
                border-radius: 4px;
                border: none;
                cursor: pointer;
                margin-bottom: 1rem;
            }

            .action-button a {
                /*background: var(--primary-color);*/
                color: white;
                text-decoration: none;


            }

            .status-badge {
                padding: 0.25rem 0.75rem;
                border-radius: 9999px;
                font-size: 0.875rem;
            }

            .status-active {
                background: #d1fae5;
                color: #059669;
            }

            .status-pending {
                background: #fef3c7;
                color: #d97706;
            }

            /* Responsive Table Styles */
            .table-responsive {
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
                margin-bottom: 1rem;
            }

            .content-table {
                background: white;
                padding: 1rem;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                margin-top: 1rem;
            }

            .table-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1rem;
                flex-wrap: wrap;
                gap: 1rem;
            }

            .search-input {
                padding: 0.5rem;
                border: 1px solid #e5e7eb;
                border-radius: 4px;
                min-width: 250px;
            }

            .action-button {
                background: var(--primary-color);
                color: white;
                padding: 0.5rem 1rem;
                border-radius: 4px;
                border: none;
                cursor: pointer;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
            }

            .status-badge {
                padding: 0.25rem 0.75rem;
                border-radius: 9999px;
                font-size: 0.875rem;
            }

            .main-content{
                overflow-x: auto;
            }

            .status-active {
                background: #d1fae5;
                color: #059669;
            }
            .status-pending {
                background: #fef3c7;
                color: #d97706;
            }
            .status-cancelled {
                background: #fee2e2;
                color: #dc2626;
            }

            /*        .action-icons {
                        display: flex;
                        gap: 0.5rem;
                    }*/

            .action-icons i {
                cursor: pointer;
                padding: 0.25rem;
            }

            .action-icons i:hover {
                color: var(--primary-color);
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .dashboard-cards {
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                }

                .content {
                    padding: 1rem;
                }

                .header {
                    padding: 1rem;
                }

                .table-header {
                    flex-direction: column;
                    align-items: stretch;
                }

                .search-input {
                    width: 100%;
                }
            }
            /* Updated table styles */
            .table-container {
                width: 100%;
                overflow-x: auto;
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                margin-top: 1rem;
                padding: 1rem;
            }

            .content-table {
                min-width: 100%;
                /*width: max-content;  This ensures table takes the width of its content */
                background: white;
                border-collapse: collapse;
            }

            tr{
                height: 100%;
            }

            /* Header and cell styles */
            th, td {
                white-space: nowrap; /* Prevents text wrapping */
                padding: 12px 20px; /* Increased padding for better spacing */
                text-align: center;
                border: 1px solid #e5e7eb;
            }

            th {
                background-color: #f8fafc;
                font-weight: 600;
                color: #1e293b;
                position: sticky;
                top: 0;
                z-index: 10;
            }

            /* Column width specifications */
            .col-id {
                min-width: 80px;
            }
            .col-number {
                min-width: 120px;
            }
            .col-type {
                min-width: 120px;
            }
            .col-source {
                min-width: 150px;
            }
            .col-dest {
                min-width: 150px;
            }
            .col-departure {
                min-width: 180px;
            }
            .col-arrival {
                min-width: 180px;
            }
            .col-total {
                min-width: 100px;
            }
            .col-available {
                min-width: 100px;
            }
            .col-price {
                min-width: 120px;
            }
            .col-status {
                min-width: 120px;
            }
            .col-actions {
                min-width: 150px;
            }

            /* Row hover effect */
            tbody tr:hover {
                background-color: #f8fafc;
            }

            /* Status badge styles */
            .status-badge {
                /*padding: 6px 12px;*/
                border-radius: 999px;
                font-size: 0.875rem;
                font-weight: 500;
                /*display: inline-block;*/
                min-width: 100px;
            }

            .status-active {
                background: #dcfce7;
                color: #166534;
            }

            .status-inactive {
                background: #fee2e2;
                color: #991b1b;
            }

            /* Action buttons container */
            .action-icons {
                height: 100%;
                display: flex;
                justify-content: center;
                gap: 10px;
                min-width: 120px;
            }

            /* Action button styles */
            .action-btn {
                padding: 6px;
                border-radius: 6px;
                cursor: pointer;
                border: none;
                background: none;
                transition: all 0.2s ease;
            }

            .action-btn:hover {
                background-color: #f1f5f9;
            }

            .view-btn {
                color: #0891b2;
            }
            .edit-btn {
                color: #0284c7;
            }
            .delete-btn {
                color: #dc2626;
            }

            .disabled {
                color: #ccc;
                cursor: not-allowed;
            }


        </style>
    </head>
    <body>
        <div class="container">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="logo">
                    <i class="fas fa-bus"></i> Bus Admin
                </div>
                <ul class="nav-links">
                    <li><a href="#" data-page="pages/dashboard.jsp" class="active"><i class="fas fa-home"></i> Dashboard</a></li>
                    <li><a herf="#" data-page="pages/adminInfo.jsp" class="active"><i class="fas fa-user"></i>Admin</a></li>
                    <li><a href="#" data-page="pages/bookings.jsp"><i class="fas fa-ticket-alt"></i> Bookings</a></li>
                    <li><a href="#" data-page="pages/buses.jsp"><i class="fas fa-bus-alt"></i> Buses</a></li>
<!--                    <li><a href="#" data-page="pages/routes.jsp"><i class="fas fa-route"></i> Routes</a></li>
                    <li><a href="#" data-page="pages/customers.jsp"><i class="fas fa-users"></i> Customers</a></li>
                    <li><a href="#" data-page="pages/reports.jsp"><i class="fas fa-chart-bar"></i> Reports</a></li>
                    <li><a href="#" data-page="pages/settings.jsp"><i class="fas fa-cog"></i> Settings</a></li>-->
                </ul>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Header -->
                <div class="header">
                    <div class="header-left">
                        <h2 id="page-title">Dashboard</h2>
                    </div>
                    <div class="header-right">
                        <div class="user-profile">
                            <i class="fas fa-user-circle fa-lg"></i>
                            <span>Admin User</span>
                        </div>
                        <!--<i class="fas fa-bell fa-lg"></i>-->
                        <%   if (session.getAttribute("LogedAdminInfo") != null) {
                        %>

                        <a href="${pageContext.request.contextPath}/LogoutAdmin">
                            <i class="fas fa-sign-out-alt fa-lg"></i></a>
                            <%
                                }
                            %>
                    </div>
                </div>

                <!-- Content Area -->
                <div class="content">
                    <div id="main-content"></div>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const navLinks = document.querySelectorAll('.nav-links a');
                const mainContent = document.getElementById('main-content');
                const pageTitle = document.getElementById('page-title');

                async function loadContent(pageUrl) {
                    try {
                        console.log(pageUrl);
                        const response = await fetch(pageUrl);
                        if (!response.ok) {
                            throw new Error(`HTTP error! status: ${response.status}`);
                        }
                        const content = await response.text();
                        mainContent.innerHTML = content;

                        // Update page title
                        const pageName = pageUrl.split('/').pop().replace('.jsp', '');
                        pageTitle.textContent = pageName.charAt(0).toUpperCase() + pageName.slice(1);

                        // Update active link after content is loaded
                        navLinks.forEach(link => {
                            link.classList.toggle('active', link.getAttribute('data-page') === pageUrl);
                        });
                    } catch (error) {
                        mainContent.innerHTML = `
                     <div style="text-align: center; color: red; padding: 2rem;">
                         <i class="fas fa-exclamation-triangle"></i>
                         <p>Error loading content. Please try again.</p>
                         <small>${error.message}</small>
                     </div>
                 `;
                        console.error('Error:', error);
                    }
                }

                // Add click event listeners to all navigation links
                navLinks.forEach(link => {
                    link.addEventListener('click', (e) => {
                        e.preventDefault();

                        // Remove active class from all links
                        navLinks.forEach(l => l.classList.remove('active'));

                        // Add active class to clicked link
                        link.classList.add('active');

                        // Load the corresponding content
                        const pageUrl = link.getAttribute('data-page');
                        loadContent(pageUrl);
                    });
                });

                // Load initial page based on URL parameter
                const urlParams = new URLSearchParams(window.location.search);
                const param = urlParams.get('param');
                console.log(param);
                if (param) {
                    const pageUrl = `pages/${param.param}.jsp`; // Fixed from param.param to param
                    loadContent(pageUrl);
                    // Update active navigation link
                    navLinks.forEach(link => {
                        link.classList.toggle('active', link.getAttribute('data-page') === pageUrl);
                    });
                } else {
                    loadContent('pages/dashboard.jsp');
                }
            });
        </script>
    </body>
</html>
