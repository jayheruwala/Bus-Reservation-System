
package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DatabaseUtil;
import java.time.LocalDateTime;
import model.BusesModel;
import model.IntermediateStationsModel;

public class BusesDAO {
    public List<BusesModel> getAllBusesWithStations() {
        List<BusesModel> buses = new ArrayList<>();
        String busQuery = "SELECT * FROM Buses";
        String stationQuery = "SELECT * FROM Intermediate_Stations WHERE BusID = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement busStmt = conn.prepareStatement(busQuery);
             ResultSet busRs = busStmt.executeQuery()) {

            while (busRs.next()) {
                BusesModel bus = new BusesModel();
                bus.setBusID(busRs.getInt("BusID"));
                bus.setBusNumber(busRs.getString("BusNumber"));
                bus.setBusType(busRs.getString("BusType"));
                bus.setSource(busRs.getString("Source"));
                bus.setDestination(busRs.getString("Destination"));
                bus.setDepartureDateTime(busRs.getTimestamp("DepartureDateTime") != null ? 
                    busRs.getTimestamp("DepartureDateTime").toLocalDateTime() : null);
                bus.setArrivalDateTime(busRs.getTimestamp("ArrivalDateTime") != null ? 
                    busRs.getTimestamp("ArrivalDateTime").toLocalDateTime() : null);
                bus.setTotalSeats(busRs.getInt("TotalSeats"));
                bus.setAvailableSeats(busRs.getInt("AvailableSeats"));
                bus.setTicketPrice(busRs.getDouble("TicketPrice"));

                // Fetch Intermediate Stations
                List<IntermediateStationsModel> stations = new ArrayList<>();
                try (PreparedStatement stationStmt = conn.prepareStatement(stationQuery)) {
                    stationStmt.setInt(1, bus.getBusID());
                    try (ResultSet stationRs = stationStmt.executeQuery()) {
                        while (stationRs.next()) {
                            IntermediateStationsModel station = new IntermediateStationsModel();
                            station.setStationID(stationRs.getInt("StationID"));
                            station.setBusID(stationRs.getInt("BusID"));
                            station.setStationName(stationRs.getString("StationName"));
                            station.setArrivalDateTime(stationRs.getTimestamp("ArrivalDateTime") != null ?
                                stationRs.getTimestamp("ArrivalDateTime").toLocalDateTime() : null);
                            station.setDepartureDateTime(stationRs.getTimestamp("DepartureDateTime") != null ?
                                stationRs.getTimestamp("DepartureDateTime").toLocalDateTime() : null);
                            stations.add(station);
                        }
                    }
                }
                bus.setStations(stations);
                buses.add(bus);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return buses;
    }
    
    
    public BusesModel getBusById(int busId) {
        BusesModel bus = null;
        String query = "SELECT * FROM Buses WHERE BusID = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, busId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    bus = extractBusFromResultSet(rs);
                    bus.setStations(getIntermediateStations(busId));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bus;
    }
    
    private BusesModel extractBusFromResultSet(ResultSet rs) throws SQLException {
        BusesModel bus = new BusesModel();
        bus.setBusID(rs.getInt("BusID"));
        bus.setBusNumber(rs.getString("BusNumber"));
        bus.setBusType(rs.getString("BusType"));
        bus.setSource(rs.getString("Source"));
        bus.setDestination(rs.getString("Destination"));
        
        Timestamp departureTimestamp = rs.getTimestamp("DepartureDateTime");
        bus.setDepartureDateTime(departureTimestamp != null ? departureTimestamp.toLocalDateTime() : null);
        
        Timestamp arrivalTimestamp = rs.getTimestamp("ArrivalDateTime");
        bus.setArrivalDateTime(arrivalTimestamp != null ? arrivalTimestamp.toLocalDateTime() : null);
        
        bus.setTotalSeats(rs.getInt("TotalSeats"));
        bus.setAvailableSeats(rs.getInt("AvailableSeats"));
        bus.setTicketPrice(rs.getDouble("TicketPrice"));
        return bus;
    }
    
    private List<IntermediateStationsModel> getIntermediateStations(int busId) {
        List<IntermediateStationsModel> stations = new ArrayList<>();
        String query = "SELECT * FROM Intermediate_Stations WHERE BusID = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, busId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    IntermediateStationsModel station = new IntermediateStationsModel();
                    station.setStationID(rs.getInt("StationID"));
                    station.setBusID(rs.getInt("BusID"));
                    station.setStationName(rs.getString("StationName"));
                    
                    Timestamp arrivalTimestamp = rs.getTimestamp("ArrivalDateTime");
                    station.setArrivalDateTime(arrivalTimestamp != null ? arrivalTimestamp.toLocalDateTime() : null);
                    
                    Timestamp departureTimestamp = rs.getTimestamp("DepartureDateTime");
                    station.setDepartureDateTime(departureTimestamp != null ? departureTimestamp.toLocalDateTime() : null);
                    
                    stations.add(station);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stations;
    }
  
    
    
    public boolean updateBus(BusesModel bus) {
        String query = "UPDATE Buses SET BusNumber = ?, BusType = ?, Source = ?, Destination = ?, " +
                      "DepartureDateTime = ?, ArrivalDateTime = ?, TotalSeats = ?, AvailableSeats = ?, " +
                      "TicketPrice = ? WHERE BusID = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, bus.getBusNumber());
            stmt.setString(2, bus.getBusType());
            stmt.setString(3, bus.getSource());
            stmt.setString(4, bus.getDestination());
            stmt.setTimestamp(5, bus.getDepartureDateTime() != null ? 
                             Timestamp.valueOf(bus.getDepartureDateTime()) : null);
            stmt.setTimestamp(6, bus.getArrivalDateTime() != null ? 
                             Timestamp.valueOf(bus.getArrivalDateTime()) : null);
            stmt.setInt(7, bus.getTotalSeats());
            stmt.setInt(8, bus.getAvailableSeats());
            stmt.setDouble(9, bus.getTicketPrice());
            stmt.setInt(10, bus.getBusID());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateIntermediateStations(int busId, List<IntermediateStationsModel> stations) {
        // First, delete existing stations for the bus
        String deleteQuery = "DELETE FROM Intermediate_Stations WHERE BusID = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement deleteStmt = conn.prepareStatement(deleteQuery)) {
            deleteStmt.setInt(1, busId);
            deleteStmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        // Insert new/updated stations
        String insertQuery = "INSERT INTO Intermediate_Stations (BusID, StationName, ArrivalDateTime, DepartureDateTime) " +
                           "VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
            for (IntermediateStationsModel station : stations) {
                insertStmt.setInt(1, busId);
                insertStmt.setString(2, station.getStationName());
                insertStmt.setTimestamp(3, station.getArrivalDateTime() != null ?
                                       Timestamp.valueOf(station.getArrivalDateTime()) : null);
                insertStmt.setTimestamp(4, station.getDepartureDateTime() != null ?
                                       Timestamp.valueOf(station.getDepartureDateTime()) : null);
                insertStmt.executeUpdate();
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    
}

