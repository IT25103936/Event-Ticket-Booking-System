package com.model;

public class Ticket {

    private int id;
    private int bookingId;
    private int userId;
    private int eventId;
    private String seatNo;
    private double price;
    private String status;

    public Ticket() {}

    public Ticket(int id, int bookingId, int userId, int eventId,
                  String seatNo, double price, String status) {
        this.id        = id;
        this.bookingId = bookingId;
        this.userId    = userId;
        this.eventId   = eventId;
        this.seatNo    = seatNo;
        this.price     = price;
        this.status    = status;
    }

    public int    getId()        { return id; }
    public void   setId(int id)  { this.id = id; }

    public int    getBookingId()             { return bookingId; }
    public void   setBookingId(int bookingId){ this.bookingId = bookingId; }

    public int    getUserId()              { return userId; }
    public void   setUserId(int userId)    { this.userId = userId; }

    public int    getEventId()             { return eventId; }
    public void   setEventId(int eventId)  { this.eventId = eventId; }

    public String getSeatNo()              { return seatNo; }
    public void   setSeatNo(String seatNo) { this.seatNo = seatNo; }

    public double getPrice()               { return price; }
    public void   setPrice(double price)   { this.price = price; }

    public String getStatus()              { return status; }
    public void   setStatus(String status) { this.status = status; }


    public String getSeatDisplay() {
        if (seatNo != null && seatNo.startsWith("[") && seatNo.endsWith("]")) {
            return seatNo.substring(1, seatNo.length() - 1);
        }
        return seatNo;
    }


    public String toFileString() {
        return id        + "," +
                bookingId + "," +
                userId    + "," +
                eventId   + "," +
                seatNo    + "," +
                price     + "," +
                status;
    }

    @Override
    public String toString() {
        return "Ticket{id=" + id +
                ", bookingId=" + bookingId +
                ", userId=" + userId +
                ", eventId=" + eventId +
                ", seatNo='" + seatNo + '\'' +
                ", price=" + price +
                ", status='" + status + '\'' + '}';
    }
}