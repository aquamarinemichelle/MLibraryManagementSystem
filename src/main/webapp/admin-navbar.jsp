
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    jakarta.servlet.http.HttpSession userSession = request.getSession(false);
    String username = (userSession != null) ? (String) userSession.getAttribute("username") : null;
%>

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
            <a class="nav-link <%= request.getRequestURI().contains("admin-dashboard") ? "active" : "" %>" 
               href="admin-dashboard.jsp">
                <i class="fas fa-tachometer-alt"></i> Dashboard
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link <%= request.getRequestURI().contains("BookServlet") || request.getRequestURI().contains("books.jsp") ? "active" : "" %>" 
               href="BookServlet">
                <i class="fas fa-book"></i> All Books
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link <%= request.getRequestURI().contains("add-book.jsp") ? "active" : "" %>" 
               href="add-book.jsp">
                <i class="fas fa-plus-circle"></i> Add New Book
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link <%= request.getRequestURI().contains("users.jsp") ? "active" : "" %>" 
               href="users.jsp">
                <i class="fas fa-users"></i> Manage Users
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link <%= request.getRequestURI().contains("transactions.jsp") || request.getRequestURI().contains("TransactionServlet") ? "active" : "" %>" 
               href="TransactionServlet">
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

<style>
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

.sidebar .nav-link i {
    width: 25px;
    text-align: center;
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

.sidebar-footer {
    border-top: 1px solid rgba(255,255,255,0.1);
}
</style>
