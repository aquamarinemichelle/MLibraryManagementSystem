
CREATE DATABASE mlibrarydb;
USE mlibrarydb;

CREATE TABLE books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    year INT,
    category VARCHAR(100),
    description TEXT,
    available BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Sample data
INSERT INTO books (title, author, isbn, year, category, description, available) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', '9780743273565', 1925, 'Fiction', 'A classic novel of the Jazz Age', true),
('To Kill a Mockingbird', 'Harper Lee', '9780061120084', 1960, 'Fiction', 'A novel about racial injustice in the American South', true),
('1984', 'George Orwell', '9780451524935', 1949, 'Fiction', 'A dystopian social science fiction novel', false),
('The Catcher in the Rye', 'J.D. Salinger', '9780316769488', 1951, 'Fiction', 'A story about teenage alienation and loss', true),
('The Hobbit', 'J.R.R. Tolkien', '9780547928227', 1937, 'Fantasy', 'A fantasy novel about Bilbo Baggins', true),
('Pride and Prejudice', 'Jane Austen', '9780141439518', 1813, 'Romance', 'A romantic novel of manners', true),
('The Da Vinci Code', 'Dan Brown', '9780307474278', 2003, 'Mystery', 'A mystery thriller novel', false),
('Harry Potter and the Sorcerer''s Stone', 'J.K. Rowling', '9780590353427', 1997, 'Fantasy', 'The first book in the Harry Potter series', true),
('The Alchemist', 'Paulo Coelho', '9780062315007', 1988, 'Fiction', 'A philosophical book about following your dreams', true),
('Thinking, Fast and Slow', 'Daniel Kahneman', '9780374533557', 2011, 'Science', 'A book about psychology and behavioral economics', true);

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    role VARCHAR(20) DEFAULT 'user',
    full_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- default users
INSERT INTO users (username, password, email, role, full_name) VALUES
('admin', 'admin123', 'admin@library.com', 'admin', 'Library Admin'),
('john', 'user123', 'john@email.com', 'user', 'John Doe'),
('jane', 'user123', 'jane@email.com', 'user', 'Jane Smith');

CREATE TABLE transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    user_id INT NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    book_title VARCHAR(200) NOT NULL,
    borrow_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    due_date DATE NOT NULL,
    return_date TIMESTAMP NULL,
    status ENUM('borrowed', 'returned', 'overdue') DEFAULT 'borrowed',
    fine_amount DECIMAL(10,2) DEFAULT 0.00,
    notes TEXT,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);


CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_book_id ON transactions(book_id);
CREATE INDEX idx_transactions_status ON transactions(status);
CREATE INDEX idx_transactions_due_date ON transactions(due_date);