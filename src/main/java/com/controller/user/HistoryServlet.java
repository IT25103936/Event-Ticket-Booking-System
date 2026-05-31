package com.controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/HistoryServlet")
public class HistoryServlet extends HttpServlet {

    private static final String BOOKINGS_FILE = "data/bookings.txt";
    private static final String PAYMENTS_FILE = "data/payments.txt";
    private static final String TICKETS_FILE  = "data/tickets.txt";

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();


        String currentUserId = "";
        Object userObj = session.getAttribute("user");

        if (userObj != null) {
            try {
                currentUserId = String.valueOf(
                        ((com.model.User) userObj).getId()
                );
            } catch (Exception e) {
                currentUserId = "";
            }
        }


        if (currentUserId == null || currentUserId.isEmpty()) {
            Object uid = session.getAttribute("userId");
            if (uid != null) currentUserId = String.valueOf(uid);
        }

        List<Map<String, String>> bookingHistory = new ArrayList<>();

        File bookingFile = new File(
                getServletContext().getRealPath("/") + BOOKINGS_FILE
        );

        if (bookingFile.exists()) {
            try (BufferedReader br =
                         new BufferedReader(new FileReader(bookingFile))) {

                String line;
                while ((line = br.readLine()) != null) {
                    line = line.trim();
                    if (line.isEmpty()) continue;


                    String bookingId, userId, eventId, seats, qty, total, payId, date, time, status;

                    int bOpen  = line.indexOf('[');
                    int bClose = line.indexOf(']');

                    if (bOpen != -1 && bClose > bOpen) {

                        String[] prefix = line.substring(0, bOpen).split(",");
                        String   seat   = line.substring(bOpen, bClose + 1); // "[A3,B3]"

                        String[] suffix = line.substring(bClose + 1).split(",");

                        if (prefix.length < 3 || suffix.length < 7) continue;

                        bookingId = prefix[0].trim();
                        userId    = prefix[1].trim();
                        eventId   = prefix[2].trim();

                        seats     = seat.substring(1, seat.length() - 1).trim();
                        qty       = suffix[1].trim();
                        total     = suffix[2].trim();
                        payId     = suffix[3].trim();
                        date      = suffix[4].trim();
                        time      = suffix[5].trim();
                        status    = suffix[6].trim();

                    } else {

                        String[] d = line.split(",");
                        if (d.length < 10) continue;

                        bookingId = d[0].trim();
                        userId    = d[1].trim();
                        eventId   = d[2].trim();
                        seats     = d[3].trim();
                        qty       = d[4].trim();
                        total     = d[5].trim();
                        payId     = d[6].trim();
                        date      = d[7].trim();
                        time      = d[8].trim();
                        status    = d[9].trim();
                    }


                    if (!currentUserId.equals(userId)) continue;

                    Map<String, String> map = new HashMap<>();
                    map.put("bookingId",  bookingId);
                    map.put("eventId",    eventId);
                    map.put("userId",     userId);
                    map.put("seats",      seats);
                    map.put("qty",        qty);
                    map.put("total",      total);
                    map.put("paymentId",  payId);
                    map.put("date",       date);
                    map.put("time",       time);
                    map.put("status",     status);


                    map.put("paymentMethod", "—");
                    map.put("paymentStatus", "—");
                    map.put("ticketIds",     "—");

                    loadPaymentDetails(map, payId);
                    loadTicketDetails(map, bookingId);

                    bookingHistory.add(map);
                }
            }
        }

        request.setAttribute("historyList", bookingHistory);
        request.getRequestDispatcher("/user/history.jsp")
                .forward(request, response);
    }

    // PAYMENT DETAILS

    private void loadPaymentDetails(Map<String, String> map, String paymentId) {
        try {
            File file = new File(
                    getServletContext().getRealPath("/") + PAYMENTS_FILE
            );
            if (!file.exists()) return;

            BufferedReader br = new BufferedReader(new FileReader(file));
            String line;
            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;

                String[] d = line.split(",", 6);
                if (d.length < 5) continue;
                if (!d[0].trim().equals(paymentId)) continue;

                map.put("paymentMethod", d[3].trim());
                map.put("paymentStatus", d[4].trim());
                break;
            }
            br.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private void loadTicketDetails(Map<String, String> map, String bookingId) {
        try {
            File file = new File(
                    getServletContext().getRealPath("/") + TICKETS_FILE
            );
            if (!file.exists()) return;

            BufferedReader br = new BufferedReader(new FileReader(file));
            String line;
            List<String> ticketIds = new ArrayList<>();

            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;


                String[] d = line.split(",", 7);
                if (d.length < 2) continue;

                String tid = d[0].trim();
                String bid = d[1].trim();

                if (bid.equals(bookingId)) {
                    ticketIds.add("#T" + tid);
                }
            }
            br.close();

            if (!ticketIds.isEmpty()) {
                map.put("ticketIds", String.join(", ", ticketIds));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}