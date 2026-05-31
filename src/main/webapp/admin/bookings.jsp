<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking Control | EventPass</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="/EventTicketBookingSystem/css/adminview/bookings.css">
</head>

<body>

<div class="page-wrapper">
    <%@ include file="navbar.jsp" %>

    <main class="main-content">

        <div class="glass-header">
            <div>
                <h4 class="fw-800 mb-0">Booking Management</h4>
                <p class="text-muted small mb-0">Oversee reservations and ticket distributions</p>
            </div>

            <button class="btn-add" onclick="openAdd()">
                <i class="bi bi-plus-lg me-2"></i> New Reservation
            </button>
        </div>

        <div class="crystal-card">
            <table class="crystal-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>User / Event</th>
                    <th>Seats</th>
                    <th>Qty</th>
                    <th>Total</th>
                    <th>Date / Time</th>
                    <th>Status</th>
                    <th class="text-end">Actions</th>
                </tr>
                </thead>

                <tbody>
                <%
                    // FILE FORMAT (10 columns, 0-indexed):
                    // 0:id, 1:userId, 2:eventId, 3:seats(pipe-separated),
                    // 4:quantity, 5:totalPrice, 6:paymentId, 7:date, 8:time, 9:status
                    File file = new File(application.getRealPath("/") + "data/bookings.txt");

                    if (file.exists()) {
                        BufferedReader br = new BufferedReader(new FileReader(file));
                        String line;

                        while ((line = br.readLine()) != null) {

                            if (line.trim().isEmpty()) continue;

                            String[] d = line.split(",");

                            if (d.length < 10) continue;

                            String status = d[9].trim();

                            String statusClass =
                                    status.equalsIgnoreCase("CONFIRMED") ? "badge-confirmed" :
                                    status.equalsIgnoreCase("PENDING")   ? "badge-pending"   :
                                                                           "badge-cancelled";

                            // seats are stored pipe-separated inside column 3
                            String seatsDisplay = d[3].replace("|", ", ");
                %>
                <tr>
                    <td class="fw-800 opacity-50">#<%= d[0] %></td>

                    <td>
                        <div class="d-flex align-items-center gap-3">
                            <div>
                                <small class="text-muted d-block">User</small>
                                <span class="fw-700">ID: <%= d[1] %></span>
                            </div>
                            <div class="vr opacity-25"></div>
                            <div>
                                <small class="text-muted d-block">Event</small>
                                <span class="fw-700">ID: <%= d[2] %></span>
                            </div>
                        </div>
                    </td>

                    <td>
                        <span class="fw-600"><%= seatsDisplay %></span>
                    </td>

                    <td>
                        <span class="fw-800"><%= d[4] %></span>
                        <small class="text-muted">Tickets</small>
                    </td>

                    <td>
                        <span class="fw-700">LKR <%= d[5] %></span>
                    </td>

                    <td>
                        <small class="text-muted d-block"><%= d[7] %></small>
                        <span class="fw-600"><%= d[8] %></span>
                    </td>

                    <td>
                        <span class="status-pill <%= statusClass %>"><%= status %></span>
                    </td>

                    <td class="text-end">
                        <div class="d-flex gap-2 justify-content-end">

                            <%-- Pass all 10 fields to openEdit — seats as the raw pipe string --%>
                            <button class="btn btn-light btn-sm rounded-3"
                                onclick="openEdit(
                                    '<%= d[0] %>',
                                    '<%= d[1] %>',
                                    '<%= d[2] %>',
                                    '<%= d[3].replace("|",",") %>',
                                    '<%= d[4] %>',
                                    '<%= d[5] %>',
                                    '<%= d[6] %>',
                                    '<%= d[7] %>',
                                    '<%= d[8] %>',
                                    '<%= d[9].trim() %>'
                                )">
                                <i class="bi bi-pencil text-primary"></i>
                            </button>

                            <form action="<%= request.getContextPath() %>/BookingServlet" method="post" class="d-inline">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id"     value="<%= d[0] %>">
                                <button type="submit" class="btn btn-light btn-sm rounded-3">
                                    <i class="bi bi-trash3 text-danger"></i>
                                </button>
                            </form>

                        </div>
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

    </main>
</div>

<!-- MODAL -->
<div class="modal fade" id="bookingModal">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content glass-modal">

            <div class="modal-header-accent">
                <h5 class="fw-800 mb-1" id="formTitle">Add Booking</h5>
                <p class="small opacity-75 mb-0">Manually insert or update a reservation</p>
            </div>

            <div class="modal-body p-4">

                <form action="<%= request.getContextPath() %>/BookingServlet" method="post">

                    <input type="hidden" name="action" id="action" value="create">
                    <input type="hidden" name="id"     id="id">

                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <label class="small fw-800 text-muted mb-2">USER ID</label>
                            <input type="text" name="userId" id="userId" class="form-control" required>
                        </div>

                        <div class="col-6">
                            <label class="small fw-800 text-muted mb-2">EVENT ID</label>
                            <input type="text" name="eventId" id="eventId" class="form-control" required>
                        </div>
                    </div>

                    <%-- FIXED: servlet reads `seats` (comma-separated) and splits into List<String> --%>
                    <div class="mb-3">
                        <label class="small fw-800 text-muted mb-2">SEATS
                            <span class="fw-400 opacity-75">(comma-separated, e.g. A1,B3)</span>
                        </label>
                        <input type="text" name="seats" id="seats" class="form-control"
                               placeholder="A1,A2,B5" required>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <label class="small fw-800 text-muted mb-2">TICKETS</label>
                            <%-- FIXED: servlet reads `quantity` not `qty` --%>
                            <input type="number" name="quantity" id="quantity" class="form-control" required min="1">
                        </div>

                        <div class="col-6">
                            <label class="small fw-800 text-muted mb-2">TOTAL PRICE (LKR)</label>
                            <%-- FIXED: servlet reads `totalPrice` --%>
                            <input type="number" step="0.01" name="totalPrice" id="totalPrice"
                                   class="form-control" min="0">
                        </div>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <label class="small fw-800 text-muted mb-2">PAYMENT ID</label>
                            <input type="number" name="paymentId" id="paymentId" class="form-control">
                        </div>

                        <div class="col-6">
                            <label class="small fw-800 text-muted mb-2">STATUS</label>
                            <select name="status" id="status" class="form-select">
                                <option value="CONFIRMED">CONFIRMED</option>
                                <option value="PENDING">PENDING</option>
                                <option value="CANCELLED">CANCELLED</option>
                            </select>
                        </div>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-6">
                            <label class="small fw-800 text-muted mb-2">DATE</label>
                            <input type="date" name="date" id="date" class="form-control">
                        </div>

                        <div class="col-6">
                            <label class="small fw-800 text-muted mb-2">TIME</label>
                            <input type="time" name="time" id="time" class="form-control">
                        </div>
                    </div>

                    <button type="submit" class="btn-add w-100 py-3">
                        <i class="bi bi-shield-check me-2"></i> Commit Reservation
                    </button>

                </form>

            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const modal = new bootstrap.Modal(document.getElementById('bookingModal'));

    function getNow() {
        const now = new Date();
        const date = now.toISOString().split('T')[0]; // yyyy-MM-dd

        // 24-hour HH:mm for <input type="time">
        const time = String(now.getHours()).padStart(2, '0') + ':' +
                     String(now.getMinutes()).padStart(2, '0');

        return { date, time };
    }

    function openAdd() {
        const now = getNow();

        document.getElementById('formTitle').textContent = 'Add Booking';
        document.getElementById('action').value    = 'create';
        document.getElementById('id').value        = '';
        document.getElementById('userId').value    = '';
        document.getElementById('eventId').value   = '';
        document.getElementById('seats').value     = '';
        document.getElementById('quantity').value  = '';
        document.getElementById('totalPrice').value = '';
        document.getElementById('paymentId').value = '';
        document.getElementById('date').value      = now.date;
        document.getElementById('time').value      = now.time;
        document.getElementById('status').value    = 'CONFIRMED';

        modal.show();
    }

    // seats param: comma-separated seat ids from the table row
    function openEdit(id, userId, eventId, seats, quantity, totalPrice, paymentId, date, time, status) {
        document.getElementById('formTitle').textContent = 'Edit Booking';
        document.getElementById('action').value     = 'update';
        document.getElementById('id').value         = id;
        document.getElementById('userId').value     = userId;
        document.getElementById('eventId').value    = eventId;
        document.getElementById('seats').value      = seats;       // comma-separated
        document.getElementById('quantity').value   = quantity;
        document.getElementById('totalPrice').value = totalPrice;
        document.getElementById('paymentId').value  = paymentId;
        document.getElementById('date').value       = date;
        document.getElementById('time').value       = time;
        document.getElementById('status').value     = status;

        modal.show();
    }
</script>

</body>
</html>
