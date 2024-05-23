<%-- 
    Document   : modiPelicula
    Created on : 30 dic 2023, 10:47:29
    Author     : gonzalo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
<head>
    <title>Formulario para modificar entrada</title>
</head>
<body>
    <h1>Modificar entrada</h1>
    <form action="GestionEntradasServlet" method="post">
        <!-- Menú desplegable para seleccionar el número de sala -->
        <label for="Id_entradas">Id de la entrada:</label>
        <select name="Id_entradas" id="Id_entradas">
            <option value="">Seleccionar número de id de entrada</option> <!-- Opción en blanco -->
            <!-- Aquí se cargarán dinámicamente las salas desde la base de datos -->
        </select>
        <br>
        <!-- Resto de los campos del formulario -->
        Número de sala:<br>
        <input type="number" name="numero_sala"><br><br>
        Nombre de la Película:<br>
        <input type="text" name="nombre_pelicula"><br><br>
        Número de Filas:<br>
        <input type="number" name="filas"><br><br>
        Número de Columnas:<br>
        <input type="number" name="columnas"><br><br>
        
        <input type="submit" value="Modificar Entrada">
    </form>
    <button onclick="irAtras()">Atrás</button>
    <script>
        function irAtras() {
            window.location.href = 'gestion.jsp';
        }

        // Cargar los números de las salas desde el servidor
         fetch('GestionEntradasServlet')
            .then(response => {
                if (response.ok) {
                    return response.text();
                } else {
                    throw new Error('Error al obtener las entradas');
                }
            })
            .then(data => {
                // Crear un elemento div para procesar la respuesta HTML
                const tempDiv = document.createElement('div');
                tempDiv.innerHTML = data;

                // Obtener todas las filas de la tabla
                const rows = tempDiv.querySelectorAll('tr');

                // Obtener el select para añadir las opciones
                const select = document.getElementById('Id_entradas');

                // Agregar la opción en blanco al principio
                const blankOption = document.createElement('option');
                

                // Iterar sobre las filas y extraer los IDs de las entradas
                rows.forEach(row => {
                    const columns = row.querySelectorAll('td');
                    if (columns.length > 0) {
                        const idEntrada = columns[0].textContent;
                        const option = document.createElement('option');
                        option.value = idEntrada;
                        option.textContent = idEntrada;
                        select.appendChild(option);
                    }
                });
            })
            .catch(error => console.error('Error al obtener IDs de entradas:', error));
    </script>
</body>
</html>