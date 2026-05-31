package com.service;

import com.model.User;

import java.io.File;
import java.util.List;

public interface UserService {

    void addUser(File file, User user);

    void updateUser(File file, User user);

    void deleteUser(File file, String id);

    List<User> getAllUsers();
}
