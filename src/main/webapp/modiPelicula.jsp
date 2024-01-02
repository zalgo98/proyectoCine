<%-- 
    Document   : modiPelicula
    Created on : 30 dic 2023, 10:47:29
    Author     : gonzalo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Modificar Películas</title>
</head>
<body>
    <h2>Modificar Películas</h2>

    <div class="container">
        <h1>Consulta de Películas</h1>
        <table id="peliculasTable">
            <!-- Aquí se cargarán dinámicamente los datos de las películas -->
        </table>
        <button onclick="guardarCambios()">Guardar Cambios</button>
    </div>

    <script>
        window.onload = function() {
            obtenerPeliculas();
        };

        function obtenerPeliculas() {
            fetch('GestionPeliculasServlet')
                .then(response => {
                    if (response.ok) {
                        return response.text();
                    }
                    throw new Error('Error en la respuesta del servidor');
                })
                .then(data => {
                    const peliculasTable = document.getElementById('peliculasTable');
                    peliculasTable.innerHTML = data;
                })
                .catch(error => console.error('Error al obtener películas:', error));
        }

        function guardarCambios() {
            const peliculasTable = document.getElementById('peliculasTable');
            const rows = peliculasTable.querySelectorAll('tr');

            const datosActualizados = [];

            rows.forEach(row => {
                const inputs = row.querySelectorAll('input');
                const rowData = [];

                inputs.forEach(input => {
                    rowData.push(input.value);
                });

                datosActualizados.push(rowData);
            });

            fetch('GuardarCambiosServlet', {
                method: 'EDIT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(datosActualizados)
            })
            .then(response => {
                if (response.ok) {
                    // Actualización exitosa, puedes hacer algo aquí si lo deseas
                    console.log('Cambios guardados exitosamente');
                } else {
                    throw new Error('Error al guardar cambios');
                }
            })
            .catch(error => console.error('Error al guardar cambios:', error));
        }
    </script>
</body>
</html>

