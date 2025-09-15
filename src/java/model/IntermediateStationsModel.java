
package model;
import java.time.LocalDateTime;

public class IntermediateStationsModel {
    private int stationID;
    private int busID;
    private String stationName;
    private LocalDateTime arrivalDateTime;
    private LocalDateTime departureDateTime;

    // Getters and Setters
    public int getStationID() { return stationID; }
    public void setStationID(int stationID) { this.stationID = stationID; }

    public int getBusID() { return busID; }
    public void setBusID(int busID) { this.busID = busID; }

    public String getStationName() { return stationName; }
    public void setStationName(String stationName) { this.stationName = stationName; }

    public LocalDateTime getArrivalDateTime() { return arrivalDateTime; }
    public void setArrivalDateTime(LocalDateTime arrivalDateTime) { this.arrivalDateTime = arrivalDateTime; }

    public LocalDateTime getDepartureDateTime() { return departureDateTime; }
    public void setDepartureDateTime(LocalDateTime departureDateTime) { this.departureDateTime = departureDateTime; }
}

