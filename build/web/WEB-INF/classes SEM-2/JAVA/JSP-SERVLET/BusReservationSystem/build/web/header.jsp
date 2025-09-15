<%-- 
    Document   : header
    Created on : 15 Mar 2025, 3:15:47 am
    Author     : jayhe
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="model.User"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Bus Reservation System</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
    
    body {
      background-color: #f5f7fa;
    }
    
    .header {
      background: linear-gradient(135deg, #1a3a8f 0%, #0f2557 100%);
      color: white;
      padding: 0.5rem 2rem;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      position: relative;
      overflow: hidden;
    }
    
    .header-container {
      display: flex;
      justify-content: space-between;
      align-items: center;
      max-width: 1200px;
      margin: 0 auto;
      position: relative;
      z-index: 2;
    }
    
    .logo {
      display: flex;
      align-items: center;
    }
    
    .logo-icon {
      font-size: 2.5rem;
      margin-right: 1rem;
      color: #ffdd59;
    }
    
    .logo-text h1 {
      font-size: 1.8rem;
      font-weight: 700;
      margin-bottom: 0.2rem;
      letter-spacing: 0.5px;
    }
    
    .logo-text p {
      font-size: 0.9rem;
      opacity: 0.9;
      letter-spacing: 0.5px;
    }
    
    .nav-menu {
      display: flex;
      list-style: none;
    }
    
    .nav-item {
      position: relative;
      margin: 0 0.5rem;
    }
    
    .nav-link {
      color: white;
      text-decoration: none;
      padding: 1.8rem 1rem;
      font-weight: 500;
      display: inline-block;
      transition: all 0.3s ease;
      position: relative;
    }
    
    .nav-link:hover {
      color: #ffdd59;
    }
    
    .nav-link.active {
      /*color: #ffdd59;*/
    }
    
/*    .nav-link.active::after {
      content: '';
      position: absolute;
      bottom: 1.2rem;
      left: 1rem;
      right: 1rem;
      height: 3px;
      background-color: #ffdd59;
      border-radius: 2px;
    }*/
    
    .header-buttons {
      display: flex;
      align-items: center;
    }
    
    .header-btn {
      padding: 0.6rem 1.2rem;
      border-radius: 4px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      font-size: 0.9rem;
      border: none;
      margin-left: 1rem;
      display: flex;
      align-items: center;
    }
    
    .header-btn.outline {
      background: transparent;
      color: white;
      border: 2px solid rgba(255, 255, 255, 0.5);
    }
    
    .header-btn.outline:hover {
      border-color: #ffdd59;
      color: #ffdd59;
    }
    
    .header-btn.primary {
      background-color: #ffdd59;
      color: #0f2557;
    }
    
    .header-btn.primary:hover {
      background-color: #ffd32a;
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }
    
    .btn-icon {
      margin-right: 0.5rem;
    }
    
    .burger-menu {
      display: none;
      font-size: 1.8rem;
      cursor: pointer;
      color: white;
    }
    
    .header-decoration {
      position: absolute;
      right: -50px;
      top: -50px;
      width: 200px;
      height: 200px;
      border-radius: 50%;
      background: rgba(255, 221, 89, 0.1);
      z-index: 1;
    }
    
    .header-decoration:nth-child(2) {
      left: 30%;
      top: -100px;
      width: 150px;
      height: 150px;
      background: rgba(255, 255, 255, 0.05);
    }
    
    @media (max-width: 992px) {
      .nav-menu {
        display: none;
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        background: #0f2557;
        flex-direction: column;
        padding: 1rem 0;
        box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
        z-index: 10;
      }
      
      .nav-menu.active {
        display: flex;
      }
      
      .nav-item {
        margin: 0;
      }
      
      .nav-link {
        padding: 1rem 2rem;
        width: 100%;
        display: block;
      }
      
      .nav-link.active::after {
        bottom: 0.8rem;
      }
      
      .burger-menu {
        display: block;
      }
      
      .header-buttons {
        margin-right: 1rem;
      }
      
      .header-btn.outline {
        display: none;
      }
    }
    
    @media (max-width: 576px) {
      .logo-text h1 {
        font-size: 1.5rem;
      }
      
      .logo-text p {
        display: none;
      }
      
      .header-btn {
        padding: 0.5rem 1rem;
        font-size: 0.8rem;
      }
    }
    
    .user-info {
  color: white;
  font-weight: 500;
  margin-right: 1rem;
  display: flex;
  align-items: center;
}

.user-icon {
  margin-right: 0.5rem;
}
  </style>
</head>
<body>
  <header class="header">
    <div class="header-decoration"></div>
    <div class="header-decoration"></div>
    
    <div class="header-container">
      <div class="logo">
        <div class="logo-icon">
          <i class="fas fa-bus"></i>
        </div>
        <div class="logo-text">
          <h1>TransitEase</h1>
          <p>Bus Reservation System</p>
        </div>
      </div>
      
      <nav>
        <ul class="nav-menu" id="navMenu">
          <li class="nav-item">
            <a href="index.jsp" class="nav-link active">Home</a>
          </li>
          <li class="nav-item">
            <a href="#" class="nav-link">Search</a>
          </li>
          <li class="nav-item">
              <a href="findRoute.jsp" class="nav-link">Routes</a>
          </li>
          <li class="nav-item">
            <a href="#" class="nav-link">My Bookings</a>
          </li>
          <li class="nav-item">
            <a href="#" class="nav-link">Support</a>
          </li>
        </ul>
      </nav>
        
        
      
     <div class="header-buttons">
        <% 
          // Check if user is logged in
          HttpSession sess = request.getSession(false);
          User user = (sess != null) ? (User) sess.getAttribute("user") : null;
          
          if (user != null) {
            // User is logged in - show username and logout button
        %>
          <span class="user-info">
            <span class="user-icon"><i class="fas fa-user"></i></span>
            Welcome, <%= user.getName() %>
          </span>
          <a class="header-btn primary" href="Logout" onclick="return confirm('Are you sure you want to logout?');">
            <span class="btn-icon"><i class="fas fa-sign-out-alt"></i></span>
            Logout
          </a>
        <% 
          } else {
            // User is not logged in - show login and signup buttons
        %>
          <a class="header-btn outline" href="login.jsp">
            <span class="btn-icon"><i class="fas fa-sign-in-alt"></i></span>
            Login
          </a>
          <a class="header-btn primary" href="registration.jsp">
            <span class="btn-icon"><i class="fas fa-user-plus"></i></span>
            Sign Up
          </a>
        <% 
          }
        %>
        <div class="burger-menu" id="burgerMenu">
          <i class="fas fa-bars"></i>
        </div>
      </div>
    </div>
  </header>
  
  <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/js/all.min.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      const burgerMenu = document.getElementById('burgerMenu');
      const navMenu = document.getElementById('navMenu');
      
      burgerMenu.addEventListener('click', function() {
        navMenu.classList.toggle('active');
      });
      
      // Add animation effects for header elements
      const headerElements = document.querySelectorAll('.logo, .nav-menu, .header-buttons');
      
      headerElements.forEach(element => {
        element.style.opacity = '0';
        element.style.transform = 'translateY(-20px)';
        element.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
      });
      
      setTimeout(() => {
        headerElements.forEach((element, index) => {
          setTimeout(() => {
            element.style.opacity = '1';
            element.style.transform = 'translateY(0)';
          }, index * 200);
        });
      }, 300);
      
      // Hover effect for nav links
      const navLinks = document.querySelectorAll('.nav-link');
      
      navLinks.forEach(link => {
        link.addEventListener('mouseenter', function() {
          if (!this.classList.contains('active')) {
            this.style.transform = 'translateY(-2px)';
          }
        });
        
        link.addEventListener('mouseleave', function() {
          if (!this.classList.contains('active')) {
            this.style.transform = 'translateY(0)';
          }
        });
      });
    });
  </script>
</body>
</html>
