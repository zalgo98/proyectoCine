<%-- 
    Document   : modiPelicula
    Created on : 30 dic 2023, 10:47:29
    Author     : gonzalo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edición de Películas</title>
</head>
<body>
    <h1>Consulta y Edición de Películas</h1>

    <label for="pelicula">Selecciona una película:</label>
    <select id="pelicula" onchange="mostrarDatosPelicula()">
        <!-- Aquí se llenará dinámicamente con las películas disponibles -->
    </select>

    <div>
        <input type="text" id="nombrePelicula" placeholder="Nombre de Película">
        <input type="text" id="sinopsis" placeholder="Sinopsis">
        <input type="text" id="paginaOficial" placeholder="Página Oficial">
        <!-- Otros campos de la película -->
        <input type="number" id="duracion" min="0" max="300" placeholder="Duración">
        <input type="number" id="anno" min="1800" max="3000" placeholder="Año">
        <input type="text" id="distribuidora" placeholder="Distribuidora">
        <input type="text" id="director" placeholder="Director">
        <input type="text" id="actores" placeholder="Actores">
        <select id="clasificacionEdad">
            <option value="TP">TP</option>
            <option value="+13">+13</option>
            <option value="+16">+16</option>
            <option value="+18">+18</option>
        </select>
        <input type="text" id="otrosDatos" placeholder="Otros Datos">
    </div>

    <button onclick="guardarCambios()">Guardar Cambios</button>
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
                        mostrarDatosPelicula();
                    }
                })
                .catch(error => console.error('Error al obtener películas:', error));
        }

        function mostrarDatosPelicula() {
            const select = document.getElementById('pelicula');
            const selectedPelicula = select.options[select.selectedIndex].textContent;

            fetch(`GestionPeliculasServlet?nombrepelicula=${selectedPelicula}`)
                .then(response => {
                    if (response.ok) {
                        return response.text();
                    }
                    throw new Error('Error en la respuesta del servidor');
                })
                .then(data => {
                    const datosPelicula = data.split(',');
                    document.getElementById('nombrePelicula').value = datosPelicula[0] || '';
                    document.getElementById('sinopsis').value = datosPelicula[1] || '';
                    document.getElementById('paginaOficial').value = datosPelicula[2] || '';
                    document.getElementById('duracion').value = datosPelicula[6] || '';
                    document.getElementById('anno').value = datosPelicula[7] || '';
                    document.getElementById('distribuidora').value = datosPelicula[8] || '';
                    document.getElementById('director').value = datosPelicula[9] || '';
                    document.getElementById('actores').value = datosPelicula[10] || '';
                    document.getElementById('clasificacionEdad').value = datosPelicula[11] || '';
                    document.getElementById('otrosDatos').value = datosPelicula[12] || '';
                })
                .catch(error => console.error('Error al obtener datos de película:', error));
        }

        function guardarCambios() {
    const nombrePelicula = document.getElementById('nombrePelicula').value;
    const sinopsis = document.getElementById('sinopsis').value;
    const paginaOficial = document.getElementById('paginaOficial').value;
    const duracion = document.getElementById('duracion').value;
    const anno = document.getElementById('anno').value;
    const distribuidora = document.getElementById('distribuidora').value;
    const director = document.getElementById('director').value;
    const actores = document.getElementById('actores').value;
    const clasificacionEdad = document.getElementById('clasificacionEdad').value;
    const otrosDatos = document.getElementById('otrosDatos').value;

    fetch('GestionPeliculasServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: `nombrepelicula=${nombrePelicula}&sinopsis=${sinopsis}&paginaoficial=${paginaOficial}&duracion=${duracion}&anno=${anno}&distribuidora=${distribuidora}&director=${director}&actores=${actores}&clasificacionedad=${clasificacionEdad}&otrosDatos=${otrosDatos}`
    })
    .then(response => {
        if (response.ok) {
            // Realizar alguna acción si la actualización fue exitosa
            console.log('Cambios guardados exitosamente');
        } else {
            throw new Error('Error al guardar los cambios');
        }
    })
    .catch(error => console.error('Error al guardar cambios:', error));
}


        function irAtras() {
            window.location.href = 'gestion.jsp';
        }

        window.onload = obtenerPeliculas;
    </script>
</body>
</html>
