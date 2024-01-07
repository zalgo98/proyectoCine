<%-- 
    Document   : BorrarPelicula
    Created on : 30 dic 2023, 10:47:03
    Author     : gonzalo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Consulta de Entradas</title>
</head>
<body>
    <h1>Consulta de Entradas</h1>

    <div>
        <label for="sala">Selecciona una Sala:</label>
        <select id="sala">
            <option value=""> </option>
        </select>
    </div>
<div id="entradaIdDiv" style="display: none;">
        <label for="idEntrada">Escribe el ID de la entrada:</label>
        <input type="text" id="idEntrada">
         <button onclick="borrarEntrada()">Borrar Entrada</button>
    </div>
    <div id="entradasDiv">
        <!-- Aquí se cargará la tabla con las entradas -->
    
    </div>

     <button onclick="mostrarInputEntrada()">Ver Entradas</button>
    
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
                    select.innerHTML = '<option value=""> </option>';

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
                .catch(error => console.error('Error al obtener salas: ', error));
        }
function mostrarInputEntrada() {
            const entradaIdDiv = document.getElementById('entradaIdDiv');
            obtenerEntradas();
            entradaIdDiv.style.display = 'block';
        }

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

function borrarEntrada() {
    const idEntrada = document.getElementById('idEntrada').value;

    if (idEntrada) {
        fetch(`GestionEntradasServlet?id_entrada=${idEntrada}`, {
            method: 'DELETE'
        })
            .then(response => {
                if (response.ok) {
                    return response.text();
                }
                throw new Error('No se pudo eliminar la entrada');
            })
            .then(data => {
                alert(data);
                obtenerEntradas(); // Actualizar la lista después de eliminar
            })
            .catch(error => {
                console.error('Error al borrar entrada por ID:', error.message || error);
            });
    } else {
        alert('Por favor, ingresa un ID de entrada válido');
    }
}
       function irAtras() {
            window.location.href = 'gestion.jsp';
        }

        window.onload = obtenerSalas;
    </script>
</body>
</html>
