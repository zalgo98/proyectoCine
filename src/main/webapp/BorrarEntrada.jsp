<%-- 
    Document   : BorrarPelicula
    Created on : 30 dic 2023, 10:47:03
    Author     : gonzalo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Consulta de Salas y Entradas</title>
    </head>
    <body>
        <h1>Consulta de Salas y Entradas</h1>

        <div>
            <label for="sala">Selecciona una Sala:</label>
            <select id="sala" onchange="obtenerEntradas()">
                <!-- Aquí se cargarán las salas dinámicamente -->
            </select>
        </div>

        <div id="entradasDiv">
            <!-- Aquí se cargará la tabla con las entradas -->
        </div>

        <button onclick="borrarEntradas()">Borrar Entradas</button>
        <button onclick="irAtras()">Atrás</button>

        <script>
            function obtenerEntradas() {
                const selectSala = document.getElementById('sala');
                const selectedSala = selectSala.options[selectSala.selectedIndex].value;

                fetch(`GestionEntradasServlet?numero_sala=${selectedSala}`)
                        .then(response => {
                            if (response.ok) {
                                return response.text();
                            }
                            throw new Error('Error en la respuesta del servidor');
                        })
                        .then(data => {
                            const entradasDiv = document.getElementById('entradasDiv');
                            entradasDiv.innerHTML = data;
                        })
                        .catch(error => console.error('Error al obtener entradas: ', error));
            }

            function obtenerSalas() {
                fetch('GestionSalasServlet')
                        .then(response => {
                            if (response.ok) {
                                return response.text();
                            }
                            throw new Error('Error en la respuesta del servidor');
                        })
                        .then(data => {
                            const parser = new DOMParser();
                            const htmlDocument = parser.parseFromString(data, 'text/html');
                            const tableRows = htmlDocument.querySelectorAll('tr');

                            const select = document.getElementById('sala');
                            select.innerHTML = '';

                            for (let i = 1; i < tableRows.length; i++) {
                                const columns = tableRows[i].querySelectorAll('td');
                                if (columns.length > 0) {
                                    const numero_sala = columns[0].textContent;
                                    const option = document.createElement('option');
                                    option.textContent = numero_sala;
                                    select.appendChild(option);
                                }
                            }
                        })
                        .catch(error => console.error('Error al obtener sala: ', error));
            }

            function borrarEntradas() {
                const checkboxes = document.querySelectorAll('input[type="checkbox"]:checked');
                const entradasSeleccionadas = Array.from(checkboxes).map(checkbox => checkbox.value);

                fetch('GestionEntradasServlet?entradas=' + entradasSeleccionadas.join(','), {
                    method: 'DELETE'
                })
                        .then(response => {
                            if (response.ok) {
                                return response.text();
                            }
                            throw new Error('Error al borrar entradas');
                        })
                        .then(data => {
                            alert(data);
                            obtenerEntradas();
                        })
                        .catch(error => console.error('Error al borrar entradas:', error));
            }

            function irAtras() {
                window.location.href = 'gestion.jsp';
            }

            document.getElementById('sala').addEventListener('change', obtenerEntradas);

            window.onload = () => {
                obtenerSalas();
                obtenerEntradas();
            };
        </script>
    </body>
</html>
