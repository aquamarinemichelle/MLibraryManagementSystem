
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.TransactionDAO, com.library.Transaction, com.library.UserDAO, com.library.User, java.util.*, java.text.SimpleDateFormat" %>
<%
  
    jakarta.servlet.http.HttpSession userSession = request.getSession(false);
    String username = (userSession != null) ? (String) userSession.getAttribute("username") : null;
    
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    UserDAO userDAO = new UserDAO();
    User user = userDAO.getUserByUsername(username);
    TransactionDAO transactionDAO = new TransactionDAO();
    
    List<Transaction> transactions = new ArrayList<>();
    if (user != null) {
        transactions = transactionDAO.getTransactionsByUserId(user.getId());
    }
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>📚 My Borrowings</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="container">
       
        <nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
            <div class="container">
                <a class="navbar-brand" href="user-dashboard.jsp">
                    <i class="fas fa-book-reader me-2"></i>
                    <strong>Library Portal</strong>
                </a>
                <div class="navbar-nav ms-auto">
                    <a class="nav-link text-white" href="user-dashboard.jsp">
                        <i class="fas fa-home me-1"></i> Dashboard
                    </a>
                    <a class="nav-link text-white" href="books-user.jsp">
                        <i class="fas fa-book me-1"></i> Browse Books
                    </a>
                    <a class="nav-link active" href="my-transactions.jsp">
                        <i class="fas fa-history me-1"></i> My Borrowings
                    </a>
                    <a class="nav-link text-white" href="AuthServlet?action=logout">
                        <i class="fas fa-sign-out-alt me-1"></i> Logout
                    </a>
                </div>
            </div>
        </nav>
        
        
        <div class="mb-4">
            <h2><i class="fas fa-history me-2"></i>My Borrowing History</h2>
            <p class="text-muted">View all books you've borrowed from the library</p>
        </div>
        
        
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">Borrowed Books (<%= transactions.size() %>)</h5>
            </div>
            <div class="card-body">
                <% if (transactions.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="fas fa-book-open fa-3x text-muted mb-3"></i>
                        <h5>No Borrowings Yet</h5>
                        <p class="text-muted">You haven't borrowed any books yet.</p>
                        <a href="books-user.jsp" class="btn btn-primary">
                            <i class="fas fa-book me-1"></i> Browse Books
                        </a>
                    </div>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Book Title</th>
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
                                    <td><strong><%= transaction.getBookTitle() %></strong></td>
                                    <td><%= dateFormat.format(transaction.getBorrowDate()) %></td>
                                    <td><%= dateFormat.format(transaction.getDueDate()) %></td>
                                    <td>
                                        <% if (transaction.getReturnDate() != null) { %>
                                            <%= dateFormat.format(transaction.getReturnDate()) %>
                                        <% } else { %>
                                            <span class="text-muted">Not returned</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if ("borrowed".equals(transaction.getStatus())) { %>
                                            <span class="badge bg-warning">Currently Borrowed</span>
                                        <% } else if ("returned".equals(transaction.getStatus())) { %>
                                            <span class="badge bg-success">Returned</span>
                                        <% } else { %>
                                            <span class="badge bg-danger">Overdue</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (transaction.getFineAmount() > 0) { %>
                                            <span class="text-danger">
                                                $<%= String.format("%.2f", transaction.getFineAmount()) %>
                                            </span>
                                        <% } else { %>
                                            <span class="text-muted">None</span>
                                        <% } %>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>
        
        
        <div class="card mt-4">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i>Important Information</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4">
                        <i class="fas fa-clock text-primary me-2"></i>
                        <strong>Borrowing Period:</strong>
                        <span class="text-muted">14 days</span>
                    </div>
                    <div class="col-md-4">
                        <i class="fas fa-exclamation-triangle text-warning me-2"></i>
                        <strong>Late Fee:</strong>
                        <span class="text-muted">$0.50 per day</span>
                    </div>
                    <div class="col-md-4">
                        <i class="fas fa-book text-success me-2"></i>
                        <strong>Max Books:</strong>
                        <span class="text-muted">5 at a time</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
