<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Book</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .form-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 30px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .form-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px 10px 0 0;
            margin: -30px -30px 30px -30px;
        }
    </style>
</head>
<body>
    <div class="container py-5">
        <div class="form-container">
            <div class="form-header">
                <h2 class="mb-0">
                    <i class="fas fa-plus-circle me-2"></i>
                    Add New Book
                </h2>
                <p class="mb-0">Fill in the book details below</p>
            </div>

            <form action="BookServlet?action=add" method="post">
                <div class="mb-3">
                    <label class="form-label">Book Title *</label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-heading"></i>
                        </span>
                        <input type="text" class="form-control" name="title" 
                               placeholder="Enter book title" required>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">Author *</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-user"></i>
                            </span>
                            <input type="text" class="form-control" name="author" 
                                   placeholder="Author name" required>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">ISBN *</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-barcode"></i>
                            </span>
                            <input type="text" class="form-control" name="isbn" 
                                   placeholder="10 or 13 digits" required>
                        </div>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">Publication Year</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-calendar"></i>
                            </span>
                            <input type="number" class="form-control" name="year" 
                                   min="1000" max="2100" placeholder="2023">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Category</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-tags"></i>
                            </span>
                            <select class="form-select" name="category">
                                <option value="Fiction">Fiction</option>
                                <option value="Non-Fiction">Non-Fiction</option>
                                <option value="Science">Science</option>
                                <option value="Technology">Technology</option>
                                <option value="Literature">Literature</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea class="form-control" name="description" 
                              rows="3" placeholder="Book description..."></textarea>
                </div>

                <div class="mb-4">
                    <label class="form-label">Availability</label>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="available" 
                               id="availableYes" value="true" checked>
                        <label class="form-check-label" for="availableYes">
                            <i class="fas fa-check-circle text-success me-1"></i>
                            Available for borrowing
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="available" 
                               id="availableNo" value="false">
                        <label class="form-check-label" for="availableNo">
                            <i class="fas fa-times-circle text-danger me-1"></i>
                            Currently unavailable
                        </label>
                    </div>
                </div>

                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                    <a href="books.jsp" class="btn btn-secondary me-md-2">
                        <i class="fas fa-times me-1"></i>Cancel
                    </a>
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-save me-1"></i>Add Book
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>