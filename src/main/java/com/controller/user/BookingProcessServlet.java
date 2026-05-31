package com.controller.user;

import com.model.Booking;
import com.model.Payment;
import com.model.Ticket;
import com.model.User;

import com.service.BookingService;
import com.service.PaymentService;
import com.service.TicketService;

import com.service.impl.BookingServiceImpl;
import com.service.impl.PaymentServiceImpl;
import com.service.impl.TicketServiceImpl;

import com.utils.EmailUtil;
import com.utils.TicketPdfGenerator;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/BookingProcessServlet")
@MultipartConfig
public class BookingProcessServlet extends HttpServlet {

    private final BookingService  service       = new BookingServiceImpl();
    private final PaymentService  pservice      = new PaymentServiceImpl();
    private final TicketService   ticketService = new TicketServiceImpl();

    private static final String BOOKING_FILE = "data/bookings.txt";
    private static final String PAYMENT_FILE = "data/payments.txt";
    private static final String TICKET_FILE  = "data/tickets.txt";

    private File getFile(String path) {
        return new File(getServletContext().getRealPath("/") + path);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");


        if ("cancel".equals(action)) {
            handleCancel(request, response);
            return;
        }

        if (!"create".equals(action)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid action");
            return;
        }


        // CREATE BOOKING
        try {
            User user = (User) request.getSession().getAttribute("user");
            String email = (user != null) ? user.getEmail() : "";

            int    userId        = parseIntSafe(request.getParameter("userId"));
            int    eventId       = parseIntSafe(request.getParameter("eventId"));
            String seatsParam    = sanitise(request.getParameter("selectedSeats"));
            double totalPrice    = parseDoubleSafe(request.getParameter("totalPrice"));
            String date          = sanitise(request.getParameter("date"));
            String time          = sanitise(request.getParameter("time"));
            String paymentMethod = sanitise(request.getParameter("paymentMethod"));
            String location      = sanitise(request.getParameter("location"));
            String eventName     = sanitise(request.getParameter("eventName"));

            List<String> seatList = parseSeats(seatsParam);
            int quantity = seatList.size();

            if (quantity == 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("No seats selected");
                return;
            }

            // PAYMENT
            String status = "CASH".equalsIgnoreCase(paymentMethod) ? "PENDING" : "PAID";

            Payment payment = new Payment(
                    0, userId, totalPrice, paymentMethod, status, date
            );
            pservice.create(getFile(PAYMENT_FILE), payment);
            int paymentId = payment.getId();

            // BOOKING
            Booking booking = new Booking(
                    0, userId, eventId, seatList,
                    quantity, totalPrice, paymentId, date, time, status
            );
            service.create(getFile(BOOKING_FILE), booking);
            int bookingId = booking.getId();

            // TICKET
            double singleTicketPrice = totalPrice / quantity;
            Ticket ticket = new Ticket(
                    0, bookingId, userId, eventId,
                    seatList.toString(), totalPrice, "ACTIVE"
            );
            ticketService.create(getFile(TICKET_FILE), ticket);

            // EMAIL + PDF
            String pdfPath = TicketPdfGenerator.generateTicket(
                    "BK" + bookingId,
                    eventName,
                    "User-" + userId,
                    date,
                    time,
                    location,
                    seatList.toString(),
                    String.valueOf(quantity),
                    String.valueOf(totalPrice),
                    paymentMethod
            );

            String html = "<h2>Booking Confirmed</h2>"
                    + "<p>Your ticket is attached.</p>"
                    + "<p><b>Booking ID:</b> " + bookingId + "</p>";

            EmailUtil.sendTicketEmail(email, "Event Pass | Event Ticket Booking", html, pdfPath);

            System.out.println("======================================");
            System.out.println("TICKET EMAIL SENT SUCCESSFULLY");
            System.out.println("Booking ID : " + bookingId);
            System.out.println("User Email : " + email);
            System.out.println("PDF Path   : " + pdfPath);
            System.out.println("Seats      : " + seatList);
            System.out.println("Total      : " + totalPrice);
            System.out.println("Payment    : " + paymentMethod);
            System.out.println("Status     : " + status);
            System.out.println("======================================");

            response.getWriter().write(String.valueOf(bookingId));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("ERROR");
        }
    }


    //  cancel handler — marks booking + ticket

