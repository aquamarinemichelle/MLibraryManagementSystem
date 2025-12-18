
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - MLibrary System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .login-container {
            max-width: 400px;
            margin: 100px auto;
            padding: 0 15px;
        }
        
        .login-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            animation: slideUp 0.5s ease-out;
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .login-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2.5rem;
            margin: 0 auto 20px;
        }
        
        .login-title {
            color: #333;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .login-subtitle {
            color: #666;
            font-size: 0.9rem;
        }
        
        .form-control {
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            padding: 12px 15px;
            font-size: 1rem;
            transition: all 0.3s;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.25);
        }
        
        .input-group-text {
            background: white;
            border: 2px solid #e0e0e0;
            border-right: none;
        }
        
        .input-group .form-control {
            border-left: none;
        }
        
        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            padding: 12px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s;
            width: 100%;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .login-links {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        .login-links a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        
        .login-links a:hover {
            text-decoration: underline;
        }
        
        .alert {
            border-radius: 10px;
            border: none;
            padding: 15px;
            margin-bottom: 20px;
        }
        
        .demo-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-top: 20px;
            border-left: 4px solid #667eea;
            font-size: 0.9rem;
        }
        
        .demo-info h6 {
            color: #333;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @media (max-width: 576px) {
            .login-container {
                margin: 50px auto;
            }
            
            .login-card {
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-card">
            <div class="login-header">
                <div class="login-icon">
                    <i class="fas fa-book-reader"></i>
                </div>
                <h2 class="login-title">Welcome Back</h2>
                <p class="login-subtitle">Sign in to access your library account</p>
            </div>
            
            <!-- Error/Success Messages -->
            <% 
                String error = request.getParameter("error");
                String success = request.getParameter("success");
                
                if (error != null) {
                    String errorMessage = "";
                    switch(error) {
                        case "invalid": errorMessage = "Invalid username or password!"; break;
                        case "empty": errorMessage = "Please enter username and password"; break;
                        case "logout": errorMessage = "You have been logged out successfully"; break;
                        default: errorMessage = "Login failed. Please try again.";
                    }
                    
                    if ("logout".equals(error)) {
            %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle me-2"></i>
                    <%= errorMessage %>
                </div>
            <% } else { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <%= errorMessage %>
                </div>
            <% } } %>
            
            <% if (success != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle me-2"></i>
                    <%= success.equals("registered") ? "Registration successful! Please login." : success %>
                </div>
            <% } %>
            
            <!-- Login Form -->
            <form action="AuthServlet" method="post">
                <input type="hidden" name="action" value="login">
                
                <div class="mb-4">
                    <label class="form-label">Username</label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-user"></i>
                        </span>
                        <input type="text" class="form-control" name="username" 
                               placeholder="Enter your username" required autofocus>
                    </div>
                </div>
                
                <div class="mb-4">
                    <label class="form-label">Password</label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-lock"></i>
                        </span>
                        <input type="password" class="form-control" name="password" 
                               placeholder="Enter your password" required>
                    </div>
                </div>
                
                <div class="mb-4">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="rememberMe">
                        <label class="form-check-label" for="rememberMe">
                            Remember me
                        </label>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-login">
                    <i class="fas fa-sign-in-alt me-2"></i>Login to Library
                </button>
            </form>
            
            <!-- Demo Info (Optional - remove if you don't want it) -->
            <div class="demo-info">
                <h6><i class="fas fa-info-circle me-2"></i>Need Access?</h6>
                <p class="mb-2">If you don't have an account, please register first.</p>
                <p class="mb-0">For any assistance, contact the library administrator.</p>
            </div>
            
            <!-- Links -->
            <div class="login-links">
                <p class="mb-2">
                    New to MLibrary? 
                    <a href="register.jsp">Create an account</a>
                </p>
                <p class="mb-0">
                    <a href="index.html">
                        <i class="fas fa-arrow-left me-1"></i>Back to Home
                    </a>
                </p>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      
        document.querySelector('form').addEventListener('submit', function(e) {
            const username = document.querySelector('input[name="username"]').value;
            const password = document.querySelector('input[name="password"]').value;
            
            if (!username || !password) {
                e.preventDefault();
                alert('Please enter both username and password.');
                return;
            }
        });
       
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    if (alert.parentNode) {
                        alert.style.opacity = '0';
                        alert.style.transition = 'opacity 0.5s';
                        setTimeout(() => {
                            if (alert.parentNode) {
                                alert.remove();
                            }
                        }, 500);
                    }
                }, 5000);
            });
        });
    </script>
</body>
</html>
