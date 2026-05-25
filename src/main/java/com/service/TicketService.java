package com.service;

import com.model.Ticket;

import java.io.File;
import java.util.List;

public interface TicketService {

    int generateId(File file);

    void create(File file, Ticket ticket);

    void update(File file, Ticket ticket);

    void delete(File file, int id);

    List<Ticket> readAll(File file);

    void writeAll(File file, List<Ticket> list);
}