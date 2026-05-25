<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>VIP Rewards | EventPass Dashboard</title>

    <!-- Core UI -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=Outfit:wght@800&family=JetBrains+Mono&display=swap" rel="stylesheet">

    <!-- QR Logic -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>

   <!-- Load CSS file -->
   <link rel="stylesheet" href="/eventTicketBookingSystem/css/userview/coupons.css">

</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="container ">
    <div class="page-header d-flex justify-content-between align-items-end mt-4 ">
        <div class="mt-4">
            <h2 class="fw-800 mb-1 m-4">Your Rewards</h2>
            <p class="text-white-50 small mb-0">Exclusive digital perks for your account.</p>
        </div>
        <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 px-3 py-2 rounded-pill fw-bold">
            <i class="bi bi-gem me-1"></i> VIP STATUS
        </span>
    </div>

    <div class="reward-grid">
        <%
            File file = new File(application.getRealPath("/") + "data/coupons.txt");
            int count = 0;
            if (file.exists()) {
                BufferedReader br = new BufferedReader(new FileReader(file));
                String line;
                while ((line = br.readLine()) != null) {
                    if (line.trim().isEmpty()) continue;
                    String[] data = line.split(",");
                    if (data.length < 4 || !"true".equals(data[3].trim())) continue;
                    count++;
        %>

        <div class="reward-card">
            <!-- QR View -->
            <div class="qr-overlay" id="qr-<%= count %>">
                <i class="bi bi-x-circle-fill close-qr" onclick="hideQR(<%= count %>)"></i>
                <div class="qr-frame" id="canvas-<%= count %>"></div>
                <div class="text-center mt-3">
                    <p class="text-dark fw-bold mb-0">SCAN TO REDEEM</p>
                    <small class="text-muted"><%= data[1] %></small>
                </div>
            </div>

            <div class="d-flex justify-content-between align-items-center mb-1">
                <small class="fw-bold opacity-50 text-uppercase" style="letter-spacing: 1px;">Offer #<%= count %></small>
                <i class="bi bi-stars text-info"></i>
            </div>

            <div class="discount-val"><%= data[2] %>%</div>

            <div class="card-title">Member Credit</div>
            <p class="card-desc">Redeemable for instant discounts on all premium event categories.</p>

            <div class="action-bar">
                <button class="btn-copy-alt" onclick="copyCode('<%= data[1] %>')">
                    <span><%= data[1] %></span>
                    <i class="bi bi-clipboard"></i>
                </button>
                <button class="btn-qr-alt" onclick="showQR(<%= count %>, '<%= data[1] %>')">
                    <i class="bi bi-qr-code-scan"></i>
                </button>
            </div>
        </div>

        <%
                }
                br.close();
            }
            if (count == 0) {
        %>
            <div class="col-12 text-center py-5">
                <i class="bi bi-gift opacity-25" style="font-size: 4rem;"></i>
                <p class="mt-3 opacity-50">No active rewards available right now.</p>
            </div>
        <% } %>
    </div>
</div>

<div id="copyToast">COPIED TO CLIPBOARD</div>
<%@ include file="footer.jsp" %>
<script>
    function copyCode(text) {
        navigator.clipboard.writeText(text);
        const toast = document.getElementById('copyToast');
        toast.style.display = 'block';
        setTimeout(() => toast.style.display = 'none', 2000);
    }

    function showQR(id, code) {
        const frame = document.getElementById('canvas-' + id);
        frame.innerHTML = ""; // Clear old QR

        new QRCode(frame, {
            text: code,
            width: 150,
            height: 150,
            colorDark : "#000000",
            colorLight : "#ffffff",
            correctLevel : QRCode.CorrectLevel.H
        });

        document.getElementById('qr-' + id).style.display = 'flex';
    }

    function hideQR(id) {
        document.getElementById('qr-' + id).style.display = 'none';
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>