
package model;


import java.time.LocalDateTime;

public class BookingDetails {
    private Long bookingID;
    private String bookingReference;
    private LocalDateTime bookingDateTime;
    private Long busID;
    private String sourceDestination;
    private LocalDateTime departureDateTime;
    private LocalDateTime arrivalDateTime;
    private Long passengerID;
    private String seatNumber;
    private String passengerName;
    private int age;
    private String gender;
    private Long paymentID;
    private Long breakdownID;
    private String paymentStatus;

    // Getters and Setters
    public Long getBookingID() {
        return bookingID;
    }

    public void setBookingID(Long bookingID) {
        this.bookingID = bookingID;
    }

    public String getBookingReference() {
        return bookingReference;
    }

    public void setBookingReference(String bookingReference) {
        this.bookingReference = bookingReference;
    }

    public LocalDateTime getBookingDateTime() {
        return bookingDateTime;
    }

    public void setBookingDateTime(LocalDateTime bookingDateTime) {
        this.bookingDateTime = bookingDateTime;
    }

    public Long getBusID() {
        return busID;
    }

    public void setBusID(Long busID) {
        this.busID = busID;
    }

    public String getSourceDestination() {
        return sourceDestination;
    }

    public void setSourceDestination(String sourceDestination) {
        this.sourceDestination = sourceDestination;
    }

    public LocalDateTime getDepartureDateTime() {
        return departureDateTime;
    }

    public void setDepartureDateTime(LocalDateTime departureDateTime) {
        this.departureDateTime = departureDateTime;
    }

    public LocalDateTime getArrivalDateTime() {
        return arrivalDateTime;
    }

    public void setArrivalDateTime(LocalDateTime arrivalDateTime) {
        this.arrivalDateTime = arrivalDateTime;
    }

    public Long getPassengerID() {
        return passengerID;
    }

    public void setPassengerID(Long passengerID) {
        this.passengerID = passengerID;
    }

    public String getSeatNumber() {
        return seatNumber;
    }

    public void setSeatNumber(String seatNumber) {
        this.seatNumber = seatNumber;
    }

    public String getPassengerName() {
        return passengerName;
    }

    public void setPassengerName(String passengerName) {
        this.passengerName = passengerName;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Long getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(Long paymentID) {
        this.paymentID = paymentID;
    }

    public Long getBreakdownID() {
        return breakdownID;
    }

    public void setBreakdownID(Long breakdownID) {
        this.breakdownID = breakdownID;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    @Override
    public String toString() {
        return "BookingDetails{" +
                "bookingID=" + bookingID +
                ", bookingReference='" + bookingReference + '\'' +
                ", bookingDateTime=" + bookingDateTime +
                ", busID=" + busID +
                ", sourceDestination='" + sourceDestination + '\'' +
                ", departureDateTime=" + departureDateTime +
                ", arrivalDateTime=" + arrivalDateTime +
                ", passengerID=" + passengerID +
                ", seatNumber='" + seatNumber + '\'' +
                ", passengerName='" + passengerName + '\'' +
                ", age=" + age +
                ", gender='" + gender + '\'' +
                ", paymentID=" + paymentID +
                ", breakdownID=" + breakdownID +
                ", paymentStatus='" + paymentStatus + '\'' +
                '}';
    }
}

