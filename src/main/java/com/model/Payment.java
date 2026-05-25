package com.model;

public class Payment {

    private int id;
    private int userId;
    private double amount;
    private String method;
    private String status;
    private String date;

    public Payment(int id, int userId, double amount,
                   String method, String status, String date) {
        this.id = id;
        this.userId = userId;
        this.amount = amount;
        this.method = method;
        this.status = status;
        this.date = date;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    // file format:
    // id,userId,amount,method,status,date
    public String toFileString() {
        return id + "," + userId + "," + amount + "," +
                method + "," + status + "," + date;
    }
}