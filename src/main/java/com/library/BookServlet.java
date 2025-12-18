
package com.library;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class BookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookDAO bookDAO;
    
    @Override
    public void init() {
        bookDAO = new BookDAO();
    }
    
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && "admin".equals(session.getAttribute("role"));
    }
   
    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("user") != null;
    }
 
    private String getUserRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (String) session.getAttribute("role") : null;
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "delete":
                    deleteBook(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "view":
                    viewBook(request, response);
                    break;
                case "search":
                    searchBooks(request, response);
                    break;
                default:
                    listBooks(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "add":
                    addBook(request, response);
                    break;
                case "update":
                    updateBook(request, response);
                    break;
                default:
                    listBooks(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
    
    private void listBooks(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
       
        if (!isLoggedIn(request)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String role = getUserRole(request);
        request.setAttribute("userRole", role);
        request.setAttribute("books", bookDAO.getAllBooks());
       
        if ("admin".equals(role)) {
            request.getRequestDispatcher("books.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("books-user.jsp").forward(request, response);
        }
    }
    
    private void addBook(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
       
        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String isbn = request.getParameter("isbn");
        int year = request.getParameter("year") != null && !request.getParameter("year").isEmpty() 
                  ? Integer.parseInt(request.getParameter("year")) : 2023;
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        boolean available = Boolean.parseBoolean(request.getParameter("available"));
        
        Book newBook = new Book(title, author, isbn, year, category, description, available);
        bookDAO.addBook(newBook);
        
        response.sendRedirect("BookServlet");
    }
    
    private void deleteBook(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        bookDAO.deleteBook(id);
        response.sendRedirect("BookServlet");
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        Book existingBook = bookDAO.getBookById(id);
        request.setAttribute("book", existingBook);
        request.getRequestDispatcher("edit-book.jsp").forward(request, response);
    }
    
    private void updateBook(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
       
        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String isbn = request.getParameter("isbn");
        int year = Integer.parseInt(request.getParameter("year"));
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        boolean available = Boolean.parseBoolean(request.getParameter("available"));
        
        Book book = new Book(title, author, isbn, year, category, description, available);
        book.setId(id);
        bookDAO.updateBook(book);
        
        response.sendRedirect("BookServlet");
    }
    
    private void viewBook(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
       
        if (!isLoggedIn(request)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        Book book = bookDAO.getBookById(id);
        
        if (book == null) {
            response.sendRedirect("BookServlet");
            return;
        }
        
        String role = getUserRole(request);
        request.setAttribute("userRole", role);
        request.setAttribute("book", book);
        
        if ("admin".equals(role)) {
            request.getRequestDispatcher("view-book.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("view-book-user.jsp").forward(request, response);
        }
    }
    
    private void searchBooks(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
     
        if (!isLoggedIn(request)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String keyword = request.getParameter("keyword");
        String role = getUserRole(request);
        
        request.setAttribute("userRole", role);
        request.setAttribute("books", bookDAO.searchBooks(keyword));
        request.setAttribute("searchKeyword", keyword);
    
        if ("admin".equals(role)) {
            request.getRequestDispatcher("books.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("books-user.jsp").forward(request, response);
        }
    }
}
