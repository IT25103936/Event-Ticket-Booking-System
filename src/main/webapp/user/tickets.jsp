<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>My Tickets | EventPass</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="/eventTicketBookingSystem/css/userview/tickets.css">
</head>

<body>

<%@ include file="navbar.jsp" %>

<%
User user = (User) session.getAttribute("user");
String userId = (user != null) ? String.valueOf(user.getId()) : "";

String path = application.getRealPath("/") + "data/tickets.txt";
File file = new File(path);

boolean hasTickets = false;
%>

<div class="page-header text-center mt-5">
    <div class="container">
        <h1 class="fw-800 display-5" style="font-weight: 800;">My Tickets</h1>
        <p class="text-muted">You have 3 upcoming events. Ready to explore?</p>
    </div>
</div>

<div class="container mb-5">
    <div class="row justify-content-center">
        <div class="col-lg-10">

<%
if (file.exists()) {

    BufferedReader br = new BufferedReader(new FileReader(file));
    String line;

    while ((line = br.readLine()) != null) {

        if (line.trim().isEmpty()) continue;

        String[] d = line.split(",");

        if (d.length < 5) continue;

        String ticketId = d[0];
        String eventId  = d[1];
        String seat     = d[2];
        String price    = d[3];
        String status   = d[4];

        hasTickets = true;
%>


            <!-- TICKET -->
            <div class="ticket-wrapper">
                <div class="ticket-card">

                    <div class="ticket-info">
                        <span class="t-category">Event Ticket</span>
                        <h2 class="t-name">Event ID: <%= eventId %></h2>

                        <div class="t-meta">
                            <div class="meta-box">
                                <span>Seat</span>
                                <p><%= seat %></p>
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
                                Ticket Booking System
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

    br.close();
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