
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.TransactionDAO, com.library.Transaction, java.util.*, java.text.SimpleDateFormat" %>
<%

    jakarta.servlet.http.HttpSession userSession = request.getSession(false);
    String role = (userSession != null) ? (String) userSession.getAttribute("role") : null;
    String username = (userSession != null) ? (String) userSession.getAttribute("username") : null;
    
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    TransactionDAO transactionDAO = new TransactionDAO();
    List<Transaction> transactions = transactionDAO.getAllTransactions();
    Map<String, Integer> stats = transactionDAO.getTransactionStats();
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>📚 Transaction History</title>
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
        
        .sidebar-header {
            padding: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        
        .sidebar .nav-link {
            color: rgba(255,255,255,0.8);
            padding: 12px 20px;
            border-left: 3px solid transparent;
            transition: all 0.3s;
        }
        
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            color: white;
            background: rgba(255,255,255,0.1);
            border-left-color: #3498db;
        }
        
        .main-content {
            margin-left: 250px;
            padding: 20px;
        }
        
        .stat-card {
            border-radius: 10px;
            padding: 20px;
            color: white;
            margin-bottom: 20px;
        }
        
        .user-profile {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }
        
        .transaction-table th {
            background-color: #f8f9fa;
            font-weight: 600;
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
                <a class="nav-link" href="users.jsp">
                    <i class="fas fa-users"></i> Manage Users
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="TransactionServlet">
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
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="mb-1"><i class="fas fa-exchange-alt me-2"></i>All Transactions</h2>
                <p class="text-muted mb-0">View all library borrowing history</p>
            </div>
            <div>
                <a href="admin-dashboard.jsp" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-1"></i> Back to Dashboard
                </a>
            </div>
        </div>
        
        <!-- Stats Cards -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="stat-card bg-primary">
                    <div class="card-body">
                        <h3 class="mb-0"><%= stats.getOrDefault("borrowed", 0) %></h3>
                        <p class="mb-0">Active Borrowings</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card bg-success">
                    <div class="card-body">
                        <h3 class="mb-0"><%= stats.getOrDefault("returned", 0) %></h3>
                        <p class="mb-0">Books Returned</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card bg-danger">
                    <div class="card-body">
                        <h3 class="mb-0"><%= stats.getOrDefault("overdue", 0) %></h3>
                        <p class="mb-0">Overdue Books</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card bg-info">
                    <div class="card-body">
                        <h3 class="mb-0"><%= transactions.size() %></h3>
                        <p class="mb-0">Total Transactions</p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Transactions Table -->
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Transaction History</h5>
                <div>
                    <span class="badge bg-primary me-2">Borrowed: <%= stats.getOrDefault("borrowed", 0) %></span>
                    <span class="badge bg-success me-2">Returned: <%= stats.getOrDefault("returned", 0) %></span>
                    <span class="badge bg-danger">Overdue: <%= stats.getOrDefault("overdue", 0) %></span>
                </div>
            </div>
            <div class="card-body">
                <% if (transactions.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="fas fa-exchange-alt fa-3x text-muted mb-3"></i>
                        <h5>No Transactions Yet</h5>
                        <p class="text-muted">No books have been borrowed yet.</p>
                        <a href="admin-dashboard.jsp" class="btn btn-primary">
                            <i class="fas fa-arrow-left me-1"></i> Back to Dashboard
                        </a>
                    </div>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover transaction-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>User</th>
                                    <th>Book</th>
                                    <th>Borrow Date</th>
                                    <th>Due Date</th>
                                    <th>Return Date</th>
                                    <th>Status</th>
                                    <th>Fine</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Transaction transaction : transactions) { %>
                                <tr>
                                    <td>#<%= transaction.getId() %></td>
                                    <td>
                                        <strong><%= transaction.getUserName() %></strong>
                                        <br>
                                        <small class="text-muted">User ID: <%= transaction.getUserId() %></small>
                                    </td>
                                    <td>
                                        <strong><%= transaction.getBookTitle() %></strong>
                                        <br>
                                        <small class="text-muted">Book ID: <%= transaction.getBookId() %></small>
                                    </td>
                                    <td><%= dateFormat.format(transaction.getBorrowDate()) %></td>
                                    <td>
                                        <%= dateFormat.format(transaction.getDueDate()) %>
                                        <% 
                                            // Check if overdue
                                            java.util.Date today = new java.util.Date();
                                            if (transaction.getDueDate().before(today) && 
                                                !"returned".equals(transaction.getStatus())) {
                                        %>
                                            <br>
                                            <small class="text-danger">
                                                <i class="fas fa-exclamation-triangle"></i> Overdue
                                            </small>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (transaction.getReturnDate() != null) { %>
                                            <%= dateFormat.format(transaction.getReturnDate()) %>
                                        <% } else { %>
                                            <span class="text-muted">-</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if ("borrowed".equals(transaction.getStatus())) { %>
                                            <span class="badge bg-primary">
                                                <i class="fas fa-book-reader me-1"></i> Borrowed
                                            </span>
                                        <% } else if ("returned".equals(transaction.getStatus())) { %>
                                            <span class="badge bg-success">
                                                <i class="fas fa-check-circle me-1"></i> Returned
                                            </span>
                                        <% } else { %>
                                            <span class="badge bg-danger">
                                                <i class="fas fa-exclamation-triangle me-1"></i> Overdue
                                            </span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (transaction.getFineAmount() > 0) { %>
                                            <span class="text-danger fw-bold">
                                                $<%= String.format("%.2f", transaction.getFineAmount()) %>
                                            </span>
                                        <% } else { %>
                                            <span class="text-muted">$0.00</span>
                                        <% } %>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- Summary Info -->
                    <div class="row mt-4">
                        <div class="col-md-6">
                            <div class="alert alert-info">
                                <h6><i class="fas fa-info-circle me-2"></i>Transaction Summary</h6>
                                <p class="mb-1">Total Records: <strong><%= transactions.size() %></strong></p>
                                <p class="mb-1">Active Borrowings: <strong><%= stats.getOrDefault("borrowed", 0) %></strong></p>
                                <p class="mb-1">Completed Returns: <strong><%= stats.getOrDefault("returned", 0) %></strong></p>
                                <p class="mb-0">Overdue Books: <strong><%= stats.getOrDefault("overdue", 0) %></strong></p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="alert alert-light">
                                <h6><i class="fas fa-clock me-2"></i>System Information</h6>
                                <p class="mb-1">Current Date: <strong><%= new SimpleDateFormat("MMM dd, yyyy").format(new java.util.Date()) %></strong></p>
                                <p class="mb-1">Borrowing Period: <strong>14 days</strong></p>
                                <p class="mb-0">Late Fee: <strong>$0.50 per day</strong></p>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="row mt-4">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-secondary text-white">
                        <h6 class="mb-0"><i class="fas fa-chart-bar me-2"></i>Transaction Stats</h6>
                    </div>
                    <div class="card-body">
                        <div class="row text-center">
                            <div class="col-4">
                                <h3 class="text-primary"><%= stats.getOrDefault("borrowed", 0) %></h3>
                                <small class="text-muted">Borrowed</small>
                            </div>
                            <div class="col-4">
                                <h3 class="text-success"><%= stats.getOrDefault("returned", 0) %></h3>
                                <small class="text-muted">Returned</small>
                            </div>
                            <div class="col-4">
                                <h3 class="text-danger"><%= stats.getOrDefault("overdue", 0) %></h3>
                                <small class="text-muted">Overdue</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h6 class="mb-0"><i class="fas fa-cog me-2"></i>Quick Actions</h6>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="admin-dashboard.jsp" class="btn btn-outline-primary">
                                <i class="fas fa-tachometer-alt me-1"></i> Go to Dashboard
                            </a>
                            <a href="BookServlet" class="btn btn-outline-success">
                                <i class="fas fa-book me-1"></i> View All Books
                            </a>
                            <a href="users.jsp" class="btn btn-outline-warning">
                                <i class="fas fa-users me-1"></i> Manage Users
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
