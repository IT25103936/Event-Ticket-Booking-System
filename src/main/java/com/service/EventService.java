package com.service;

import com.model.Event;
import java.io.File;
import java.util.List;

public interface EventService {

    int generateNextId(File file);

    void create(File file, Event event);

    void update(File file, Event event);

    void delete(File file, int id);

    List<Event> readAll(File file);

    void writeAll(File file, List<Event> events);
}

