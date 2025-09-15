<%--
    Document   : index
    Created on : 15 Mar 2025, 3:00:00 pm
    Author     : jayhe (adapted for xAI Grok)
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%@page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>TransitEase - Bus Reservation System</title>
   <style>
 
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

html, body {
  height: 100%;
  margin: 0;
  scroll-behavior: smooth;
}

body {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #f5f7fa;
  color: #333;
  line-height: 1.6;
}

main {
  flex: 1 0 auto;
}

a {
  text-decoration: none;
  color: inherit;
}

.container {
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

/* Header Styles - Fixed and Animated */
header {
  background-color: rgba(15, 37, 87, 0.95);
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  transition: all 0.3s ease;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

header.scrolled {
  padding: 0.5rem 0;
  background-color: rgba(15, 37, 87, 0.98);
}

.header-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 2rem;
}

.logo {
  display: flex;
  align-items: center;
  color: #ffdd59;
  font-size: 1.5rem;
  font-weight: 700;
  text-decoration: none;
}

.logo i {
  margin-right: 0.5rem;
  font-size: 1.8rem;
}

nav ul {
  display: flex;
  list-style: none;
}

nav ul li {
  margin-left: 1.5rem;
}

nav ul li a {
  color: white;
  text-decoration: none;
  font-weight: 500;
  transition: color 0.3s ease;
  position: relative;
  padding-bottom: 0.5rem;
}

nav ul li a:hover {
  color: #ffdd59;
}

nav ul li a::after {
  content: '';
  position: absolute;
  width: 0;
  height: 2px;
  bottom: 0;
  left: 0;
  background-color: #ffdd59;
  transition: width 0.3s ease;
}

nav ul li a:hover::after {
  width: 100%;
}

.hamburger {
  display: none;
  cursor: pointer;
  color: white;
  font-size: 1.5rem;
}

/* Enhanced Hero Section */
.hero {
  background: linear-gradient(135deg, #1a3a8f 0%, #0f2557 100%);
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  text-align: center;
  color: white;
  margin-top: 0;
  overflow: hidden;
}

.hero::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image: url('https://source.unsplash.com/random/1600x900/?bus,travel');
  background-size: cover;
  background-position: center;
  opacity: 0.15;
  z-index: 0;
}

.hero-content {
  max-width: 800px;
  padding: 0 2rem;
  position: relative;
  z-index: 1;
  animation: fadeIn 1s ease-out;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

.hero-content h1 {
  font-size: 3.5rem;
  font-weight: 700;
  margin-bottom: 1.5rem;
  color: #ffdd59;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.hero-content p {
  font-size: 1.3rem;
  margin-bottom: 2rem;
  opacity: 0.9;
  line-height: 1.8;
}

.hero-btn {
  display: inline-block;
  background-color: #ffdd59;
  color: #0f2557;
  padding: 1rem 2rem;
  border: none;
  border-radius: 4px;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  text-decoration: none;
  margin-top: 1rem;
}

.hero-btn:hover {
  background-color: #ffd32a;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.hero-decoration {
  position: absolute;
  right: -100px;
  top: -100px;
  width: 300px;
  height: 300px;
  border-radius: 50%;
  background: rgba(255, 221, 89, 0.1);
  z-index: 0;
  animation: float 8s ease-in-out infinite;
}

.hero-decoration:nth-child(2) {
  left: -100px;
  bottom: -100px;
  top: auto;
  right: auto;
  width: 250px;
  height: 250px;
  animation-delay: 2s;
}

@keyframes float {
  0% { transform: translateY(0) rotate(0deg); }
  50% { transform: translateY(-20px) rotate(5deg); }
  100% { transform: translateY(0) rotate(0deg); }
}

/* Quick Search Box */
.search-box {
  background-color: white;
  padding: 2rem;
  border-radius: 10px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  margin-top: -5rem;
  position: relative;
  z-index: 2;
  max-width: 900px;
  margin-left: auto;
  margin-right: auto;
  transform: translateY(20px);
  opacity: 0;
  animation: slideUp 0.8s ease-out forwards;
  animation-delay: 0.5s;
}

@keyframes slideUp {
  to { transform: translateY(0); opacity: 1; }
}

.search-form {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
}

.form-group {
  display: flex;
  flex-direction: column;
}

.form-group label {
  margin-bottom: 0.5rem;
  font-weight: 500;
  color: #0f2557;
}

.form-control {
  padding: 0.8rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 1rem;
  transition: border-color 0.3s ease, box-shadow 0.3s ease;
}

.form-control:focus {
  outline: none;
  border-color: #1a3a8f;
  box-shadow: 0 0 0 3px rgba(26, 58, 143, 0.1);
}

.search-btn {
  background-color: #1a3a8f;
  color: white;
  border: none;
  padding: 0.8rem;
  border-radius: 4px;
  cursor: pointer;
  font-weight: 600;
  transition: background-color 0.3s ease, transform 0.3s ease;
  margin-top: 1.5rem;
}

.search-btn:hover {
  background-color: #0f2557;
  transform: translateY(-2px);
}

/* Improved Info Section */
.info {
  padding: 8rem 2rem 4rem;
  text-align: center;
  background-color: #fff;
}

.info h2 {
  font-size: 2.5rem;
  margin-bottom: 1.5rem;
  color: #0f2557;
  position: relative;
  display: inline-block;
}

.info h2::after {
  content: '';
  position: absolute;
  bottom: -10px;
  left: 50%;
  transform: translateX(-50%);
  width: 80px;
  height: 4px;
  background-color: #ffdd59;
  border-radius: 2px;
}

.info p {
  font-size: 1.1rem;
  max-width: 900px;
  margin: 0 auto 3rem;
  color: #666;
  line-height: 1.8;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 2rem;
  max-width: 1200px;
  margin: 0 auto;
}

.info-card {
  padding: 2.5rem 2rem;
  background: #f5f7fa;
  border-radius: 10px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
  text-align: left;
  display: flex;
  flex-direction: column;
  border-top: 4px solid transparent;
}

.info-card:hover {
  transform: translateY(-10px);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  border-top-color: #1a3a8f;
}

.info-card-icon {
  background-color: rgba(26, 58, 143, 0.1);
  color: #1a3a8f;
  width: 60px;
  height: 60px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 1.5rem;
  font-size: 1.5rem;
  transition: all 0.3s ease;
}

.info-card:hover .info-card-icon {
  background-color: #1a3a8f;
  color: white;
}

.info-card h3 {
  font-size: 1.5rem;
  margin-bottom: 1rem;
  color: #1a3a8f;
}

.info-card p {
  font-size: 1rem;
  color: #666;
  margin: 0;
  margin-bottom: 1.5rem;
  flex-grow: 1;
}

.info-card a {
  color: #1a3a8f;
  text-decoration: none;
  font-weight: 600;
  display: inline-flex;
  align-items: center;
}

.info-card a i {
  margin-left: 0.5rem;
  transition: transform 0.3s ease;
}

.info-card a:hover i {
  transform: translateX(5px);
}

/* CTA Section with Gradient Overlay */
.cta {
  background: linear-gradient(135deg, #1a3a8f 0%, #0f2557 100%);
  color: white;
  padding: 6rem 2rem;
  text-align: center;
  position: relative;
  overflow: hidden;
}

.cta::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url('https://source.unsplash.com/random/1600x900/?bus,station');
  background-size: cover;
  background-position: center;
  opacity: 0.1;
  z-index: 0;
}

.cta-container {
  position: relative;
  z-index: 1;
  max-width: 800px;
  margin: 0 auto;
}

.cta h2 {
  font-size: 3rem;
  margin-bottom: 1.5rem;
  color: #ffdd59;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.cta p {
  font-size: 1.2rem;
  margin-bottom: 2.5rem;
  opacity: 0.9;
  line-height: 1.8;
}

.cta-btn {
  background-color: #ffdd59;
  color: #0f2557;
  padding: 1.2rem 2.5rem;
  border: none;
  border-radius: 4px;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  display: inline-block;
  text-decoration: none;
  position: relative;
  overflow: hidden;
}

.cta-btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(255, 255, 255, 0.1);
  transform: translateX(-100%);
  transition: transform 0.3s ease;
}

.cta-btn:hover {
  background-color: #ffd32a;
  transform: translateY(-3px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

.cta-btn:hover::before {
  transform: translateX(0);
}

/* Testimonials Section */
.testimonials {
  padding: 5rem 2rem;
  background-color: #f5f7fa;
  text-align: center;
}

.testimonial-header h2 {
  font-size: 2.5rem;
  color: #0f2557;
  margin-bottom: 1rem;
  position: relative;
  display: inline-block;
}

.testimonial-header h2::after {
  content: '';
  position: absolute;
  bottom: -10px;
  left: 50%;
  transform: translateX(-50%);
  width: 80px;
  height: 4px;
  background-color: #ffdd59;
  border-radius: 2px;
}

.testimonial-container {
  display: flex;
  justify-content: center;
  align-items: stretch;
  flex-wrap: wrap;
  max-width: 1200px;
  margin: 3rem auto 0;
  gap: 2rem;
}

.testimonial-card {
  background-color: white;
  padding: 2rem;
  border-radius: 10px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  flex: 1;
  min-width: 300px;
  max-width: 400px;
  text-align: left;
  position: relative;
  transition: all 0.3s ease;
}

.testimonial-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
}

.testimonial-card::before {
  content: '\201C';
  position: absolute;
  top: 20px;
  left: 20px;
  font-size: 5rem;
  color: rgba(26, 58, 143, 0.1);
  font-family: Georgia, serif;
  line-height: 1;
}

.testimonial-text {
  font-style: italic;
  margin-bottom: 1.5rem;
  color: #555;
  line-height: 1.7;
}

.testimonial-author {
  display: flex;
  align-items: center;
  margin-top: 1rem;
}

.testimonial-author-img {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  overflow: hidden;
  margin-right: 1rem;
  border: 2px solid #ffdd59;
}

.testimonial-author-info h4 {
  font-size: 1.1rem;
  margin-bottom: 0.2rem;
  color: #1a3a8f;
}

.testimonial-author-info p {
  font-size: 0.9rem;
  color: #777;
  margin: 0;
}

/* Footer Section */
footer {
  background-color: #0f2557;
  color: white;
  padding: 4rem 2rem 2rem;
}

.footer-container {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 2rem;
  max-width: 1200px;
  margin: 0 auto;
}

.footer-column h3 {
  font-size: 1.3rem;
  margin-bottom: 1.5rem;
  color: #ffdd59;
  position: relative;
  padding-bottom: 0.8rem;
}

.footer-column h3::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 40px;
  height: 3px;
  background-color: #ffdd59;
}

.footer-column ul {
  list-style: none;
}

.footer-column ul li {
  margin-bottom: 0.8rem;
}

.footer-column ul li a {
  color: rgba(255, 255, 255, 0.8);
  transition: all 0.3s ease;
  display: inline-block;
}

.footer-column ul li a:hover {
  color: #ffdd59;
  transform: translateX(5px);
}

.footer-column p {
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 1rem;
  line-height: 1.6;
}

.social-icons {
  display: flex;
  gap: 1rem;
  margin-top: 1.5rem;
}

.social-icons a {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background-color: rgba(255, 255, 255, 0.1);
  color: white;
  transition: all 0.3s ease;
}

.social-icons a:hover {
  background-color: #ffdd59;
  color: #0f2557;
  transform: translateY(-3px);
}

.footer-bottom {
  text-align: center;
  padding-top: 2rem;
  margin-top: 2rem;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.6);
  font-size: 0.9rem;
}

