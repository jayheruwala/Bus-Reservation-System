
document.addEventListener('DOMContentLoaded', function() {
    // DOM Elements
    const form = document.getElementById('loginForm');
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const passwordToggle = document.getElementById('passwordToggle');
    const emailError = document.getElementById('emailError');
    const passwordError = document.getElementById('passwordError');
    
    // Validation patterns
    const patterns = {
        email: /^([a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$/,
        password: /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$/
    };
    
    // Toggle password visibility
    passwordToggle.addEventListener('click', function() {
        const type = passwordInput.type === 'password' ? 'text' : 'password';
        passwordInput.type = type;
        this.querySelector('i').classList.toggle('fa-eye');
        this.querySelector('i').classList.toggle('fa-eye-slash');
    });
    
    // Form submission
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        
        // Reset error states
        emailInput.classList.remove('error');
        passwordInput.classList.remove('error');
        emailError.classList.remove('show-error');
        passwordError.classList.remove('show-error');
        
        // Validate inputs
        let isValid = true;
        
        if (!patterns.email.test(emailInput.value)) {
            emailInput.classList.add('error');
            emailError.textContent = 'Please enter a valid email address';
            emailError.classList.add('show-error');
            isValid = false;
        }
        
        if (!patterns.password.test(passwordInput.value)) {
            passwordInput.classList.add('error');
            passwordError.textContent = 'Password must be at least 8 characters with letters and numbers';
            passwordError.classList.add('show-error');
            isValid = false;
        }
        
        // If valid, submit to servlet
        if (isValid) {
            this.submit(); // Submits the form to the "Login" servlet specified in form action
        }
    });
});
