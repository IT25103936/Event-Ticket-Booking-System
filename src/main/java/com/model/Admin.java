package com.model;

public class Admin extends User {

    private String adminLevel;
    private boolean active;

    public Admin() {
        super();
        this.setRole("ADMIN");
        this.adminLevel = "ADMIN"; // default level
        this.active = true;
    }

    public Admin(int id, String name, String email, String phone,
                 String role, String password, String image,
                 String adminLevel) {

        super(id, name, email, phone, "ADMIN", password, image);

        this.adminLevel = adminLevel;
        this.active = true;
    }


    public String getAdminLevel() {
        return adminLevel;
    }

    public void setAdminLevel(String adminLevel) {
        this.adminLevel = adminLevel;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    // FILE FORMAT:
    // id,name,email,phone,role,password,image,adminLevel,active

    public String toFileString() {
        return getId() + "," +
                getName() + "," +
                getEmail() + "," +
                getPhone() + "," +
                getRole() + "," +
                getPassword() + "," +
                getImage() + "," +
                adminLevel + "," +
                active;
    }



}