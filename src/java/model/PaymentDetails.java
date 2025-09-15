package model;

public class PaymentDetails implements java.io.Serializable {
    private double baseFare;
    private double platformFee;
    private double serviceTax;
    private double insuranceFee;
    private double totalAmount;
    
    public PaymentDetails() {
        // Default constructor
    }
    
    public void calculateTotal() {
        this.totalAmount = this.baseFare + this.platformFee + this.serviceTax + this.insuranceFee;
    }
    
    // Getters and setters
    public double getBaseFare() { 
        return baseFare; 
    }
    
    public void setBaseFare(double baseFare) { 
        this.baseFare = baseFare; 
    }
    
    public double getPlatformFee() { 
        return platformFee; 
    }
    
    public void setPlatformFee(double platformFee) { 
        this.platformFee = platformFee; 
    }
    
    public double getServiceTax() { 
        return serviceTax; 
    }
    
    public void setServiceTax(double serviceTax) { 
        this.serviceTax = serviceTax; 
    }
    
    public double getInsuranceFee() { 
        return insuranceFee; 
    }
    
    public void setInsuranceFee(double insuranceFee) { 
        this.insuranceFee = insuranceFee; 
    }
    
    public double getTotalAmount() { 
        return totalAmount; 
    }
    
    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    @Override
    public String toString() {
        return "PaymentDetails{" +
                "baseFare=" + baseFare +
                ", platformFee=" + platformFee +
                ", serviceTax=" + serviceTax +
                ", insuranceFee=" + insuranceFee +
                ", totalAmount=" + totalAmount +
                '}';
    }
}