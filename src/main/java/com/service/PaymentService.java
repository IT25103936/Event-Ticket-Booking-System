package com.service;

import java.io.File;
import java.util.List;
import com.model.Payment;

public interface PaymentService {

    int generateId(File file);

    void create(File file, Payment payment);

    void update(File file, Payment payment);

    void delete(File file, int id);

    List<String> readAll(File file);

    void writeAll(File file, List<String> list);
}