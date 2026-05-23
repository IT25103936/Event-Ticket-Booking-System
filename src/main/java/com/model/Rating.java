package com.model;

public class Rating {

    private int id;
    private int userId;
    private int eventId;
    private int rating;   // 1 - 5 stars
    private String comment;
    private String date;

    public Rating(int id, int userId, int eventId,
                  int rating, String comment, String date) {
        this.id = id;
        this.userId = userId;
        this.eventId = eventId;
        this.rating = rating;
        this.comment = comment;
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

    public int getEventId() {
        return eventId;
    }

    public void setEventId(int eventId) {
        this.eventId = eventId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    // file format:
    // id,userId,eventId,rating,comment,date
    public String toFileString() {
        return id + "," + userId + "," + eventId + "," +
                rating + "," + comment + "," + date;
    }
}