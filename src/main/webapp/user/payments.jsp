<%@ page import="com.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Transaction Flow | EventPass</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

   <!-- Load CSS file -->
       <link rel="stylesheet" href="/eventTicketBookingSystem/css/userview/payments.css">
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="main-content">
    <div class="container">

        <h2 class="page-title">Financial Flow</h2>

        <div class="label-row d-none d-md-flex">
            <div style="flex: 2;">Account / Protocol</div>
            <div style="flex: 1;">Transaction Volume</div>
            <div style="flex: 0.5; text-align: right;">Status</div>
        </div>

        <div class="transaction-item">
            <div class="data-main">
                <div class="avatar-box">
                    <div style="width: 45px; height: 45px; background: white; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px;">
                        <i class="bi bi-person-circle text-primary"></i>
                    </div>
                </div>
                <div>
                    <span class="id-tag">#TRX-8820</span>
                    <h5 class="user-name">John Doe</h5>
                    <span class="event-sub">Midnight Jazz Concert</span>
                </div>
            </div>

            <div class="data-info">
                <p class="amount-big">5,000.00 LKR</p>
                <span class="date-muted">April 20, 2026 • 09:42 AM</span>
            </div>

            <div class="data-status">
                <span class="status-pill status-paid">
                    <i class="bi bi-patch-check-fill"></i> CLEARED
                </span>
            </div>
        </div>

        <div class="transaction-item">
            <div class="data-main">
                <div class="avatar-box">
                    <div style="width: 45px; height: 45px; background: white; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px;">
                        <i class="bi bi-person-circle text-warning"></i>
                    </div>
                </div>
                <div>
                    <span class="id-tag">#TRX-8821</span>
                    <h5 class="user-name">Jane Smith</h5>
                    <span class="event-sub">Global Tech Summit 2026</span>
                </div>
            </div>

            <div class="data-info">
                <p class="amount-big">3,000.00 LKR</p>
                <span class="date-muted">May 15, 2026 • 02:15 PM</span>
            </div>

            <div class="data-status">
                <span class="status-pill status-pending">
                    <i class="bi bi-clock-history"></i> PENDING
                </span>
            </div>
        </div>

    </div>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>