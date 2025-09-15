<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login - TransitEase Bus Reservation</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
    
    body {
      background-color: #f5f7fa;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      padding: 2rem;
    }
    
    .login-container {
      width: 100%;
      max-width: 520px;
      background: white;
      border-radius: 12px;
      box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
      overflow: hidden;
      position: relative;
    }
    
    .form-header {
      background: linear-gradient(135deg, #1a3a8f 0%, #0f2557 100%);
      color: white;
      padding: 2rem;
      text-align: center;
      position: relative;
    }
    
    .form-header h2 {
      font-size: 1.8rem;
      font-weight: 700;
      margin-bottom: 0.5rem;
    }
    
    .form-header p {
      font-size: 0.95rem;
      opacity: 0.9;
    }
    
    .header-icon {
      font-size: 2.5rem;
      color: #ffdd59;
      margin-bottom: 1rem;
    }
    
    .header-decoration {
      position: absolute;
      right: -30px;
      top: -30px;
      width: 150px;
      height: 150px;
      border-radius: 50%;
      background: rgba(255, 221, 89, 0.1);
      z-index: 1;
    }
    
    .form-body {
      padding: 2.5rem 2rem;
    }
    
    .form-group {
      margin-bottom: 1.5rem;
      position: relative;
    }
    
    .form-label {
      display: block;
      font-size: 0.9rem;
      font-weight: 600;
      color: #333;
      margin-bottom: 0.5rem;
    }
    
    .form-input {
      width: 100%;
      padding: 0.8rem 1rem;
      border-radius: 6px;
      border: 2px solid #e1e5ee;
      font-size: 1rem;
      transition: all 0.3s ease;
      outline: none;
    }
    
    .form-input:focus {
      border-color: #1a3a8f;
      box-shadow: 0 0 0 4px rgba(26, 58, 143, 0.1);
    }
    
    .form-input.error {
      border-color: #ff3860;
    }
    
    .form-input::placeholder {
      color: #aab0bc;
    }
    
    .input-icon {
      position: absolute;
      top: 39px;
      right: 15px;
      color: #aab0bc;
    }
    
    .error-message {
      font-size: 0.8rem;
      color: #ff3860;
      margin-top: 0.4rem;
      display: none;
    }
    
    .servererror{
        font-size: 0.8rem;
      color: #ff3860;
      margin-top: 0.4rem;
    }
    
    .show-error {
      display: block;
    }
    
    .password-toggle {
      position: absolute;
      top: 39px;
      right: 15px;
      color: #aab0bc;
      cursor: pointer;
      border: none;
      background: none;
      font-size: 1rem;
    }
    
    .login-btn {
      width: 100%;
      padding: 1rem;
      border-radius: 6px;
      border: none;
      background-color: #ffdd59;
      color: #0f2557;
      font-size: 1rem;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      margin-bottom: 1.5rem;
    }
    
    .login-btn:hover, .login-btn:focus {
      background-color: #ffd32a;
      box-shadow: 0 5px 15px rgba(255, 221, 89, 0.4);
      transform: translateY(-2px);
    }
    
    .login-btn:disabled {
      background-color: #e1e5ee;
      color: #8e9cb2;
      cursor: not-allowed;
      transform: none;
      box-shadow: none;
    }
    
    .register-prompt {
      text-align: center;
      font-size: 0.9rem;
      color: #4a5568;
    }
    
    .register-link {
      color: #1a3a8f;
      text-decoration: none;
      font-weight: 600;
    }
    
    .register-link:hover {
      text-decoration: underline;
    }
    
    /* Modal styles */
    .modal {
      display: none;
      position: fixed;
      z-index: 10;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      overflow: auto;
      background-color: rgba(0, 0, 0, 0.5);
      align-items: center;
      justify-content: center;
    }
    
    .modal-content {
      background-color: white;
      margin: auto;
      padding: 2rem;
      border-radius: 12px;
      width: 90%;
      max-width: 500px;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
    }
    
    /* Success animation */
    .success-checkmark {
      width: 80px;
      height: 80px;
      margin: 0 auto;
      margin-bottom: 1rem;
    }
    
    .check-icon {
      width: 80px;
      height: 80px;
      position: relative;
      border-radius: 50%;
      box-sizing: content-box;
      border: 4px solid #4CAF50;
    }
    
    .check-icon::before {
      top: 3px;
      left: -2px;
      width: 30px;
      transform-origin: 100% 50%;
      border-radius: 100px 0 0 100px;
    }
    
    .check-icon::after {
      top: 0;
      left: 30px;
      width: 60px;
      transform-origin: 0 50%;
      border-radius: 0 100px 100px 0;
      animation: rotate-circle 4.25s ease-in;
    }
    
    .check-icon::before, .check-icon::after {
      content: '';
      height: 100px;
      position: absolute;
      background: white;
      transform: rotate(-45deg);
    }
    
    .icon-line {
      height: 5px;
      background-color: #4CAF50;
      display: block;
      border-radius: 2px;
      position: absolute;
      z-index: 10;
    }
    
    .icon-line.line-tip {
      top: 46px;
      left: 14px;
      width: 25px;
      transform: rotate(45deg);
      animation: icon-line-tip 0.75s;
    }
    
    .icon-line.line-long {
      top: 38px;
      right: 8px;
      width: 47px;
      transform: rotate(-45deg);
      animation: icon-line-long 0.75s;
    }
    
    .icon-circle {
      top: -4px;
      left: -4px;
      z-index: 10;
      width: 80px;
      height: 80px;
      border-radius: 50%;
      position: absolute;
      box-sizing: content-box;
      border: 4px solid rgba(76, 175, 80, 0.5);
    }
    
    .icon-fix {
      top: 8px;
      width: 5px;
      left: 26px;
      z-index: 1;
      height: 85px;
      position: absolute;
      transform: rotate(-45deg);
      background-color: white;
    }
    
    @keyframes rotate-circle {
      0% { transform: rotate(-45deg); }
      5% { transform: rotate(-45deg); }
      12% { transform: rotate(-405deg); }
      100% { transform: rotate(-405deg); }
    }
    
    @keyframes icon-line-tip {
      0% { width: 0; left: 1px; top: 19px; }
      54% { width: 0; left: 1px; top: 19px; }
      70% { width: 50px; left: -8px; top: 37px; }
      84% { width: 17px; left: 21px; top: 48px; }
      100% { width: 25px; left: 14px; top: 45px; }
    }
    
    @keyframes icon-line-long {
      0% { width: 0; right: 46px; top: 54px; }
      65% { width: 0; right: 46px; top: 54px; }
      84% { width: 55px; right: 0px; top: 35px; }
      100% { width: 47px; right: 8px; top: 38px; }
    }
    
    /* Confirmation modal */
    .confirmation-modal {
      text-align: center;
      padding: 2rem;
    }
    
    .confirmation-title {
      color: #1a3a8f;
      font-size: 1.8rem;
      margin-bottom: 0.5rem;
    }
    
    .confirmation-message {
      color: #4a5568;
      font-size: 1.1rem;
      margin-bottom: 2rem;
    }
    
    .dashboard-btn {
      background-color: #1a3a8f;
      color: white;
      border: none;
      padding: 0.8rem 2rem;
      border-radius: 6px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
    }
    
    .dashboard-btn:hover {
      background-color: #0f2557;
    }
    
    @media (max-width: 576px) {
      .form-header {
        padding: 1.5rem;
      }
      
      .form-body {
        padding: 1.5rem;
      }
      
      .form-header h2 {
        font-size: 1.5rem;
      }
      
      .header-icon {
        font-size: 2rem;
      }
    }
  </style>
</head>
<body>
  <div class="login-container">
    <div class="form-header">
      <div class="header-decoration"></div>
      <div class="header-icon">
        <i class="fas fa-sign-in-alt"></i>
      </div>
      <h2>Welcome Back</h2>
      <p>Login to TransitEase for seamless bus travel</p>
    </div>
    
    <div class="form-body">
        <form id="loginForm" action="Login" method="POST">
        <!-- Email Field -->
        <div class="form-group">
          <label for="email" class="form-label">Email Address</label>
          <input type="email" id="email" name="email" class="form-input" placeholder="Enter your email address" required>
          <i class="fas fa-envelope input-icon"></i>
          <div class="error-message" id="emailError">Please enter a valid email address</div>
        </div>
        
        <!-- Password Field -->
        <div class="form-group">
          <label for="password" class="form-label">Password</label>
          <input type="password" id="password" name="password" class="form-input" placeholder="Enter your password" required>
          <button type="button" class="password-toggle" id="passwordToggle">
            <i class="fas fa-eye"></i>
          </button>
          <div class="error-message" id="passwordError">Please enter your password</div>
        </div>
        
        <%
            if(request.getAttribute("UserNotFound")!=null){
            %>
            <div class="servererror">
        <%= request.getAttribute("UserNotFound")  %></div>
        <% } %>
        <!-- Submit Button -->
        <button type="submit" class="login-btn" id="loginBtn">Login</button>
        
        <!-- Register Prompt -->
        <p class="register-prompt">
            Don't have an account? <a href="registration.jsp" class="register-link">Register here</a>
        </p>
      </form>
    </div>
  </div>
  
  <!-- Login Success Modal -->
  <div id="successModal" class="modal">
    <div class="modal-content confirmation-modal">
      <div class="success-checkmark">
        <div class="check-icon">
          <span class="icon-line line-tip"></span>
          <span class="icon-line line-long"></span>
          <div class="icon-circle"></div>
          <div class="icon-fix"></div>
        </div>
      </div>
      <h2 class="confirmation-title">Login Successful!</h2>
      <p class="confirmation-message">Welcome back! You're now logged in and ready to book your bus tickets.</p>
      <button class="dashboard-btn">Go to Dashboard</button>
    </div>
  </div>
  
 <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/js/all.min.js"></script>
 <script src="js/loginJs.js"></script>
</body>
</html>