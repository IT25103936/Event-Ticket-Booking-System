<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%!
// --- HELPER METHOD: Finds the Event Name from events.txt using Event ID ---
public String getEventNameById(String eventId, ServletContext application) {
    String path = application.getRealPath("/") + "data/events.txt";
    File file = new File(path);

    if (!file.exists()) return "Unknown Event (" + eventId + ")";

    try (BufferedReader br = new BufferedReader(new FileReader(file))) {
        String line;
        while ((line = br.readLine()) != null) {
            if (line.trim().isEmpty()) continue;
            String[] tokens = line.split(",");

            // Assuming index 0 is Event ID, and index 1 is the Event Name
            if (tokens.length >= 2 && tokens[0].trim().equals(eventId.trim())) {
                return tokens[1].trim();
            }
        }
    } catch (Exception e) {
        return "Error loading name (" + eventId + ")";
    }
    return "Event Not Found";
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>My Tickets | EventPass</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="/EventTicketBookingSystem/css/userview/tickets.css">
</head>

<body>

<%@ include file="navbar.jsp" %>

<%
User user = (User) session.getAttribute("user");
String currentUserId = (user != null) ? String.valueOf(user.getId()).trim() : "";

String path = application.getRealPath("/") + "data/tickets.txt";
File file = new File(path);

boolean hasTickets = false;
%>

<div class="page-header text-center mt-5">
    <div class="container">
        <h1 class="fw-800 display-5" style="font-weight: 800;">My Tickets</h1>
        <p class="text-muted">Review your upcoming event entry passes.</p>
    </div>
</div>

<div class="container mb-5">
    <div class="row justify-content-center">
        <div class="col-lg-10">

<%
if (file.exists() && !currentUserId.isEmpty()) {

    try (BufferedReader br = new BufferedReader(new FileReader(file))) {
        String line;

        while ((line = br.readLine()) != null) {
            if (line.trim().isEmpty()) continue;

            String[] d = line.split(",");
            if (d.length < 6) continue;

            String ticketId = d[0].trim();
            String eventId  = d[3].trim();
            String userIdDB = d[2].trim();


            if (!currentUserId.equals(userIdDB)) continue;

            // CROSS-REFERENCE CALL: Grab the real title name from events.txt
            String eventName = getEventNameById(eventId, application);

            String seatsRaw = d[3];
            if (d.length > 6) {
                StringBuilder sb = new StringBuilder(d[3]);
                for (int i = 4; i < d.length - 2; i++) {
                    sb.append(",").append(d[i]);
                }
                seatsRaw = sb.toString();
            }

            String price  = d[d.length - 2].trim();
            String status = d[d.length - 1].trim();

            hasTickets = true;

            String seats = seatsRaw
                    .replace("[", "")
                    .replace("]", "")
                    .replace(",", " | ")
                    .replace("\"", "");
%>

            <div class="ticket-wrapper mb-4">
                <div class="ticket-card">

                    <div class="ticket-info">
                        <span class="t-category">Event Ticket</span>
                        <h2 class="t-name"><%= eventName %></h2>

                        <div class="t-meta">
                            <div class="meta-box">
                                <span>Seat</span>
                                <p><%= seats %></p>
                            </div>

                            <div class="meta-box">
                                <span>Price</span>
                                <p>LKR <%= price %></p>
                            </div>

                            <div class="meta-box">
                                <span>Status</span>
                                <p><%= status %></p>
                            </div>
                        </div>

                        <div class="mt-3">
                            <span class="small text-muted">
                                <i class="bi bi-ticket-perforated text-primary"></i>
                                Event ID: <%= eventId %>
                            </span>
                        </div>
                    </div>

                    <div class="ticket-stub">
                        <div class="qr-box">
                            <i class="bi bi-qr-code"></i>
                        </div>

                        <span class="t-id">#TKT-<%= ticketId %></span>

                        <div class="status-badge">
                            <%= status %>
                        </div>
                    </div>

                </div>
            </div>

<%
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error processing tickets file: " + e.getMessage() + "</div>");
    }
}
%>

<%
if (!hasTickets) {
%>
    <div class="text-center py-5">
        <i class="bi bi-ticket-detailed text-muted" style="font-size: 4rem; opacity: 0.3;"></i>
        <h4 class="mt-3 text-muted">No tickets found</h4>
        <a href="events.jsp" class="btn btn-primary mt-2">Browse Events</a>
    </div>
<%
}
%>

        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>