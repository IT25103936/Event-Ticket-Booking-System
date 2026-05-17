package com.model;

public class Ticket {

    private int id;
    private int bookingId;
    private String seatNo;
    private double price;
    private String status;

    public Ticket(int id, int bookingId, String seatNo, double price, String status) {
        this.id = id;
        this.bookingId = bookingId;
        this.seatNo = seatNo;
        this.price = price;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public String getSeatNo() { return seatNo; }
    public void setSeatNo(String seatNo) { this.seatNo = seatNo; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String toFileString() {
        return id + "," + bookingId + "," + seatNo + "," + price + "," + status;
    }
}


