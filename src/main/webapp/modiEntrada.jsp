<%-- 
    Document   : modiPelicula
    Created on : 30 dic 2023, 10:47:29
    Author     : gonzalo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
<head>
    <title>Formulario para modificar sala</title>
</head>
<body>
    <h1>Modificar sala</h1>
    <form action="GestionSalasServlet" method="post">
        <!-- Menú desplegable para seleccionar el número de sala -->
        <label for="numero_sala">Número de sala:</label>
        <select name="numero_sala" id="numero_sala">
            <option value="">Seleccionar número de sala</option> <!-- Opción en blanco -->
            <!-- Aquí se cargarán dinámicamente las salas desde la base de datos -->
        </select>
        <br>
        <!-- Resto de los campos del formulario -->
        Nombre de la Película:<br>
        <input type="text" name="nombre_pelicula"><br><br>
        Número de Filas:<br>
        <input type="number" name="filas"><br><br>
        Número de Columnas:<br>
        <input type="number" name="columnas"><br><br>
        
        <input type="submit" value="Modificar sala">
    </form>
    <button onclick="irAtras()">Atrás</button>
    <script>
        function irAtras() {
            window.location.href = 'gestion.jsp';
        }

        // Cargar los números de las salas desde el servidor
        fetch('GestionSalasServlet')
            .then(response => {
                if (response.ok) {
                    return response.text();
                } else {
                    throw new Error('Error al obtener las salas');
                }
            })
            .then(data => {
                // Crear un elemento div para procesar la respuesta HTML
                const tempDiv = document.createElement('div');
                tempDiv.innerHTML = data;

                // Obtener todas las filas de la tabla
                const rows = tempDiv.querySelectorAll('tr');

                // Obtener el select para añadir las opciones
                const select = document.getElementById('numero_sala');

                // Agregar la opción en blanco al principio
                const blankOption = document.createElement('option');
               
                select.appendChild(blankOption);

                // Iterar sobre las filas y extraer los números de las salas
                rows.forEach(row => {
                    const columns = row.querySelectorAll('td');
                    if (columns.length > 0) {
                        const numero_sala = columns[0].textContent;
                        const option = document.createElement('option');
                        option.value = numero_sala;
                        option.textContent = numero_sala;
                        select.appendChild(option);
                    }
                });
            })
            .catch(error => console.error('Error al obtener salas:', error));
    </script>
</body>
</html>
