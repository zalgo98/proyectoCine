/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import java.sql.Connection;

import jakarta.jms.JMSException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author gonzalo
 */
@WebServlet("/insertarPelicula")
public class GestionPeliculasServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private Connection conn;

    public void init() throws ServletException {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = (Connection) DriverManager.getConnection("jdbc:derby://localhost:1527/sample", "app", "app");
        } catch (Exception e) {
            throw new ServletException("Error de inicialización: " + e.getMessage());
        }
    }

    public void destroy() {
        try {
            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(GestionPeliculasServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nombrePelicula = request.getParameter("nombre_pelicula");
        String sinopsis = request.getParameter("sinopsis");
        String paginaOficial = request.getParameter("pagina oficial");
        String tituloOriginal = request.getParameter("titulo original");
        String genero = request.getParameter("genero");
        String nacionalidad = request.getParameter("nacionalidad");
        String duracion = request.getParameter("duracion");
        int año = Integer.parseInt(request.getParameter("año"));
        String distribuidora = request.getParameter("distribuidora");
        String director = request.getParameter("director");
        String actores = request.getParameter("actores");
        String clasificacionEdad = request.getParameter("clasificacion_edad");
        String otrosDatos = request.getParameter("otrosDatos");

        try {
            String query = "INSERT INTO Peliculas (nombre_pelicula, sinopsis, pagina_oficial, titulo_original, genero, nacionalidad, duracion, anio, distribuidora, director, actores, clasificacion_edad, otros_datos) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement statement = conn.prepareStatement(query)) {
                statement.setString(1, nombrePelicula);
                statement.setString(2, sinopsis);
                statement.setString(3, paginaOficial);
                statement.setString(4, tituloOriginal);
                statement.setString(5, genero);
                statement.setString(6, nacionalidad);
                statement.setString(7, duracion);
                statement.setInt(8, año);
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
