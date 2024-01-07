<%-- 
    Document   : consultarPelis
    Created on : 30 dic 2023, 10:47:40
    Author     : gonzalo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Consulta de Sala</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }

        .container {
            width: 80%;
            margin: 20px auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            background-color: #fff;
        }

        h1 {
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Consulta de Salas</h1>
        <table id="salasTable">
            <!-- Aquí se cargarán dinámicamente los datos de las salas -->
        </table>
    </div>

    <script>
        window.onload = function() {
            obtenerSalas(); // Corregí el paréntesis faltante aquí
        };

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

                    const table = document.getElementById('salasTable');
                    table.innerHTML = ''; // Limpiar la tabla antes de cargar los datos

                    // Agregar títulos de columna
                    const columnHeaders = tableRows[0].querySelectorAll('th');
                    const headerRow = document.createElement('tr');
                    columnHeaders.forEach(header => {
                        const headerCell = document.createElement('th');
                        headerCell.textContent = header.textContent;
                        headerRow.appendChild(headerCell);
                    });
                    table.appendChild(headerRow);

                    // Agregar filas de datos
                    for (let i = 1; i < tableRows.length; i++) {
                        const columns = tableRows[i].querySelectorAll('td');
                        if (columns.length > 0) {
                            const row = document.createElement('tr');
                            columns.forEach(column => {
                                const cell = document.createElement('td');
                                cell.textContent = column.textContent;
                                row.appendChild(cell);
                            });
                            table.appendChild(row);
                        }
                    }
                })
                .catch(error => console.error('Error al obtener salas: ', error));
        }
    </script>
</body>
</html>