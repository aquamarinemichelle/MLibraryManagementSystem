<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.Book" %>
<%
    Book book = (Book) request.getAttribute("book");
    if (book == null) {
        response.sendRedirect("BookServlet");
        return;
    }
    
    String statusClass = book.isAvailable() ? "bg-success" : "bg-danger";
    String statusIcon = book.isAvailable() ? "check" : "times";
    String statusText = book.isAvailable() ? "Available for Borrowing" : "Currently Unavailable";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= book.getTitle() %> - View Book</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .book-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 0;
            border-radius: 15px;
            margin-bottom: 30px;
        }
        .status-badge {
            font-size: 1rem;
            padding: 8px 15px;
        }
        .book-details-card {
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            border: none;
        }
        .book-cover-large {
            height: 300px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 5rem;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .detail-item {
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .detail-item:last-child {
            border-bottom: none;
        }
        .action-buttons {
            position: sticky;
            top: 20px;
        }
        .description-box {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container py-4">
        <!-- Header -->
        <div class="book-header text-center">
            <div class="container">
                <h1 class="display-5 fw-bold mb-3"><i class="fas fa-book me-2"></i><%= book.getTitle() %></h1>
                <h4 class="mb-3">by <%= book.getAuthor() %></h4>
                <span class="status-badge badge <%= statusClass %>">
                    <i class="fas fa-<%= statusIcon %>-circle me-1"></i>
                    <%= statusText %>
                </span>
            </div>
        </div>

        <!-- Navigation -->
        <div class="mb-4">
            <a href="BookServlet" class="btn btn-outline-primary">
                <i class="fas fa-arrow-left me-1"></i> Back to All Books
            </a>
            <a href="BookServlet?action=edit&id=<%= book.getId() %>" class="btn btn-warning">
                <i class="fas fa-edit me-1"></i> Edit Book
            </a>
            <a href="add-book.jsp" class="btn btn-success">
                <i class="fas fa-plus-circle me-1"></i> Add New Book
            </a>
        </div>

        <!-- Book Details -->
        <div class="row">
            <!-- Left Column: Book Cover and Quick Actions -->
            <div class="col-lg-4 mb-4">
                <div class="book-cover-large">
                    <i class="fas fa-book-open"></i>
                </div>
                
                <div class="card book-details-card action-buttons">
                    <div class="card-header bg-dark text-white">
                        <h5 class="mb-0"><i class="fas fa-bolt me-2"></i>Quick Actions</h5>
                    </div>
                    <div class="card-body">
                        <% if (book.isAvailable()) { %>
                            <button class="btn btn-success w-100 mb-2" data-bs-toggle="modal" data-bs-target="#borrowModal">
                                <i class="fas fa-handshake me-2"></i>Borrow This Book
                            </button>
                        <% } else { %>
                            <button class="btn btn-secondary w-100 mb-2" disabled>
                                <i class="fas fa-times me-2"></i>Not Available for Borrowing
                            </button>
                        <% } %>
                        
                        <button class="btn btn-info w-100 mb-2" data-bs-toggle="modal" data-bs-target="#reserveModal">
                            <i class="fas fa-calendar-check me-2"></i>Reserve Book
                        </button>
                        
                        <button class="btn btn-primary w-100 mb-2" onclick="window.print()">
                            <i class="fas fa-print me-2"></i>Print Details
                        </button>
                        
                        <a href="BookServlet?action=delete&id=<%= book.getId() %>" 
                           class="btn btn-danger w-100"
                           onclick="return confirm('Are you sure you want to delete this book?')">
                            <i class="fas fa-trash me-2"></i>Delete Book
                        </a>
                    </div>
                </div>

                <!-- Quick Stats -->
                <div class="card book-details-card mt-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="fas fa-chart-bar me-2"></i>Book Stats</h5>
                    </div>
                    <div class="card-body">
                        <div class="detail-item">
                            <small class="text-muted">Book ID</small>
                            <p class="mb-0 fw-bold">#<%= book.getId() %></p>
                        </div>
                        <div class="detail-item">
                            <small class="text-muted">Added Date</small>
                            <p class="mb-0">Recently</p>
                        </div>
                        <div class="detail-item">
                            <small class="text-muted">Times Borrowed</small>
                            <p class="mb-0">0 times</p>
                        </div>
                        <div class="detail-item">
                            <small class="text-muted">Current Status</small>
                            <p class="mb-0">
                                <span class="badge <%= statusClass %>">
                                    <%= book.isAvailable() ? "On Shelf" : "Checked Out" %>
                                </span>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Right Column: Book Information -->
            <div class="col-lg-8">
                <div class="card book-details-card">
                    <div class="card-header bg-primary text-white">
                        <h3 class="mb-0"><i class="fas fa-info-circle me-2"></i>Book Information</h3>
                    </div>
                    <div class="card-body">
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
                                    <p class="fs-5"><%= book.getIsbn() %></p>
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
                                        <span class="badge bg-info p-2"><%= book.getCategory() %></span>
                                    </p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="detail-item">
                            <h6><i class="fas fa-align-left text-primary me-2"></i>Description</h6>
                            <div class="description-box">
                                <% 
                                    String description = book.getDescription();
                                    if (description != null && !description.trim().isEmpty()) {
                                %>
                                    <p class="mb-0"><%= description %></p>
                                <% } else { %>
                                    <p class="text-muted mb-0"><i>No description available for this book.</i></p>
                                <% } %>
                            </div>
                        </div>
                        
                        <!-- Additional Information -->
                        <div class="row mt-4">
                            <div class="col-md-6">
                                <div class="card bg-light">
                                    <div class="card-body">
                                        <h6><i class="fas fa-qrcode me-2"></i>Book ID</h6>
                                        <p class="mb-0 text-muted">Use this ID for borrowing</p>
                                        <h3 class="mt-2 text-primary">#<%= book.getId() %></h3>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card bg-light">
                                    <div class="card-body">
                                        <h6><i class="fas fa-exchange-alt me-2"></i>Availability</h6>
                                        <p class="mb-0 text-muted">Current status</p>
                                        <h3 class="mt-2 <%= statusClass.replace("bg-", "text-") %>">
                                            <%= book.isAvailable() ? "AVAILABLE" : "UNAVAILABLE" %>
                                        </h3>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Related Actions -->
                <div class="row mt-4">
                    <div class="col-md-4">
                        <div class="card text-center h-100">
                            <div class="card-body">
                                <i class="fas fa-history fa-2x text-primary mb-3"></i>
                                <h5>Borrow History</h5>
                                <p class="text-muted">View past transactions</p>
                                <button class="btn btn-outline-primary" disabled>Coming Soon</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card text-center h-100">
                            <div class="card-body">
                                <i class="fas fa-copy fa-2x text-warning mb-3"></i>
                                <h5>Book Copies</h5>
                                <p class="text-muted">Manage multiple copies</p>
                                <button class="btn btn-outline-warning" disabled>Coming Soon</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card text-center h-100">
                            <div class="card-body">
                                <i class="fas fa-chart-line fa-2x text-success mb-3"></i>
                                <h5>Popularity</h5>
                                <p class="text-muted">See book statistics</p>
                                <button class="btn btn-outline-success" disabled>Coming Soon</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modals -->
    <!-- Borrow Modal -->
    <div class="modal fade" id="borrowModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Borrow "<%= book.getTitle() %>"</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="borrowForm">
                        <div class="mb-3">
                            <label class="form-label">User ID</label>
                            <input type="number" class="form-control" placeholder="Enter user ID" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Due Date</label>
                            <input type="date" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="termsCheck">
                                <label class="form-check-label" for="termsCheck">
                                    I agree to the borrowing terms
                                </label>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="processBorrow()">Confirm Borrow</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Reserve Modal -->
    <div class="modal fade" id="reserveModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Reserve "<%= book.getTitle() %>"</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="reserveForm">
                        <div class="mb-3">
                            <label class="form-label">User ID</label>
                            <input type="number" class="form-control" placeholder="Enter user ID" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Reservation Date</label>
                            <input type="date" class="form-control" required>
                        </div>
                        <p class="text-muted">
                            <i class="fas fa-info-circle me-1"></i>
                            This book will be reserved for you when it becomes available.
                        </p>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-info" onclick="processReservation()">Confirm Reservation</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function processBorrow() {
            alert('Borrow functionality will be implemented in Phase 2 (Transactions)');
            const borrowModal = bootstrap.Modal.getInstance(document.getElementById('borrowModal'));
            borrowModal.hide();
        }
        
        function processReservation() {
            alert('Reservation functionality will be implemented in Phase 2');
            const reserveModal = bootstrap.Modal.getInstance(document.getElementById('reserveModal'));
            reserveModal.hide();
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            document.querySelectorAll('input[type="date"]').forEach(input => {
                input.min = today;
             
                if (input.closest('#borrowModal')) {
                    const dueDate = new Date();
                    dueDate.setDate(dueDate.getDate() + 14);
                    input.value = dueDate.toISOString().split('T')[0];
                }
            });
        });
    </script>
</body>
</html>