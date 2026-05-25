package com.service;

import com.model.Booking;

import java.io.File;
import java.util.List;

public interface BookingService {

    int generateId(File file);

    void create(File file, Booking booking);

    void update(File file, Booking booking);

    void delete(File file, int id);

    List<String> readAll(File file);

    void writeAll(File file, List<String> list);
}