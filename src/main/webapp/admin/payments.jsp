<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Finance Ledger | EventPass</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

 <!-- Load CSS file -->
       <link rel="stylesheet" href="/eventTicketBookingSystem/css/adminview/payments.css">


</head>

<body>

<div class="page-wrapper">
    <%@ include file="navbar.jsp" %>

    <main class="main-content">
        <!-- HEADER -->
        <div class="glass-header">
            <div>
                <h4 class="fw-800 mb-0" style="letter-spacing: -1px;">Payment Management</h4>
                <p class="text-muted small mb-0">Track transactions and revenue streams</p>
            </div>

            <button class="btn-action" onclick="openAdd()">
                <i class="bi bi-plus-circle-fill me-2"></i> Log Payment
            </button>
        </div>

        <!-- TABLE -->
        <div class="crystal-card">
            <table class="crystal-table">
                <thead>
                    <tr>
                        <th>Transaction ID</th>
                        <th>User Reference</th>
                        <th>Amount</th>
                        <th>Method</th>
                        <th>Status</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    File file = new File(application.getRealPath("/") + "data/payments.txt");
                    if(file.exists()){
                        BufferedReader br = new BufferedReader(new FileReader(file));
                        String line;
                        while((line = br.readLine()) != null){
                            String[] d = line.split(",");
                            String methIcon = d[3].equalsIgnoreCase("Card") ? "bi-credit-card" :
                                             (d[3].equalsIgnoreCase("Online") ? "bi-globe" : "bi-cash-stack");
                            String statClass = d[4].equalsIgnoreCase("PAID") ? "status-paid" : "status-pending";
                %>
                    <tr>
                        <td class="small fw-800 opacity-50">TXN-<%= d[0] %></td>
                        <td class="fw-700">USER_<%= d[1] %></td>
                        <td class="amount-text text-success">$<%= d[2] %></td>
                        <td>
                            <div class="d-flex align-items-center">
                                <span class="method-icon"><i class="bi <%= methIcon %>"></i></span>
                                <span class="fw-600"><%= d[3] %></span>
                            </div>
                        </td>
                        <td>
                            <span class="pill <%= statClass %>"><%= d[4] %></span>
                        </td>
                       <td class="text-end">
                           <%
                               String status = d[4].trim();
                               boolean isPaid = "PAID".equalsIgnoreCase(status);
                           %>

                           <% if (!isPaid) { %>
                               <div class="d-flex gap-2 justify-content-end">

                                   <button class="btn btn-light btn-sm rounded-3 shadow-sm"
                                       onclick="openEdit('<%=d[0]%>','<%=d[1]%>','<%=d[2]%>','<%=d[3]%>','<%=d[4]%>')">
                                       <i class="bi bi-pencil-fill text-primary"></i>
                                   </button>

                                   <form action="<%=request.getContextPath()%>/PaymentServlet"
                                         method="post"
                                         class="d-inline">

                                       <input type="hidden" name="action" value="delete">
                                       <input type="hidden" name="id" value="<%=d[0]%>">

                                       <button class="btn btn-light btn-sm rounded-3 shadow-sm">
                                           <i class="bi bi-trash3-fill text-danger"></i>
                                       </button>
                                   </form>

                               </div>
                           <% } else { %>

                               <span class="badge text-secondary px-3 py-2">
                                 Settled Payment
                               </span>

                           <% } %>
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
<div class="modal fade" id="paymentModal">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content glass-modal">
            <div class="modal-header-finance">
                <h5 class="fw-800 mb-1" id="formTitle">Add Payment</h5>
                <p class="small opacity-75 mb-0">Record a new financial transaction</p>
            </div>

            <div class="modal-body p-4">
                <form action="<%=request.getContextPath()%>/PaymentServlet" method="post">
                    <input type="hidden" name="action" id="action" value="create">
                    <input type="hidden" name="id" id="id">

                    <div class="mb-3">
                        <label class="small fw-800 text-muted mb-2">TARGET USER ID</label>
                        <div class="input-group-crystal">
                            <input type="text" name="userId" id="userId" class="form-control" placeholder="Enter user reference" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="small fw-800 text-muted mb-2">PAYMENT AMOUNT ($)</label>
                        <div class="input-group-crystal">
                            <input type="number" name="amount" id="amount" class="form-control" placeholder="0.00" step="0.01" required>
                        </div>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-6">
                            <label class="small fw-800 text-muted mb-2">METHOD</label>
                            <div class="input-group-crystal">
                                <select name="method" id="method" class="form-select">
                                    <option value="Card">Credit Card</option>
                                    <option value="Cash">Cash</option>
                                    <option value="Online">Online Banking</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-6">
                            <label class="small fw-800 text-muted mb-2">STATUS</label>
                            <div class="input-group-crystal">
                                <select name="status" id="status" class="form-select">
                                    <option value="PAID">PAID</option>
                                    <option value="PENDING">PENDING</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <button class="btn-action w-100 py-3 mt-2">
                        <i class="bi bi-wallet2 me-2"></i> Confirm Transaction
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    let modal = new bootstrap.Modal(document.getElementById('paymentModal'));

    function openAdd(){
        document.getElementById("action").value="create";
        document.getElementById("formTitle").innerText="Log New Payment";
        document.getElementById("userId").value="";
        document.getElementById("amount").value="";
        document.getElementById("method").value="Card";
        document.getElementById("status").value="PAID";
        modal.show();
    }

    function openEdit(id,u,a,m,s){
        document.getElementById("action").value="update";
        document.getElementById("formTitle").innerText="Update Transaction";
        document.getElementById("id").value=id;
        document.getElementById("userId").value=u;
        document.getElementById("amount").value=a;
        document.getElementById("method").value=m;
        document.getElementById("status").value=s;
        modal.show();
    }
</script>

</body>
</html>