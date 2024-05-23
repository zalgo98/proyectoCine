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

import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.sql.SQLException;

import java.sql.Time;

import java.time.LocalDate;
import java.time.LocalTime;

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
        String idEntrada = request.getParameter("id");
        String numero_sala = request.getParameter("numero_sala");
        String nombre_pelicula = request.getParameter("nombre_pelicula");
        int fila = Integer.parseInt(request.getParameter("fila"));
        int columna = Integer.parseInt(request.getParameter("columna"));

        // Obtener la fecha y hora actual
        LocalDate fechaActual = LocalDate.now();
        Date fechaSql = Date.valueOf(fechaActual);
        LocalTime horaActual = LocalTime.now();
        Time timestamp = Time.valueOf(horaActual);

        // Verificar si la entrada ya existe en la base de datos
        boolean asientoAsignado;
        try {
             boolean peliculaExiste = verificarExistenciaPelicula(this.conn, nombre_pelicula);
             boolean salaExiste = verificarExistenciaSala(this.conn, numero_sala);
                  
            asientoAsignado = verificarAsientoAsignado(this.conn, numero_sala, fila, columna);

            if (idEntrada != null && !idEntrada.isEmpty()) {
                response.getWriter().write("La entrada se ha modificado");
               int id= Integer.parseInt(idEntrada);
                boolean modificacionExitosa = modificarEntrada(id, numero_sala, nombre_pelicula, fila, columna);

                if (modificacionExitosa) {
                    response.getWriter().write("La entrada se ha modificado");
                    response.sendRedirect("gestion.jsp"); // Redireccionar a una página de gestión o mostrar un mensaje de éxito
                } else {
                    throw new ServletException("Error al modificar la entrada");
                }
            } else {
                try {
                    // Verificar si la película existe en la tabla de películas y si la sala existe
                    if (!peliculaExiste || !salaExiste) {
                        // Si la película no existe, se informa al cliente y se detiene el proceso
                        response.getWriter().write("Película o sala no encontrada en el cine");
                        return;
                    }

                    // Verificar si ya existe una entrada con la misma fila y columna
                    if (asientoAsignado) {
                        // Si el asiento ya está asignado, informar al cliente y detener el proceso
                        response.getWriter().write("Asiento ya asignado");
                        return;
                    }

                    String query = "INSERT INTO entradas (fecha, hora, numero_sala, fila, columna, nombre_pelicula) VALUES (?, ?, ?, ?, ?, ?)";

                    try (PreparedStatement statement = this.conn.prepareStatement(query)) {
                        statement.setDate(1, fechaSql);
                        statement.setTime(2, timestamp);
                        statement.setString(3, numero_sala);
                        statement.setInt(4, fila);
                        statement.setInt(5, columna);
                        statement.setString(6, nombre_pelicula);

                        statement.executeUpdate();
                    }

                    // Informar al cliente sobre la creación exitosa de la entrada
                    response.getWriter().write("La entrada ha sido creada exitosamente");
                    response.sendRedirect("gestion.jsp");
                } catch (SQLException e) {
                    throw new ServletException("Error en la inserción de entrada: " + e.getMessage());
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(GestionEntradasServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private boolean verificarAsientoAsignado(Connection conn, String numeroSala, int fila, int columna) throws SQLException {
        String query = "SELECT COUNT(*) AS count FROM entradas WHERE numero_sala = ? AND fila = ? AND columna = ?";
        try (PreparedStatement statement = conn.prepareStatement(query)) {
            statement.setString(1, numeroSala);
            statement.setInt(2, fila);
            statement.setInt(3, columna);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                int count = resultSet.getInt("count");
                return count > 0;
            }
        }
        return false;
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

    @Override

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String numeroSala = request.getParameter("numero_sala");
            String query = "SELECT id,hora, numero_sala, fila, columna, nombre_pelicula FROM entradas";

            // Verificar si se proporcionó un número de sala válido
            if (numeroSala != null && !numeroSala.isEmpty()) {
                // Query SQL para obtener las entradas de la sala especificada
                query += " WHERE numero_sala = ?";
            }

            PreparedStatement statement = conn.prepareStatement(query);

            // Si se proporciona un número de sala, configurar el parámetro en la consulta
            if (numeroSala != null && !numeroSala.isEmpty()) {
                statement.setString(2, numeroSala);
            }

            ResultSet resultSet = statement.executeQuery();

            StringBuilder entradasHTML = new StringBuilder();
            entradasHTML.append("<table><tr><th>Id</th><th>Hora</th><th>Sala</th><th>Fila</th><th>Columna</th><th>Pelicula</th></tr>");

            while (resultSet.next()) {
                int id = resultSet.getInt("Id");
                String hora = resultSet.getString("hora");
                int fila = resultSet.getInt("fila");
                int columna = resultSet.getInt("columna");
                String nombre_pelicula = resultSet.getString("nombre_pelicula");
                String sala = resultSet.getString("numero_sala");

                entradasHTML.append("<tr>");
                entradasHTML.append("<td>").append(id).append("</td>");
                entradasHTML.append("<td>").append(hora).append("</td>");
                entradasHTML.append("<td>").append(sala).append("</td>");
                entradasHTML.append("<td>").append(fila).append("</td>");
                entradasHTML.append("<td>").append(columna).append("</td>");
                entradasHTML.append("<td>").append(nombre_pelicula).append("</td>");
                entradasHTML.append("</tr>");
            }

            entradasHTML.append("</table>");

            response.setContentType("text/html");
            response.getWriter().write(entradasHTML.toString());

        } catch (SQLException e) {
            throw new ServletException("Error al obtener entradas: " + e.getMessage());
        }
    }

    @Override
    public void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String idEntrada = request.getParameter("idEntrada");

        try {
            String query = "DELETE FROM entradas WHERE ID = ?";

            try (PreparedStatement statement = this.conn.prepareStatement(query)) {
                statement.setString(1, idEntrada); // Usar el ID de entrada proporcionado

                int deletedRows = statement.executeUpdate();

                response.setContentType("text/plain");
                if (deletedRows > 0) {
                    response.getWriter().write("Entrada eliminada con ID: " + idEntrada);
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // Establecer código de estado 400 Bad Request
                    response.getWriter().write("La entrada no se encontró o no se pudo eliminar");
                }
            }
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // Establecer código de estado 500 Internal Server Error
            response.getWriter().write("Error al eliminar entrada: " + e.getMessage());
        }
    }

   

    private boolean modificarEntrada(int id, String numero_sala, String nombre_pelicula, int fila, int columna) throws ServletException {
        boolean modificacionExitosa = false;
        try {
            
            String query = "UPDATE entradas SET numero_sala=?, fila=?, columna=? , nombre_pelicula=? WHERE id =?";
            try (PreparedStatement statement = this.conn.prepareStatement(query)) {
                statement.setString(1, numero_sala);
                statement.setInt(2, fila);
                statement.setInt(3, columna);
                statement.setString(4, nombre_pelicula);
                 statement.setInt(5, id);
                int filasActualizadas = statement.executeUpdate();
                if (filasActualizadas > 0) {
                    modificacionExitosa = true;
                }
            }
        } catch (SQLException e) {
            throw new ServletException("Error al modificar entrada: " + e.getMessage());
        }
        return modificacionExitosa;
    }
}
