package model;

import java.time.LocalDateTime;
import java.util.List;

public class Bus {
    private int busId;
    private String busNumber;
    private String busType;
    private String source;
    private String destination;
    private LocalDateTime departureTime; // Changed to LocalDateTime
    private LocalDateTime arrivalTime;   // Changed to LocalDateTime
    private int totalSeats;
    private int availableSeats;
    private double ticket;
    private List<String> intermediateStations;

    // Constructor
    public Bus(int busId, String busNumber, String busType, String source, String destination,
               LocalDateTime departureTime, LocalDateTime arrivalTime, int totalSeats, int availableSeats,
               double ticket, List<String> intermediateStations) {
        this.busId = busId;
        this.busNumber = busNumber;
        this.busType = busType;
        this.source = source;
        this.destination = destination;
        this.departureTime = departureTime;
        this.arrivalTime = arrivalTime;
        this.totalSeats = totalSeats;
        this.availableSeats = availableSeats;
        this.ticket = ticket;
        this.intermediateStations = intermediateStations;
    }

    // Getters
    public int getBusId() { return busId; }
    public String getBusNumber() { return busNumber; }
    public String getBusType() { return busType; }
    public String getSource() { return source; }
    public String getDestination() { return destination; }
    public LocalDateTime getDepartureTime() { return departureTime; }
    public LocalDateTime getArrivalTime() { return arrivalTime; }
    public int getTotalSeats() { return totalSeats; }
    public int getAvailableSeats() { return availableSeats; }
    public double getTicket() { return ticket; }
    public List<String> getIntermediateStations() { return intermediateStations; }
}