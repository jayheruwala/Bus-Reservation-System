<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>TransitEase - Bus Reservation System</title>
  <link rel="stylesheet" href="css/style.css"> <!-- External CSS for maintainability -->
</head>
<style>
    /* General Reset */
body {
  margin: 0;
  padding: 0;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background-color: #f5f7fa;
  color: #333;
}

main {
  flex: 1 0 auto;
}

/* Hero Section */
.page-hero {
  background: linear-gradient(135deg, #1a3a8f 0%, #0f2557 100%);
  color: white;
  text-align: center;
  padding: 6rem 2rem;
  position: relative;
  overflow: hidden;
}

.page-hero h1 {
  font-size: 3rem;
  margin-bottom: 1.5rem;
  color: #ffdd59;
}

.page-hero p {
  font-size: 1.2rem;
  opacity: 0.9;
}

/* Info Section */
.page-info {
  padding: 5rem 2rem;
  text-align: center;
  background: white;
}

.page-info h2 {
  font-size: 2.5rem;
  color: #0f2557;
  margin-bottom: 1rem;
}

.page-info p {
  font-size: 1.1rem;
  max-width: 800px;
  margin: 0 auto 3rem;
  color: #666;
}

.page-info .info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 2rem;
  max-width: 1200px;
  margin: 0 auto;
}

.info-box {
  padding: 2rem;
  background: #f5f7fa;
  border-radius: 10px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
  text-align: left;
}

.info-box:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
}

.info-box h3 {
  font-size: 1.5rem;
  color: #1a3a8f;
  margin-bottom: 1rem;
}

/* CTA Section */
.page-cta {
  background: linear-gradient(135deg, #1a3a8f 0%, #0f2557 100%);
  color: white;
  text-align: center;
  padding: 6rem 2rem;
}

.page-cta h2 {
  font-size: 2.5rem;
  color: #ffdd59;
}

.page-cta .cta-btn {
  display: inline-block;
  background-color: #ffdd59;
  color: #0f2557;
  padding: 1rem 2rem;
  border-radius: 5px;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.3s ease;
  margin-top: 1.5rem;
}

.page-cta .cta-btn:hover {
  background-color: #ffd32a;
  transform: translateY(-3px);
}

/* Responsive Design */
@media (max-width: 768px) {
  .page-hero h1 {
    font-size: 2.5rem;
  }
  .page-info h2, .page-cta h2 {
    font-size: 2rem;
  }
}
</style>
<body>
  <!-- Include Header -->
  <%@ include file="header.jsp" %>
  
  <main>
    <section class="page-hero">
      <div class="hero-content">
        <h1>Welcome to TransitEase</h1>
        <p>Your trusted platform for bus travel solutions, offering convenience and reliability across every journey.</p>
      </div>
    </section>
    
    <section class="page-info">
      <h2>About Bus Reservations</h2>
      <p>
        Bus reservations simplify travel by allowing you to secure your seat in advance, ensuring a stress-free journey. With TransitEase, you can explore various routes, check availability, and manage your bookings with ease.
      </p>
      <div class="info-grid">
        <div class="info-box">
          <h3>What is a Bus Reservation?</h3>
          <p>A bus reservation is the process of booking a seat on a bus for a specific route and date, providing you with a guaranteed spot and peace of mind.</p>
        </div>
        <div class="info-box">
          <h3>Benefits of Booking</h3>
          <p>Advance reservations offer convenience, flexibility, and often better pricing, along with the ability to choose your preferred seat and travel time.</p>
        </div>
        <div class="info-box">
          <h3>How It Works</h3>
          <p>Simply select your destination, pick a date, and confirm your booking online. TransitEase handles the rest, ensuring a smooth travel experience.</p>
        </div>
      </div>
    </section>
    
      
    <section class="page-cta">
      <h2>Get Started Today</h2>
      <p>Experience hassle-free bus travel with TransitEase. Join us and make your next trip effortless!</p>
      <% if(user == null){ %>
      <a href="registration.jsp" class="cta-btn">Sign Up Now</a>
      <% } else {   %>
      <a href="findRoute.jsp" class="cta-btn">Search Bus</a>
      <% } %>
    </section>
  </main>
  
  <!-- Include Footer -->
  <%@ include file="footer.jsp" %>
</body>
</html>
