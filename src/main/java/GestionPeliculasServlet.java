/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import java.sql.Connection;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author gonzalo
 */
@WebServlet(urlPatterns = {"/GestionPeliculasServlet"})
public class GestionPeliculasServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private Connection conn;

    @Override
    public void init() throws ServletException {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            this.conn = DriverManager.getConnection("jdbc:derby://localhost:1527/sample","app", "app");
            
        } catch (Exception e) {
            throw new ServletException("Error de inicialización: " + e.getMessage());
        }
    }

    @Override
    public void destroy() {
        try {
            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(GestionPeliculasServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String nombrePelicula = request.getParameter("nombrepelicula");
        String sinopsis = request.getParameter("sinopsis");
        String paginaOficial = request.getParameter("paginaoficial");
        String tituloOriginal = request.getParameter("titulooriginal");
        String genero = request.getParameter("genero");
        String nacionalidad = request.getParameter("nacionalidad");
        String duracion = (request.getParameter("duracion"));
        int anno = Integer.parseInt(request.getParameter("anno"));
        String distribuidora = request.getParameter("distribuidora");
        String director = request.getParameter("director");
        String actores = request.getParameter("actores");
        String clasificacionEdad = request.getParameter("clasificacionedad");
        String otrosDatos = request.getParameter("otrosDatos");
        
        try {
            String query = "INSERT INTO Peliculas (nombrepelicula, sinopsis, paginaoficial, titulooriginal, genero, nacionalidad, duracion,anno, distribuidora, director, actores, clasificacionedad, otrosDatos) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement statement = this.conn.prepareStatement(query)) {
                statement.setString(1, nombrePelicula);
                statement.setString(2, sinopsis);
                statement.setString(3, paginaOficial);
                statement.setString(4, tituloOriginal);
                statement.setString(5, genero);
                statement.setString(6, nacionalidad);
                statement.setString(7, duracion);
                statement.setInt(8, anno);
                statement.setString(9, distribuidora);
                statement.setString(10, director);
                statement.setString(11, actores);
                statement.setString(12, clasificacionEdad);
                statement.setString(13, otrosDatos);

                statement.executeUpdate();
            }

            response.sendRedirect("gestion.jsp");
        } catch (SQLException e) {
            throw new ServletException("Error en la inserción de película: " + e.getMessage());
        }
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    try {
        Statement statement = conn.createStatement();
        ResultSet resultSet = statement.executeQuery("SELECT nombrepelicula, director, duracion, anno FROM Peliculas");

        StringBuilder peliculasHTML = new StringBuilder();
        peliculasHTML.append("<tr><th>Nombre</th><th>Director</th><th>Duración</th><th>Anno</th></tr>");

        while (resultSet.next()) {
            String nombre = resultSet.getString("nombrepelicula");
            String director = resultSet.getString("director");
            String duracion = resultSet.getString("duracion");
            String anno = resultSet.getString("anno");

            peliculasHTML.append("<tr>");
            peliculasHTML.append("<td>").append(nombre).append("</td>");
            peliculasHTML.append("<td>").append(director).append("</td>");
            peliculasHTML.append("<td>").append(duracion).append("</td>");
            peliculasHTML.append("<td>").append(anno).append("</td>");
            peliculasHTML.append("</tr>");
        }

        response.setContentType("text/html");
        response.getWriter().write("<table>" + peliculasHTML.toString() + "</table>");
    } catch (SQLException e) {
        throw new ServletException("Error al obtener películas: " + e.getMessage());
    }
}
protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String nombrePelicula = request.getParameter("nombrepelicula");
    // Obtener los demás parámetros necesarios para la película

    try {
        // Query SQL para actualizar los datos de la película en la base de datos
        String query = "UPDATE Peliculas SET sinopsis=?, paginaoficial=?, titulooriginal=?, genero=?, nacionalidad=?, duracion=?, anno=?, distribuidora=?, director=?, actores=?, clasificacionedad=?, otrosDatos=? WHERE nombrepelicula=?";

        try (PreparedStatement statement = this.conn.prepareStatement(query)) {
            // Establecer los valores de los parámetros para la actualización
            statement.setString(1, request.getParameter("sinopsis"));
            statement.setString(2, request.getParameter("paginaoficial"));
            statement.setString(3, request.getParameter("titulooriginal"));
            statement.setString(4, request.getParameter("genero"));
            statement.setString(5, request.getParameter("nacionalidad"));
            statement.setString(6, request.getParameter("duracion"));
            statement.setInt(7, Integer.parseInt(request.getParameter("anno")));
            statement.setString(8, request.getParameter("distribuidora"));
            statement.setString(9, request.getParameter("director"));
            statement.setString(10, request.getParameter("actores"));
            statement.setString(11, request.getParameter("clasificacionedad"));
            statement.setString(12, request.getParameter("otrosDatos"));
            statement.setString(13, nombrePelicula); // Usamos el nombre para identificar la película a actualizar

            // Ejecutar la actualización
            int updatedRows = statement.executeUpdate();

            // Manejar la respuesta según el resultado de la actualización
            if (updatedRows > 0) {
                response.getWriter().write("Película actualizada: " + nombrePelicula);
            } else {
                response.getWriter().write("No se pudo actualizar la película");
            }
        }
    } catch (SQLException | NumberFormatException e) {
        throw new ServletException("Error al actualizar la película: " + e.getMessage());
    }
}

    

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pelicula = request.getParameter("pelicula");
        
        try {
            PreparedStatement statement = conn.prepareStatement("DELETE FROM Peliculas WHERE nombrepelicula = ?");
            statement.setString(1, pelicula);
            int deletedRows = statement.executeUpdate();
            
            response.setContentType("text/plain");
            if (deletedRows > 0) {
                response.getWriter().write("Pelicula eliminada: " + pelicula);
                
            } else {
                response.getWriter().write("La pelicula no se encontro o no se pudo eliminar");
            }
            
        } catch (SQLException e) {
            throw new ServletException("Error al eliminar pelicula: " + e.getMessage());
        }
    }
}