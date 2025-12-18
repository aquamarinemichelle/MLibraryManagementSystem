
package com.library;

import database.DatabaseConfig;
import java.sql.*;
import java.util.*;
import java.util.Date;

public class TransactionDAO {
    private static final String URL = DatabaseConfig.URL;
    private static final String USER = DatabaseConfig.USER;
    private static final String PASSWORD = DatabaseConfig.PASSWORD;
    
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("DEBUG: MySQL JDBC Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            System.err.println("ERROR: Failed to load MySQL JDBC Driver");
            e.printStackTrace();
        }
    }
    
    private Connection getConnection() throws SQLException {
        try {
            System.out.println("DEBUG: Attempting database connection to: " + URL);
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("DEBUG: Database connection successful");
            return conn;
        } catch (SQLException e) {
            System.err.println("ERROR: Database connection failed");
            System.err.println("URL: " + URL);
            System.err.println("User: " + USER);
            System.err.println("Error: " + e.getMessage());
            throw e;
        }
    }
    
    public boolean addTransaction(Transaction transaction) {
        System.out.println("DEBUG: ========== ADD TRANSACTION START ==========");
        System.out.println("DEBUG: Book ID: " + transaction.getBookId());
        System.out.println("DEBUG: User ID: " + transaction.getUserId());
        System.out.println("DEBUG: User Name: " + transaction.getUserName());
        System.out.println("DEBUG: Book Title: " + transaction.getBookTitle());
        System.out.println("DEBUG: Due Date: " + transaction.getDueDate());

        String sql = "INSERT INTO transactions (book_id, user_id, user_name, book_title, due_date, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = getConnection();
            System.out.println("DEBUG: Got database connection");
            
            System.out.println("DEBUG: Preparing SQL: " + sql);
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setInt(1, transaction.getBookId());
            pstmt.setInt(2, transaction.getUserId());
            pstmt.setString(3, transaction.getUserName());
            pstmt.setString(4, transaction.getBookTitle());
            pstmt.setDate(5, new java.sql.Date(transaction.getDueDate().getTime()));
            pstmt.setString(6, "borrowed"); 
            
            System.out.println("DEBUG: Executing SQL");
            int rows = pstmt.executeUpdate();
            System.out.println("DEBUG: Rows affected: " + rows);
            
            if (rows > 0) {
                System.out.println("DEBUG: Transaction added successfully!");
                return true;
            } else {
                System.out.println("DEBUG: No rows affected");
                return false;
            }
            
        } catch (SQLException e) {
            System.err.println("ERROR in addTransaction: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            System.err.println("SQL: " + sql);
            e.printStackTrace();
         
            System.err.println("Parameters:");
            System.err.println("  book_id: " + transaction.getBookId());
            System.err.println("  user_id: " + transaction.getUserId());
            System.err.println("  user_name: " + transaction.getUserName());
            System.err.println("  book_title: " + transaction.getBookTitle());
            System.err.println("  due_date: " + transaction.getDueDate());
            
            return false;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
                System.out.println("DEBUG: Database resources closed");
            } catch (SQLException e) {
                System.err.println("ERROR closing resources: " + e.getMessage());
            }
            System.out.println("DEBUG: ========== ADD TRANSACTION END ==========");
        }
    }
    
    public boolean addTransactionWithBorrowDate(Transaction transaction) {
        System.out.println("DEBUG: ========== ADD TRANSACTION WITH BORROW DATE ==========");
     
        String sql = "INSERT INTO transactions (book_id, user_id, user_name, book_title, borrow_date, due_date, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, transaction.getBookId());
            pstmt.setInt(2, transaction.getUserId());
            pstmt.setString(3, transaction.getUserName());
            pstmt.setString(4, transaction.getBookTitle());
            pstmt.setTimestamp(5, new Timestamp(transaction.getBorrowDate().getTime()));
            pstmt.setDate(6, new java.sql.Date(transaction.getDueDate().getTime()));
            pstmt.setString(7, "borrowed");
            
            int rows = pstmt.executeUpdate();
            System.out.println("DEBUG: Rows affected (with borrow_date): " + rows);
            return rows > 0;
            
        } catch (SQLException e) {
            System.err.println("ERROR in addTransactionWithBorrowDate: " + e.getMessage());
            System.err.println("SQL: " + sql);
            e.printStackTrace();
            return false;
        }
    }
   
    public boolean returnBook(int transactionId, Date returnDate, double fineAmount, String notes) {
        String sql = "UPDATE transactions SET return_date = ?, status = 'returned', " +
                     "fine_amount = ?, notes = ? WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setTimestamp(1, new Timestamp(returnDate.getTime()));
            pstmt.setDouble(2, fineAmount);
            pstmt.setString(3, notes);
            pstmt.setInt(4, transactionId);
            
            int rows = pstmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            System.err.println("Error returning book: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<Transaction> getAllTransactions() {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM transactions ORDER BY borrow_date DESC";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                transactions.add(extractTransactionFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all transactions: " + e.getMessage());
            e.printStackTrace();
        }
        
        return transactions;
    }

    public List<Transaction> getTransactionsByUserId(int userId) {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM transactions WHERE user_id = ? ORDER BY borrow_date DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                transactions.add(extractTransactionFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting user transactions: " + e.getMessage());
            e.printStackTrace();
        }
        
        return transactions;
    }
  
    public List<Transaction> getActiveBorrowings() {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM transactions WHERE status IN ('borrowed', 'overdue') " +
                     "ORDER BY due_date";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                transactions.add(extractTransactionFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting active borrowings: " + e.getMessage());
            e.printStackTrace();
        }
        
        return transactions;
    }
  
    public List<Transaction> getOverdueTransactions() {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM transactions WHERE status = 'overdue' " +
                     "ORDER BY due_date";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                transactions.add(extractTransactionFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting overdue transactions: " + e.getMessage());
            e.printStackTrace();
        }
        
        return transactions;
    }
  
    public Transaction getTransactionById(int id) {
        String sql = "SELECT * FROM transactions WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractTransactionFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting transaction by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
   
    public Map<String, Integer> getTransactionStats() {
        Map<String, Integer> stats = new HashMap<>();
        String[] statuses = {"borrowed", "returned", "overdue"};
        
        for (String status : statuses) {
            String sql = "SELECT COUNT(*) as count FROM transactions WHERE status = ?";
            try (Connection conn = getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {
                
                pstmt.setString(1, status);
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    stats.put(status, rs.getInt("count"));
                }
                
            } catch (SQLException e) {
                System.err.println("Error getting transaction stats: " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        return stats;
    }
   
    public void updateOverdueStatus() {
        String sql = "UPDATE transactions SET status = 'overdue' " +
                     "WHERE status = 'borrowed' AND due_date < CURRENT_DATE()";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            
            stmt.executeUpdate(sql);
            
        } catch (SQLException e) {
            System.err.println("Error updating overdue status: " + e.getMessage());
            e.printStackTrace();
        }
    }
  
    private Transaction extractTransactionFromResultSet(ResultSet rs) throws SQLException {
        Transaction transaction = new Transaction();
        transaction.setId(rs.getInt("id"));
        transaction.setBookId(rs.getInt("book_id"));
        transaction.setUserId(rs.getInt("user_id"));
        transaction.setUserName(rs.getString("user_name"));
        transaction.setBookTitle(rs.getString("book_title"));
        transaction.setBorrowDate(rs.getTimestamp("borrow_date"));
        transaction.setDueDate(rs.getDate("due_date"));
        
        Timestamp returnDate = rs.getTimestamp("return_date");
        if (returnDate != null) {
            transaction.setReturnDate(returnDate);
        }
        
        transaction.setStatus(rs.getString("status"));
        transaction.setFineAmount(rs.getDouble("fine_amount"));
        transaction.setNotes(rs.getString("notes"));
        
        return transaction;
    }
}
