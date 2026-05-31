package com.service.impl;

import com.model.Payment;
import com.service.PaymentService;

import java.io.*;
import java.util.*;

public class PaymentServiceImpl implements PaymentService {

    @Override
    public int generateId(File file) {

        int id = 1;

        try {
            if (!file.exists()) return id;

            BufferedReader br = new BufferedReader(new FileReader(file));
            String line;

            while ((line = br.readLine()) != null) {

                if (line.trim().isEmpty()) continue;

                String[] d = line.split(",");

                try {
                    id = Math.max(id, Integer.parseInt(d[0]) + 1);
                } catch (Exception ignored) {}
            }

            br.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return id;
    }

    @Override
    public void create(File file, Payment p) {

        try {
            file.getParentFile().mkdirs();
            file.createNewFile();

            int id = generateId(file);
            p.setId(id);

            BufferedWriter bw = new BufferedWriter(new FileWriter(file, true));
            bw.write(p.toFileString());
            bw.newLine();
            bw.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(File file, Payment p) {

        List<String> list = readAll(file);
        List<String> updated = new ArrayList<>();

        for (String line : list) {

            String[] d = line.split(",");

            if (Integer.parseInt(d[0]) == p.getId()) {
                updated.add(p.toFileString());
            } else {
                updated.add(line);
            }
        }

        writeAll(file, updated);
    }

    @Override
    public void delete(File file, int id) {

        List<String> list = readAll(file);
        List<String> updated = new ArrayList<>();

        for (String line : list) {

            if (!line.startsWith(id + ",")) {
                updated.add(line);
            }
        }

        writeAll(file, updated);
    }

    @Override
    public List<String> readAll(File file) {

        List<String> list = new ArrayList<>();

        try {
            if (!file.exists()) return list;

            BufferedReader br = new BufferedReader(new FileReader(file));
            String line;

            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    list.add(line);
                }
            }

            br.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public void writeAll(File file, List<String> list) {

        try {
            BufferedWriter bw = new BufferedWriter(new FileWriter(file));

            for (String s : list) {
                bw.write(s);
                bw.newLine();
            }

            bw.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}