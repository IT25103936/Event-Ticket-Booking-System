package com.model;

public class Admin {

    private int id;
    private String name;
    private String email;
    private String phone;
    private String password;
    private String role;
    private String image;

    public Admin(int id, String name, String email, String phone,
                 String password,String role,String image) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.image = image;
        this.role = role;
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    // id,name,email,phone,password,image,role
    public String toFileString() {
        return id + "," + name + "," + email + "," + phone + "," +
                password + "," + image + "," + role;


    }
}
