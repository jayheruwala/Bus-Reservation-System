// Registration form validation and terms modal functionality
document.addEventListener('DOMContentLoaded', function() {
    // Form and input elements
    const registrationForm = document.getElementById('registrationForm');
    const nameInput = document.getElementById('name');
    const contactInput = document.getElementById('contact');
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const termsCheckbox = document.getElementById('terms');
    
    // Error message elements
    const nameError = document.getElementById('nameError');
    const contactError = document.getElementById('contactError');
    const emailError = document.getElementById('emailError');
    const passwordError = document.getElementById('passwordError');
    const confirmPasswordError = document.getElementById('confirmPasswordError');
    const termsError = document.getElementById('termsError');
    
    // Modal elements
    const termsModal = document.getElementById('termsModal');
    const termsLink = document.getElementById('termsLink');
    const closeModal = document.getElementById('closeModal');
    const acceptTerms = document.getElementById('acceptTerms');
    const successModal = document.getElementById('successModal');
    const backToLogin = document.querySelector('.back-to-login');
    
    // Password toggle buttons
    const passwordToggle = document.getElementById('passwordToggle');
    const confirmPasswordToggle = document.getElementById('confirmPasswordToggle');
    
    // Validation patterns
    const namePattern = /^[a-zA-Z\s]{2,50}$/;
    const contactPattern = /^[0-9]{10,12}$/;
    const emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
    const passwordPattern = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$/;
    
    // Hide all error messages initially
    hideAllErrors();
    
    // Form submission handler
    registrationForm.addEventListener('submit', function(e) {
        // Prevent form submission if validation fails
        if (!validateForm()) {
            e.preventDefault();
        }
    });
    
    // Input validation on blur
    nameInput.addEventListener('blur', validateName);
    contactInput.addEventListener('blur', validateContact);
    emailInput.addEventListener('blur', validateEmail);
    passwordInput.addEventListener('blur', validatePassword);
    confirmPasswordInput.addEventListener('blur', validateConfirmPassword);
    
    // Terms and conditions modal handlers
    termsLink.addEventListener('click', openTermsModal);
    closeModal.addEventListener('click', closeTermsModal);
    acceptTerms.addEventListener('click', acceptTermsAndClose);
    
    // Success modal handler
    backToLogin.addEventListener('click', function() {
        successModal.style.display = 'none';
        window.location.href = 'login.jsp'; // Replace with your login page URL
    });
    
    // Password visibility toggle
    passwordToggle.addEventListener('click', function() {
        togglePasswordVisibility(passwordInput, this);
    });
    
    confirmPasswordToggle.addEventListener('click', function() {
        togglePasswordVisibility(confirmPasswordInput, this);
    });
    
    // Close modal when clicking outside
    window.addEventListener('click', function(e) {
        if (e.target === termsModal) {
            closeTermsModal();
        }
        if (e.target === successModal) {
            successModal.style.display = 'none';
        }
    });
    
    // Validation functions
    function validateForm() {
        const isNameValid = validateName();
        const isContactValid = validateContact();
        const isEmailValid = validateEmail();
        const isPasswordValid = validatePassword();
        const isConfirmPasswordValid = validateConfirmPassword();
        const isTermsAccepted = validateTerms();
        
        return isNameValid && isContactValid && isEmailValid && 
               isPasswordValid && isConfirmPasswordValid && isTermsAccepted;
    }
    
    function validateName() {
        if (!nameInput.value.trim()) {
            showError(nameInput, nameError, 'Please enter your full name');
            return false;
        } else if (!namePattern.test(nameInput.value.trim())) {
            showError(nameInput, nameError, 'Name should contain only letters and spaces (2-50 characters)');
            return false;
        } else {
            hideError(nameInput, nameError);
            return true;
        }
    }
    
    function validateContact() {
        if (!contactInput.value.trim()) {
            showError(contactInput, contactError, 'Please enter your contact number');
            return false;
        } else if (!contactPattern.test(contactInput.value.trim())) {
            showError(contactInput, contactError, 'Contact number should contain 10-12 digits only');
            return false;
        } else {
            hideError(contactInput, contactError);
            return true;
        }
    }
    
    function validateEmail() {
        if (!emailInput.value.trim()) {
            showError(emailInput, emailError, 'Please enter your email address');
            return false;
        } else if (!emailPattern.test(emailInput.value.trim())) {
            showError(emailInput, emailError, 'Please enter a valid email address');
            return false;
        } else {
            hideError(emailInput, emailError);
            return true;
        }
    }
    
    function validatePassword() {
        if (!passwordInput.value) {
            showError(passwordInput, passwordError, 'Please enter a password');
            return false;
        } else if (!passwordPattern.test(passwordInput.value)) {
            showError(passwordInput, passwordError, 'Password must be at least 8 characters with letters and numbers');
            return false;
        } else {
            hideError(passwordInput, passwordError);
            // If confirm password is already filled, validate it again
            if (confirmPasswordInput.value) {
                validateConfirmPassword();
            }
            return true;
        }
    }
    
    function validateConfirmPassword() {
        if (!confirmPasswordInput.value) {
            showError(confirmPasswordInput, confirmPasswordError, 'Please confirm your password');
            return false;
        } else if (confirmPasswordInput.value !== passwordInput.value) {
            showError(confirmPasswordInput, confirmPasswordError, 'Passwords do not match');
            return false;
        } else {
            hideError(confirmPasswordInput, confirmPasswordError);
            return true;
        }
    }
    
    function validateTerms() {
        if (!termsCheckbox.checked) {
            termsError.style.display = 'block';
            return false;
        } else {
            termsError.style.display = 'none';
            return true;
        }
    }
    
    // Modal functions
    function openTermsModal() {
        termsModal.style.display = 'block';
    }
    
    function closeTermsModal() {
        termsModal.style.display = 'none';
    }
    
    function acceptTermsAndClose() {
        termsCheckbox.checked = true;
        termsError.style.display = 'none';
        closeTermsModal();
    }
    
    // Helper functions
    function showError(input, errorElement, message) {
        input.classList.add('error-input');
        errorElement.textContent = message;
        errorElement.style.display = 'block';
    }
    
    function hideError(input, errorElement) {
        input.classList.remove('error-input');
        errorElement.style.display = 'none';
    }
    
    function hideAllErrors() {
        const errorMessages = document.querySelectorAll('.error-message');
        errorMessages.forEach(error => {
            error.style.display = 'none';
        });
    }
    
    function togglePasswordVisibility(passwordField, toggleButton) {
        const icon = toggleButton.querySelector('i');
        
        if (passwordField.type === 'password') {
            passwordField.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            passwordField.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    }
});