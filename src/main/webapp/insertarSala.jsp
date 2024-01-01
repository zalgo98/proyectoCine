<%-- 
    Document   : insertarSala
    Created on : 29 dic 2023, 12:34:37
    Author     : gonzalo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Formulario Sala de Cine</title>
</head>
<body>
    <h2>Introduce los datos de la sala de cine:</h2>
    <form action="GestionSalasServlet" method="post">
        Número de Sala:<br>
        <input type="text" name="numero_sala"><br><br>
        Nombre de la Película:<br>
        <input type="text" name="nombre_pelicula"><br><br>
        Número de Filas:<br>
        <input type="number" name="filas"><br><br>
        Número de Columnas:<br>
        <input type="number" name="columnas"><br><br>
        <input type="submit" value="Ingresar sala">
    </form>
</body>
</html>
