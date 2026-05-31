package com.controller.admin;

import com.model.Booking;
import com.service.BookingService;
import com.service.impl.BookingServiceImpl;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {

    private BookingService service = new BookingServiceImpl();

    private static final String FILE_PATH = "data/bookings.txt";

    private File getFile() {
        return new File(getServletContext().getRealPath("/") + FILE_PATH);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String action = request.getParameter("action");
        File file = getFile();

        // CREATE
        if ("create".equals(action)) {

            List<String> seats = parseSeats(request.getParameter("seats"));

            Booking b = new Booking(
                    0,
                    parseIntSafe(request.getParameter("userId")),
                    parseIntSafe(request.getParameter("eventId")),
                    seats,
                    parseIntSafe(request.getParameter("quantity")),
                    parseDoubleSafe(request.getParameter("totalPrice")),
                    parseIntSafe(request.getParameter("paymentId")),
                    request.getParameter("date"),
                    request.getParameter("time"),
                    request.getParameter("status")
            );

            service.create(file, b);
        }

        // UPDATE
        else if ("update".equals(action)) {

            List<String> seats = parseSeats(request.getParameter("seats"));

            Booking b = new Booking(
                    parseIntSafe(request.getParameter("id")),
                    parseIntSafe(request.getParameter("userId")),
                    parseIntSafe(request.getParameter("eventId")),
                    seats,
                    parseIntSafe(request.getParameter("quantity")),
                    parseDoubleSafe(request.getParameter("totalPrice")),
                    parseIntSafe(request.getParameter("paymentId")),
                    request.getParameter("date"),
                    request.getParameter("time"),
                    request.getParameter("status")
            );

            service.update(file, b);
        }

        //  DELETE
        else if ("delete".equals(action)) {
            service.delete(file, parseIntSafe(request.getParameter("id")));
        }

        response.sendRedirect(request.getContextPath() + "/admin/bookings.jsp");
    }


    private List<String> parseSeats(String seatsParam) {

        if (seatsParam == null || seatsParam.trim().isEmpty()) {
            return new ArrayList<>();
        }

        String[] parts = seatsParam.split(",");
        List<String> seats = new ArrayList<>();
        for (String part : parts) {
            String trimmed = part.trim();
            if (!trimmed.isEmpty()) {
                seats.add(trimmed.toUpperCase());
            }
        }
        return seats;
    }

    // SAFE INT
    private int parseIntSafe(String value) {
        try {
            return (value == null || value.isEmpty()) ? 0 : Integer.parseInt(value);
        } catch (Exception e) {
            return 0;
        }
    }

    // SAFE DOUBLE
    private double parseDoubleSafe(String value) {
        try {
            return (value == null || value.isEmpty()) ? 0.0 : Double.parseDouble(value);
        } catch (Exception e) {
            return 0.0;
        }
    }
}