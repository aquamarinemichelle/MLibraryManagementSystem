package com.library;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
    }
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            logout(request, response);
        } else if ("checkUsername".equals(action)) {
            checkUsernameAvailability(request, response);
        } else {
           
            response.sendRedirect("login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("login".equals(action)) {
            login(request, response);
        } else if ("logout".equals(action)) {
            logout(request, response);
        } else if ("register".equals(action)) {
            register(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }
    
    private void login(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
      
        System.out.println("AuthServlet: Login attempt for user: " + username);
        
        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            System.out.println("AuthServlet: Empty username or password");
            response.sendRedirect("login.jsp?error=empty");
            return;
        }
       
        username = username.trim();
        password = password.trim();
      
        User user = userDAO.authenticate(username, password);
        
        if (user != null) {
            System.out.println("AuthServlet: Database authentication successful for: " + username);
            System.out.println("AuthServlet: User role: " + user.getRole());
            
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("fullName", user.getFullName());
            
            session.setMaxInactiveInterval(30 * 60);
          
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);
    
            if ("admin".equals(user.getRole())) {
                System.out.println("AuthServlet: Redirecting admin to admin-dashboard.jsp");
                response.sendRedirect("admin-dashboard.jsp");
            } else {
                System.out.println("AuthServlet: Redirecting user to user-dashboard.jsp");
                response.sendRedirect("user-dashboard.jsp");
            }
        } else {
        
            System.out.println("AuthServlet: Database authentication failed for: " + username);
         
            if (checkDemoCredentials(username, password)) {
                System.out.println("AuthServlet: Demo credentials matched for: " + username);
              
                User demoUser = createDemoUser(username);
           
                HttpSession session = request.getSession(true);
                session.setAttribute("user", demoUser);
                session.setAttribute("role", demoUser.getRole());
                session.setAttribute("username", demoUser.getUsername());
                session.setAttribute("fullName", demoUser.getFullName());
               
                session.setMaxInactiveInterval(30 * 60);
               
                response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                response.setHeader("Pragma", "no-cache");
                response.setDateHeader("Expires", 0);
            
                if ("admin".equals(demoUser.getRole())) {
                    System.out.println("AuthServlet: Redirecting demo admin to admin-dashboard.jsp");
                    response.sendRedirect("admin-dashboard.jsp");
                } else {
                    System.out.println("AuthServlet: Redirecting demo user to user-dashboard.jsp");
                    response.sendRedirect("user-dashboard.jsp");
                }
            } else {
              
                System.out.println("AuthServlet: All authentication attempts failed for: " + username);
                response.sendRedirect("login.jsp?error=invalid");
            }
        }
    }
    
    private void register(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String zipCode = request.getParameter("zipCode");
        
        System.out.println("AuthServlet: Registration attempt for user: " + username);
   
        if (username == null || password == null || email == null || firstName == null || lastName == null ||
            username.trim().isEmpty() || password.trim().isEmpty() || email.trim().isEmpty() || 
            firstName.trim().isEmpty() || lastName.trim().isEmpty()) {
            System.out.println("AuthServlet: Empty required fields");
            response.sendRedirect("register.jsp?error=empty_fields");
            return;
        }
     
        username = username.trim();
        password = password.trim();
        email = email.trim();
        firstName = firstName.trim();
        lastName = lastName.trim();
    
        if (!password.equals(confirmPassword)) {
            System.out.println("AuthServlet: Passwords do not match");
            response.sendRedirect("register.jsp?error=password_mismatch");
            return;
        }
    
        if (userDAO.usernameExists(username)) {
            System.out.println("AuthServlet: Username already exists: " + username);
            response.sendRedirect("register.jsp?error=username_taken");
            return;
        }
     
        if (userDAO.emailExists(email)) {
            System.out.println("AuthServlet: Email already exists: " + email);
            response.sendRedirect("register.jsp?error=email_taken");
            return;
        }
   
        String fullName = firstName + " " + lastName;
     
        User newUser = new User(username, password, email, "user", fullName);
      
        boolean success = userDAO.registerUser(newUser);
        
        if (success) {
            System.out.println("AuthServlet: Registration successful for: " + username);
           
            User user = userDAO.authenticate(username, password);
            if (user != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);
                session.setAttribute("role", user.getRole());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("fullName", user.getFullName());
                
                session.setMaxInactiveInterval(30 * 60);
              
                response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                response.setHeader("Pragma", "no-cache");
                response.setDateHeader("Expires", 0);
               
                response.sendRedirect("user-dashboard.jsp");
            } else {
               
                response.sendRedirect("login.jsp?success=registered");
            }
        } else {
            System.out.println("AuthServlet: Registration failed for: " + username);
            response.sendRedirect("register.jsp?error=registration_failed");
        }
    }
    
    private void checkUsernameAvailability(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String username = request.getParameter("username");
        
        if (username == null || username.trim().isEmpty()) {
            response.getWriter().write("{\"available\": false, \"message\": \"Username is required\"}");
            return;
        }
        
        username = username.trim();
        boolean exists = userDAO.usernameExists(username);
  
        String jsonResponse;
        if (exists) {
            jsonResponse = "{\"available\": false, \"message\": \"Username already taken\"}";
        } else {
            jsonResponse = "{\"available\": true, \"message\": \"Username available\"}";
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonResponse);
    }

    private boolean checkDemoCredentials(String username, String password) {
     
        if ("admin".equals(username) && "admin123".equals(password)) {
            return true;
        } else if (("john".equals(username) || "jane".equals(username)) && "user123".equals(password)) {
            return true;
        }
        return false;
    }
 
    private User createDemoUser(String username) {
        User user = new User();
        user.setUsername(username);
        
        if ("admin".equals(username)) {
            user.setRole("admin");
            user.setFullName("Administrator");
            user.setEmail("admin@library.com");
        } else if ("john".equals(username)) {
            user.setRole("user");
            user.setFullName("John Doe");
            user.setEmail("john@email.com");
        } else if ("jane".equals(username)) {
            user.setRole("user");
            user.setFullName("Jane Smith");
            user.setEmail("jane@email.com");
        } else {
            user.setRole("user");
            user.setFullName(username);
        }
        
        return user;
    }
    
    private void logout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            System.out.println("AuthServlet: Logging out user: " + session.getAttribute("username"));
            session.invalidate();
        }

        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        response.sendRedirect("login.jsp?error=logout");
    }
}