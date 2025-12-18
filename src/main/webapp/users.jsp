
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.UserDAO, com.library.User, java.util.*" %>
<%
 
    jakarta.servlet.http.HttpSession userSession = request.getSession(false);
    String role = (userSession != null) ? (String) userSession.getAttribute("role") : null;
    String username = (userSession != null) ? (String) userSession.getAttribute("username") : null;
    
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    UserDAO userDAO = new UserDAO();
    List<User> users = userDAO.getAllUsers();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>📚 Manage Users</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
            min-height: 100vh;
        }
        
        .sidebar {
            background: linear-gradient(to bottom, #2c3e50, #1a252f);
            color: white;
            min-height: 100vh;
            padding: 0;
            position: fixed;
            width: 250px;
            z-index: 1000;
        }
        
        .main-content {
            margin-left: 250px;
            padding: 20px;
        }
        
        .user-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px 0;
            margin-bottom: 30px;
            border-radius: 0 0 20px 20px;
        }
        
        .user-card {
            transition: transform 0.2s;
            border: 1px solid #e0e0e0;
        }
        
        .user-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        
        .user-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            font-weight: bold;
        }
        
        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                position: relative;
                min-height: auto;
            }
            
            .main-content {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h4 class="mb-0">
                <i class="fas fa-book-open me-2"></i>
                <strong>Library Admin</strong>
            </h4>
            <small class="text-muted">Management System</small>
        </div>
        
        <div class="user-profile p-3 border-bottom border-secondary">
            <div class="user-avatar">
                <%= username != null ? username.charAt(0) : "A" %>
            </div>
            <div>
                <h6 class="mb-0"><%= username %></h6>
                <small class="text-muted">Administrator</small>
            </div>
        </div>
        
        <ul class="nav flex-column mt-3">
            <li class="nav-item">
                <a class="nav-link" href="admin-dashboard.jsp">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="BookServlet">
                    <i class="fas fa-book"></i> All Books
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="add-book.jsp">
                    <i class="fas fa-plus-circle"></i> Add New Book
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="users.jsp">
                    <i class="fas fa-users"></i> Manage Users
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="TransactionServlet">
                    <i class="fas fa-exchange-alt"></i> Transactions
                </a>
            </li>
            <li class="nav-item mt-4">
                <a class="nav-link text-danger" href="AuthServlet?action=logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Header -->
        <div class="user-header">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="display-5 fw-bold mb-3">
                            <i class="fas fa-users me-2"></i>User Management
                        </h1>
                        <p class="lead mb-4">Manage all users in the library system</p>
                    </div>
                    <div class="col-md-4 text-end">
                        <a href="admin-dashboard.jsp" class="btn btn-outline-light">
                            <i class="fas fa-arrow-left me-2"></i> Back to Dashboard
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Users Grid -->
        <div class="container">
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header bg-info text-white">
                            <h5 class="mb-0">
                                <i class="fas fa-users me-2"></i>
                                All Users (<%= users.size() %>)
                            </h5>
                        </div>
                        <div class="card-body">
                            <% if (users.isEmpty()) { %>
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i>
                                No users found in the database.
                            </div>
                            <% } else { %>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Username</th>
                                            <th>Full Name</th>
                                            <th>Email</th>
                                            <th>Role</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (User user : users) { %>
                                        <tr>
                                            <td>#<%= user.getId() %></td>
                                            <td>
                                                <strong><%= user.getUsername() %></strong>
                                            </td>
                                            <td><%= user.getFullName() %></td>
                                            <td><%= user.getEmail() %></td>
                                            <td>
                                                <% if ("admin".equals(user.getRole())) { %>
                                                    <span class="badge bg-danger">
                                                        <i class="fas fa-user-shield me-1"></i> Admin
                                                    </span>
                                                <% } else { %>
                                                    <span class="badge bg-primary">
                                                        <i class="fas fa-user me-1"></i> User
                                                    </span>
                                                <% } %>
                                            </td>
                                            <td>
                                                <span class="badge bg-success">Active</span>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Statistics -->
            <div class="row">
                <div class="col-md-4">
                    <div class="card text-white bg-primary">
                        <div class="card-body text-center">
                            <h3><%= users.size() %></h3>
                            <p class="mb-0">Total Users</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <%
                        int adminCount = 0;
                        int userCount = 0;
                        for (User user : users) {
                            if ("admin".equals(user.getRole())) {
                                adminCount++;
                            } else {
                                userCount++;
                            }
                        }
                    %>
                    <div class="card text-white bg-warning">
                        <div class="card-body text-center">
                            <h3><%= adminCount %></h3>
                            <p class="mb-0">Administrators</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card text-white bg-success">
                        <div class="card-body text-center">
                            <h3><%= userCount %></h3>
                            <p class="mb-0">Regular Users</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
