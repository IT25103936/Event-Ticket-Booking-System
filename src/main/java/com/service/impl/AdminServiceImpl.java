package com.service.impl;


import com.model.Admin;
import com.service.AdminService;


import java.io.*;
import java.util.ArrayList;
import java.util.List;


public class AdminServiceImpl implements AdminService {


    @Override
    public void createAdmin(Admin admin, String path) {


        File file = new File(path);
        file.getParentFile().mkdirs();


        int id = 1;


        try (BufferedReader br = new BufferedReader(new FileReader(file))) {


            String line;
            while ((line = br.readLine()) != null) {
                if (line.trim().isEmpty()) continue;


                String[] d = line.split(",");
                id = Math.max(id, Integer.parseInt(d[0]) + 1);
            }


        } catch (Exception ignored) {}


        admin.setId(id);


        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file, true))) {
            bw.write(admin.toFileString());
            bw.newLine();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    @Override
    public void updateAdmin(Admin admin, String path) {


        File file = new File(path);


        if (file.getParentFile() != null) {
            file.getParentFile().mkdirs();
        }


        List<String> list = new ArrayList<>();


        // READ
        try (BufferedReader br = new BufferedReader(new FileReader(file))) {


            String line;


            while ((line = br.readLine()) != null) {


                String[] d = line.split(",");


                if (d.length == 0) {
                    continue;
                }


                int fileId;


                try {
                    fileId = Integer.parseInt(d[0].trim());
                } catch (Exception e) {
                    list.add(line);
                    continue;
                }


                if (fileId == admin.getId()) {


                    String image = (d.length > 6) ? d[6] : "default.png";
                    String active = (d.length > 8) ? d[8] : "true";


                    list.add(
                            admin.getId() + "," +
                                    admin.getName() + "," +
                                    admin.getEmail() + "," +
                                    admin.getPhone() + "," +
                                    admin.getRole() + "," +
                                    admin.getPassword() + "," +
                                    image + "," +
                                    admin.getAdminLevel() + "," +
                                    active
                    );


                } else {
                    list.add(line);
                }
            }


        } catch (Exception e) {
            e.printStackTrace();
        }


        // WRITE BACK
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file, false))) {


            for (String s : list) {
                bw.write(s);
                bw.newLine();
            }


        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    @Override
    public void deleteAdmin(int id, String path) {


        File file = new File(path);
        List<String> list = new ArrayList<>();


        try (BufferedReader br = new BufferedReader(new FileReader(file))) {


            String line;
            while ((line = br.readLine()) != null) {


                String[] d = line.split(",");


                if (Integer.parseInt(d[0]) != id) {
                    list.add(line);
                }
            }


        } catch (Exception e) {
            e.printStackTrace();
        }


        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file))) {
            for (String s : list) {
                bw.write(s);
                bw.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

