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
import java.util.ArrayList;
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
            this.conn = DriverManager.getConnection("jdbc:derby://localhost:1527/sample", "app", "app");

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
        // Verificar si la película ya existe en la base de datos
        boolean peliculaExiste = verificarExistenciaPelicula(nombrePelicula);

        if (peliculaExiste) {
            
                boolean modificacionExitosa = modificarPelicula(nombrePelicula, sinopsis, paginaOficial, tituloOriginal, genero, nacionalidad, duracion, anno, distribuidora, director, actores, clasificacionEdad, otrosDatos);

        if (modificacionExitosa) {
            response.getWriter().write("La pelicula se ha modificado");
            response.sendRedirect("gestion.jsp"); // Redireccionar a una página de gestión o mostrar un mensaje de éxito
        }else{
            throw new ServletException("Error al modificar la película");
        } 
        } else {
           

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
    }
private boolean verificarExistenciaPelicula(String nombrePelicula) throws ServletException {
    boolean existe = false;
    try {
        // Realizar la consulta para verificar si la película ya existe en la tabla Peliculas
        String query = "SELECT * FROM Peliculas WHERE nombrepelicula = ?";
        try (PreparedStatement statement = this.conn.prepareStatement(query)) {
            statement.setString(1, nombrePelicula);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                // Si se encuentra al menos una fila, significa que la película ya existe
                existe = true;
                
            }
        }
    } catch (SQLException e) {
        throw new ServletException("Error al verificar existencia de película: " + e.getMessage());
    }
    return existe;
}
private boolean modificarPelicula(String nombrePelicula, String sinopsis, String paginaOficial, String tituloOriginal, String genero, String nacionalidad, String duracion, int anno, String distribuidora, String director, String actores, String clasificacionEdad, String otrosDatos) throws ServletException {
    boolean modificacionExitosa = false;
    try {
        
        String query = "UPDATE Peliculas SET sinopsis=?, paginaoficial=?, titulooriginal=?, genero=?, nacionalidad=?, duracion=?, anno=?, distribuidora=?, director=?, actores=?, clasificacionedad=?, otrosDatos=? WHERE nombrepelicula=?";
        try (PreparedStatement statement = this.conn.prepareStatement(query)) {
            statement.setString(1, sinopsis);
            statement.setString(2, paginaOficial);
            statement.setString(3, tituloOriginal);
            statement.setString(4, genero);
            statement.setString(5, nacionalidad);
            statement.setString(6, duracion);
            statement.setInt(7, anno);
            statement.setString(8, distribuidora);
            statement.setString(9, director);
            statement.setString(10, actores);
            statement.setString(11, clasificacionEdad);
            statement.setString(12, otrosDatos);
            statement.setString(13, nombrePelicula);

            int filasActualizadas = statement.executeUpdate();
            if (filasActualizadas > 0) {
                modificacionExitosa = true;
            }
        }
    } catch (SQLException e) {
        throw new ServletException("Error al modificar película: " + e.getMessage());
    }
    return modificacionExitosa;
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
