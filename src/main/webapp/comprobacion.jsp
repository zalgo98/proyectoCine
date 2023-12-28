<%-- 
    Document   : comprobacion
    Created on : 27 dic 2023, 13:38:24
    Author     : gonzalo
--%>

<%@ page import="java.sql.*, javax.naming.*, javax.sql.*" %>
<%
Connection connection = null;
PreparedStatement statement = null;
ResultSet resultSet = null;

try {
    // Establecer la conexión con la base de datos
    Class.forName("org.apache.derby.jdbc.ClientDriver");
    connection = DriverManager.getConnection("jdbc:derby://localhost:1527/sample", "app", "app");

    // Obtener los parámetros del formulario
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    // Consulta para verificar las credenciales del usuario en la tabla de usuarios
    String query = "SELECT * FROM usuarios WHERE usuario = ? AND contraseña = ?";
    statement = connection.prepareStatement(query);
    statement.setString(1, username);
    statement.setString(2, password);
    resultSet = statement.executeQuery();

    if (resultSet.next()) {
        // Verificar si el usuario está en la tabla de administración
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
            // Cerrar recursos de la consulta de administración
            if (adminResultSet != null) adminResultSet.close();
            if (adminStatement != null) adminStatement.close();
        }

        if (isAdmin) {
            // Usuario es administrador, redirigir a la página de gestión
            response.sendRedirect("gestion.jsp");
        } else {
            // Si las credenciales son válidas pero no es administrador, redirigir a la página de inicio
            session.setAttribute("username", username);
            response.sendRedirect("index.html");
        }
    } else {
        // Si las credenciales no son válidas, redirigir de nuevo a la página de inicio de sesión
        response.sendRedirect("inicioSesion.jsp");
    }
} catch (Exception e) {
    // Manejar excepciones
    e.printStackTrace();
} finally {
    // Cerrar recursos
    try {
        if (resultSet != null) resultSet.close();
        if (statement != null) statement.close();
        if (connection != null) connection.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
}
%>