    private void handleCancel(HttpServletRequest request,
                              HttpServletResponse response) throws IOException {

        int bookingId = parseIntSafe(request.getParameter("bookingId"));
        int userId    = parseIntSafe(request.getParameter("userId"));

        if (bookingId <= 0) {
            response.sendRedirect(
                    request.getContextPath() + "/user/myBooking.jsp?error=invalid_id"
            );
            return;
        }

        try {
            File bookingFile = getFile(BOOKING_FILE);
            File ticketFile  = getFile(TICKET_FILE);


            List<String> bookingLines = readLines(bookingFile);
            List<String> updatedBookings = new ArrayList<>();
            boolean bookingFound = false;

            for (String line : bookingLines) {
                if (line.trim().isEmpty()) { updatedBookings.add(line); continue; }

                String[] firstTwo = line.split(",", 3);
                int  lineBookingId = parseIntSafe(firstTwo[0]);
                int  lineUserId    = firstTwo.length > 1 ? parseIntSafe(firstTwo[1]) : 0;

                if (lineBookingId == bookingId && lineUserId == userId) {
                    // Replace the last token (status) with CANCELLED
                    String updated = replaceLastToken(line, "CANCELLED");
                    updatedBookings.add(updated);
                    bookingFound = true;
                } else {
                    updatedBookings.add(line);
                }
            }

            if (!bookingFound) {
                response.sendRedirect(
                        request.getContextPath() + "/user/myBooking.jsp?error=not_found"
                );
                return;
            }

            writeLines(bookingFile, updatedBookings);


            List<String> ticketLines   = readLines(ticketFile);
            List<String> updatedTickets = new ArrayList<>();

            for (String line : ticketLines) {
                if (line.trim().isEmpty()) { updatedTickets.add(line); continue; }


                String[] parts = line.split(",", 3);

                int lineTicketBookingId = parts.length > 1 ? parseIntSafe(parts[1]) : -1;

                if (lineTicketBookingId == bookingId) {
                    updatedTickets.add(replaceLastToken(line, "CANCELLED"));
                } else {
                    updatedTickets.add(line);
                }
            }

            writeLines(ticketFile, updatedTickets);

            System.out.println("Booking #" + bookingId + " cancelled by user " + userId);

            response.sendRedirect(
                    request.getContextPath() + "/user/myBooking.jsp?cancelled=1"
            );

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(
                    request.getContextPath() + "/user/myBooking.jsp?error=server"
            );
        }
    }


    // HELPERS


    private List<String> readLines(File file) throws IOException {
        List<String> lines = new ArrayList<>();
        if (!file.exists()) return lines;
        BufferedReader br = new BufferedReader(new FileReader(file));
        String line;
        while ((line = br.readLine()) != null) lines.add(line);
        br.close();
        return lines;
    }


    private void writeLines(File file, List<String> lines) throws IOException {
        file.getParentFile().mkdirs();
        BufferedWriter bw = new BufferedWriter(new FileWriter(file));
        for (String line : lines) {
            bw.write(line);
            bw.newLine();
        }
        bw.close();
    }


    private String replaceLastToken(String line, String newValue) {

        int depth = 0;
        for (int i = line.length() - 1; i >= 0; i--) {
            char c = line.charAt(i);
            if (c == ']') depth++;
            else if (c == '[') depth--;
            else if (c == ',' && depth == 0) {
                return line.substring(0, i + 1) + newValue;
            }
        }
        return line;
    }

    private List<String> parseSeats(String seatsParam) {
        List<String> result = new ArrayList<>();
        if (seatsParam == null || seatsParam.trim().isEmpty()) return result;
        for (String s : seatsParam.split(",")) {
            String t = s.trim().toUpperCase();
            if (!t.isEmpty()) result.add(t);
        }
        return result;
    }

    private int parseIntSafe(String v) {
        try { return (v == null || v.isEmpty()) ? 0 : Integer.parseInt(v.trim()); }
        catch (Exception e) { return 0; }
    }

    private double parseDoubleSafe(String v) {
        try { return (v == null || v.isEmpty()) ? 0.0 : Double.parseDouble(v.trim()); }
        catch (Exception e) { return 0.0; }
    }

    private String sanitise(String v) {
        return v == null ? "" : v.trim();
    }
}