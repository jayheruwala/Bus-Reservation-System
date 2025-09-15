document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('editAdminForm');
    const fullNameInput = document.getElementById('full_name');
    const emailInput = document.getElementById('email');
    const mobileInput = document.getElementById('mobile_no');
    
    // Validation functions
    function validateFullName(name) {
        const nameRegex = /^[A-Za-z\s]{1,25}$/;
        return nameRegex.test(name);
    }

    function validateEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    function validateMobile(mobile) {
        const mobileRegex = /^\d{10}$/;
        return mobileRegex.test(mobile);
    }

    // Real-time validation
    fullNameInput.addEventListener('input', function() {
        if (!validateFullName(this.value)) {
            this.setCustomValidity('Full name must contain only letters and spaces, max 25 characters, no digits or special characters');
        } else {
            this.setCustomValidity('');
        }
    });

    emailInput.addEventListener('input', function() {
        if (!validateEmail(this.value)) {
            this.setCustomValidity('Please enter a valid email address');
        } else {
            this.setCustomValidity('');
        }
    });

    mobileInput.addEventListener('input', function() {
        if (!validateMobile(this.value)) {
            this.setCustomValidity('Please enter a valid 10-digit mobile number');
        } else {
            this.setCustomValidity('');
        }
    });

    // Form submission handler
    form.addEventListener('submit', function(e) {
        let isValid = true;

        // Check if all fields are filled
        const inputs = form.querySelectorAll('input[required], select[required]');
        inputs.forEach(input => {
            if (!input.value.trim()) {
                input.setCustomValidity('This field is required');
                isValid = false;
            } else {
                input.setCustomValidity('');
            }
        });

        // Validate full name
        if (!validateFullName(fullNameInput.value)) {
            fullNameInput.setCustomValidity('Full name must contain only letters and spaces, max 25 characters, no digits or special characters');
            isValid = false;
        }

        // Validate email
        if (!validateEmail(emailInput.value)) {
            emailInput.setCustomValidity('Please enter a valid email address');
            isValid = false;
        }

        // Validate mobile
        if (!validateMobile(mobileInput.value)) {
            mobileInput.setCustomValidity('Please enter a valid 10-digit mobile number');
            isValid = false;
        }

        // If invalid, trigger browser validation UI
        if (!isValid) {
            form.reportValidity();
            e.preventDefault(); // Only prevent submission if validation fails
        }
        // If valid, allow form to submit normally to servlet
    });

    // Clear validation messages on input
    form.querySelectorAll('input, select').forEach(input => {
        input.addEventListener('input', function() {
            this.setCustomValidity('');
        });
    });

    // Cancel button handler
    const cancelBtn = document.getElementById('cancelBtn');
    cancelBtn.addEventListener('click', function() {
        if (confirm('Are you sure you want to cancel? Any unsaved changes will be lost.')) {
            console.log('Canceled');
            window.location.href = 'adminList.jsp'; // Redirect to admin list
        }
    });
});