<%-- 
    Document   : BorrarPelicula
    Created on : 30 dic 2023, 10:47:03
    Author     : gonzalo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Consulta de Salas</title>
</head>
<body>
    <h1>Borrado de Sala</h1>
    
    <div>
        <label for="sala">Selecciona una Sala:</label>
        <select id="sala"></select>
    </div>

    <button onclick="borrarSala()">Borrar</button>
    <button onclick="irAtras()">Atrás</button>

    <script>
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


        function borrarSala() {
            const select = document.getElementById('sala');
            const selectedSala = select.options[select.selectedIndex].value;

            fetch('GestionSalaServlet?sala=' + selectedSala, {
                method: 'DELETE'
            })
                .then(response => response.text())
                .then(data => {
                    alert(data);
                    obtenerSalas();
                })
                .catch(error => console.error('Error al borrar sala:', error));
        }

        function irAtras() {
            window.location.href = 'gestion.jsp';
        }

        window.onload = obtenerSalas;
    </script>
</body>
</html>



