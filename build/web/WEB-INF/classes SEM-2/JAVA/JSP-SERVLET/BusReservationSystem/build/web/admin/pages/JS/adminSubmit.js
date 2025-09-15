document.getElementById('adminForm').addEventListener('submit', function(event) {
    event.preventDefault(); // Prevent form submission until validation passes

    // Clear previous error messages
    document.querySelectorAll('.error-message').forEach(el => el.textContent = '');

    // Get form values
    const fullName = document.getElementById('full_name').value.trim();
    const username = document.getElementById('username').value.trim();
    const email = document.getElementById('email').value.trim();
    const mobileNo = document.getElementById('mobile_no').value.trim();
    const password = document.getElementById('password').value;
    const role = document.getElementById('role').value;

    let isValid = true;

    // Regex patterns
    const nameRegex = /^[a-zA-Z\s]+$/; // Letters and spaces only
    const usernameRegex = /^[a-zA-Z0-9]+$/; // Letters and numbers only
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    const mobileRegex = /^[0-9]{10,}$/; // At least 10 digits
    const passwordRegex = /^[a-zA-Z0-9]{8,}$/; // Letters, numbers, at least 8 chars

    // Validate Full Name
    if (!fullName) {
        document.getElementById('full_name_error').textContent = 'Full name is required';
        isValid = false;
    } else if (!nameRegex.test(fullName)) {
        document.getElementById('full_name_error').textContent = 'Full name can only contain letters and spaces';
        isValid = false;
    }

    // Validate Username
    if (!username) {
        document.getElementById('username_error').textContent = 'Username is required';
        isValid = false;
    } else if (!usernameRegex.test(username)) {
        document.getElementById('username_error vae username_error').textContent = 'Username can only contain letters and numbers';
        isValid = false;
    }

    // Validate Email
    if (!email) {
        document.getElementById('email_error').textContent = 'Email is required';
        isValid = false;
    } else if (!emailRegex.test(email)) {
        document.getElementById('email_error').textContent = 'Please enter a valid email address';
        isValid = false;
    }

    // Validate Mobile Number
    if (!mobileNo) {
        document.getElementById('mobile_no_error').textContent = 'Mobile number is required';
        isValid = false;
    } else if (!mobileRegex.test(mobileNo)) {
        document.getElementById('mobile_no_error').textContent = 'Mobile number must be at least 10 digits';
        isValid = false;
    }

    // Validate Password
    if (!password) {
        document.getElementById('password_error').textContent = 'Password is required';
        isValid = false;
    } else if (!passwordRegex.test(password)) {
        document.getElementById('password_error').textContent = 'Password must be at least 8 characters, letters and numbers only';
        isValid = false;
    }

    // Validate Role
    if (!role) {
        document.getElementById('role_error').textContent = 'Role is required';
        isValid = false;
    }

    // If all validations pass, submit the form
    if (isValid) {
        this.submit(); // Submit to servlet
    }
});

// Clear error message on input change
document.querySelectorAll('.form-control').forEach(input => {
    input.addEventListener('input', function() {
        const errorId = this.id + '_error';
        document.getElementById(errorId).textContent = '';
    });
});