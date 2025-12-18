package com.library;

import database.DatabaseConfig;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {
    private static final String URL = DatabaseConfig.URL;
    private static final String USER = DatabaseConfig.USER;
    private static final String PASSWORD = DatabaseConfig.PASSWORD;
    
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
    
    
    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books ORDER BY id DESC";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Book book = extractBookFromResultSet(rs);
                books.add(book);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all books: " + e.getMessage());
            e.printStackTrace();
        }
        
        return books;
    }
    
   
    public boolean addBook(Book book) {
        String sql = "INSERT INTO books (title, author, isbn, year, category, description, available) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, book.getTitle());
            pstmt.setString(2, book.getAuthor());
            pstmt.setString(3, book.getIsbn());
            pstmt.setInt(4, book.getYear());
            pstmt.setString(5, book.getCategory());
            pstmt.setString(6, book.getDescription());
            pstmt.setBoolean(7, book.isAvailable());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding book: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    
    public Book getBookById(int id) {
        String sql = "SELECT * FROM books WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractBookFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting book by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
 
    public boolean updateBook(Book book) {
        String sql = "UPDATE books SET title = ?, author = ?, isbn = ?, year = ?, " +
                     "category = ?, description = ?, available = ? WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, book.getTitle());
            pstmt.setString(2, book.getAuthor());
            pstmt.setString(3, book.getIsbn());
            pstmt.setInt(4, book.getYear());
            pstmt.setString(5, book.getCategory());
            pstmt.setString(6, book.getDescription());
            pstmt.setBoolean(7, book.isAvailable());
            pstmt.setInt(8, book.getId());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating book: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
   
    public boolean deleteBook(int id) {
        String sql = "DELETE FROM books WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting book: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
   
    public List<Book> searchBooks(String keyword) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE title LIKE ? OR author LIKE ? OR isbn LIKE ? " +
                     "OR category LIKE ? ORDER BY id DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            pstmt.setString(4, searchPattern);
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Book book = extractBookFromResultSet(rs);
                books.add(book);
            }
            
        } catch (SQLException e) {
            System.err.println("Error searching books: " + e.getMessage());
            e.printStackTrace();
        }
        
        return books;
    }
    
  
    public int getAvailableBooksCount() {
        String sql = "SELECT COUNT(*) FROM books WHERE available = true";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting available books count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
   
    public int getTotalBooksCount() {
        String sql = "SELECT COUNT(*) FROM books";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting total books count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
   
    private Book extractBookFromResultSet(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setId(rs.getInt("id"));
        book.setTitle(rs.getString("title"));
        book.setAuthor(rs.getString("author"));
        book.setIsbn(rs.getString("isbn"));
        book.setYear(rs.getInt("year"));
        book.setCategory(rs.getString("category"));
        book.setDescription(rs.getString("description"));
        book.setAvailable(rs.getBoolean("available"));
        return book;
    }
}