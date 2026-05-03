package com.model;

public class Event {
    private int id;
    private String name;
    private String date;
    private String location;
    private double price;
    private String description;
    private String imagePath;

    public Event(int id, String name, String date, String location,
                 double price, String description, String imagePath) {
        this.id = id;
        this.name = name;
        this.date = date;
        this.location = location;
        this.price = price;
        this.description = description;
        this.imagePath = imagePath;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    // file format:
    // id,name,date,location,price,description,imagePath
    public String toFileString() {
        return id + "," + name + "," + date + "," + location + "," +
                price + "," + description + "," + imagePath;
    }
}
