<%-- 
    Document   : inicioSesion
    Created on : 27 dic 2023, 12:20:34
    Author     : gonzalo
--%>

<%@ page import="java.sql.*, javax.naming.*, javax.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Iniciar Sesión</title>
  <script>
    function submitForm() {
      // Aquí puedes realizar validaciones del formulario antes de enviarlo al servidor
      // Envía el formulario al servidor
      document.getElementById("loginForm").submit();
    }
  </script>
</head>
<body>

<h2>Iniciar Sesión</h2>

<form id="loginForm" action="comprobacion.jsp" method="post">
  <label for="username">Nombre de Usuario:</label>
  <input type="text" id="username" name="username" required><br><br>

  <label for="password">Contraseña:</label>
  <input type="password" id="password" name="password" required><br><br>

  <input type="button" value="Iniciar Sesión" onclick="submitForm()">
</form>

</body>
</html>
