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

 <!-- Load CSS file -->
       <link rel="stylesheet" href="/eventTicketBookingSystem/css/adminview/tickets.css">


</head>

<body>

<div class="page-wrapper">
    <%@ include file="navbar.jsp" %>

    <main class="main-content">
        <!-- HEADER -->
        <div class="glass-header">
            <div>
                <h4 class="fw-800 mb-0" style="letter-spacing: -1px;">Ticket Inventory</h4>
                <p class="text-muted small mb-0">Manage individual ticket units and seat assignments</p>
            </div>

            <button class="btn-add-ticket" onclick="openAdd()">
                <i class="bi bi-ticket-perforated-fill me-2"></i> Issue Ticket
            </button>
        </div>

        <!-- TABLE SECTION -->
        <div class="crystal-card">
            <table class="crystal-table">
                <thead>
                    <tr>
                        <th>Ticket ID</th>
                        <th>Booking Ref</th>
                        <th>Seat</th>
                        <th>Value</th>
                        <th>Status</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    File file = new File(application.getRealPath("/") + "data/tickets.txt");
                    if(file.exists()){
                        BufferedReader br = new BufferedReader(new FileReader(file));
                        String line;
                        while((line = br.readLine()) != null){
                            String[] d = line.split(",");
                            String statusClass = d[4].equalsIgnoreCase("ACTIVE") ? "status-active" :
                                                 (d[4].equalsIgnoreCase("USED") ? "status-used" : "status-cancelled");
                %>
                    <tr>
                        <td class="fw-800 text-muted small">#<%= d[0] %></td>
                        <td class="fw-700">BK-<%= d[1] %></td>
                        <td><span class="seat-badge"><%= d[2] %></span></td>
                        <td class="fw-800 text-primary">$<%= d[3] %></td>
                        <td>
                            <span class="pill-sm <%= statusClass %>"><%= d[4] %></span>
                        </td>
                        <td class="text-end">
                            <div class="d-flex gap-2 justify-content-end">
                                <button class="btn btn-light btn-sm rounded-3" onclick="openEdit('<%=d[0]%>','<%=d[1]%>','<%=d[2]%>','<%=d[3]%>','<%=d[4]%>')">
                                    <i class="bi bi-pencil-square text-primary"></i>
                                </button>
                                <form action="<%=request.getContextPath()%>/TicketServlet" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%=d[0]%>">
                                    <button class="btn btn-light btn-sm rounded-3">
                                        <i class="bi bi-trash3 text-danger"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                <%
                        } br.close();
                    }
                %>
                </tbody>
            </table>
        </div>
    </main>
</div>

<!-- MODAL -->
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
                    <input type="hidden" name="id" id="id">

                    <div class="mb-3">
                        <label class="small fw-800 text-muted mb-2 ms-1">BOOKING REFERENCE ID</label>
                        <div class="input-group-crystal">
                            <input type="text" name="bookingId" id="bookingId" class="form-control" placeholder="BK-101" required>
                        </div>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <label class="small fw-800 text-muted mb-2 ms-1">SEAT NUMBER</label>
                            <div class="input-group-crystal">
                                <input type="text" name="seatNo" id="seatNo" class="form-control" placeholder="A-12" required>
                            </div>
                        </div>
                        <div class="col-6">
                            <label class="small fw-800 text-muted mb-2 ms-1">PRICE ($)</label>
                            <div class="input-group-crystal">
                                <input type="number" name="price" id="price" class="form-control" placeholder="0.00" required>
                            </div>
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
    let modal = new bootstrap.Modal(document.getElementById('ticketModal'));

    function openAdd(){
        document.getElementById("action").value="create";
        document.getElementById("formTitle").innerText="Issue New Ticket";
        document.getElementById("bookingId").value="";
        document.getElementById("seatNo").value="";
        document.getElementById("price").value="";
        document.getElementById("status").value="ACTIVE";
        modal.show();
    }

    function openEdit(id, b, s, p, st){
        document.getElementById("action").value="update";
        document.getElementById("formTitle").innerText="Update Ticket Info";
        document.getElementById("id").value=id;
        document.getElementById("bookingId").value=b;
        document.getElementById("seatNo").value=s;
        document.getElementById("price").value=p;
        document.getElementById("status").value=st;
        modal.show();
    }
</script>

</body>
</html>