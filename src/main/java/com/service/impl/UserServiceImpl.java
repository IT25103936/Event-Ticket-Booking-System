package com.service.impl;

import com.model.User;
import com.service.UserService;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class UserServiceImpl implements UserService {

    // CREATE
    @Override
    public void addUser(File file, User user) {
        try {
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }

            // Get last ID
            int lastId = 0;
            BufferedReader br = new BufferedReader(new FileReader(file));
            String line;
            while ((line = br.readLine()) != null) {
                String[] d = line.split(",");
                try {
                    int id = Integer.parseInt(d[0].trim());
                    if (id > lastId) lastId = id;
                } catch (Exception ignored) {}
            }
            br.close();

            int newId = lastId + 1;

            BufferedWriter bw = new BufferedWriter(new FileWriter(file, true));
            bw.write(newId + "," +
                    user.getName() + "," +
                    user.getEmail() + "," +
                    user.getPhone() + "," +
                    user.getRole() + "," +
                    user.getPassword() + "," +
                    user.getImage());
            bw.newLine();
            bw.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // UPDATE
    @Override
    public void updateUser(File file, User user) {
        System.out.println("updateUser impl: " + user);

        try {
            if (!file.exists()) return;

            List<String> lines = new ArrayList<>();
            BufferedReader br = new BufferedReader(new FileReader(file));
            String line;

            while ((line = br.readLine()) != null) {
                String[] d = line.split(",");

                if (d.length == 0 || line.trim().isEmpty()) {
                    continue;
                }

                if (d[0].trim().equals(String.valueOf(user.getId()).trim())) {
                    line = user.getId() + "," +
                            user.getName() + "," +
                            user.getEmail() + "," +
                            user.getPhone() + "," +
                            user.getRole() + "," +
                            user.getPassword() + "," +
                            user.getImage();
                }

                lines.add(line);
            }
            br.close();

            BufferedWriter bw = new BufferedWriter(new FileWriter(file, false));
            for (String l : lines) {
                bw.write(l);
                bw.newLine();
            }
            bw.flush();
            bw.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // DELETE
    @Override
    public void deleteUser(File file, String id) {
        try {
            List<String> lines = new ArrayList<>();
            BufferedReader br = new BufferedReader(new FileReader(file));
            String line;
            while ((line = br.readLine()) != null) {
                String[] d = line.split(",");
                if (!d[0].trim().equals(id.trim())) {
                    lines.add(line);
                }
            }
            br.close();

            BufferedWriter bw = new BufferedWriter(new FileWriter(file));
            for (String l : lines) {
                bw.write(l);
                bw.newLine();
            }
            bw.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // GET ALL
    @Override
    public List<User> getAllUsers() {

        return new ArrayList<>();
    }


    public List<User> getAllUsers(File file) {
        List<User> users = new ArrayList<>();
        if (file == null || !file.exists()) return users;

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                String[] d = line.split(",");
                if (d.length < 7) continue;
                // id,name,email,phone,role,password,image
                User u = new User(
                        Integer.parseInt(d[0].trim()),
                        d[1].trim(),
                        d[2].trim(),
                        d[3].trim(),
                        d[4].trim(),
                        d[5].trim(),
                        d[6].trim()
                );
                users.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }
}
