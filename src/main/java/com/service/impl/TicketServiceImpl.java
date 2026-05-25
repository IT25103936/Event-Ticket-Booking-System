package com.service.impl;

import com.model.Ticket;
import com.service.TicketService;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class TicketServiceImpl implements TicketService {

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
    public void create(File file, Ticket ticket) {

        try {

            file.getParentFile().mkdirs();
            file.createNewFile();

            int id = generateId(file);

            ticket.setId(id);

            BufferedWriter bw =
                    new BufferedWriter(
                            new FileWriter(file, true)
                    );

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

        List<Ticket> updated =
                new ArrayList<>();

        for (Ticket t : list) {

            if (t.getId() == ticket.getId()) {

                updated.add(ticket);

            } else {

                updated.add(t);
            }
        }

        writeAll(file, updated);
    }

    @Override
    public void delete(File file, int id) {

        List<Ticket> list = readAll(file);

        List<Ticket> updated =
                new ArrayList<>();

        for (Ticket t : list) {

            if (t.getId() != id) {
                updated.add(t);
            }
        }

        writeAll(file, updated);
    }

    @Override
    public List<Ticket> readAll(File file) {

        List<Ticket> list =
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

                Ticket ticket = new Ticket(
                        Integer.parseInt(d[0]),
                        Integer.parseInt(d[1]),
                       d[2],
                        Double.parseDouble(d[3]),
                        d[4]
                );

                list.add(ticket);
            }

            br.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return list;
    }

    @Override
    public void writeAll(File file,
                         List<Ticket> list) {

        try {

            BufferedWriter bw =
                    new BufferedWriter(
                            new FileWriter(file)
                    );

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