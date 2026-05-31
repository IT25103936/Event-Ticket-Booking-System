package com.service;

import java.io.File;
import java.util.List;
import com.model.Booking;

public interface BookingService {

    int generateId(File file);

    void create(File file, Booking booking);

    void update(File file, Booking booking);

    void delete(File file, int id);

    List<String> readAll(File file);

    void writeAll(File file, List<String> list);
}