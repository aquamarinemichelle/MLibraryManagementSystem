
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.BookDAO, com.library.TransactionDAO, com.library.UserDAO, com.library.User, java.util.*" %>
<%
   
    jakarta.servlet.http.HttpSession userSession = request.getSession(false);
    String username = (userSession != null) ? (String) userSession.getAttribute("username") : null;
    String role = (userSession != null) ? (String) userSession.getAttribute("role") : null;
    
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
   
    BookDAO bookDAO = new BookDAO();
    int totalBooks = bookDAO.getTotalBooksCount();
    int availableBooks = bookDAO.getAvailableBooksCount();
    int borrowedBooks = totalBooks - availableBooks;
    
    
    int userBorrowedCount = 0;
    UserDAO userDAO = new UserDAO();
    TransactionDAO transactionDAO = new TransactionDAO();
    User user = userDAO.getUserByUsername(username);
    
    if (user != null) {
        List<com.library.Transaction> transactions = transactionDAO.getTransactionsByUserId(user.getId());
        for (com.library.Transaction t : transactions) {
            if ("borrowed".equals(t.getStatus()) || "overdue".equals(t.getStatus())) {
                userBorrowedCount++;
            }
        }
    }
    
    int userReservedCount = 0; 
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>📚 User Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .user-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 0;
            margin-bottom: 30px;
            border-radius: 0 0 20px 20px;
        }
        
        .navbar-user {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .dashboard-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            transition: transform 0.3s;
            height: 100%;
        }
        
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-card {
            padding: 25px;
            border-radius: 15px;
            color: white;
            text-align: center;
            margin-bottom: 20px;
        }
        
        .stat-card.books {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .stat-card.borrowed {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        }
        
        .stat-card.reserved {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
        }
        
        .stat-card.history {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        
        .feature-card {
            padding: 25px;
            border-radius: 15px;
            background: white;
            text-align: center;
            height: 100%;
            transition: all 0.3s;
        }
        
        .feature-card:hover {
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        
        .feature-icon {
            font-size: 3rem;
            margin-bottom: 15px;
            display: inline-block;
            padding: 20px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .quick-links {
            list-style: none;
            padding: 0;
        }
        
        .quick-links li {
            padding: 10px 15px;
            margin-bottom: 8px;
            background: white;
            border-radius: 10px;
            transition: all 0.3s;
        }
        
        .quick-links li:hover {
            background: #f8f9fa;
            transform: translateX(5px);
        }
        
        .recent-activity {
            max-height: 300px;
            overflow-y: auto;
        }
        
        .activity-item {
            padding: 12px 15px;
            border-left: 3px solid #667eea;
            margin-bottom: 10px;
            background: white;
            border-radius: 0 10px 10px 0;
        }
        
        .welcome-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    
    <nav class="navbar navbar-expand-lg navbar-user">
        <div class="container">
            <a class="navbar-brand text-white" href="user-dashboard.jsp">
                <i class="fas fa-book-reader me-2"></i>
                <strong>Library Portal</strong>
            </a>
            
            <div class="navbar-nav ms-auto align-items-center">
                <span class="text-white me-3">
                    <i class="fas fa-user me-1"></i> Welcome, <%= username %>
                </span>
                <a class="nav-link text-white" href="books-user.jsp">
                    <i class="fas fa-book me-1"></i> Browse Books
                </a>
                <a class="nav-link text-white" href="my-transactions.jsp">
                    <i class="fas fa-bookmark me-1"></i> My Books
                </a>
                <a class="nav-link text-white" href="AuthServlet?action=logout">
                    <i class="fas fa-sign-out-alt me-1"></i> Logout
                </a>
            </div>
        </div>
    </nav>

    
    <div class="user-header">
        <div class="container text-center">
            <h1 class="display-5 fw-bold mb-3">
                <i class="fas fa-home me-2"></i>User Dashboard
            </h1>
            <p class="lead mb-4">Welcome back to your library account</p>
        </div>
    </div>

    
    <div class="container">
      
        <div class="welcome-section">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h3 class="mb-3">Hello, <%= username %>! 👋</h3>
                    <p class="text-muted mb-0">
                        Welcome to your library dashboard. Browse our collection of <%= totalBooks %> books, 
                        manage your borrowings, and discover new titles to read.
                    </p>
                </div>
                <div class="col-md-4 text-end">
                    <span class="badge bg-success fs-6">
                        <i class="fas fa-user-check me-1"></i> Member
                    </span>
                    <span class="badge bg-info fs-6 ms-2">
                        <i class="fas fa-book me-1"></i> Reader
                    </span>
                </div>
            </div>
        </div>

       
        <div class="row mb-4">
            <div class="col-md-3 col-6 mb-3">
                <div class="stat-card books">
                    <h2 class="mb-1"><%= totalBooks %></h2>
                    <p class="mb-0">Total Books</p>
                </div>
            </div>
            <div class="col-md-3 col-6 mb-3">
                <div class="stat-card borrowed">
                    <h2 class="mb-1"><%= userBorrowedCount %></h2>
                    <p class="mb-0">My Borrowed</p>
                </div>
            </div>
            <div class="col-md-3 col-6 mb-3">
                <div class="stat-card reserved">
                    <h2 class="mb-1"><%= userReservedCount %></h2>
                    <p class="mb-0">My Reserved</p>
                </div>
            </div>
            <div class="col-md-3 col-6 mb-3">
                <div class="stat-card history">
                    <h2 class="mb-1"><%= (user != null) ? transactionDAO.getTransactionsByUserId(user.getId()).size() : 0 %></h2>
                    <p class="mb-0">Total History</p>
                </div>
            </div>
        </div>

       
        <div class="row mb-4">
            <div class="col-md-4 col-6 mb-3">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-book-open"></i>
                    </div>
                    <h5>Browse Books</h5>
                    <p class="text-muted small">Explore our collection</p>
                    <a href="books-user.jsp" class="btn btn-outline-primary btn-sm">Browse Now</a>
                </div>
            </div>
            <div class="col-md-4 col-6 mb-3">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-handshake"></i>
                    </div>
                    <h5>Borrow Books</h5>
                    <p class="text-muted small">Borrow available books</p>
                    <a href="books-user.jsp" class="btn btn-outline-success btn-sm">Borrow Now</a>
                </div>
            </div>
            <div class="col-md-4 col-6 mb-3">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-bookmark"></i>
                    </div>
                    <h5>My Books</h5>
                    <p class="text-muted small">View borrowed books</p>
                    <a href="my-transactions.jsp" class="btn btn-outline-warning btn-sm">View My Books</a>
                </div>
            </div>
        </div>

        
        <div class="row">
            <div class="col-lg-6 mb-4">
                <div class="dashboard-card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-bolt me-2"></i>Quick Links</h5>
                    </div>
                    <div class="card-body">
                        <ul class="quick-links">
                            <li>
                                <a href="books-user.jsp" class="text-decoration-none text-dark">
                                    <i class="fas fa-search text-primary me-2"></i>Search for Books
                                </a>
                            </li>
                            <li>
                                <a href="books-user.jsp?keyword=best" class="text-decoration-none text-dark">
                                    <i class="fas fa-star text-warning me-2"></i>Popular Books
                                </a>
                            </li>
                            <li>
                                <a href="books-user.jsp?keyword=new" class="text-decoration-none text-dark">
                                    <i class="fas fa-plus-circle text-success me-2"></i>New Arrivals
                                </a>
                            </li>
                            <li>
                                <a href="my-transactions.jsp" class="text-decoration-none text-dark">
                                    <i class="fas fa-history text-info me-2"></i>Borrowing History
                                </a>
                            </li>
                            <li>
                                <a href="#" class="text-decoration-none text-dark" onclick="showHelp()">
                                    <i class="fas fa-question-circle text-secondary me-2"></i>Help & Support
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-6 mb-4">
                <div class="dashboard-card">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="fas fa-history me-2"></i>Recent Activity</h5>
                    </div>
                    <div class="card-body recent-activity">
                        <div class="activity-item">
                            <i class="fas fa-book text-success me-2"></i>
                            <strong>Last Login</strong>
                            <p class="mb-0 text-muted">You logged in to your account</p>
                            <small class="text-muted">Just now</small>
                        </div>
                        <div class="activity-item">
                            <i class="fas fa-info-circle text-primary me-2"></i>
                            <strong>Library Stats</strong>
                            <p class="mb-0 text-muted"><%= availableBooks %> books available out of <%= totalBooks %></p>
                            <small class="text-muted">Updated daily</small>
                        </div>
                        <div class="activity-item">
                            <i class="fas fa-bookmark text-warning me-2"></i>
                            <strong>My Borrowings</strong>
                            <p class="mb-0 text-muted">You have <%= userBorrowedCount %> borrowed book(s)</p>
                            <small class="text-muted">Check due dates</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

       
        <div class="row mt-4">
            <div class="col-12">
                <div class="dashboard-card">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i>Library Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4 text-center mb-3">
                                <i class="fas fa-clock fa-2x text-primary mb-2"></i>
                                <h6>Borrowing Period</h6>
                                <p class="text-muted mb-0">14 days</p>
                            </div>
                            <div class="col-md-4 text-center mb-3">
                                <i class="fas fa-book fa-2x text-success mb-2"></i>
                                <h6>Max Books</h6>
                                <p class="text-muted mb-0">5 books at a time</p>
                            </div>
                            <div class="col-md-4 text-center mb-3">
                                <i class="fas fa-calendar-check fa-2x text-warning mb-2"></i>
                                <h6>Renewals</h6>
                                <p class="text-muted mb-0">2 renewals allowed</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

   
    <footer class="mt-5 pt-4 border-top text-center">
        <div class="container">
            <p class="text-muted">
                <strong>Library Management System</strong> | 
                User: <%= username %> | 
                <span id="currentDate"></span>
            </p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
       
        const now = new Date();
        const options = { year: 'numeric', month: 'long', day: 'numeric' };
        document.getElementById('currentDate').textContent = now.toLocaleDateString('en-US', options);
        
        function showHelp() {
            alert('For help, please contact the library administrator at admin@library.com or call (123) 456-7890.');
        }
    </script>
</body>
</html>
