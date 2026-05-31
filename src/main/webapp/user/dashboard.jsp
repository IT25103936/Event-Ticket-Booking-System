<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title> Dashboard | EventPass</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Preconnect (faster font loading) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Load CSS non-blocking -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

  <!-- Load CSS file -->
<link rel="stylesheet" href="/EventTicketBookingSystem/css/userview/userDashboard.css">

</head>

<body>

<%@ include file="navbar.jsp" %>

<div class="main-content ">
    <div class="container ">

        <div class="dashboard-header mb-5 text-center">
            <h2>Your gateway to live events and experiences.</h2>
            <p style="color: rgba(255,255,255,0.8); font-weight: 500;">
            Find concerts, festivals, and experiences near you.
            </p>
        </div>

        <div class="row g-4">

            <div class="col-xl-6 col-md-12">
                <a href="<%= request.getContextPath() %>/user/events.jsp" class="bento-card">
                    <div class="card-head">
                        <div class="icon-box"><i class="bi bi-stars"></i></div>
                        <h4>Discover Events</h4>
                    </div>
                    <p>Track real-time ticket availability and explore upcoming curated experiences.</p>
                    <span class="bento-link">Enter Module <i class="bi bi-arrow-right"></i></span>
                </a>
            </div>

            <div class="col-xl-2 col-md-6">
                <a href="<%= request.getContextPath() %>/user/myBooking.jsp" class="bento-card">
                    <div class="card-head">
                        <div class="icon-box" style="color: #10b981;"><i class="bi bi-calendar2-check"></i></div>
                        <h4>Bookings</h4>
                    </div>
                    <p>Manage active user reservations.</p>
                    <span class="bento-link" style="color: #10b981;">Manage <i class="bi bi-arrow-right"></i></span>
                </a>
            </div>

            <div class="col-xl-2 col-md-6">
                <a href="<%= request.getContextPath() %>/user/seatMap.jsp" class="bento-card">
                    <div class="card-head">
                        <div class="icon-box" style="color: #06b6d4;"><i class="bi bi-grid-fill"></i></div>
                        <h4>Seat Map</h4>
                    </div>
                    <p>Interactive floor plans.</p>
                    <span class="bento-link" style="color: #06b6d4;">View <i class="bi bi-arrow-right"></i></span>
                </a>
            </div>

<div class="col-xl-2 col-md-6"> <a href="<%= request.getContextPath() %>/user/tickets.jsp" class="bento-card"> <div class="card-head"> <div class="icon-box" style="color: #f59e0b;"><i class="bi bi-ticket-perforated"></i></div> <h4>Passes</h4> </div> <p>QR Entry credentials.</p> <span class="bento-link" style="color: #f59e0b;">View <i class="bi bi-arrow-right"></i></span> </a> </div> <div class="col-xl-3 col-md-6"> <a href="<%= request.getContextPath() %>/user/history.jsp" class="bento-card"> <div class="card-head"> <div class="icon-box" style="color: #64748b;"><i class="bi bi-activity"></i></div> <h4>Logs</h4> </div> <p>System activity tracking.</p> <span class="bento-link" style="color: #64748b;">Review <i class="bi bi-arrow-right"></i></span> </a> </div>

            <div class="col-xl-3 col-md-6">
                <a href="<%= request.getContextPath() %>/user/payments.jsp" class="bento-card">
                    <div class="card-head">
                        <div class="icon-box" style="color: #ef4444;"><i class="bi bi-wallet2"></i></div>
                        <h4>Financial Hub</h4>
                    </div>
                    <p>Comprehensive transaction monitoring, refund processing, and revenue auditing.</p>
                    <span class="bento-link" style="color: #ef4444;">Audit Now <i class="bi bi-arrow-right"></i></span>
                </a>
            </div>


<div class="col-xl-3 col-md-6">
    <a href="<%= request.getContextPath() %>/user/coupons.jsp" class="bento-card">

        <div class="card-head">
            <div class="icon-box" style="color: #4f46e5;">
                <i class="bi bi-ticket-perforated-fill"></i>
            </div>
            <h4>Coupon Center</h4>
        </div>

        <p>
            Manage promotional coupons, discount codes, and QR-based offers for events and users.
        </p>

        <span class="bento-link" style="color: #4f46e5;">
            Manage Coupons <i class="bi bi-arrow-right"></i>
        </span>

    </a>
</div>




<div class="col-xl-3 col-md-6">
    <a href="<%= request.getContextPath() %>/user/instructions.jsp" class="bento-card">
        <div class="card-head">
            <div class="icon-box" style="color: #06b6d4;">
                <i class="bi bi-journal-text"></i>
            </div>
            <h4>Instructions</h4>
        </div>
        <p>Step-by-step guide to book events, select seats, and complete payments smoothly.</p>
        <span class="bento-link" style="color: #06b6d4;">
            View Guide <i class="bi bi-arrow-right"></i>
        </span>
    </a>
</div>
        </div>
    </div>
</div>

<div class="m-5 p-3"></div>


<%@ include file="footer.jsp" %>

</body>
</html>