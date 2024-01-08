<%-- 
    Document   : gestion
    Created on : 27 dic 2023, 12:43:37
    Author     : gonzalo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Cine</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h1>Gestión de Cine</h1>
        <div class="row">
            <div class="col-md-4">
                <h2>Gestión de Películas</h2>
                
                <button type="button" onclick="window.location.href = 'insertarPelicula.jsp';">Insertar</button>
                <button type="button" onclick="window.location.href = 'BorrarPelicula.jsp';">Borrar</button>
                <button type="button" onclick="window.location.href = 'modiPelicula.jsp';">Modificar</button>
                <button type="button" onclick="window.location.href = 'consultarPelis.jsp';">Consultar</button>
            </div>
            <div class="col-md-4">
                <h2>Gestión de Salas</h2>
                <button type="button" onclick="window.location.href = 'insertarSala.jsp';">Insertar</button>
                <button type="button" onclick="window.location.href = 'BorrarSala.jsp';">Borrar</button>
                <button type="button" onclick="window.location.href = 'modiSala.jsp';">Modificar</button>
                <button type="button" onclick="window.location.href = 'consultarSala.jsp';">Consultar</button>
            </div>
            <div class="col-md-4">
                <h2>Gestión de Entradas</h2>
                <button type="button" onclick="window.location.href = 'insertarEntrada.jsp';">Insertar</button>
                <button type="button" onclick="window.location.href = 'BorrarEntrada.jsp';">Borrar</button>
                <button type="button" onclick="window.location.href = 'modiEntrada.jsp';">Modificar</button>
                <button type="button" onclick="window.location.href = 'consultarEntradas.jsp'">Consultar</button>
            </div>
        </div>
        <div class="row">
            <div class="col-md-4">
                <h2>Gestión de Informes</h2>
                <button type="button" class="btn btn-info">Listado de Películas por Género</button>
                <button type="button" class="btn btn-info">Listado de Películas por Salas</button>
                <!-- Otros botones para informes -->
            </div>
        </div>
    </div>
</body>
</html>
