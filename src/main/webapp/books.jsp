<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.BookDAO, com.library.Book, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .book-card {
            transition: transform 0.2s;
            border: 1px solid #e0e0e0;
        }
        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .status-badge {
            position: absolute;
            top: 10px;
            right: 10px;
        }
        .book-cover {
            height: 200px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
        }
    </style>
</head>
<body>
    <div class="container-fluid py-4">
        <div class="row mb-4">
            <div class="col">
                <h1 class="display-5 fw-bold">
                    <i class="fas fa-book me-2"></i>Book Management
                </h1>
                <p class="lead">Manage all books in your library</p>
            </div>
            <div class="col-auto">
                <a href="admin-dashboard.jsp" class="btn btn-outline-primary me-2">
                    <i class="fas fa-home"></i> Dashboard
                </a>
                <a href="add-book.jsp" class="btn btn-success">
                    <i class="fas fa-plus-circle"></i> Add New Book
                </a>
            </div>
        </div>

       
        <div class="card mb-4">
            <div class="card-body">
                <form action="BookServlet" method="get" class="row g-3">
                    <input type="hidden" name="action" value="search">
                    <div class="col-md-8">
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-search"></i>
                            </span>
                            <input type="text" class="form-control" name="keyword" 
                                   placeholder="Search by title, author, ISBN, or category..." 
                                   value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
                        </div>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-search me-1"></i> Search
                        </button>
                    </div>
                    <div class="col-md-2">
                        <a href="BookServlet" class="btn btn-secondary w-100">
                            <i class="fas fa-redo"></i> Clear
                        </a>
                    </div>
                </form>
            </div>
        </div>

     
        <div class="row">
            <%
                BookDAO bookDAO = new BookDAO();
                List<Book> books = null;
                String keyword = request.getParameter("keyword");
                
                if (keyword != null && !keyword.trim().isEmpty()) {
                    books = bookDAO.searchBooks(keyword);
                } else {
                    books = bookDAO.getAllBooks();
                }
                
                if (books == null || books.isEmpty()) {
            %>
            <div class="col-12">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>
                    No books found. 
                    <% if (keyword != null && !keyword.trim().isEmpty()) { %>
                        No books match your search "<%= keyword %>". 
                    <% } %>
                    <a href="add-book.jsp" class="alert-link">Add your first book</a>
                </div>
            </div>
            <% 
                } else { 
                    for (Book book : books) { 
            %>
            <div class="col-md-4 mb-4">
                <div class="card book-card h-100">
                    <div class="book-cover">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="card-body">
                        <span class="status-badge">
                            <% if (book.isAvailable()) { %>
                                <span class="badge bg-success">
                                    <i class="fas fa-check"></i> Available
                                </span>
                            <% } else { %>
                                <span class="badge bg-danger">
                                    <i class="fas fa-times"></i> Unavailable
                                </span>
                            <% } %>
                        </span>
                        
                        <h5 class="card-title"><%= book.getTitle() %></h5>
                        <h6 class="card-subtitle mb-2 text-muted">
                            <i class="fas fa-user"></i> <%= book.getAuthor() %>
                        </h6>
                        
                        <div class="mb-3">
                            <small class="text-muted">
                                <i class="fas fa-barcode"></i> ISBN: <%= book.getIsbn() %>
                            </small>
                        </div>
                        
                        <p class="card-text">
                            <% 
                                String description = book.getDescription();
                                if (description != null && !description.trim().isEmpty()) {
                                    if (description.length() > 100) {
                                        out.print(description.substring(0, 100) + "...");
                                    } else {
                                        out.print(description);
                                    }
                                } else {
                            %>
                                <span class="text-muted">No description available</span>
                            <% } %>
                        </p>
                        
                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <small class="text-muted">
                                    <i class="fas fa-calendar"></i> <%= book.getYear() %>
                                </small>
                            </div>
                            <div class="col-6 text-end">
                                <small class="badge bg-info">
                                    <i class="fas fa-tag"></i> <%= book.getCategory() %>
                                </small>
                            </div>
                        </div>
                        
                        <div class="btn-group w-100">
                            <a href="BookServlet?action=view&id=<%= book.getId() %>" 
                               class="btn btn-outline-info btn-sm">
                                <i class="fas fa-eye"></i> View
                            </a>
                            <a href="BookServlet?action=edit&id=<%= book.getId() %>" 
                               class="btn btn-outline-warning btn-sm">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <a href="BookServlet?action=delete&id=<%= book.getId() %>" 
                               class="btn btn-outline-danger btn-sm"
                               onclick="return confirm('Are you sure you want to delete this book?')">
                                <i class="fas fa-trash"></i> Delete
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <% 
                    } 
                } 
            %>
        </div>
        
      
        <div class="row mt-4">
            <div class="col-md-3">
                <div class="card text-white bg-primary">
                    <div class="card-body text-center">
                        <h3><%= bookDAO.getTotalBooksCount() %></h3>
                        <p class="mb-0">Total Books</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-white bg-success">
                    <div class="card-body text-center">
                        <h3><%= bookDAO.getAvailableBooksCount() %></h3>
                        <p class="mb-0">Available</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-white bg-warning">
                    <div class="card-body text-center">
                        <%
                            int borrowedCount = bookDAO.getTotalBooksCount() - bookDAO.getAvailableBooksCount();
                        %>
                        <h3><%= borrowedCount %></h3>
                        <p class="mb-0">Borrowed</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-white bg-dark">
                    <div class="card-body text-center">
                        <h3><%= (books != null) ? books.size() : 0 %></h3>
                        <p class="mb-0">Displayed</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>