<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%!
// --- HELPER METHOD: Finds Event Name by cross-referencing Booking ID through bookings.txt and events.txt ---
public String getEventNameByBookingId(String bookingId, ServletContext application) {
    if (bookingId == null || bookingId.trim().isEmpty()) return "Unknown Transaction";

    String bookingsPath = application.getRealPath("/") + "data/bookings.txt";
    String eventsPath = application.getRealPath("/") + "data/events.txt";

    File bookingsFile = new File(bookingsPath);
    String foundEventId = null;

    // Step 1: Search bookings.txt for the bookingId to extract the corresponding eventId
    if (bookingsFile.exists()) {
        try (BufferedReader br = new BufferedReader(new FileReader(bookingsFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                String[] tokens = line.split(",");
                // Assuming bookings.txt: bookingId, eventId, userId, ...
                if (tokens.length >= 2 && tokens[0].trim().equalsIgnoreCase(bookingId.trim())) {
                    foundEventId = tokens[1].trim();
                    break;
                }
            }
        } catch (Exception e) {
            // Fallback gracefully on parsing glitches
        }
    }

    if (foundEventId == null) return "Booking Ref: #" + bookingId;

    // Step 2: Search events.txt using the foundEventId to extract the human-readable Title
    File eventsFile = new File(eventsPath);
    if (eventsFile.exists()) {
        try (BufferedReader br = new BufferedReader(new FileReader(eventsFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                String[] tokens = line.split(",");
                if (tokens.length >= 2 && tokens[0].trim().equalsIgnoreCase(foundEventId)) {
                    return tokens[1].trim();
                }
            }
        } catch (Exception e) {
            // Fallback gracefully
        }
    }

    return "Event ID: " + foundEventId;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Transaction Flow | EventPass</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="/EventTicketBookingSystem/css/userview/payments.css">
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="main-content">
    <div class="container">

        <h2 class="page-title">Financial Flow</h2>

        <div class="label-row d-none d-md-flex">
            <div style="flex: 2;">Account / Protocol</div>
            <div style="flex: 1;">Transaction Volume</div>
            <div style="flex: 0.5; text-align: right;">Status</div>
        </div>

<%
    String paymentPath = application.getRealPath("/") + "data/payments.txt";
    File file = new File(paymentPath);
    boolean hasPayments = false;

    // Fetch the logged-in user to ensure they only view their own transactions if needed
    User user = (User) session.getAttribute("user");
    String currentUserId = (user != null) ? String.valueOf(user.getId()).trim() : "";

    if (file.exists()) {
        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.trim().isEmpty()) continue;

                // Splitting explicitly across the 6 available columns
                String[] d = line.split(",");
                if (d.length < 6) continue;

                String paymentId = d[0].trim();
                String bookingId = d[1].trim();
                String amount    = d[2].trim();
                String method    = d[3].trim();
                String status    = d[4].trim();
                String date      = d[5].trim();

                hasPayments = true;

                // Smart Lookup: Find the event title by looking up the booking reference
                String eventName = getEventNameByBookingId(bookingId, application);

                // UI Presentation Context Mappings
                String statusClass = "status-pending";
                String statusIcon = "bi-clock-history";

                if ("CLEARED".equalsIgnoreCase(status) || "PAID".equalsIgnoreCase(status) || "SUCCESS".equalsIgnoreCase(status)) {
                    statusClass = "status-paid";
                    statusIcon = "bi-patch-check-fill";
                } else if ("FAILED".equalsIgnoreCase(status) || "CANCELLED".equalsIgnoreCase(status)) {
                    statusClass = "status-cancelled";
                    statusIcon = "bi-x-circle-fill";
                }
%>

        <div class="transaction-item">
            <div class="data-main">
                <div class="avatar-box">
                    <div style="width: 45px; height: 45px; background: white; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px;">
                        <i class="bi bi-credit-card-2-front <%= statusClass.equals("status-paid") ? "text-primary" : "text-warning" %>"></i>
                    </div>
                </div>
                <div>
                    <span class="id-tag">#TRX-<%= paymentId %></span>
                    <h5 class="user-name">Booking Ref: #BK-<%= bookingId %></h5>
                    <span class="event-sub"><%= eventName %></span>
                </div>
            </div>

            <div class="data-info">
                <p class="amount-big">LKR <%= amount %></p>
                <span class="date-muted"><%= date %> • via <%= method %></span>
            </div>

            <div class="data-status">
                <span class="status-pill <%= statusClass %>">
                    <i class="bi <%= statusIcon %>"></i> <%= status.toUpperCase() %>
                </span>
            </div>
        </div>

<%
            }
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error rendering log data: " + e.getMessage() + "</div>");
        }
    }

    if (!hasPayments) {
%>
        <div class="text-center py-5">
            <i class="bi bi-cash-stack text-muted" style="font-size: 4rem; opacity: 0.3;"></i>
            <h4 class="mt-3 text-muted">No transactions found</h4>
        </div>
<%
    }
%>

    </div>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>