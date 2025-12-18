<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - MLibrary System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .register-container {
            max-width: 500px;
            margin: 50px auto;
            padding: 40px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        .register-header {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            color: white;
            padding: 30px;
            border-radius: 15px 15px 0 0;
            margin: -40px -40px 40px -40px;
            text-align: center;
        }
        .password-strength {
            height: 5px;
            margin-top: 5px;
            border-radius: 5px;
            transition: all 0.3s;
        }
        .strength-weak { background: #dc3545; width: 25%; }
        .strength-fair { background: #ffc107; width: 50%; }
        .strength-good { background: #28a745; width: 75%; }
        .strength-strong { background: #20c997; width: 100%; }
        .terms-box {
            max-height: 150px;
            overflow-y: auto;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            padding: 10px;
            background: #f8f9fa;
        }
    </style>
</head>
<body style="background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); min-height: 100vh;">
    <div class="register-container">
        <div class="register-header">
            <h1><i class="fas fa-user-plus me-2"></i>Create Account</h1>
            <p class="mb-0">Join MLibrary to borrow books</p>
        </div>
        
        <form action="AuthServlet" method="post" id="registerForm">
            <input type="hidden" name="action" value="register">
            
            
            <h5 class="mb-3"><i class="fas fa-user-circle me-2"></i>Personal Information</h5>
            
            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">First Name *</label>
                    <input type="text" class="form-control" name="firstName" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Last Name *</label>
                    <input type="text" class="form-control" name="lastName" required>
                </div>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Email Address *</label>
                <div class="input-group">
                    <span class="input-group-text">
                        <i class="fas fa-envelope"></i>
                    </span>
                    <input type="email" class="form-control" name="email" 
                           placeholder="your@email.com" required>
                </div>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Phone Number</label>
                <div class="input-group">
                    <span class="input-group-text">
                        <i class="fas fa-phone"></i>
                    </span>
                    <input type="tel" class="form-control" name="phone" 
                           placeholder="+1 234 567 8900">
                </div>
            </div>
            
           
            <h5 class="mb-3 mt-4"><i class="fas fa-key me-2"></i>Account Information</h5>
            
            <div class="mb-3">
                <label class="form-label">Username *</label>
                <div class="input-group">
                    <span class="input-group-text">
                        <i class="fas fa-user"></i>
                    </span>
                    <input type="text" class="form-control" name="username" 
                           id="username" placeholder="Choose username" required>
                    <button class="btn btn-outline-secondary" type="button" 
                            onclick="checkUsername()">Check</button>
                </div>
                <div class="form-text" id="usernameFeedback"></div>
            </div>
            
            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">Password *</label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-lock"></i>
                        </span>
                        <input type="password" class="form-control" name="password" 
                               id="password" placeholder="Create password" required
                               oninput="checkPasswordStrength()">
                    </div>
                    <div class="password-strength" id="passwordStrength"></div>
                    <div class="form-text" id="passwordFeedback"></div>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Confirm Password *</label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-lock"></i>
                        </span>
                        <input type="password" class="form-control" name="confirmPassword" 
                               id="confirmPassword" placeholder="Confirm password" required
                               oninput="checkPasswordMatch()">
                    </div>
                    <div class="form-text" id="confirmFeedback"></div>
                </div>
            </div>
            
            <h5 class="mb-3 mt-4"><i class="fas fa-home me-2"></i>Address (Optional)</h5>
            
            <div class="mb-3">
                <label class="form-label">Street Address</label>
                <input type="text" class="form-control" name="address">
            </div>
            
            <div class="row mb-4">
                <div class="col-md-6">
                    <label class="form-label">City</label>
                    <input type="text" class="form-control" name="city">
                </div>
                <div class="col-md-3">
                    <label class="form-label">State</label>
                    <input type="text" class="form-control" name="state">
                </div>
                <div class="col-md-3">
                    <label class="form-label">ZIP Code</label>
                    <input type="text" class="form-control" name="zipCode">
                </div>
            </div>
            
          
            <div class="mb-4">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="termsCheck" required>
                    <label class="form-check-label" for="termsCheck">
                        I agree to the 
                        <a href="#" data-bs-toggle="modal" data-bs-target="#termsModal">
                            Terms and Conditions
                        </a> *
                    </label>
                </div>
            </div>
  
            <% 
                String error = request.getParameter("error");
                String success = request.getParameter("success");
                
                if (error != null) {
                    String errorMessage = "";
                    switch(error) {
                        case "username_taken": errorMessage = "Username already exists!"; break;
                        case "email_taken": errorMessage = "Email already registered!"; break;
                        case "password_mismatch": errorMessage = "Passwords do not match!"; break;
                        default: errorMessage = "Registration failed. Please try again.";
                    }
            %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <%= errorMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } 
                if (success != null) { 
            %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>
                    Registration successful! You can now login.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
 
            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-success btn-lg" id="submitBtn">
                    <i class="fas fa-user-plus me-2"></i>Create Account
                </button>
                <a href="login.jsp" class="btn btn-outline-primary">
                    <i class="fas fa-sign-in-alt me-2"></i>Already have an account? Login
                </a>
            </div>
        </form>
    </div>

    <div class="modal fade" id="termsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Terms and Conditions</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="terms-box">
                        <h6>MLibrary Membership Agreement</h6>
                        <p><strong>1. Membership Eligibility</strong><br>
                        Membership is open to all individuals above 12 years of age.</p>
                        
                        <p><strong>2. Borrowing Privileges</strong><br>
                        Members may borrow up to 5 books at a time for 14 days.</p>
                        
                        <p><strong>3. Responsibilities</strong><br>
                        Members are responsible for all materials borrowed on their card.</p>
                        
                        <p><strong>4. Lost or Damaged Materials</strong><br>
                        Members will be charged for lost or damaged materials.</p>
                        
                        <p><strong>5. Privacy</strong><br>
                        Your personal information will be protected according to our privacy policy.</p>
                        
                        <p><strong>6. Account Security</strong><br>
                        You are responsible for maintaining the confidentiality of your account.</p>
                        
                        <p><strong>7. Changes to Terms</strong><br>
                        MLibrary reserves the right to modify these terms at any time.</p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let usernameAvailable = false;
        let passwordValid = false;
        let passwordsMatch = false;

        function checkUsername() {
            const username = document.getElementById('username').value;
            if (!username) {
                document.getElementById('usernameFeedback').innerHTML = 
                    '<span class="text-danger">Please enter a username</span>';
                return;
            }
          
            const button = event.target;
            const originalText = button.innerHTML;
            button.innerHTML = '<span class="spinner-border spinner-border-sm"></span>';
            button.disabled = true;
       
            fetch('AuthServlet?action=checkUsername&username=' + encodeURIComponent(username))
                .then(response => response.json())
                .then(data => {
                    if (data.available) {
                        document.getElementById('usernameFeedback').innerHTML = 
                            '<span class="text-success"><i class="fas fa-check me-1"></i>Username available</span>';
                        usernameAvailable = true;
                    } else {
                        document.getElementById('usernameFeedback').innerHTML = 
                            '<span class="text-danger"><i class="fas fa-times me-1"></i>Username already taken</span>';
                        usernameAvailable = false;
                    }
                    updateSubmitButton();
                })
                .catch(error => {
                    document.getElementById('usernameFeedback').innerHTML = 
                        '<span class="text-warning">Could not check username</span>';
                })
                .finally(() => {
                    button.innerHTML = originalText;
                    button.disabled = false;
                });
        }
   
        function checkPasswordStrength() {
            const password = document.getElementById('password').value;
            const strengthBar = document.getElementById('passwordStrength');
            const feedback = document.getElementById('passwordFeedback');
            
            if (password.length === 0) {
                strengthBar.className = 'password-strength';
                feedback.innerHTML = '';
                passwordValid = false;
                updateSubmitButton();
                return;
            }
            
            let strength = 0;
            let messages = [];

            if (password.length >= 8) strength++;
            else messages.push('At least 8 characters');
     
            if (/[a-z]/.test(password)) strength++;
            else messages.push('One lowercase letter');
          
            if (/[A-Z]/.test(password)) strength++;
            else messages.push('One uppercase letter');
           
            if (/[0-9]/.test(password)) strength++;
            else messages.push('One number');
  
            if (/[^A-Za-z0-9]/.test(password)) strength++;
            else messages.push('One special character');
            
            strengthBar.className = 'password-strength strength-' + 
                (strength <= 2 ? 'weak' : strength <= 3 ? 'fair' : strength <= 4 ? 'good' : 'strong');
            
            if (strength >= 4) {
                feedback.innerHTML = '<span class="text-success"><i class="fas fa-check me-1"></i>Strong password</span>';
                passwordValid = true;
            } else if (strength >= 2) {
                feedback.innerHTML = '<span class="text-warning">Medium strength. ' + messages.join(', ') + '</span>';
                passwordValid = false;
            } else {
                feedback.innerHTML = '<span class="text-danger">Weak password. ' + messages.join(', ') + '</span>';
                passwordValid = false;
            }
            
            updateSubmitButton();
        }
    
        function checkPasswordMatch() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const feedback = document.getElementById('confirmFeedback');
            
            if (confirmPassword.length === 0) {
                feedback.innerHTML = '';
                passwordsMatch = false;
                updateSubmitButton();
                return;
            }
            
            if (password === confirmPassword) {
                feedback.innerHTML = '<span class="text-success"><i class="fas fa-check me-1"></i>Passwords match</span>';
                passwordsMatch = true;
            } else {
                feedback.innerHTML = '<span class="text-danger"><i class="fas fa-times me-1"></i>Passwords do not match</span>';
                passwordsMatch = false;
            }
            
            updateSubmitButton();
        }
  
        function updateSubmitButton() {
            const submitBtn = document.getElementById('submitBtn');
            const allValid = usernameAvailable && passwordValid && passwordsMatch;
            
            submitBtn.disabled = !allValid;
            if (!allValid) {
                submitBtn.title = 'Please complete all requirements';
            } else {
                submitBtn.title = '';
            }
        }
   
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const firstName = document.getElementsByName('firstName')[0].value;
            const lastName = document.getElementsByName('lastName')[0].value;
            const email = document.getElementsByName('email')[0].value;
            
            if (!firstName || !lastName || !email) {
                e.preventDefault();
                alert('Please fill in all required fields');
                return;
            }
            
            if (!usernameAvailable) {
                e.preventDefault();
                alert('Please choose an available username');
                return;
            }
            
            if (!passwordValid) {
                e.preventDefault();
                alert('Please use a stronger password');
                return;
            }
            
            if (!passwordsMatch) {
                e.preventDefault();
                alert('Passwords do not match');
                return;
            }
          
            const btn = document.getElementById('submitBtn');
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Creating account...';
            btn.disabled = true;
        });
       
        let usernameTimeout;
        document.getElementById('username').addEventListener('input', function() {
            clearTimeout(usernameTimeout);
            usernameTimeout = setTimeout(checkUsername, 500);
        });
    </script>
</body>
</html>