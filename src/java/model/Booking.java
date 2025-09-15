package model;

import java.sql.Timestamp;

public class Booking {
    private int bookingId;
    private String bookingReference;
    private String busId;
    private double totalAmount;
    private Timestamp bookingDateTime;
    private String paymentStatus;
    private String seatNumbers;
    private int passengerCount;

    // Getters and Setters
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public String getBookingReference() { return bookingReference; }
    public void setBookingReference(String bookingReference) { this.bookingReference = bookingReference; }
    public String getBusId() { return busId; }
    public void setBusId(String busId) { this.busId = busId; }
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    public Timestamp getBookingDateTime() { return bookingDateTime; }
    public void setBookingDateTime(Timestamp bookingDateTime) { this.bookingDateTime = bookingDateTime; }
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    public String getSeatNumbers() { return seatNumbers; }
    public void setSeatNumbers(String seatNumbers) { this.seatNumbers = seatNumbers; }
    public int getPassengerCount() { return passengerCount; }
    public void setPassengerCount(int passengerCount) { this.passengerCount = passengerCount; }
}