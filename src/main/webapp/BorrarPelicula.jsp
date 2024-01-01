<%-- 
    Document   : BorrarPelicula
    Created on : 30 dic 2023, 10:47:03
    Author     : gonzalo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Consulta de Películas</title>
</head>
<body>
    <h1>Borrado de Películas</h1>
    
    <div>
        <label for="pelicula">Selecciona una película:</label>
        <select id="pelicula"></select>
    </div>

    <button onclick="borrarPelicula()">Borrar</button>
    <button onclick="irAtras()">Atrás</button>

    <script>
        function obtenerPeliculas() {
            fetch('GestionPeliculasServlet')
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

                    const select = document.getElementById('pelicula');
                    select.innerHTML = '';

                    for (let i = 1; i < tableRows.length; i++) {
                        const columns = tableRows[i].querySelectorAll('td');
                        if (columns.length > 0) {
                            const nombrePelicula = columns[0].textContent;
                            const option = document.createElement('option');
                            option.textContent = nombrePelicula;
                            select.appendChild(option);
                        }
                    }
                })
                .catch(error => console.error('Error al obtener películas:', error));
        }

        function borrarPelicula() {
            const select = document.getElementById('pelicula');
            const selectedPelicula = select.options[select.selectedIndex].value;

            fetch('GestionPeliculasServlet?pelicula=' + selectedPelicula, {
                method: 'DELETE'
            })
                .then(response => response.text())
                .then(data => {
                    alert(data);
                    obtenerPeliculas();
                })
                .catch(error => console.error('Error al borrar película:', error));
        }

        function irAtras() {
            window.location.href = 'gestion.jsp';
        }

        window.onload = obtenerPeliculas;
    </script>
</body>
</html>