/* Mobile Menu Styles */
@media (max-width: 768px) {
  .hamburger {
    display: block;
  }
  
  nav ul {
    display: none;
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    flex-direction: column;
    background-color: #0f2557;
    padding: 1rem 0;
    box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
  }
  
  nav ul.show {
    display: flex;
  }
  
  nav ul li {
    margin: 0;
    width: 100%;
    text-align: center;
  }
  
  nav ul li a {
    display: block;
    padding: 0.8rem 1rem;
  }
  
  nav ul li a::after {
    display: none;
  }
  
  .hero-content h1 {
    font-size: 2.5rem;
  }
  
  .hero-content p {
    font-size: 1.1rem;
  }
  
  .info h2, .cta h2 {
    font-size: 2rem;
  }
  
  .cta-btn {
    padding: 1rem 2rem;
  }
  
  .feature-item, .feature-item:nth-child(even) {
    flex-direction: column;
  }
  
  .feature-image, .feature-content {
    padding: 1rem;
  }
}

/* Scrollbar Styling */
::-webkit-scrollbar {
  width: 10px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
}

::-webkit-scrollbar-thumb {
  background: #1a3a8f;
  border-radius: 5px;
}

::-webkit-scrollbar-thumb:hover {
  background: #0f2557;
}

/* Animations for Page Elements */
.animate-on-scroll {
  opacity: 0;
  transform: translateY(30px);
  transition: opacity 0.6s ease, transform 0.6s ease;
}

