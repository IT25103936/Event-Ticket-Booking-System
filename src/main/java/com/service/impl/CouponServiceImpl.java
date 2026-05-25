package com.service.impl;

import com.model.Coupon;
import com.service.CouponService;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class CouponServiceImpl implements CouponService {

    @Override
    public List<Coupon> readFile(File file) {

        List<Coupon> list = new ArrayList<>();

        try {

            if (!file.exists()) return list;

            BufferedReader br =
                    new BufferedReader(new FileReader(file));

            String line;

            while ((line = br.readLine()) != null) {

                if (line.trim().isEmpty()) continue;

                String[] d = line.split(",");

                Coupon coupon = new Coupon(
                        Integer.parseInt(d[0]),
                        d[1],
                        Integer.parseInt(d[2]),
                        d[3]
                );

                list.add(coupon);
            }

            br.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public void create(File file, Coupon coupon) {

        try {

            file.getParentFile().mkdirs();
            file.createNewFile();

            List<Coupon> list = readFile(file);

            int id = generateId(list);

            coupon = new Coupon(
                    id,
                    coupon.getCode().toUpperCase(),
                    coupon.getDiscount(),
                    coupon.getStatus()
            );

            list.add(coupon);

            writeFile(file, list);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(File file, Coupon coupon) {

        List<Coupon> list = readFile(file);
        List<Coupon> updated = new ArrayList<>();

        for (Coupon c : list) {

            if (c.getId() == coupon.getId()) {
                updated.add(coupon);
            } else {
                updated.add(c);
            }
        }

        writeFile(file, updated);
    }

    @Override
    public void delete(File file, int id) {

        List<Coupon> list = readFile(file);
        List<Coupon> updated = new ArrayList<>();

        for (Coupon c : list) {

            if (c.getId() != id) {
                updated.add(c);
            }
        }

        writeFile(file, updated);
    }

    @Override
    public void writeFile(File file, List<Coupon> list) {

        try {

            if (file.getParentFile() != null) {
                file.getParentFile().mkdirs();
            }

            BufferedWriter bw =
                    new BufferedWriter(new FileWriter(file));

            for (Coupon c : list) {
                bw.write(toLine(c));
                bw.newLine();
            }

            bw.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private int generateId(List<Coupon> list) {

        int id = 1;

        for (Coupon c : list) {
            id = Math.max(id, c.getId() + 1);
        }

        return id;
    }

    private String toLine(Coupon c) {
        return c.getId() + "," +
                c.getCode() + "," +
                c.getDiscount() + "," +
                c.getStatus();
    }
}