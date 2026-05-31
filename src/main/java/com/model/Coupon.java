package com.model;

public class Coupon {

    private int id;
    private String code;
    private int discount;
    private String status;

    public Coupon(int id, String code, int discount, String status) {
        this.id = id;
        this.code = code;
        this.discount = discount;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public String getCode() {
        return code;
    }

    public int getDiscount() {
        return discount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}