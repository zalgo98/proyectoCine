/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 *
 * @author gonzalo
 */
@WebServlet(urlPatterns = {"/prueba"})
public class prueba extends HttpServlet {
private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            connection = DriverManager.getConnection("jdbc:derby://localhost:1527/sample", "app", "app");

            String query = "SELECT * FROM usuarios WHERE usuario = ? AND contraseña = ?";
            statement = connection.prepareStatement(query);
            statement.setString(1, username);
            statement.setString(5, password);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                PreparedStatement adminStatement = null;
                ResultSet adminResultSet = null;
                boolean isAdmin = false;
                try {
                    String adminQuery = "SELECT * FROM administracion WHERE usuario = ?";
                    adminStatement = connection.prepareStatement(adminQuery);
                    adminStatement.setString(1, username);
                    adminResultSet = adminStatement.executeQuery();

                    isAdmin = adminResultSet.next();
                } finally {
                    if (adminResultSet != null) adminResultSet.close();
                    if (adminStatement != null) adminStatement.close();
                }

                if (isAdmin) {
                    response.sendRedirect("gestion.jsp");
                } else {
                    HttpSession session = request.getSession();
                    session.setAttribute("username", username);
                    response.sendRedirect("index.html");
                }
            } else {
                response.sendRedirect("inicioSesion.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}

