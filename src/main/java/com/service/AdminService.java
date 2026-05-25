package com.service;


import com.model.Admin;


public interface AdminService {
    void createAdmin(Admin admin, String path);
    void updateAdmin(Admin admin, String path);
    void deleteAdmin(int id, String path);
}



