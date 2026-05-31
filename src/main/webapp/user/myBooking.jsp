<%@ page import="java.io.*" %>
<%@ page import="com.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>My Bookings | EventPass</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="/EventTicketBookingSystem/css/userview/myBookings.css">
</head>

<body>

<%@ include file="navbar.jsp" %>

<%
User user = (User) session.getAttribute("user");
String userId = (user != null) ? String.valueOf(user.getId()) : "";
%>

<div class="main-content">
    <div class="container">

        <div class="d-flex justify-content-between align-items-center mb-5">
            <div>
                <h3 class="mb-1">My Reservations</h3>
                <p class="text-muted fw-500 mb-0">Overview of your scheduled event access.</p>
            </div>
            <a href="events.jsp" class="btn btn-add-glass">
                <i class="bi bi-plus-circle-fill me-2"></i>New Booking
            </a>
        </div>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="stat-card-glass">
                    <div class="stat-icon-circle text-primary">
                        <i class="bi bi-ticket-perforated-fill"></i>
                    </div>
                    <div>
                        <small class="text-muted fw-bold d-block">ACTIVE</small>
                        <span class="fs-4 fw-800 text-dark">12 Tickets</span>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card-glass">
                    <div class="stat-icon-circle text-warning">
                        <i class="bi bi-hourglass-split"></i>
                    </div>
                    <div>
                        <small class="text-muted fw-bold d-block">WAITING</small>
                        <span class="fs-4 fw-800 text-dark">02 Pending</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="glass-panel">
            <div class="table-responsive">
                <table class="table table-custom">
                    <thead>
                        <tr>
                            <th>Identifier</th>
                            <th>Event Activity</th>
                            <th>Quantity</th>
                            <th>Status</th>
                            <th class="text-end">Management</th>
                        </tr>
                    </thead>

                    <tbody>
<%
String path = application.getRealPath("/") + "data/bookings.txt";
File file = new File(path);

if (file.exists()) {
    BufferedReader br = new BufferedReader(new FileReader(file));
    String line;

    while ((line = br.readLine()) != null) {
        if (line.trim().isEmpty()) continue;

        // FIX: bracket-aware parse — same issue as tickets.txt
        // Format: id,userId,eventId,[seat,seat,...],qty,total,paymentId,date,time,status
        String bookingId, userIdDb, eventId, seats, qty, total, date, time, status;

        int bOpen  = line.indexOf('[');
        int bClose = line.indexOf(']');

        if (bOpen != -1 && bClose > bOpen) {
            // Split prefix (before '[') and suffix (after ']') separately
            String[] prefix = line.substring(0, bOpen).split(",");   // id,userId,eventId,
            String   seat   = line.substring(bOpen, bClose + 1);     // [A3,B3]
            String[] suffix = line.substring(bClose + 1).split(","); // ,qty,total,payId,date,time,status

            // prefix: ["id","userId","eventId",""] — last element is empty (trailing comma)
            // suffix: ["","qty","total","payId","date","time","status"]
            if (prefix.length < 3 || suffix.length < 7) continue;

            bookingId = prefix[0].trim();
            userIdDb  = prefix[1].trim();
            eventId   = prefix[2].trim();
            seats     = seat.trim();
            qty       = suffix[1].trim();
            total     = suffix[2].trim();
            // suffix[3] = paymentId (skip)
            date      = suffix[4].trim();
            time      = suffix[5].trim();
            status    = suffix[6].trim();

        } else {
            // No brackets — plain single seat
            String[] d = line.split(",");
            if (d.length < 10) continue;

            bookingId = d[0].trim();
            userIdDb  = d[1].trim();
            eventId   = d[2].trim();
            seats     = d[3].trim();
            qty       = d[4].trim();
            total     = d[5].trim();
            // d[6] = paymentId (skip)
            date      = d[7].trim();
            time      = d[8].trim();
            status    = d[9].trim();
        }

        // FIX: filter to only show bookings belonging to the logged-in user
        if (userId.isEmpty() || !userId.equals(userIdDb)) continue;

        // Strip brackets from seat display
        String seatsDisplay = (seats.startsWith("[") && seats.endsWith("]"))
                ? seats.substring(1, seats.length() - 1) : seats;

        String bg    = "#dcfce7";
        String color = "#15803d";
        if ("PENDING".equalsIgnoreCase(status))   { bg = "#fef9c3"; color = "#a16207"; }
        else if ("CANCELLED".equalsIgnoreCase(status)) { bg = "#fee2e2"; color = "#b91c1c"; }
%>

<tr>
    <td><span class="booking-tag">#BK-<%= bookingId %></span></td>

    <td>
        <span class="event-main-text">Event ID: <%= eventId %></span>
        <small class="text-muted">
            <i class="bi bi-geo-alt-fill me-1"></i>
            Seats: <%= seatsDisplay %> &bull; <%= date %> <%= time %>
        </small>
    </td>

    <td><span class="fw-bold"><%= qty %> Seats</span></td>

    <td>
        <span class="badge rounded-pill"
              style="background:<%= bg %>; color:<%= color %>; font-weight:700;">
            <%= status %>
        </span>
    </td>

    <td class="text-end">
        <% if (!"CANCELLED".equalsIgnoreCase(status)) { %>
        <%-- FIX: correct servlet URL + action=cancel --%>
        <form method="post" action="<%= request.getContextPath() %>/BookingProcessServlet">
            <input type="hidden" name="action"    value="cancel">
            <input type="hidden" name="bookingId" value="<%= bookingId %>">
            <input type="hidden" name="userId"    value="<%= userId %>">
            <button type="submit" class="btn btn-cancel-glass"
                    onclick="return confirm('Cancel booking #BK-<%= bookingId %>?')">
                Cancel
            </button>
        </form>
        <% } else { %>
        <span class="text-muted small">Cancelled</span>
        <% } %>
    </td>
</tr>

<%
    }
    br.close();
}
%>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</div>

<%@ include file="footer.jsp" %>

</body>
</html>
