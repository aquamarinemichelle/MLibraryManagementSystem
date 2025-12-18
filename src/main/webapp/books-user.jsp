
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.BookDAO, com.library.Book, java.util.*" %>
<%
 
    jakarta.servlet.http.HttpSession userSession = request.getSession(false);
    String username = (userSession != null) ? (String) userSession.getAttribute("username") : null;
    String role = (userSession != null) ? (String) userSession.getAttribute("role") : null;
    
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
   
    BookDAO bookDAO = new BookDAO();
    List<Book> books = null;
    String keyword = request.getParameter("keyword");
    
    if (keyword != null && !keyword.trim().isEmpty()) {
        books = bookDAO.searchBooks(keyword);
    } else {
        books = bookDAO.getAllBooks();
    }
    
    int totalBooks = bookDAO.getTotalBooksCount();
    int availableBooks = bookDAO.getAvailableBooksCount();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>📚 Library Catalog</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .navbar-user {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .user-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 0;
            margin-bottom: 30px;
            border-radius: 0 0 20px 20px;
        }
        
        .book-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: transform 0.3s, box-shadow 0.3s;
            height: 100%;
            overflow: hidden;
        }
        
        .book-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.15);
        }
        
        .book-cover {
            height: 200px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 4rem;
            position: relative;
        }
        
        .status-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            font-size: 0.8rem;
            padding: 5px 10px;
            border-radius: 20px;
        }
        
        .book-description {
            height: 72px;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            margin-bottom: 15px;
        }
        
        .stat-card {
            border-radius: 10px;
            padding: 20px;
            color: white;
            margin-bottom: 20px;
        }
        
        .stat-card.total {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .stat-card.available {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        }
        
        .stat-card.borrowed {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
        }
        
        .search-box {
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }
        
        .category-badge {
            font-size: 0.8rem;
            padding: 5px 10px;
            border-radius: 20px;
        }
        
        .action-btn {
            width: 100%;
            margin-top: 10px;
            padding: 8px;
            border-radius: 8px;
        }
        
        .empty-state {
            text-align: center;
            padding: 50px 20px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        
        .empty-state i {
            font-size: 4rem;
            color: #6c757d;
            margin-bottom: 20px;
        }
        
        
        .alert-message {
            animation: slideIn 0.3s ease-out;
        }
        
        @keyframes slideIn {
            from {
                transform: translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
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
                    <i class="fas fa-user me-1"></i> <%= username %>
                </span>
                <a class="nav-link text-white" href="user-dashboard.jsp">
                    <i class="fas fa-home me-1"></i> Dashboard
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
                <i class="fas fa-book-open me-2"></i>Library Catalog
            </h1>
            <p class="lead mb-4">Browse and discover books from our collection</p>
            
           
            <div class="row justify-content-center">
                <div class="col-md-3 col-6">
                    <div class="stat-card total">
                        <h3 class="mb-1"><%= totalBooks %></h3>
                        <p class="mb-0">Total Books</p>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card available">
                        <h3 class="mb-1"><%= availableBooks %></h3>
                        <p class="mb-0">Available Now</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

   
    <div class="container">
       
        <%
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            if (success != null) {
        %>
            <div class="alert alert-success alert-message alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i> <%= success %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <%
            } else if (error != null) {
        %>
            <div class="alert alert-danger alert-message alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <%
            }
        %>

      
        <div class="search-box">
            <form action="books-user.jsp" method="get" class="row g-3">
                <div class="col-md-10">
                    <div class="input-group">
                        <span class="input-group-text bg-transparent border-end-0">
                            <i class="fas fa-search"></i>
                        </span>
                        <input type="text" class="form-control border-start-0" name="keyword" 
                               placeholder="Search by title, author, ISBN, or category..." 
                               value="<%= keyword != null ? keyword : "" %>">
                    </div>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-search me-1"></i> Search
                    </button>
                </div>
            </form>
        </div>

        <% if (books == null || books.isEmpty()) { %>
        <div class="empty-state">
            <i class="fas fa-book-open"></i>
            <h3 class="mb-3">No Books Found</h3>
            <% if (keyword != null && !keyword.trim().isEmpty()) { %>
                <p class="text-muted mb-4">No books match your search "<strong><%= keyword %></strong>"</p>
            <% } else { %>
                <p class="text-muted mb-4">The library catalog is currently empty.</p>
            <% } %>
            <a href="books-user.jsp" class="btn btn-outline-primary">
                <i class="fas fa-redo me-1"></i> Clear Search
            </a>
        </div>
        <% } else { %>
        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 row-cols-xl-4 g-4">
            <% for (Book book : books) { 
               
                java.util.Date today = new java.util.Date();
                java.util.Calendar cal = java.util.Calendar.getInstance();
                cal.setTime(today);
                cal.add(java.util.Calendar.DATE, 14);
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                String dueDateStr = sdf.format(cal.getTime());
            %>
            <div class="col">
                <div class="book-card">
                    <div class="book-cover">
                        <i class="fas fa-book"></i>
                        <span class="status-badge <%= book.isAvailable() ? "bg-success" : "bg-danger" %>">
                            <i class="fas fa-<%= book.isAvailable() ? "check" : "times" %> me-1"></i>
                            <%= book.isAvailable() ? "Available" : "Borrowed" %>
                        </span>
                    </div>
                    <div class="card-body">
                        <h5 class="card-title"><%= book.getTitle() %></h5>
                        <h6 class="card-subtitle mb-3 text-muted">
                            <i class="fas fa-user-pen me-1"></i> <%= book.getAuthor() %>
                        </h6>
                        
                        <div class="book-description text-muted">
                            <% 
                                String description = book.getDescription();
                                if (description != null && !description.trim().isEmpty()) {
                                    if (description.length() > 120) {
                                        out.print(description.substring(0, 120) + "...");
                                    } else {
                                        out.print(description);
                                    }
                                } else {
                            %>
                                <span class="fst-italic">No description available</span>
                            <% } %>
                        </div>
                        
                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <small class="text-muted">
                                    <i class="fas fa-calendar-days me-1"></i> <%= book.getYear() %>
                                </small>
                            </div>
                            <div class="col-6 text-end">
                                <span class="category-badge bg-info">
                                    <i class="fas fa-tag me-1"></i> <%= book.getCategory() %>
                                </span>
                            </div>
                        </div>
                        
                        <div class="d-grid gap-2">
                            <a href="view-book-user.jsp?id=<%= book.getId() %>" 
                               class="btn btn-outline-primary action-btn">
                                <i class="fas fa-eye me-1"></i> View Details
                            </a>
                            
                            <% if (book.isAvailable()) { %>
                            <!-- Simple GET request for borrowing -->
                            <a href="TransactionServlet?action=borrow&bookId=<%= book.getId() %>&dueDate=<%= dueDateStr %>" 
                               class="btn btn-success action-btn"
                               onclick="return confirmBorrow('<%= book.getTitle().replace("'", "\\'") %>')">
                                <i class="fas fa-handshake me-1"></i> Borrow
                            </a>
                            <% } else { %>
                            <button class="btn btn-outline-secondary action-btn" disabled>
                                <i class="fas fa-clock me-1"></i> Not Available
                            </button>
                            <% } %>
                        </div>
                    </div>
                    <div class="card-footer bg-transparent border-top-0">
                        <small class="text-muted">
                            <i class="fas fa-barcode me-1"></i> ISBN: <%= book.getIsbn() %>
                        </small>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>
    </div>

   
    <footer class="mt-5 pt-4 border-top text-center">
        <div class="container">
            <p class="text-muted">
                <strong>Library Management System</strong> | 
                User: <%= username %> | 
                Total Books: <%= totalBooks %> | 
                Available: <%= availableBooks %>
            </p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmBorrow(bookTitle) {
            return confirm('Are you sure you want to borrow "' + bookTitle + '"?\n\nDue date will be 14 days from today.');
        }

        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert-message');
            alerts.forEach(alert => {
                setTimeout(() => {
                    if (alert.parentNode) {
                        const bsAlert = new bootstrap.Alert(alert);
                        bsAlert.close();
                    }
                }, 5000);
            });
        });
    </script>
</body>
</html>