.animate-on-scroll.visible {
  opacity: 1;
  transform: translateY(0);
}

/* Utilities */
.text-center {
  text-align: center;
}

.mb-2 {
  margin-bottom: 2rem;
}

.mt-2 {
  margin-top: 2rem;
}
 </style>
</head>
<body>
  <main>
    <!-- Header -->
    <%@ include file="header.jsp" %>

    <!-- Hero Section -->
    <section class="hero">
      <div class="hero-decoration"></div>
      <div class="hero-content">
        <h1>Welcome to TransitEase</h1>
        <p>Your trusted platform for bus travel solutions, offering convenience and reliability across every journey.</p>
      </div>
    </section>

    <!-- Info Section -->
    <section class="info">
      <h2>About Bus Reservations</h2>
      <p>
        Bus reservations simplify travel by allowing you to secure your seat in advance, ensuring a stress-free journey. With TransitEase, you can explore various routes, check availability, and manage your bookings with ease.
      </p>
      <div class="info-grid">
        <div class="info-card">
          <h3>What is a Bus Reservation?</h3>
          <p>A bus reservation is the process of booking a seat on a bus for a specific route and date, providing you with a guaranteed spot and peace of mind.</p>
        </div>
        <div class="info-card">
          <h3>Benefits of Booking</h3>
          <p>Advance reservations offer convenience, flexibility, and often better pricing, along with the ability to choose your preferred seat and travel time.</p>
        </div>
        <div class="info-card">
          <h3>How It Works</h3>
          <p>Simply select your destination, pick a date, and confirm your booking online. TransitEase handles the rest, ensuring a smooth travel experience.</p>
        </div>
      </div>
    </section>

    <!-- Call to Action Section -->
    <section class="cta">
      <h2>Get Started Today</h2>
      <p>Experience hassle-free bus travel with TransitEase. Join us and make your next trip effortless!</p>
      <% 
        
           user = (sess != null) ? (User) sess.getAttribute("user") : null;
        if (user == null) {
      %>
        <a href="registration.jsp" class="cta-btn">Sign Up Now</a>
      <% } else { %>
        <a href="#" class="cta-btn">Go to Dashboard</a>
      <% } %>
    </section>
  </main>

  <!-- Footer -->
  <%@ include file="footer.jsp" %>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/js/all.min.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      // Animate elements on scroll
      const elements = document.querySelectorAll('.hero-content, .info-card, .cta');
      const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
          }
        });
      }, { threshold: 0.2 });

      elements.forEach(element => {
        element.style.opacity = '0';
        element.style.transform = 'translateY(20px)';
        element.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
        observer.observe(element);
      });
    });
  </script>
</body>
</html>