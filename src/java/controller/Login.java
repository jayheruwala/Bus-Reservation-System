
package controller;

import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;
import model.User;
import dao.UserDAO;
import jakarta.servlet.http.HttpSession;

import util.DatabaseUtil;


public class Login extends HttpServlet {

 
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Login</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Login at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

  
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        RequestDispatcher dispatcher;
        Connection connection;
        HttpSession session = request.getSession();
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        try{
             connection = DatabaseUtil.getConnection();
        }catch(SQLException e){
            out.print("Error found : " + e.getMessage());
            return;
        }
      
        if(connection != null ){
            
            PreparedStatement findUser  = null;
            ResultSet findUserResultSet = null;
            try{
                findUser = connection.prepareStatement("select * from users where email=? and password=?");
                findUser.setString(1, email);
                findUser.setString(2, password);
                
                
                findUserResultSet = findUser.executeQuery();
                
                if(findUserResultSet.next()){
                    UserDAO ud = new UserDAO();
                   User user = ud.getUserByUserName(email);
                   
                   session.setAttribute("user", user);
                   session.setMaxInactiveInterval(30 * 60);
                   response.sendRedirect("index.jsp");
                    
                    
                }else{
                    request.setAttribute("UserNotFound", "Invalid Email Id and Password");
                    dispatcher = request.getRequestDispatcher("login.jsp");
                    dispatcher.forward(request, response);
                }
                
                
            }catch(SQLException e){
                
            }
            
            
        }
        
        
        
    }

  
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
