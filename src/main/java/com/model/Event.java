package com.model;

public class Event {

    private int id;
    private String name;
    private String date;
    private String time;
    private String location;
    private double price;
    private String description;
    private String imagePath;
    private int availableSeats;
    private String status;

    // FULL CONSTRUCTOR
    public Event(int id, String name, String date, String time,
                 String location, double price, String description,
                 String imagePath, int availableSeats, String status) {

        this.id = id;
        this.name = name;
        this.date = date;
        this.time = time;
        this.location = location;
        this.price = price;
        this.description = description;
        this.imagePath = imagePath;
        this.availableSeats = availableSeats;
        this.status = status;
    }

    // GETTERS
    public int getId() { return id; }
    public String getName() { return name; }
    public String getDate() { return date; }
    public String getTime() { return time; }
    public String getLocation() { return location; }
    public double getPrice() { return price; }
    public String getDescription() { return description; }
    public String getImagePath() { return imagePath; }
    public int getAvailableSeats() { return availableSeats; }
    public String getStatus() { return status; }

    // SETTERS
    public void setId(int id) { this.id = id; }
    public void setName(String name) { this.name = name; }
    public void setDate(String date) { this.date = date; }
    public void setTime(String time) { this.time = time; }
    public void setLocation(String location) { this.location = location; }
    public void setPrice(double price) { this.price = price; }
    public void setDescription(String description) { this.description = description; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
    public void setAvailableSeats(int availableSeats) { this.availableSeats = availableSeats; }
    public void setStatus(String status) { this.status = status; }

    // FILE FORMAT (UPDATED WITH TIME)
    public String toFileString() {
        return id + "," + name + "," + date + "," + time + "," +
                location + "," + price + "," + description + "," +
                imagePath + "," + availableSeats + "," + status;
    }
}

