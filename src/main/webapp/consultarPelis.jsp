<%-- 
    Document   : consultarPelis
    Created on : 30 dic 2023, 10:47:40
    Author     : gonzalo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Consulta de Películas</title>
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
        <h1>Consulta de Películas</h1>
        <table id="peliculasTable">
            <!-- Aquí se cargarán dinámicamente los datos de las películas -->
        </table>
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
    </script>
</body>
</html>
