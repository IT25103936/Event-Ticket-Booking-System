package com.service.impl;

import com.model.Event;
import com.service.EventService;

import java.io.*;
import java.util.*;

public class EventServiceImpl implements EventService {

    @Override
    public int generateNextId(File file) {
        return readAll(file).size() + 1;
    }

    @Override
    public void create(File file, Event event) {
        event.setId(generateNextId(file));
        writeAppend(file, event);
    }

    @Override
    public void update(File file, Event event) {

        List<Event> list = readAll(file);

        for (int i = 0; i < list.size(); i++) {
            if (list.get(i).getId() == event.getId()) {
                list.set(i, event);
                break;
            }
        }

        writeAll(file, list);
    }

    @Override
    public void delete(File file, int id) {

        List<Event> list = readAll(file);
        list.removeIf(e -> e.getId() == id);
        writeAll(file, list);
    }

    // FILE READ
    @Override
    public List<Event> readAll(File file) {

        List<Event> list = new ArrayList<>();

        if (!file.exists()) return list;

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {

            String line;

            while ((line = br.readLine()) != null) {

                if (line.trim().isEmpty()) continue;

                String[] d = line.split(",");


                if (d.length < 9) continue;

                Event e = new Event(
                        safeInt(d[0]),
                        d[1],
                        d[2],
                        d[3],
                        d[4],
                        safeDouble(d[5]),
                        d[6],
                        d[7],
                        safeInt(d[8]),
                        d[9]
                );

                list.add(e);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // FILE WRITE ALL
    @Override
    public void writeAll(File file, List<Event> events) {

        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file))) {

            for (Event e : events) {
                bw.write(e.toFileString());
                bw.newLine();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // APPEND
    private void writeAppend(File file, Event e) {

        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file, true))) {
            bw.write(e.toFileString());
            bw.newLine();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    // SAFE PARSERS
    private int safeInt(String v) {
        try { return (v == null || v.isEmpty()) ? 0 : Integer.parseInt(v); }
        catch (Exception e) { return 0; }
    }

    private double safeDouble(String v) {
        try { return (v == null || v.isEmpty()) ? 0.0 : Double.parseDouble(v); }
        catch (Exception e) { return 0.0; }
    }
}