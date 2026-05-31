package com.service;

import com.model.Rating;

import java.io.File;
import java.util.List;

public interface RatingService {

    int generateId(File file);

    void create(File file, Rating rating);

    void update(File file, Rating rating);

    void delete(File file, int id);

    List<Rating> readAll(File file);

    void writeAll(File file, List<Rating> list);
}