<%-- 
    Document   : inicioSesion
    Created on : 27 dic 2023, 12:20:34
    Author     : gonzalo
--%>

<%@ page import="java.sql.*, javax.naming.*, javax.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Iniciar Sesi�n</title>
  <script>
    function submitForm() {
      // Aqu� puedes realizar validaciones del formulario antes de enviarlo al servidor
      // Env�a el formulario al servidor
      document.getElementById("loginForm").submit();
    }
  </script>
</head>
<body>

<h2>Iniciar Sesi�n</h2>

<form id="loginForm" action="comprobacion.jsp" method="post">
  <label for="username">Nombre de Usuario:</label>
  <input type="text" id="username" name="username" required><br><br>

  <label for="password">Contrase�a:</label>
  <input type="password" id="password" name="password" required><br><br>

  <input type="button" value="Iniciar Sesi�n" onclick="submitForm()">
</form>

</body>
</html>
