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
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Calendar;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author gonzalo
 */
@WebServlet(urlPatterns = {"/GestionEntradasServlet"})
public class GestionEntradasServlet extends HttpServlet {

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
    String numero_sala = request.getParameter("numero_sala");
    String nombre_pelicula = request.getParameter("nombre_pelicula");
    int fila = Integer.parseInt(request.getParameter("fila"));
    int columna = Integer.parseInt(request.getParameter("columna"));
    
    // Obtener la fecha y hora actual
    LocalDate fechaActual = LocalDate.now();
    Date fechaSql = Date.valueOf(fechaActual);
    LocalTime horaActual = LocalTime.now();
    Time timestamp = Time.valueOf(horaActual);

    try {
        // Verificar si la película existe en la tabla de películas y si la sala existe
        boolean peliculaExiste = verificarExistenciaPelicula(this.conn, nombre_pelicula);
        boolean SalaExiste = verificarExistenciaSala(this.conn, numero_sala);
        if (!peliculaExiste || !SalaExiste) {
            // Si la película no existe, se informa al cliente y se detiene el proceso
            response.getWriter().write("Película o sala no encontrada en el cine");
            return;
        }

        String query = "INSERT INTO entradas (fecha, hora, numero_sala,fila, columna, nombre_pelicula) VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement statement = this.conn.prepareStatement(query)) {
            statement.setDate(1, fechaSql);
            statement.setTime(2, timestamp);
            statement.setString(3, numero_sala);
            
            statement.setString(5, nombre_pelicula);

            statement.executeUpdate();
        }

        // Informar al cliente sobre la creación exitosa de la sala
        response.getWriter().write("La entrada ha sido creada exitosamente");
        response.sendRedirect("gestion.jsp");
    } catch (SQLException e) {
        throw new ServletException("Error en la inserción de entrada: " + e.getMessage());
    }
}


// Método para verificar la existencia de la película en la tabla Peliculas
    private boolean verificarExistenciaPelicula(Connection conn, String nombrePelicula) throws SQLException {
        String query = "SELECT COUNT(*) AS total FROM Peliculas WHERE nombrepelicula = ?";

        try (PreparedStatement statement = conn.prepareStatement(query)) {
            statement.setString(1, nombrePelicula);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    int total = resultSet.getInt("total");
                    return total > 0; // Devolver true si el total es mayor que 0 (la película existe)
                }
            }
        }
        return false;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Statement statement = conn.createStatement();
            ResultSet resultSet = statement.executeQuery("SELECT numero_sala, nombre_pelicula, filas, columnas FROM Salas");

            StringBuilder salasHTML = new StringBuilder();
            salasHTML.append("<tr><th>Número Sala</th><th>Nombre Película</th><th>Filas</th><th>Columnas</th></tr>");

            while (resultSet.next()) {
                String numeroSala = resultSet.getString("numero_sala");
                String nombrePelicula = resultSet.getString("nombre_pelicula");
                int filas = resultSet.getInt("filas");
                int columnas = resultSet.getInt("columnas");

                salasHTML.append("<tr>");
                salasHTML.append("<td>").append(numeroSala).append("</td>");
                salasHTML.append("<td>").append(nombrePelicula).append("</td>");
                salasHTML.append("<td>").append(filas).append("</td>");
                salasHTML.append("<td>").append(columnas).append("</td>");
                salasHTML.append("</tr>");
            }

            response.setContentType("text/html");
            response.getWriter().write("<table border='1'>" + salasHTML.toString() + "</table>");
        } catch (SQLException e) {
            throw new ServletException("Error al obtener salas: " + e.getMessage());
        }
    }

    private boolean verificarExistenciaSala(Connection conn, String numero_sala) throws SQLException {
        String query = "SELECT COUNT(*) AS total FROM salas WHERE numero_sala = ?";

        try (PreparedStatement statement = conn.prepareStatement(query)) {
            statement.setString(1, numero_sala);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    int total = resultSet.getInt("total");
                    return total > 0; // Devolver true si el total es mayor que 0 (la sala existe)
                }
            }
        }
        return false;
    }
}
