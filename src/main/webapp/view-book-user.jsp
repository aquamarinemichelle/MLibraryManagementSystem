
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
 
    String idParam = request.getParameter("id");
    Book book = null;
    BookDAO bookDAO = new BookDAO();
    
    if (idParam != null && !idParam.trim().isEmpty()) {
        try {
            int bookId = Integer.parseInt(idParam);
            book = bookDAO.getBookById(bookId);
        } catch (NumberFormatException e) {
            // Invalid ID format
        }
    }
    
    if (book == null) {
        response.sendRedirect("books-user.jsp");
        return;
    }
    
    String statusClass = book.isAvailable() ? "bg-success" : "bg-danger";
    String statusIcon = book.isAvailable() ? "check-circle" : "times-circle";
    String statusText = book.isAvailable() ? "Available for Borrowing" : "Currently Checked Out";
    
 
    List<Book> allSimilarBooks = bookDAO.searchBooks(book.getCategory());
    List<Book> similarBooks = new ArrayList<>();

    int count = 0;
    for (Book b : allSimilarBooks) {
        if (b.getId() != book.getId() && count < 3) {
            similarBooks.add(b);
            count++;
        }
    }
 
    java.util.Date today = new java.util.Date();
    java.util.Calendar cal = java.util.Calendar.getInstance();
    cal.setTime(today);
    cal.add(java.util.Calendar.DATE, 14);
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
    String dueDateStr = sdf.format(cal.getTime());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= book.getTitle() %> - Book Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .book-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 0;
            border-radius: 0 0 20px 20px;
            margin-bottom: 30px;
        }
        
        .navbar-user {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .book-cover-large {
            height: 350px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 5rem;
            border-radius: 15px;
            margin-bottom: 20px;
        }
        
        .info-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
        }
        
        .detail-item {
            padding: 12px 0;
            border-bottom: 1px solid #eee;
        }
        
        .detail-item:last-child {
            border-bottom: none;
        }
        
        .status-badge {
            font-size: 1rem;
            padding: 8px 20px;
            border-radius: 25px;
        }
        
        .description-box {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 25px;
            margin: 20px 0;
        }
        
        .similar-book-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
            transition: transform 0.3s;
            height: 100%;
        }
        
        .similar-book-card:hover {
            transform: translateY(-5px);
        }
        
        .similar-book-cover {
            height: 120px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2.5rem;
            border-radius: 10px 10px 0 0;
        }
        
        .action-buttons {
            position: sticky;
            top: 20px;
        }
        
        .book-meta {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
        }
        
        .badge-category {
            font-size: 0.9rem;
            padding: 8px 15px;
            border-radius: 20px;
        }
        
        @media (max-width: 768px) {
            .action-buttons {
                position: static;
                margin-top: 20px;
            }
            
            .book-cover-large {
                height: 250px;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
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
                <a class="nav-link text-white" href="books-user.jsp">
                    <i class="fas fa-book me-1"></i> Browse
                </a>
                <a class="nav-link text-white" href="AuthServlet?action=logout">
                    <i class="fas fa-sign-out-alt me-1"></i> Logout
                </a>
            </div>
        </div>
    </nav>

    <!-- Book Header -->
    <div class="book-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="display-6 fw-bold mb-3"><i class="fas fa-book me-2"></i><%= book.getTitle() %></h1>
                    <h4 class="mb-3">by <%= book.getAuthor() %></h4>
                    <span class="status-badge badge <%= statusClass %>">
                        <i class="fas fa-<%= statusIcon %> me-1"></i>
                        <%= statusText %>
                    </span>
                </div>
                <div class="col-md-4 text-end">
                    <a href="books-user.jsp" class="btn btn-outline-light">
                        <i class="fas fa-arrow-left me-1"></i> Back to Books
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container">
        <div class="row">
            <!-- Left Column: Book Info -->
            <div class="col-lg-8">
                <!-- Book Cover -->
                <div class="book-cover-large">
                    <i class="fas fa-book-open"></i>
                </div>
                
                <!-- Description -->
                <div class="info-card">
                    <h4 class="mb-4"><i class="fas fa-align-left me-2"></i>Description</h4>
                    <div class="description-box">
                        <% 
                            String description = book.getDescription();
                            if (description != null && !description.trim().isEmpty()) {
                        %>
                            <p class="mb-0"><%= description %></p>
                        <% } else { %>
                            <p class="text-muted mb-0 fst-italic">
                                <i class="fas fa-info-circle me-2"></i>No description available for this book.
                            </p>
                        <% } %>
                    </div>
                </div>
                
                <!-- Book Details -->
                <div class="info-card">
                    <h4 class="mb-4"><i class="fas fa-info-circle me-2"></i>Book Details</h4>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="detail-item">
                                <h6><i class="fas fa-user text-primary me-2"></i>Author</h6>
                                <p class="fs-5"><%= book.getAuthor() %></p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="detail-item">
                                <h6><i class="fas fa-barcode text-primary me-2"></i>ISBN</h6>
                                <p class="fs-5"><code><%= book.getIsbn() %></code></p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="detail-item">
                                <h6><i class="fas fa-calendar text-primary me-2"></i>Publication Year</h6>
                                <p class="fs-5"><%= book.getYear() %></p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="detail-item">
                                <h6><i class="fas fa-tags text-primary me-2"></i>Category</h6>
                                <p class="fs-5">
                                    <span class="badge bg-info badge-category"><%= book.getCategory() %></span>
                                </p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="detail-item">
                        <h6><i class="fas fa-hashtag text-primary me-2"></i>Book ID</h6>
                        <p class="fs-5">LIB<%= String.format("%05d", book.getId()) %></p>
                    </div>
                </div>
                
                <!-- Similar Books -->
                <% if (!similarBooks.isEmpty()) { %>
                <div class="info-card">
                    <h4 class="mb-4"><i class="fas fa-bookmark me-2"></i>Similar Books</h4>
                    <p class="text-muted mb-4">Other books in the same category:</p>
                    
                    <div class="row">
                        <% for (Book similarBook : similarBooks) { %>
                        <div class="col-md-4 mb-3">
                            <div class="similar-book-card">
                                <div class="similar-book-cover">
                                    <i class="fas fa-book"></i>
                                </div>
                                <div class="card-body">
                                    <h6 class="card-title"><%= similarBook.getTitle() %></h6>
                                    <p class="card-text text-muted small">
                                        <i class="fas fa-user-pen me-1"></i> <%= similarBook.getAuthor() %>
                                    </p>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="badge <%= similarBook.isAvailable() ? "bg-success" : "bg-danger" %>">
                                            <%= similarBook.isAvailable() ? "Available" : "Borrowed" %>
                                        </span>
                                        <a href="view-book-user.jsp?id=<%= similarBook.getId() %>" 
                                           class="btn btn-sm btn-outline-primary">
                                            View
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } %>
            </div>
            
            <!-- Right Column: Actions -->
            <div class="col-lg-4">
                <div class="action-buttons">
                    <!-- Status Card -->
                    <div class="info-card">
                        <h5 class="mb-3"><i class="fas fa-exchange-alt me-2"></i>Availability Status</h5>
                        <div class="text-center">
                            <div class="mb-4">
                                <i class="fas fa-<%= statusIcon %> fa-3x text-<%= book.isAvailable() ? "success" : "danger" %> mb-3"></i>
                                <h3 class="<%= statusClass.replace("bg-", "text-") %>">
                                    <%= book.isAvailable() ? "AVAILABLE" : "UNAVAILABLE" %>
                                </h3>
                            </div>
                            
                            <% if (book.isAvailable()) { %>
                                <p class="text-muted mb-3">This book is ready for immediate borrowing.</p>
                                <a href="TransactionServlet?action=borrow&bookId=<%= book.getId() %>&dueDate=<%= dueDateStr %>" 
                                   class="btn btn-success btn-lg w-100 mb-2"
                                   onclick="return confirm('Are you sure you want to borrow &quot;<%= book.getTitle() %>&quot;?')">
                                    <i class="fas fa-handshake me-2"></i>Borrow This Book
                                </a>
                                <button class="btn btn-outline-primary w-100 mb-2" onclick="addToWishlist()">
                                    <i class="fas fa-heart me-2"></i>Add to Wishlist
                                </button>
                            <% } else { %>
                                <p class="text-muted mb-3">This book is currently checked out.</p>
                                <button class="btn btn-info btn-lg w-100 mb-2" onclick="showReserveModal()">
                                    <i class="fas fa-calendar-check me-2"></i>Reserve for Later
                                </button>
                            <% } %>
                        </div>
                    </div>
                    
                    <!-- Quick Info -->
                    <div class="info-card">
                        <h5 class="mb-3"><i class="fas fa-bolt me-2"></i>Quick Info</h5>
                        <div class="book-meta">
                            <div class="mb-2">
                                <small class="text-muted">Book ID</small>
                                <p class="mb-0 fw-bold">LIB<%= String.format("%05d", book.getId()) %></p>
                            </div>
                            <div class="mb-2">
                                <small class="text-muted">ISBN</small>
                                <p class="mb-0"><%= book.getIsbn() %></p>
                            </div>
                            <div class="mb-2">
                                <small class="text-muted">Category</small>
                                <p class="mb-0">
                                    <span class="badge bg-info"><%= book.getCategory() %></span>
                                </p>
                            </div>
                            <div>
                                <small class="text-muted">Year</small>
                                <p class="mb-0"><%= book.getYear() %></p>
                            </div>
                        </div>
                        
                        <div class="d-grid gap-2">
                            <button class="btn btn-outline-secondary" onclick="window.print()">
                                <i class="fas fa-print me-2"></i>Print Details
                            </button>
                            <button class="btn btn-outline-dark" onclick="shareBook()">
                                <i class="fas fa-share-alt me-2"></i>Share Book
                            </button>
                        </div>
                    </div>
                    
                    <!-- Library Info -->
                    <div class="info-card">
                        <h5 class="mb-3"><i class="fas fa-university me-2"></i>Library Info</h5>
                        <div class="book-meta">
                            <div class="mb-3">
                                <i class="fas fa-clock text-primary me-2"></i>
                                <strong>Borrowing Period:</strong>
                                <span class="text-muted">14 days</span>
                            </div>
                            <div class="mb-3">
                                <i class="fas fa-redo text-warning me-2"></i>
                                <strong>Renewals:</strong>
                                <span class="text-muted">2 times allowed</span>
                            </div>
                            <div class="mb-3">
                                <i class="fas fa-exclamation-triangle text-danger me-2"></i>
                                <strong>Late Fee:</strong>
                                <span class="text-muted">$0.50 per day</span>
                            </div>
                            <div>
                                <i class="fas fa-book text-success me-2"></i>
                                <strong>Max Books:</strong>
                                <span class="text-muted">5 at a time</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="mt-5 pt-4 border-top text-center">
        <div class="container">
            <p class="text-muted">
                <strong>Library Management System</strong> | 
                User: <%= username %> | 
                Book ID: LIB<%= String.format("%05d", book.getId()) %>
            </p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      
        function addToWishlist() {
            try {
             
                let wishlist = [];
                const storedWishlist = localStorage.getItem('libraryWishlist');
                if (storedWishlist) {
                    wishlist = JSON.parse(storedWishlist);
                }

                const bookId = <%= book.getId() %>;
                const bookTitle = '<%= book.getTitle().replace("'", "\\'") %>';
                const bookAuthor = '<%= book.getAuthor().replace("'", "\\'") %>';
                
                let alreadyInWishlist = false;
                for (let i = 0; i < wishlist.length; i++) {
                    if (wishlist[i].id === bookId) {
                        alreadyInWishlist = true;
                        break;
                    }
                }
                
                if (alreadyInWishlist) {
                    alert('This book is already in your wishlist!');
                    return;
                }

                wishlist.push({
                    id: bookId,
                    title: bookTitle,
                    author: bookAuthor,
                    addedDate: new Date().toISOString()
                });
           
                localStorage.setItem('libraryWishlist', JSON.stringify(wishlist));

                alert('"' + bookTitle + '" has been added to your wishlist!');
                
            } catch (error) {
                console.error('Error adding to wishlist:', error);
                alert('Failed to add to wishlist. Please try again.');
            }
        }

        function shareBook() {
            const shareUrl = window.location.href;

            if (navigator.clipboard && window.isSecureContext) {
                navigator.clipboard.writeText(shareUrl).then(() => {
                    alert('Book link copied to clipboard!');
                }).catch(err => {
                    fallbackCopy(shareUrl);
                });
            } else {
                fallbackCopy(shareUrl);
            }
        }
        
        function fallbackCopy(text) {
            const textArea = document.createElement('textarea');
            textArea.value = text;
            textArea.style.position = 'fixed';
            textArea.style.left = '-999999px';
            textArea.style.top = '-999999px';
            document.body.appendChild(textArea);
            textArea.focus();
            textArea.select();
            
            try {
                document.execCommand('copy');
                alert('Book link copied to clipboard!');
            } catch (err) {
                alert('Failed to copy link. Please copy manually: ' + text);
            }
            
            document.body.removeChild(textArea);
        }
        
        function showReserveModal() {
            alert('Reservation feature coming soon!');
        }
    </script>
</body>
</html>
