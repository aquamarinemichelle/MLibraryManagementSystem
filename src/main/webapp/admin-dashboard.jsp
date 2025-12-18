
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.BookDAO, com.library.Book, com.library.UserDAO, com.library.TransactionDAO, java.util.*" %>
<%
   
    jakarta.servlet.http.HttpSession userSession = request.getSession(false);
    String role = (userSession != null) ? (String) userSession.getAttribute("role") : null;
    String username = (userSession != null) ? (String) userSession.getAttribute("username") : null;
    
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
 
    BookDAO bookDAO = new BookDAO();
    List<Book> allBooks = bookDAO.getAllBooks();
    int totalBooks = bookDAO.getTotalBooksCount();
    int availableBooks = bookDAO.getAvailableBooksCount();
    int borrowedBooks = totalBooks - availableBooks;
    
  
    UserDAO userDAO = new UserDAO();
    int totalUsers = userDAO.getTotalUsersCount();
    
   
    TransactionDAO transactionDAO = new TransactionDAO();
    Map<String, Integer> transactionStats = transactionDAO.getTransactionStats();
    int activeBorrowings = transactionStats.getOrDefault("borrowed", 0) + transactionStats.getOrDefault("overdue", 0);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>📚 Library Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #3498db;
            --accent-color: #e74c3c;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
            min-height: 100vh;
        }
        
        .sidebar {
            background: linear-gradient(to bottom, var(--primary-color), #1a252f);
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
            border-left-color: var(--secondary-color);
        }
        
        .sidebar .nav-link i {
            width: 25px;
            text-align: center;
        }
        
        .main-content {
            margin-left: 250px;
            padding: 20px;
        }
        
        .navbar-admin {
            background: white !important;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 15px 0;
        }
        
        .stat-card {
            border-radius: 10px;
            padding: 20px;
            color: white;
            margin-bottom: 20px;
            transition: transform 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-card.books {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .stat-card.users {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        
        .stat-card.transactions {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        
        .stat-card.available {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        }
        
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
        }
        
        .card-header {
            background: white;
            border-bottom: 1px solid #eee;
            font-weight: 600;
        }
        
        .btn-action {
            padding: 5px 10px;
            margin: 2px;
            font-size: 0.85rem;
        }
        
        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
        }
        
        .table-hover tbody tr:hover {
            background-color: rgba(52, 152, 219, 0.05);
        }
        
        .search-box {
            position: relative;
        }
        
        .search-box input {
            padding-right: 40px;
        }
        
        .search-box i {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
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
        
        .quick-action-btn {
            padding: 12px 20px;
            margin: 5px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s;
            text-decoration: none;
            color: inherit;
            background: white;
            border: 1px solid #dee2e6;
        }
        
        .quick-action-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            text-decoration: none;
            color: inherit;
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
                <a class="nav-link active" href="admin-dashboard.jsp">
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
        
        <div class="sidebar-footer p-3 border-top border-secondary mt-auto">
            <small class="text-muted">
                <i class="fas fa-database me-1"></i> 
                <span>Database Connected</span>
            </small>
        </div>
    </div>


    <div class="main-content">
        
        <nav class="navbar navbar-expand-lg navbar-admin">
            <div class="container-fluid">
                <h4 class="mb-0">Admin Dashboard</h4>
                
                <div class="d-flex align-items-center">
                    <div class="search-box me-3">
                        <input type="text" class="form-control" placeholder="Search books..." 
                               onkeyup="searchBooks(this.value)">
                        <i class="fas fa-search"></i>
                    </div>
                    
                    <div class="dropdown">
                        <button class="btn btn-outline-secondary dropdown-toggle" type="button" 
                                data-bs-toggle="dropdown">
                            <i class="fas fa-user-cog me-1"></i> Admin
                        </button>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="#"><i class="fas fa-user me-2"></i>Profile</a></li>
                            <li><a class="dropdown-item" href="#"><i class="fas fa-bell me-2"></i>Notifications</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="AuthServlet?action=logout">
                                <i class="fas fa-sign-out-alt me-2"></i>Logout
                            </a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </nav>

     
        <div class="row mt-4">
            <div class="col-xl-3 col-md-6">
                <div class="stat-card books">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h2><%= totalBooks %></h2>
                            <p class="mb-0">Total Books</p>
                        </div>
                        <i class="fas fa-book fa-3x opacity-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="stat-card available">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h2><%= availableBooks %></h2>
                            <p class="mb-0">Available</p>
                        </div>
                        <i class="fas fa-check-circle fa-3x opacity-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="stat-card transactions">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h2><%= activeBorrowings %></h2>
                            <p class="mb-0">Active Borrowings</p>
                        </div>
                        <i class="fas fa-exchange-alt fa-3x opacity-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="stat-card users">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h2><%= totalUsers %></h2>
                            <p class="mb-0">Total Users</p>
                        </div>
                        <i class="fas fa-users fa-3x opacity-50"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fas fa-bolt me-2"></i>Quick Actions</h5>
                        <button class="btn btn-sm btn-outline-primary" onclick="refreshData()">
                            <i class="fas fa-sync-alt"></i> Refresh
                        </button>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3 col-6 mb-3">
                                <a href="add-book.jsp" class="btn btn-success quick-action-btn">
                                    <i class="fas fa-plus-circle fa-2x"></i>
                                    <div>
                                        <strong>Add Book</strong>
                                        <small class="d-block">Add new book to library</small>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-3 col-6 mb-3">
                                <a href="TransactionServlet" class="btn btn-primary quick-action-btn">
                                    <i class="fas fa-exchange-alt fa-2x"></i>
                                    <div>
                                        <strong>Transactions</strong>
                                        <small class="d-block">View all transactions</small>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-3 col-6 mb-3">
                                <a href="users.jsp" class="btn btn-info quick-action-btn">
                                    <i class="fas fa-users fa-2x"></i>
                                    <div>
                                        <strong>Manage Users</strong>
                                        <small class="d-block">View and manage users</small>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-3 col-6 mb-3">
                                <a href="BookServlet" class="btn btn-warning quick-action-btn">
                                    <i class="fas fa-book fa-2x"></i>
                                    <div>
                                        <strong>All Books</strong>
                                        <small class="d-block">View book catalog</small>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fas fa-list me-2"></i>Recent Books</h5>
                        <div>
                            <a href="BookServlet" class="btn btn-sm btn-outline-primary me-2">
                                <i class="fas fa-eye"></i> View All
                            </a>
                            <a href="add-book.jsp" class="btn btn-sm btn-success">
                                <i class="fas fa-plus"></i> Add New
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover" id="booksTable">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Title</th>
                                        <th>Author</th>
                                        <th>ISBN</th>
                                        <th>Category</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        int displayLimit = Math.min(allBooks.size(), 10);
                                        for (int i = 0; i < displayLimit; i++) {
                                            Book currentBook = allBooks.get(i);
                                    %>
                                    <tr>
                                        <td>#<%= currentBook.getId() %></td>
                                        <td><strong><%= currentBook.getTitle() %></strong></td>
                                        <td><%= currentBook.getAuthor() %></td>
                                        <td><code><%= currentBook.getIsbn() %></code></td>
                                        <td>
                                            <span class="badge bg-info"><%= currentBook.getCategory() %></span>
                                        </td>
                                        <td>
                                            <% if (currentBook.isAvailable()) { %>
                                                <span class="status-badge bg-success">Available</span>
                                            <% } else { %>
                                                <span class="status-badge bg-danger">Borrowed</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <div class="btn-group btn-group-sm">
                                                <a href="BookServlet?action=view&id=<%= currentBook.getId() %>" 
                                                   class="btn btn-outline-info btn-action" title="View">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <a href="BookServlet?action=edit&id=<%= currentBook.getId() %>" 
                                                   class="btn btn-outline-warning btn-action" title="Edit">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="BookServlet?action=delete&id=<%= currentBook.getId() %>" 
                                                   class="btn btn-outline-danger btn-action" 
                                                   onclick="return confirmDelete(<%= currentBook.getId() %>, '<%= currentBook.getTitle().replace("'", "\\'") %>')"
                                                   title="Delete">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-history me-2"></i>Recent Activity</h5>
                    </div>
                    <div class="card-body">
                        <div class="list-group">
                            <div class="list-group-item border-0">
                                <div class="d-flex w-100 justify-content-between">
                                    <div>
                                        <i class="fas fa-book text-success me-2"></i>
                                        <strong>Library Statistics</strong>
                                    </div>
                                    <small class="text-muted">Updated now</small>
                                </div>
                                <p class="mb-1"><%= totalBooks %> total books, <%= availableBooks %> available, <%= activeBorrowings %> active borrowings</p>
                            </div>
                            <div class="list-group-item border-0">
                                <div class="d-flex w-100 justify-content-between">
                                    <div>
                                        <i class="fas fa-users text-primary me-2"></i>
                                        <strong>User Management</strong>
                                    </div>
                                    <small class="text-muted">Updated now</small>
                                </div>
                                <p class="mb-1"><%= totalUsers %> registered users in the system</p>
                            </div>
                            <div class="list-group-item border-0">
                                <div class="d-flex w-100 justify-content-between">
                                    <div>
                                        <i class="fas fa-exchange-alt text-warning me-2"></i>
                                        <strong>Transaction Status</strong>
                                    </div>
                                    <small class="text-muted">Updated now</small>
                                </div>
                                <p class="mb-1"><%= transactionStats.getOrDefault("borrowed", 0) %> borrowed, 
                                                <%= transactionStats.getOrDefault("returned", 0) %> returned, 
                                                <%= transactionStats.getOrDefault("overdue", 0) %> overdue</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-chart-pie me-2"></i>Library Stats</h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <h6>Book Status Distribution</h6>
                            <div class="progress mb-2" style="height: 20px;">
                                <div class="progress-bar bg-success" style="width: <%= (totalBooks > 0) ? (availableBooks * 100 / totalBooks) : 0 %>%;">
                                    Available (<%= availableBooks %>)
                                </div>
                            </div>
                            <div class="progress" style="height: 20px;">
                                <div class="progress-bar bg-danger" style="width: <%= (totalBooks > 0) ? (borrowedBooks * 100 / totalBooks) : 0 %>%;">
                                    Borrowed (<%= borrowedBooks %>)
                                </div>
                            </div>
                        </div>
                        <div class="mt-3 text-center">
                            <small class="text-muted">Book availability status</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <footer class="mt-5 pt-4 border-top text-center">
            <p class="text-muted">
                <strong>Library Management System</strong> | 
                Admin: <%= username %> | 
                Total Books: <%= totalBooks %> | 
                <span id="serverTime"></span>
            </p>
        </footer>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
     
        document.addEventListener('DOMContentLoaded', function() {
         
            updateServerTime();
            setInterval(updateServerTime, 60000);
        });
        
        function searchBooks(query) {
            if (query.length > 2) {
                window.location.href = 'BookServlet?action=search&keyword=' + encodeURIComponent(query);
            }
        }
        
        function confirmDelete(bookId, bookTitle) {
            return confirm('Are you sure you want to delete "' + bookTitle + '" (ID: ' + bookId + ')?\\n\\nThis action cannot be undone.');
        }
        
        function refreshData() {
            location.reload();
        }
        
        function updateServerTime() {
            const now = new Date();
            const timeString = now.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
            const dateString = now.toLocaleDateString();
            const serverTimeElement = document.getElementById('serverTime');
            if (serverTimeElement) {
                serverTimeElement.textContent = dateString + ' ' + timeString;
            }
        }
        
        function showAlert(message, type) {
            const alertDiv = document.createElement('div');
            alertDiv.className = 'alert alert-' + type + ' alert-dismissible fade show position-fixed';
            alertDiv.style.top = '20px';
            alertDiv.style.right = '20px';
            alertDiv.style.zIndex = '9999';
            alertDiv.style.minWidth = '300px';
            
           
            const icon = type === 'success' ? 'check-circle' : 'info-circle';
            alertDiv.innerHTML = '<i class="fas fa-' + icon + ' me-2"></i>' +
                                 message +
                                 '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
            
            document.body.appendChild(alertDiv);
            
            setTimeout(() => {
                if (alertDiv.parentNode) {
                    alertDiv.remove();
                }
            }, 3000);
        }
    </script>
</body>
</html>
