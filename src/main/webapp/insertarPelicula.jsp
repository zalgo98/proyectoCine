<%-- 
    Document   : insertarPelicula
    Created on : 29 dic 2023, 12:34:37
    Author     : gonzalo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Formulario para Insertar Película</title>
    </head>
    <body>
        <h1>Insertar Pelicula</h1>
        <form action="GestionPeliculasServlet" method="post">
            Nombre de Pelicula: <input type="text" name="nombrepelicula" required><br>
            Sinopsis: <input type="text" name="sinopsis"><br>
            pagina Oficial:<input type="text" name="paginaoficial"><br>
            titulo Original:<input type="text" name="titulooriginal"><br>
            genero:<input type="text" name="genero"><br>
            nacionalidad:<input type="text" name="nacionalidad"><br>
            duracion:<input type="number" name="duracion" min="0" max="300"><br>
            año:<input type="number" name="anno" min="1800" max="3000"><br>
            distribuidora:<input type="text" name="distribuidora"><br>
            director:<input type="text" name="director"><br>
            actores:<input type="text" name="actores"><br>
            Clasificacion de Edad:
            <select name="clasificacionedad">
                <option value="TP">TP</option>
                <option value="+13">+13</option>
                <option value="+16">+16</option>
                <option value="+18">+18</option>
            </select><br>
            otros Datos:<input type="text" name="otrosDatos"><br>

            <input type="submit" value="Insertar Pelicula">
        </form>
        <button onclick="irAtras()">Atrás</button>
        <script>
            function irAtras() {
            window.location.href = 'gestion.jsp';
        }
        </script>
    </body>
</html>