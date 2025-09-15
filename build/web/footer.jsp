<%--
    Document   : footer
    Created on : 15 Mar 2025, 10:00:00 am
    Author     : jayhe 
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Bus Reservation System - Footer</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .footer {
      background: linear-gradient(135deg, #1a3a8f 0%, #0f2557 100%);
      color: white;
      padding: 3rem 2rem;
      position: relative;
      overflow: hidden;
      box-shadow: 0 -4px 12px rgba(0, 0, 0, 0.1);
    }

    .footer-container {
      max-width: 1200px;
      margin: 0 auto;
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 2rem;
      position: relative;
      z-index: 2;
    }

    .footer-section h3 {
      font-size: 1.2rem;
      font-weight: 600;
      margin-bottom: 1rem;
      color: #ffdd59;
    }

    .footer-section ul {
      list-style: none;
    }

    .footer-section ul li {
      margin-bottom: 0.8rem;
    }

    .footer-link {
      color: rgba(255, 255, 255, 0.9);
      text-decoration: none;
      transition: all 0.3s ease;
    }

    .footer-link:hover {
      color: #ffdd59;
      padding-left: 5px;
    }

    .footer-contact p {
      margin-bottom: 0.8rem;
      display: flex;
      align-items: center;
    }

    .footer-contact i {
      margin-right: 0.8rem;
      color: #ffdd59;
    }

    .social-icons {
      display: flex;
      gap: 1rem;
      margin-top: 1rem;
    }

    .social-icon {
      color: white;
      font-size: 1.5rem;
      transition: all 0.3s ease;
    }

    .social-icon:hover {
      color: #ffdd59;
      transform: translateY(-3px);
    }

    .footer-bottom {
      border-top: 1px solid rgba(255, 255, 255, 0.2);
      padding-top: 1.5rem;
      margin-top: 2rem;
      text-align: center;
      font-size: 0.9rem;
      opacity: 0.9;
    }

    .footer-decoration {
      position: absolute;
      left: -50px;
      bottom: -50px;
      width: 200px;
      height: 200px;
      border-radius: 50%;
      background: rgba(255, 221, 89, 0.1);
      z-index: 1;
    }

    .footer-decoration:nth-child(2) {
      right: 30%;
      bottom: -100px;
      width: 150px;
      height: 150px;
      background: rgba(255, 255, 255, 0.05);
    }

    @media (max-width: 768px) {
      .footer-container {
        grid-template-columns: 1fr;
        text-align: center;
      }

      .social-icons {
        justify-content: center;
      }

      .footer-section ul li {
        margin-bottom: 0.6rem;
      }
    }

    @media (max-width: 576px) {
      .footer {
        padding: 2rem 1rem;
      }

      .footer-section h3 {
        font-size: 1.1rem;
      }

      .social-icon {
        font-size: 1.3rem;
      }
    }
  </style>
</head>
<body>
  <footer class="footer">
    <div class="footer-decoration"></div>
    <div class="footer-decoration"></div>

    <div class="footer-container">
      <div class="footer-section">
        <h3>About TransitEase</h3>
        <p>
          TransitEase is your reliable partner for hassle-free bus travel. Book tickets, explore routes, and enjoy a seamless journey with us.
        </p>
      </div>

      <div class="footer-section">
        <h3>Quick Links</h3>
        <ul>
          <li><a href="#" class="footer-link">Home</a></li>
          <li><a href="#" class="footer-link">Search Buses</a></li>
          <li><a href="#" class="footer-link">Routes</a></li>
          <li><a href="#" class="footer-link">My Bookings</a></li>
          <li><a href="#" class="footer-link">Support</a></li>
        </ul>
      </div>

      <div class="footer-section">
        <h3>Contact Us</h3>
        <div class="footer-contact">
          <p><i class="fas fa-phone"></i> +1 800 123 4567</p>
          <p><i class="fas fa-envelope"></i> support@transitease.com</p>
          <p><i class="fas fa-map-marker-alt"></i> 123 Travel St, City, Country</p>
        </div>
        <div class="social-icons">
          <a href="#" class="social-icon"><i class="fab fa-facebook-f"></i></a>
          <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
          <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
          <a href="#" class="social-icon"><i class="fab fa-linkedin-in"></i></a>
        </div>
      </div>
    </div>

    <div class="footer-bottom">
      <p>&copy; <%= new java.util.Date().getYear() + 1900 %> TransitEase. All Rights Reserved.</p>
    </div>
  </footer>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/js/all.min.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      // Animation for footer elements
      const footerElements = document.querySelectorAll('.footer-section, .footer-bottom');
      
      footerElements.forEach(element => {
        element.style.opacity = '0';
        element.style.transform = 'translateY(20px)';
        element.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
      });

      setTimeout(() => {
        footerElements.forEach((element, index) => {
          setTimeout(() => {
            element.style.opacity = '1';
            element.style.transform = 'translateY(0)';
          }, index * 200);
        });
      }, 300);
    });
  </script>
</body>
</html>