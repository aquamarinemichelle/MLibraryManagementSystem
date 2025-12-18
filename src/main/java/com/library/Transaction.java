
package com.library;

import java.util.Date;

public class Transaction {
    private int id;
    private int bookId;
    private int userId;
    private String userName;
    private String bookTitle;
    private Date borrowDate;
    private Date dueDate;
    private Date returnDate;
    private String status; 
    private double fineAmount;
    private String notes;
  
    public Transaction() {}
    
    public Transaction(int bookId, int userId, String userName, String bookTitle, 
                       Date borrowDate, Date dueDate, String status) {
        this.bookId = bookId;
        this.userId = userId;
        this.userName = userName;
        this.bookTitle = bookTitle;
        this.borrowDate = borrowDate;
        this.dueDate = dueDate;
        this.status = status;
        this.fineAmount = 0.0;
        this.notes = "";
    }
  
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }
    
    public Date getBorrowDate() { return borrowDate; }
    public void setBorrowDate(Date borrowDate) { this.borrowDate = borrowDate; }
    
    public Date getDueDate() { return dueDate; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }
    
    public Date getReturnDate() { return returnDate; }
    public void setReturnDate(Date returnDate) { this.returnDate = returnDate; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public double getFineAmount() { return fineAmount; }
    public void setFineAmount(double fineAmount) { this.fineAmount = fineAmount; }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
