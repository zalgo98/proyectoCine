<%-- 
    Document   : modiPelicula
    Created on : 30 dic 2023, 10:47:29
    Author     : gonzalo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Consulta de Películas</title>
</head>
<body>
    <h1>Modificado de Películas</h1>
    
    <div>
        <label for="pelicula">Selecciona una película:</label>
        <select id="pelicula">
            <option value=""> </option>
        </select>
    </div>
    <form>
        
        Sinopsis: <input type="text" name="sinopsis"><br>
        página Oficial: <input type="text" name="paginaoficial"><br>
        título Original: <input type="text" name="titulooriginal"><br>
        género: <input type="text" name="genero"><br>
        nacionalidad: <input type="text" name="nacionalidad"><br>
        duración: <input type="number" name="duracion" min="0" max="300"><br>
        año: <input type="number" name="anno" min="1800" max="3000"><br>
        distribuidora: <input type="text" name="distribuidora"><br>
        director: <input type="text" name="director"><br>
        actores: <input type="text" name="actores"><br>
        Clasificación de Edad:
        <select name="clasificacionedad">
            <option value="TP">TP</option>
            <option value="+13">+13</option>
            <option value="+16">+16</option>
            <option value="+18">+18</option>
        </select><br>
        otros Datos: <input type="text" name="otrosDatos"><br>

        
    </form>
    <button type="button" onclick="GuardarCambios()">Guardar cambios</button>
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
                     select.innerHTML = '<option value=""> </option>';

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

        function GuardarCambios() {
    const formulario = document.querySelector('form'); // Selecciona el formulario
    const formData = new FormData(formulario); // Obtiene los datos del formulario

    const select = document.getElementById('pelicula');
    const selectedPelicula = select.options[select.selectedIndex].textContent;

    formData.append('nombrepelicula', selectedPelicula); // Agrega la película seleccionada al formulario

    fetch('GestionPeliculasServlet?pelicula=' + selectedPelicula, {
                method: 'PUT'
    })
    .then(response => {
        if (response.ok) {
            return response.text();
        }
        throw new Error('Error al guardar los cambios');
    })
    .then(data => {
        alert(data); // Muestra la respuesta del servidor
        obtenerPeliculas(); // Actualiza la lista de películas después de editar
    })
    .catch(error => console.error('Error al guardar los cambios:', error));
}

        function irAtras() {
            window.location.href = 'gestion.jsp';
        }

        window.onload = obtenerPeliculas;
    </script>
</body>
</html>
