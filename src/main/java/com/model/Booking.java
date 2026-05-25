package com.model;

import java.util.List;

public class Booking {

    private int id;
    private int userId;
    private int eventId;

    private List<String> seats;
    private int quantity;
    private double totalPrice;

    private int paymentId;
    private String date;
    private String time;

    private String status;

    public Booking() {}

    public Booking(int id,
                   int userId,
                   int eventId,
                   List<String> seats,
                   int quantity,
                   double totalPrice,
                   int paymentId,
                   String date,
                   String time,
                   String status) {

        this.id = id;
        this.userId = userId;
        this.eventId = eventId;
        this.seats = seats;
        this.quantity = quantity;
        this.totalPrice = totalPrice;
        this.paymentId = paymentId;
        this.date = date;
        this.time = time;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public List<String> getSeats() { return seats; }
    public void setSeats(List<String> seats) { this.seats = seats; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }

    public String getTime() { return time; }
    public void setTime(String time) { this.time = time; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // ================= FILE FORMAT =================
    public String toFileString() {
        return id + "," +
                userId + "," +
                eventId + "," +
                String.join("|", seats) + "," +
                quantity + "," +
                totalPrice + "," +
                paymentId + "," +
                date + "," +
                time + "," +
                status;
    }
}