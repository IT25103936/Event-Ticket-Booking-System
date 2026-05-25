<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ticket Inventory | EventPass</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="/eventTicketBookingSystem/css/adminview/tickets.css">
</head>

<body>

<div class="page-wrapper">
    <%@ include file="navbar.jsp" %>

    <main class="main-content">
        <div class="glass-header">
            <div>
                <h4 class="fw-800 mb-0" style="letter-spacing: -1px;">Ticket Inventory</h4>
                <p class="text-muted small mb-0">Manage individual ticket units and seat assignments</p>
            </div>

            <button class="btn-add-ticket" onclick="openAdd()">
                <i class="bi bi-ticket-perforated-fill me-2"></i> Issue Ticket
            </button>
        </div>

        <div class="crystal-card">
            <table class="crystal-table">
                <thead>
                    <tr>
                        <th>Ticket ID</th>
                        <th>Booking Ref</th>
                        <th>User ID</th>
                        <th>Event ID</th>
                        <th>Seat</th>
                        <th>Value</th>
                        <th>Status</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
               <tbody>
               <%
                   File file = new File(application.getRealPath("/") + "data/tickets.txt");

                   if (file.exists()) {

                       try (BufferedReader br = new BufferedReader(new FileReader(file))) {

                           String line;

                           while ((line = br.readLine()) != null) {

                               if (line.trim().isEmpty()) continue;

                               String[] d = line.split(",");

                               if (d.length < 7) continue;

                               String id        = d[0].trim();
                               String bookingId = d[1].trim();
                               String userId    = d[2].trim();
                               String eventId   = d[3].trim();

                               // FIX SEATS
                               StringBuilder seatBuilder = new StringBuilder();

                               for (int i = 4; i < d.length - 2; i++) {

                                   if (i > 4) {
                                       seatBuilder.append(",");
                                   }

                                   seatBuilder.append(d[i].trim());
                               }

                               String seatsRaw = seatBuilder.toString();

                               String seatsDisplay = seatsRaw
                                       .replace("[", "")
                                       .replace("]", "")
                                       .replace(",", " ");

                               // LAST 2 VALUES
                               String price  = d[d.length - 2].trim();
                               String status = d[d.length - 1].trim();

                               String statusClass =
                                       status.equalsIgnoreCase("ACTIVE") ? "status-active" :
                                       status.equalsIgnoreCase("USED") ? "status-used" :
                                       "status-cancelled";
               %>

               <tr>
                   <td>#<%= id %></td>

                   <td>BK-<%= bookingId %></td>

                   <td><%= userId %></td>

                   <td><%= eventId %></td>

                   <td>
                       <span class="seat-badge">
                           <%= seatsDisplay %>
                       </span>
                   </td>

                   <td>LKR <%= price %></td>

                   <td>
                       <span class="pill-sm <%= statusClass %>">
                           <%= status %>
                       </span>
                   </td>

                   <td class="text-end">

                       <div class="d-flex gap-2 justify-content-end">

                           <button class="btn btn-light btn-sm rounded-3 btn-edit"
                                   data-id="<%= id %>"
                                   data-booking-id="<%= bookingId %>"
                                   data-user-id="<%= userId %>"
                                   data-event-id="<%= eventId %>"
                                   data-seat-no="<%= seatsRaw %>"
                                   data-price="<%= price %>"
                                   data-status="<%= status %>">

                               <i class="bi bi-pencil-square text-primary"></i>

                           </button>

                           <form action="<%=request.getContextPath()%>/TicketServlet"
                                 method="post"
                                 class="d-inline">

                               <input type="hidden" name="action" value="delete">

                               <input type="hidden" name="id" value="<%= id %>">

                               <button type="submit"
                                       class="btn btn-light btn-sm rounded-3"
                                       onclick="return confirm('Delete ticket #<%= id %>?')">

                                   <i class="bi bi-trash3 text-danger"></i>

                               </button>

                           </form>

                       </div>

                   </td>
               </tr>

               <%
                           }
                       } catch (Exception e) {
                           e.printStackTrace();
                       }
                   }
               %>
               </tbody>
            </table>
        </div>
    </main>
