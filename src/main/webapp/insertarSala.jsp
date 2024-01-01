<%-- 
    Document   : insertarSala
    Created on : 29 dic 2023, 12:34:37
    Author     : gonzalo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Formulario para Insertar Sala</title>
    </head>
    <body>
        <h1>Insertar Sala</h1>
        <form action="GestionSalasServlet" method="post">
            Nombre de Sala: <input type="text" name="nombrepelicula" required><br>
            
            Fila:<input type="number" name="fila" min="1" max="30"><br>
            Columna:<input type="number" name="columna" min="1" max="20"><br>
            

            <input type="submit" value="Insertar Sala">
        </form>
        <button onclick="irAtras()">Atrás</button>
        <script>
            function irAtras() {
            window.location.href = 'gestion.jsp';
        }
        </script>
    </body>
</html>