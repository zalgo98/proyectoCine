<%-- 
    Document   : insertarSala
    Created on : 29 dic 2023, 12:34:37
    Author     : gonzalo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Formulario Entradas de Cine</title>
</head>
<body>
    <h2>Introduce los datos de la entrada de cine:</h2>
    <form action="GestionEntradasServlet" method="post">
        Número de Sala:<br>
        <input type="text" name="numero_sala"><br><br>
        Nombre de la Película:<br>
        <input type="text" name="nombre_pelicula"><br><br>
        Número de Filas:<br>
        <input type="number" name="fila"><br><br>
        Número de Columnas:<br>
        <input type="number" name="columna"><br><br>
        <input type="submit" value="Ingresar entrada">
    </form>

    <!-- Botón de Atrás -->
    <form action="gestion.jsp">
        <input type="submit" value="Atrás">
    </form>
</body>
</html>