</div>

<div class="modal fade" id="ticketModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content glass-modal">
            <div class="modal-header-ticket">
                <h5 class="fw-800 mb-1" id="formTitle">Add Ticket</h5>
                <p class="small opacity-75 mb-0">Generate a new ticket for an existing booking</p>
            </div>

            <div class="modal-body p-4">
                <form action="<%=request.getContextPath()%>/TicketServlet" method="post">
                    <input type="hidden" name="action" id="action" value="create">
                    <input type="hidden" name="id"    id="ticketId">

                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <label class="small fw-800 text-muted mb-2 ms-1">BOOKING ID</label>
                            <div class="input-group-crystal">
                                <input type="number" name="bookingId" id="bookingId" class="form-control" placeholder="101" required>
                            </div>
                        </div>
                        <div class="col-6">
                            <label class="small fw-800 text-muted mb-2 ms-1">USER ID</label>
                            <div class="input-group-crystal">
                                <input type="number" name="userId" id="userId" class="form-control" placeholder="5" required>
                            </div>
                        </div>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <label class="small fw-800 text-muted mb-2 ms-1">EVENT ID</label>
                            <div class="input-group-crystal">
                                <input type="number" name="eventId" id="eventId" class="form-control" placeholder="16" required>
                            </div>
                        </div>
                        <div class="col-6">
                            <label class="small fw-800 text-muted mb-2 ms-1">SEAT NUMBER</label>
                            <div class="input-group-crystal">
                                <input type="text" name="seatNo" id="seatNo" class="form-control" placeholder="A-12" required>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="small fw-800 text-muted mb-2 ms-1">PRICE (LKR)</label>
                        <div class="input-group-crystal">
                            <input type="number" step="0.01" min="0" name="price" id="price" class="form-control" placeholder="0.00" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="small fw-800 text-muted mb-2 ms-1">VALIDATION STATUS</label>
                        <div class="input-group-crystal">
                            <select name="status" id="status" class="form-select">
                                <option value="ACTIVE">ACTIVE</option>
                                <option value="USED">USED</option>
                                <option value="CANCELLED">CANCELLED</option>
                            </select>
                        </div>
                    </div>

                    <button type="submit" class="btn-add-ticket w-100 py-3">
                        <i class="bi bi-check2-circle me-2"></i> Save Ticket Data
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
const modal = new bootstrap.Modal(document.getElementById('ticketModal'));

function openAdd() {
    document.getElementById("action").value    = "create";
    document.getElementById("formTitle").innerText = "Issue New Ticket";

    document.getElementById("ticketId").value  = "";
    document.getElementById("bookingId").value = "";
    document.getElementById("userId").value    = "";
    document.getElementById("eventId").value   = "";
    document.getElementById("seatNo").value    = "";
    document.getElementById("price").value     = "";
    document.getElementById("status").value    = "ACTIVE";

    modal.show();
}

// FIX: read values safely from data-* attributes (no quote-escaping issues)
document.querySelectorAll(".btn-edit").forEach(function(btn) {
    btn.addEventListener("click", function() {
        document.getElementById("action").value    = "update";
        document.getElementById("formTitle").innerText = "Update Ticket Info";

        document.getElementById("ticketId").value  = btn.dataset.id;
        document.getElementById("bookingId").value = btn.dataset.bookingId;
        document.getElementById("userId").value    = btn.dataset.userId;
        document.getElementById("eventId").value   = btn.dataset.eventId;
        document.getElementById("seatNo").value    = btn.dataset.seatNo;
        document.getElementById("price").value     = btn.dataset.price;
        document.getElementById("status").value    = btn.dataset.status;

        modal.show();
    });
});
</script>

</body>
</html>
