
package com.library;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.*;
import java.text.SimpleDateFormat;

public class TransactionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TransactionDAO transactionDAO;
    private BookDAO bookDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() {
        try {
            transactionDAO = new TransactionDAO();
            bookDAO = new BookDAO();
            userDAO = new UserDAO();
            System.out.println("DEBUG: TransactionServlet initialized successfully");
        } catch (Exception e) {
            System.err.println("ERROR: Failed to initialize TransactionServlet: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            System.out.println("DEBUG: No session found for admin check");
            return false;
        }
        String role = (String) session.getAttribute("role");
        System.out.println("DEBUG: Admin check - Role: " + role);
        return "admin".equals(role);
    }
    
    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            System.out.println("DEBUG: No session found for login check");
            return false;
        }
        String username = (String) session.getAttribute("username");
        boolean loggedIn = username != null;
        System.out.println("DEBUG: Login check - Username: " + username + ", Logged in: " + loggedIn);
        return loggedIn;
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("DEBUG: TransactionServlet doGet called");
        System.out.println("DEBUG: Request URL: " + request.getRequestURL());
        System.out.println("DEBUG: Query String: " + request.getQueryString());
        
        if (!isLoggedIn(request)) {
            System.out.println("DEBUG: User not logged in, redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        System.out.println("DEBUG: Action parameter: " + action);
        
        if (action == null) {
            action = "list";
            System.out.println("DEBUG: No action specified, defaulting to 'list'");
        }
        
        try {
            switch (action) {
                case "mytransactions":
                    System.out.println("DEBUG: Calling viewUserTransactions");
                    viewUserTransactions(request, response);
                    break;
                case "return":
                    System.out.println("DEBUG: Calling showReturnForm");
                    showReturnForm(request, response);
                    break;
                case "borrow":
                    System.out.println("DEBUG: Calling borrowBook via GET");
                    borrowBook(request, response);
                    break;
                default:
                    System.out.println("DEBUG: Calling listTransactions");
                    listTransactions(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("ERROR in TransactionServlet doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=" + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("DEBUG: TransactionServlet doPost called");
        System.out.println("DEBUG: Request URL: " + request.getRequestURL());
        
        if (!isLoggedIn(request)) {
            System.out.println("DEBUG: User not logged in, redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        System.out.println("DEBUG: Action parameter: " + action);
        
        try {
            if ("borrow".equals(action)) {
                System.out.println("DEBUG: Calling borrowBook via POST");
                borrowBook(request, response);
            } else if ("return".equals(action)) {
                System.out.println("DEBUG: Calling returnBook");
                returnBook(request, response);
            } else {
                System.out.println("DEBUG: No valid action, calling listTransactions");
                listTransactions(request, response);
            }
        } catch (Exception e) {
            System.err.println("ERROR in TransactionServlet doPost: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=" + e.getMessage());
        }
    }
    
    private void listTransactions(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("DEBUG: listTransactions called");
       
        if (!isAdmin(request)) {
            System.out.println("DEBUG: User is not admin, redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            System.out.println("DEBUG: Getting all transactions from DAO");
            List<Transaction> transactions = transactionDAO.getAllTransactions();
            System.out.println("DEBUG: Found " + transactions.size() + " transactions");
            
            Map<String, Integer> stats = transactionDAO.getTransactionStats();
            System.out.println("DEBUG: Got transaction stats: " + stats);
            
            request.setAttribute("transactions", transactions);
            request.setAttribute("stats", stats);
            request.getRequestDispatcher("transactions.jsp").forward(request, response);
            System.out.println("DEBUG: Forwarded to transactions.jsp");
            
        } catch (Exception e) {
            System.err.println("ERROR in listTransactions: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=Failed to load transactions: " + e.getMessage());
        }
    }
    
    private void viewUserTransactions(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("DEBUG: viewUserTransactions called");
        
        try {
            HttpSession session = request.getSession();
            String username = (String) session.getAttribute("username");
            System.out.println("DEBUG: Getting transactions for user: " + username);
            
            User user = userDAO.getUserByUsername(username);
            
            if (user == null) {
                System.out.println("DEBUG: User not found in database for username: " + username);
                request.setAttribute("error", "User not found");
            } else {
                System.out.println("DEBUG: User found - ID: " + user.getId() + ", Name: " + user.getFullName());
                List<Transaction> transactions = transactionDAO.getTransactionsByUserId(user.getId());
                System.out.println("DEBUG: Found " + transactions.size() + " transactions for user");
                
                request.setAttribute("transactions", transactions);
                request.setAttribute("user", user);
            }
            
            request.getRequestDispatcher("my-transactions.jsp").forward(request, response);
            System.out.println("DEBUG: Forwarded to my-transactions.jsp");
            
        } catch (Exception e) {
            System.err.println("ERROR in viewUserTransactions: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=Failed to load user transactions: " + e.getMessage());
        }
    }
    
    private void borrowBook(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        System.out.println("DEBUG: ========== BORROW BOOK START ==========");
        
        if (!isLoggedIn(request)) {
            System.out.println("DEBUG: User not logged in");
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
          
            String bookIdParam = request.getParameter("bookId");
            String dueDateStr = request.getParameter("dueDate");
            
            System.out.println("DEBUG: Parameters received:");
            System.out.println("DEBUG: - bookId: " + bookIdParam);
            System.out.println("DEBUG: - dueDate: " + dueDateStr);
           
            if (bookIdParam == null || bookIdParam.trim().isEmpty()) {
                System.out.println("DEBUG: bookId parameter is null or empty");
                response.sendRedirect("books-user.jsp?error=Book ID is required");
                return;
            }
            
            if (dueDateStr == null || dueDateStr.trim().isEmpty()) {
                System.out.println("DEBUG: dueDate parameter is null or empty");
                response.sendRedirect("books-user.jsp?error=Due date is required");
                return;
            }
            
            int bookId = Integer.parseInt(bookIdParam);
            System.out.println("DEBUG: Parsed bookId: " + bookId);
            
            System.out.println("DEBUG: Testing database connection...");
            try {
              
                Book testBook = bookDAO.getBookById(1); 
                System.out.println("DEBUG: BookDAO connection test passed");
            } catch (Exception e) {
                System.err.println("DEBUG: BookDAO connection test failed: " + e.getMessage());
            }
         
            System.out.println("DEBUG: Getting book with ID: " + bookId);
            Book book = bookDAO.getBookById(bookId);
            
            if (book == null) {
                System.out.println("DEBUG: Book not found, ID: " + bookId);
                response.sendRedirect("books-user.jsp?error=Book not found (ID: " + bookId + ")");
                return;
            }
            
            System.out.println("DEBUG: Book found - Title: " + book.getTitle() + ", Available: " + book.isAvailable());
            
            if (!book.isAvailable()) {
                System.out.println("DEBUG: Book is not available for borrowing");
                response.sendRedirect("books-user.jsp?error=Book '" + book.getTitle() + "' is not available for borrowing");
                return;
            }
            
            HttpSession session = request.getSession();
            String username = (String) session.getAttribute("username");
            System.out.println("DEBUG: Username from session: " + username);
            
            User user = userDAO.getUserByUsername(username);
            
            if (user == null) {
                System.out.println("DEBUG: User not found in database: " + username);
                response.sendRedirect("login.jsp?error=User session expired");
                return;
            }
            
            System.out.println("DEBUG: User found - ID: " + user.getId() + ", Name: " + user.getFullName());
        
            System.out.println("DEBUG: Parsing due date: " + dueDateStr);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date dueDate = sdf.parse(dueDateStr);
            Date borrowDate = new Date();
            
            System.out.println("DEBUG: Parsed dates - Borrow: " + borrowDate + ", Due: " + dueDate);
          
            Transaction transaction = new Transaction(
                bookId,
                user.getId(),
                user.getFullName(),
                book.getTitle(),
                borrowDate,
                dueDate,
                "borrowed"
            );
            
            System.out.println("DEBUG: Created transaction object:");
            System.out.println("DEBUG: - Book ID: " + transaction.getBookId());
            System.out.println("DEBUG: - User ID: " + transaction.getUserId());
            System.out.println("DEBUG: - User Name: " + transaction.getUserName());
            System.out.println("DEBUG: - Book Title: " + transaction.getBookTitle());
            System.out.println("DEBUG: - Borrow Date: " + transaction.getBorrowDate());
            System.out.println("DEBUG: - Due Date: " + transaction.getDueDate());
            System.out.println("DEBUG: - Status: " + transaction.getStatus());
            
            System.out.println("DEBUG: Attempting to add transaction to database");
      
            boolean success = transactionDAO.addTransaction(transaction);
         
            if (!success) {
                System.out.println("DEBUG: Main method failed, trying alternative method");
                success = transactionDAO.addTransactionWithBorrowDate(transaction);
            }
            
            if (success) {
                System.out.println("DEBUG: Transaction added successfully!");
            
                System.out.println("DEBUG: Updating book availability to false");
                book.setAvailable(false);
                boolean bookUpdated = bookDAO.updateBook(book);
                System.out.println("DEBUG: Book availability updated: " + bookUpdated);
                
                if (bookUpdated) {
                    String successMessage = "Book '" + book.getTitle() + "' borrowed successfully. Due date: " + dueDateStr;
                    System.out.println("DEBUG: Success - " + successMessage);
                    response.sendRedirect("my-transactions.jsp?success=" + 
                                         java.net.URLEncoder.encode(successMessage, "UTF-8"));
                } else {
                    System.out.println("DEBUG: Failed to update book availability");
                    response.sendRedirect("books-user.jsp?error=Book borrowed but availability not updated");
                }
            } else {
                System.out.println("DEBUG: ALL METHODS FAILED to add transaction");
                response.sendRedirect("books-user.jsp?error=Failed to process borrowing. Please try again or contact administrator.");
            }
            
        } catch (NumberFormatException e) {
            System.err.println("ERROR: Invalid book ID format");
            System.err.println("ERROR Details: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("books-user.jsp?error=Invalid book ID format. Please try again.");
        } catch (java.text.ParseException e) {
            System.err.println("ERROR: Invalid date format");
            System.err.println("ERROR Details: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("books-user.jsp?error=Invalid date format. Please use YYYY-MM-DD format.");
        } catch (Exception e) {
            System.err.println("CRITICAL ERROR in borrowBook: " + e.getMessage());
            System.err.println("ERROR Type: " + e.getClass().getName());
            e.printStackTrace();
            response.sendRedirect("books-user.jsp?error=System error: " + 
                                 e.getClass().getSimpleName() + " - " + e.getMessage());
        }
        
        System.out.println("DEBUG: ========== BORROW BOOK END ==========");
    }
    
    private void showReturnForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("DEBUG: showReturnForm called");
        
        if (!isAdmin(request)) {
            System.out.println("DEBUG: User is not admin");
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            String transactionIdParam = request.getParameter("id");
            System.out.println("DEBUG: Transaction ID parameter: " + transactionIdParam);
            
            if (transactionIdParam == null || transactionIdParam.trim().isEmpty()) {
                System.out.println("DEBUG: No transaction ID provided");
                response.sendRedirect("transactions.jsp?error=Transaction ID is required");
                return;
            }
            
            int transactionId = Integer.parseInt(transactionIdParam);
            System.out.println("DEBUG: Looking up transaction with ID: " + transactionId);
            
            Transaction transaction = transactionDAO.getTransactionById(transactionId);
            
            if (transaction == null) {
                System.out.println("DEBUG: Transaction not found, ID: " + transactionId);
                response.sendRedirect("transactions.jsp?error=Transaction not found (ID: " + transactionId + ")");
                return;
            }
            
            System.out.println("DEBUG: Transaction found - Book: " + transaction.getBookTitle() + 
                              ", User: " + transaction.getUserName());
            
            request.setAttribute("transaction", transaction);
            request.getRequestDispatcher("return-book.jsp").forward(request, response);
            System.out.println("DEBUG: Forwarded to return-book.jsp");
            
        } catch (NumberFormatException e) {
            System.err.println("ERROR: Invalid transaction ID format");
            e.printStackTrace();
            response.sendRedirect("transactions.jsp?error=Invalid transaction ID");
        } catch (Exception e) {
            System.err.println("ERROR in showReturnForm: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("transactions.jsp?error=Error loading return form: " + e.getMessage());
        }
    }
    
    private void returnBook(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        System.out.println("DEBUG: ========== RETURN BOOK START ==========");
        
        if (!isAdmin(request)) {
            System.out.println("DEBUG: User is not admin");
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            String transactionIdParam = request.getParameter("transactionId");
            String condition = request.getParameter("condition");
            String notes = request.getParameter("notes");
            String lateReturnParam = request.getParameter("lateReturn");
            
            System.out.println("DEBUG: Return parameters:");
            System.out.println("DEBUG: - transactionId: " + transactionIdParam);
            System.out.println("DEBUG: - condition: " + condition);
            System.out.println("DEBUG: - notes: " + notes);
            System.out.println("DEBUG: - lateReturn: " + lateReturnParam);
            
            if (transactionIdParam == null || transactionIdParam.trim().isEmpty()) {
                System.out.println("DEBUG: No transaction ID provided");
                response.sendRedirect("transactions.jsp?error=Transaction ID is required");
                return;
            }
            
            int transactionId = Integer.parseInt(transactionIdParam);
            System.out.println("DEBUG: Processing return for transaction ID: " + transactionId);
            
            Transaction transaction = transactionDAO.getTransactionById(transactionId);
            if (transaction == null) {
                System.out.println("DEBUG: Transaction not found, ID: " + transactionId);
                response.sendRedirect("transactions.jsp?error=Transaction not found (ID: " + transactionId + ")");
                return;
            }
            
            System.out.println("DEBUG: Transaction found - Book: " + transaction.getBookTitle() + 
                              ", User: " + transaction.getUserName() + ", Due: " + transaction.getDueDate());
            
            Date returnDate = new Date();
            double fineAmount = 0.0;
          
            boolean lateReturn = "on".equals(lateReturnParam);
            System.out.println("DEBUG: Late return flag: " + lateReturn);
            
            if (lateReturn && returnDate.after(transaction.getDueDate())) {
                long diff = returnDate.getTime() - transaction.getDueDate().getTime();
                long daysLate = diff / (1000 * 60 * 60 * 24);
                fineAmount = daysLate * 0.50; 
                System.out.println("DEBUG: Late by " + daysLate + " days, Fine: $" + fineAmount);
            }
            
            System.out.println("DEBUG: Updating transaction in database");
            
            boolean success = transactionDAO.returnBook(transactionId, returnDate, fineAmount, notes);
            
            if (success) {
                System.out.println("DEBUG: Transaction updated successfully");
             
                System.out.println("DEBUG: Updating book availability to true");
                Book book = bookDAO.getBookById(transaction.getBookId());
                if (book != null) {
                    book.setAvailable(true);
                    boolean bookUpdated = bookDAO.updateBook(book);
                    System.out.println("DEBUG: Book availability updated: " + bookUpdated);
                    
                    if (bookUpdated) {
                        String successMessage = "Book '" + book.getTitle() + "' returned successfully";
                        if (fineAmount > 0) {
                            successMessage += " (Fine: $" + String.format("%.2f", fineAmount) + ")";
                        }
                        System.out.println("DEBUG: Success - " + successMessage);
                        response.sendRedirect("transactions.jsp?success=" + 
                                             java.net.URLEncoder.encode(successMessage, "UTF-8"));
                    } else {
                        System.out.println("DEBUG: Failed to update book availability");
                        response.sendRedirect("transactions.jsp?error=Book returned but availability not updated");
                    }
                } else {
                    System.out.println("DEBUG: Book not found for ID: " + transaction.getBookId());
                    response.sendRedirect("transactions.jsp?error=Book not found");
                }
            } else {
                System.out.println("DEBUG: Failed to update transaction");
                response.sendRedirect("transactions.jsp?error=Failed to process return");
            }
            
        } catch (NumberFormatException e) {
            System.err.println("ERROR: Invalid transaction ID format");
            e.printStackTrace();
            response.sendRedirect("transactions.jsp?error=Invalid transaction ID");
        } catch (Exception e) {
            System.err.println("ERROR in returnBook: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("transactions.jsp?error=Error processing return: " + e.getMessage());
        }
        
        System.out.println("DEBUG: ========== RETURN BOOK END ==========");
    }
}
