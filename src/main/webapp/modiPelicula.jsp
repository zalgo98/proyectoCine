<%-- 
    Document   : modiPelicula
    Created on : 30 dic 2023, 10:47:29
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
        <!-- Menú desplegable para seleccionar el nombre de la película -->
        <label for="nombrePelicula">Nombre de Pelicula:</label>
        <select name="nombrepelicula" id="nombrePelicula">
            <!-- Aquí se cargarán dinámicamente los nombres de las películas desde la base de datos -->
        </select>
        <br>
        <!-- Resto de los campos del formulario -->
        Sinopsis: <input type="text" name="sinopsis"><br>
        Página Oficial:<input type="text" name="paginaoficial"><br>
        Título Original:<input type="text" name="titulooriginal"><br>
        Género:<input type="text" name="genero"><br>
        Nacionalidad:<input type="text" name="nacionalidad"><br>
        Duración:<input type="number" name="duracion" min="0" max="300"><br>
        Año:<input type="number" name="anno" min="1800" max="3000"><br>
        Distribuidora:<input type="text" name="distribuidora"><br>
        Director:<input type="text" name="director"><br>
        Actores:<input type="text" name="actores"><br>
        Clasificación de Edad:
        <select name="clasificacionedad">
            <option value="TP">TP</option>
            <option value="+13">+13</option>
            <option value="+16">+16</option>
            <option value="+18">+18</option>
        </select><br>
        Otros Datos:<input type="text" name="otrosDatos"><br>

        <input type="submit" value="Modificar Pelicula">
    </form>
    <button onclick="irAtras()">Atrás</button>
    <script>
        function irAtras() {
            window.location.href = 'gestion.jsp';
        }

        // Cargar los nombres de las películas desde el servidor
        fetch('GestionPeliculasServlet')
            .then(response => {
                if (response.ok) {
                    return response.text();
                } else {
                    throw new Error('Error al obtener nombres de películas');
                }
            })
            .then(data => {
                // Crear un elemento div para procesar la respuesta HTML
                const tempDiv = document.createElement('div');
                tempDiv.innerHTML = data;

                // Obtener todas las filas de la tabla
                const rows = tempDiv.querySelectorAll('tr');

                // Obtener el select para añadir las opciones
                const select = document.getElementById('nombrePelicula');

                // Iterar sobre las filas y extraer los nombres de las películas
                rows.forEach(row => {
                    const columns = row.querySelectorAll('td');
                    if (columns.length > 0) {
                        const nombrePelicula = columns[0].textContent;
                        const option = document.createElement('option');
                        option.value = nombrePelicula;
                        option.textContent = nombrePelicula;
                        select.appendChild(option);
                    }
                });
            })
            .catch(error => console.error('Error al obtener nombres de películas:', error));
    </script>
</body>
</html>
