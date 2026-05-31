package com.service.impl;

import com.model.Rating;
import com.service.RatingService;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class RatingServiceImpl implements RatingService {

    @Override
    public int generateId(File file) {

        int id = 1;

        try {

            if (!file.exists()) {
                return id;
            }

            BufferedReader br =
                    new BufferedReader(
                            new FileReader(file)
                    );

            String line;

            while ((line = br.readLine()) != null) {

                if (line.trim().isEmpty()) {
                    continue;
                }

                String[] d = line.split(",");

                try {

                    id = Math.max(
                            id,
                            Integer.parseInt(d[0]) + 1
                    );

                } catch (Exception ignored) {
                }
            }

            br.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return id;
    }

    @Override
    public void create(File file, Rating rating) {

        try {

            file.getParentFile().mkdirs();
            file.createNewFile();

            int id = generateId(file);

            rating.setId(id);

            BufferedWriter bw =
                    new BufferedWriter(
                            new FileWriter(file, true)
                    );

            bw.write(rating.toFileString());
            bw.newLine();

            bw.close();

        } catch (Exception e) {

            e.printStackTrace();
        }
    }

    @Override
    public void update(File file, Rating rating) {

        List<Rating> list =
                readAll(file);

        List<Rating> updated =
                new ArrayList<>();

        for (Rating r : list) {

            if (r.getId() == rating.getId()) {

                updated.add(rating);

            } else {

                updated.add(r);
            }
        }

        writeAll(file, updated);
    }

    @Override
    public void delete(File file, int id) {

        List<Rating> list =
                readAll(file);

        List<Rating> updated =
                new ArrayList<>();

        for (Rating r : list) {

            if (r.getId() != id) {
                updated.add(r);
            }
        }

        writeAll(file, updated);
    }

    @Override
    public List<Rating> readAll(File file) {

        List<Rating> list =
                new ArrayList<>();

        try {

            if (!file.exists()) {
                return list;
            }

            BufferedReader br =
                    new BufferedReader(
                            new FileReader(file)
                    );

            String line;

            while ((line = br.readLine()) != null) {

                if (line.trim().isEmpty()) {
                    continue;
                }

                String[] d = line.split(",");

                Rating rating = new Rating(
                        Integer.parseInt(d[0]), // id
                        Integer.parseInt(d[1]), // userId
                        Integer.parseInt(d[2]), // eventId
                        Integer.parseInt(d[3]), // rating
                        d[4],                   // comment
                        d[5]                    // date
                );

                list.add(rating);
            }

            br.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return list;
    }

    @Override
    public void writeAll(File file,
                         List<Rating> list) {

        try {

            BufferedWriter bw =
                    new BufferedWriter(
                            new FileWriter(file)
                    );

            for (Rating r : list) {

                bw.write(r.toFileString());
                bw.newLine();
            }

            bw.close();

        } catch (Exception e) {

            e.printStackTrace();
        }
    }
}