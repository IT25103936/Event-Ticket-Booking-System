<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Coupon Control | EventPass</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;800&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>

 <!-- Load CSS file -->
       <link rel="stylesheet" href="/eventTicketBookingSystem/css/adminview/coupons.css">


</head>
<body>

<div class="page-wrapper">
    <%@ include file="navbar.jsp" %>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-800">Coupon Inventory</h3>
            <button class="btn btn-primary rounded-4 px-4 fw-bold" onclick="openAdd()">+ New Coupon</button>
        </div>

        <div class="crystal-card">
            <table class="crystal-table">
                <thead>
                    <tr class="text-muted small fw-bold">
                        <th>CODE</th>
                        <th>QR KEY</th>
                        <th>DISCOUNT</th>
                        <th>STATUS</th>
                        <th class="text-end">ACTIONS</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    File file = new File(application.getRealPath("/") + "data/coupons.txt");
                    if(file.exists()){
                        BufferedReader br = new BufferedReader(new FileReader(file));
                        String line;
                        while((line = br.readLine()) != null){
                            if(line.trim().isEmpty()) continue;
                            String[] c = line.split(",");
                            if(c.length < 4) continue;
                %>
                    <tr>
                        <td class="fw-800 text-primary"><%= c[1] %></td>
                        <td>
                            <div class="qr-box" id="qr-<%= c[0] %>"></div>
                            <script>
                                new QRCode(document.getElementById("qr-<%= c[0] %>"), {
                                    text: "<%= c[1] %>", width: 45, height: 45
                                });
                            </script>
                        </td>
                        <td class="fw-bold"><%= c[2] %>% OFF</td>
                        <td>
                            <span class="status-pill <%= "true".equals(c[3].trim()) ? "active-bg" : "inactive-bg" %>">
                                <%= "true".equals(c[3].trim()) ? "ACTIVE" : "INACTIVE" %>
                            </span>
                        </td>
                        <td class="text-end">
                            <div class="d-flex gap-2 justify-content-end">
                                <!-- UPDATE BUTTON -->
                                <button class="btn btn-sm btn-light border shadow-sm"
                                        onclick="openEdit('<%=c[0]%>','<%=c[1]%>','<%=c[2]%>','<%=c[3].trim()%>')">
                                    <i class="bi bi-pencil-fill text-primary"></i>
                                </button>

                                <!-- DELETE FORM -->
                                <form action="<%=request.getContextPath()%>/CouponServlet" method="post"
                                      style="display:inline;" onsubmit="return confirm('Delete this coupon?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%=c[0]%>">
                                    <button type="submit" class="btn btn-sm btn-light border shadow-sm">
                                        <i class="bi bi-trash3-fill text-danger"></i>
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
<div class="modal fade" id="couponModal">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 rounded-5 shadow-lg">
            <div class="p-4 bg-dark text-white rounded-top-5">
                <h5 class="fw-800 mb-0" id="mTitle">Add Coupon</h5>
            </div>
            <div class="modal-body p-4">
                <form action="<%=request.getContextPath()%>/CouponServlet" method="post">
                    <input type="hidden" name="action" id="mAction">
                    <input type="hidden" name="id" id="mId">

                    <label class="small fw-bold text-muted mb-1">PROMO CODE</label>
                    <input type="text" name="code" id="mCode" class="form-control mb-3 rounded-3" placeholder="SUMMER50" required>

                    <div class="row">
                        <div class="col-6">
                            <label class="small fw-bold text-muted mb-1">DISCOUNT %</label>
                            <input type="number" name="discount" id="mDiscount" class="form-control rounded-3" placeholder="20" required>
                        </div>
                        <div class="col-6">
                            <label class="small fw-bold text-muted mb-1">STATUS</label>
                            <select name="active" id="mActive" class="form-select rounded-3">
                                <option value="true">Active</option>
                                <option value="false">Inactive</option>
                            </select>
                        </div>
                    </div>
                    <button class="btn btn-primary w-100 py-3 rounded-4 mt-4 fw-bold">Save Coupon Asset</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let modal = new bootstrap.Modal(document.getElementById('couponModal'));
    function openAdd() {
        document.getElementById('mAction').value = 'create';
        document.getElementById('mTitle').innerText = 'New Coupon Asset';
        document.getElementById('mCode').value = '';
        document.getElementById('mDiscount').value = '';
        modal.show();
    }
    function openEdit(id, code, disc, act) {
        document.getElementById('mAction').value = 'update';
        document.getElementById('mId').value = id;
        document.getElementById('mCode').value = code;
        document.getElementById('mDiscount').value = disc;
        document.getElementById('mActive').value = act;
        modal.show();
    }
</script>
</body>
</html>