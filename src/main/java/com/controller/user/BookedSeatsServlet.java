package com.controller.user;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

@WebServlet("/BookedSeatsServlet")
public class BookedSeatsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws IOException {

        response.setContentType("text/plain");

        File file = new File(getServletContext().getRealPath("/") + "data/bookings.txt");

        StringBuilder booked = new StringBuilder();

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {

            String line;

            while ((line = br.readLine()) != null) {

                String[] d = line.split(",");

                if (d.length < 4) continue;

                String seats = d[3]; // B3|C5

                booked.append(seats).append("|"); // collect all seats
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.getWriter().write(booked.toString());
    }
}