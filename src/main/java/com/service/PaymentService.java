package com.service;

import com.model.Payment;

import java.io.File;
import java.util.List;

public interface PaymentService {

    int generateId(File file);

    void create(File file, Payment payment);

    void update(File file, Payment payment);

    void delete(File file, int id);

    List<String> readAll(File file);

    void writeAll(File file, List<String> list);
}