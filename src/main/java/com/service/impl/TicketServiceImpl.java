package com.service.impl;

import com.model.Ticket;
import com.service.TicketService;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class TicketServiceImpl implements TicketService {


    private String[] parseLine(String line) {
        int bracketOpen  = line.indexOf('[');
        int bracketClose = line.indexOf(']');

        if (bracketOpen != -1 && bracketClose != -1 && bracketClose > bracketOpen) {

            String prefix = line.substring(0, bracketOpen);
            String seat   = line.substring(bracketOpen, bracketClose + 1);
            String suffix = line.substring(bracketClose + 1);


            String[] prefixParts = prefix.split(",");

            String[] suffixParts = suffix.split(",");


            if (prefixParts.length >= 4 && suffixParts.length >= 3) {
                return new String[]{
                        prefixParts[0].trim(),   // id
                        prefixParts[1].trim(),   // bookingId
                        prefixParts[2].trim(),   // userId
                        prefixParts[3].trim(),   // eventId
                        seat.trim(),             // seatNo
                        suffixParts[1].trim(),   // price
                        suffixParts[2].trim()    // status
                };
            }
        }


        return line.split(",", 7);
    }

    @Override
    public int generateId(File file) {

        int id = 1;

        try {
            if (!file.exists()) return id;

            BufferedReader br = new BufferedReader(new FileReader(file));
            String line;

            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;

                String[] d = parseLine(line);
                if (d.length < 1) continue;

                try {
                    id = Math.max(id, Integer.parseInt(d[0].trim()) + 1);
                } catch (NumberFormatException ignored) {}
            }

            br.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return id;
    }

    @Override
    public void create(File file, Ticket ticket) {

        try {
            file.getParentFile().mkdirs();
            file.createNewFile();

            int id = generateId(file);
            ticket.setId(id);

            BufferedWriter bw = new BufferedWriter(new FileWriter(file, true));
            bw.write(ticket.toFileString());
            bw.newLine();
            bw.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(File file, Ticket ticket) {

        List<Ticket> list = readAll(file);

        boolean found = false;
        List<Ticket> updated = new ArrayList<>();

        for (Ticket t : list) {
            if (t.getId() == ticket.getId()) {
                updated.add(ticket);
                found = true;
            } else {
                updated.add(t);
            }
        }

        if (found) {
            writeAll(file, updated);
        }
    }

    @Override
    public void delete(File file, int id) {

        List<Ticket> list = readAll(file);
        List<Ticket> updated = new ArrayList<>();

        for (Ticket t : list) {
            if (t.getId() != id) updated.add(t);
        }

        writeAll(file, updated);
    }

    @Override
    public List<Ticket> readAll(File file) {

        List<Ticket> list = new ArrayList<>();

        try {
            if (!file.exists()) return list;

            BufferedReader br = new BufferedReader(new FileReader(file));
            String line;

            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;

                String[] d = parseLine(line);

                if (d.length < 7) {
                    System.err.println("Skipping malformed ticket line: " + line);
                    continue;
                }

                try {
                    Ticket ticket = new Ticket(
                            Integer.parseInt(d[0].trim()),
                            Integer.parseInt(d[1].trim()),
                            Integer.parseInt(d[2].trim()),
                            Integer.parseInt(d[3].trim()),
                            d[4].trim(),
                            Double.parseDouble(d[5].trim()),
                            d[6].trim()
                    );
                    list.add(ticket);
                } catch (NumberFormatException e) {
                    System.err.println("Skipping malformed ticket line: " + line);
                }
            }

            br.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public void writeAll(File file, List<Ticket> list) {

        try {
            file.getParentFile().mkdirs();

            BufferedWriter bw = new BufferedWriter(new FileWriter(file));

            for (Ticket t : list) {
                bw.write(t.toFileString());
                bw.newLine();
            }

            bw.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}