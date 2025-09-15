document.addEventListener('DOMContentLoaded', function() {
      const loginForm = document.getElementById('loginForm');
      const emailInput = document.getElementById('email');
      const passwordInput = document.getElementById('password');
      const emailError = document.getElementById('emailError');
      const passwordError = document.getElementById('passwordError');
      const passwordToggle = document.getElementById('passwordToggle');
      
      passwordToggle.addEventListener('click', function() {
        const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordInput.setAttribute('type', type);
        const icon = this.querySelector('i');
        icon.classList.toggle('fa-eye');
        icon.classList.toggle('fa-eye-slash');
      });
      
      function validateEmail(email) {
        const re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(String(email).toLowerCase());
      }
      
      loginForm.addEventListener('submit', function(e) {
        let isValid = true;
        
        if (!validateEmail(emailInput.value)) {
          emailInput.classList.add('error');
          emailError.classList.add('show-error');
          isValid = false;
        } else {
          emailInput.classList.remove('error');
          emailError.classList.remove('show-error');
        }
        
        if (passwordInput.value.length < 1) {
          passwordInput.classList.add('error');
          passwordError.classList.add('show-error');
          isValid = false;
        } else {
          passwordInput.classList.remove('error');
          passwordError.classList.remove('show-error');
        }
        
        if (!isValid) {
          e.preventDefault();
        }
      });
      
      emailInput.addEventListener('input', function() {
        if (validateEmail(this.value)) {
          this.classList.remove('error');
          emailError.classList.remove('show-error');
        }
      });
      
      passwordInput.addEventListener('input', function() {
        if (this.value.length > 0) {
          this.classList.remove('error');
          passwordError.classList.remove('show-error');
        }
      });
    });