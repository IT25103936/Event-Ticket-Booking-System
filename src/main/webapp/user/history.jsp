<%@ page import="java.util.*" %>
<%@ page import="com.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Activity History | EventPass</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/eventTicketBookingSystem/css/userview/history.css">
</head>

<body>

<%@ include file="navbar.jsp" %>

<div class="main-content">
    <div class="container">

        <div class="history-card">

            <div class="d-flex justify-content-between align-items-center mb-5">
                <h4 class="page-title mb-0">
                    <i class="bi bi-clock-history text-primary me-2"></i>
                    Activity History
                </h4>
                <div class="text-muted small fw-bold">
                    Booking + Payment + Ticket Logs
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-glass">
                    <thead>
                        <tr>
                            <th>Action ID</th>
                            <th>Activity</th>
                            <th>Details</th>
                            <th>Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>

                    <tbody>
<%
List<Map<String,String>> historyList =
        (List<Map<String,String>>) request.getAttribute("historyList");

if (historyList != null && !historyList.isEmpty()) {

    for (Map<String,String> h : historyList) {

        String bookingId     = h.getOrDefault("bookingId",     "—");
        String eventId       = h.getOrDefault("eventId",       "—");
        String seats         = h.getOrDefault("seats",         "—");
        String qty           = h.getOrDefault("qty",           "—");
        String total         = h.getOrDefault("total",         "—");
        String paymentId     = h.getOrDefault("paymentId",     "—");
        String paymentMethod = h.getOrDefault("paymentMethod", "—");
        String paymentStatus = h.getOrDefault("paymentStatus", "—");
        String ticketIds     = h.getOrDefault("ticketIds",     "—");
        String date          = h.getOrDefault("date",          "—");
        String time          = h.getOrDefault("time",          "—");
        String status        = h.getOrDefault("status",        "—");

        // FIX: match actual status values — PAID / PENDING / CANCELLED
        // (was checking "CONFIRMED" which never matched → every row showed red)
        String badgeClass;
        String badgeIcon;
        if (status.equalsIgnoreCase("PAID") || status.equalsIgnoreCase("ACTIVE")) {
            badgeClass = "bg-success bg-opacity-10 text-success";
            badgeIcon  = "bi-check-circle-fill";
        } else if (status.equalsIgnoreCase("PENDING")) {
            badgeClass = "bg-warning bg-opacity-10 text-warning";
            badgeIcon  = "bi-hourglass-split";
        } else if (status.equalsIgnoreCase("CANCELLED")) {
            badgeClass = "bg-secondary bg-opacity-10 text-secondary";
            badgeIcon  = "bi-x-circle-fill";
        } else {
            badgeClass = "bg-danger bg-opacity-10 text-danger";
            badgeIcon  = "bi-exclamation-circle-fill";
        }
%>

<tr>
    <td>
        <span class="id-pill">#BK-<%= bookingId %></span>
    </td>

    <td>
        <div class="fw-bold">Booking Created</div>
        <small class="text-muted">
            <i class="bi bi-credit-card me-1"></i><%= paymentMethod %>
        </small>
        <% if (!paymentId.equals("—")) { %>
        <br><small class="text-muted">Pay ID: #<%= paymentId %></small>
        <% } %>
    </td>

    <td>
        <div><strong>Event ID:</strong> <%= eventId %></div>
        <div><strong>Seats:</strong> <%= seats %></div>
        <div><strong>Qty:</strong> <%= qty %></div>
        <div><strong>Total:</strong> LKR <%= total %></div>
        <div><strong>Tickets:</strong> <%= ticketIds %></div>
    </td>

    <td class="text-muted">
        <%= date %><br>
        <small><%= time %></small>
    </td>

    <td>
        <span class="badge-status <%= badgeClass %>">
            <i class="bi <%= badgeIcon %> me-1"></i>
            <%= status %>
        </span>
    </td>
</tr>

<%
    }

} else {
%>

<tr>
    <td colspan="5" class="text-center py-5">
        <i class="bi bi-clock-history text-muted" style="font-size: 3rem; opacity: .3;"></i>
        <h5 class="mt-3 text-muted">No Activity Found</h5>
        <p class="text-muted small">Your booking history will appear here once you make a reservation.</p>
    </td>
</tr>

<%
}
%>
                    </tbody>
                </table>
            </div>

        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
<script defer src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
