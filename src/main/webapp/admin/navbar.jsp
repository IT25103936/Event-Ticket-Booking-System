<!-- ================= SIDEBAR NAVBAR ================= -->
<style>
/* SIDEBAR BASE: High-End Glassmorphism */
.sidebar {
    width: 260px; /* Slightly wider for better breathing room */
    height: 100vh;
    position: fixed;
    top: 0;
    left: 0;

    /* Light Theme Frosted Glass */
    background: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);

    border-right: 1px solid rgba(255, 255, 255, 0.5);
    padding: 30px 20px;
    display: flex;
    flex-direction: column;
    z-index: 1000;
}

/* LOGO SECTION */
.sidebar-header {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 0 10px;
    margin-bottom: 40px;
}

.logo-box {
    width: 40px;
    height: 40px;
    background: #4f46e5;
    color: #fff;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    box-shadow: 0 8px 16px rgba(79, 70, 229, 0.3);
}

.logo-text {
    font-weight: 800;
    font-size: 1.2rem;
    color: #0f172a;
    letter-spacing: -1px;
}

/* MENU AREA */
.menu {
    flex: 1;
    overflow-y: auto;
}

.menu::-webkit-scrollbar { width: 0px; } /* Hide scrollbar for clean look */

.nav-label {
    font-size: 0.65rem;
    text-transform: uppercase;
    letter-spacing: 1.2px;
    font-weight: 800;
    color: #64748b;
    margin: 20px 0 10px 12px;
}

/* LINKS: Modern Pill Style */
.sidebar a {
    display: flex;
    align-items: center;
    color: #475569;
    text-decoration: none;
    padding: 12px 16px;
    margin-bottom: 4px;
    border-radius: 14px;
    transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
    font-size: 0.9rem;
    font-weight: 600;
}

/* ICON SPACING */
.sidebar a i {
    margin-right: 14px;
    font-size: 1.1rem;
    transition: 0.3s;
}

/* HOVER EFFECT */
.sidebar a:hover {
    background: rgba(255, 255, 255, 0.8);
    color: #4f46e5;
    transform: translateX(4px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.03);
}

/* ACTIVE STATE */
.sidebar a.active {
    background: #4f46e5;
    color: #fff;
    box-shadow: 0 10px 20px -5px rgba(79, 70, 229, 0.4);
}

.sidebar a.active i {
    color: #fff;
}

/* LOGOUT SPECIAL STYLE */
.logout-btn {
    margin-top: 20px;
    color: #ef4444 !important;
}

.logout-btn:hover {
    background: rgba(239, 68, 68, 0.1) !important;
    color: #ef4444 !important;
}

/* ================= BRAND FOOTER ================= */
.sidebar-footer {
    margin-top: auto;
    padding: 20px 10px 0 10px;
    border-top: 1px solid rgba(0,0,0,0.05);
}

.brand-card {
    background: linear-gradient(135deg, #4f46e5, #6366f1);
    padding: 15px;
    border-radius: 18px;
    color: white;
    text-align: center;
}

.brand-card i {
    font-size: 24px;
    margin-bottom: 8px;
    display: block;
}

.brand-card strong {
    display: block;
    font-size: 12px;
    font-weight: 700;
}

.brand-card span {
    font-size: 10px;
    opacity: 0.8;
}

</style>

<div class="sidebar">

    <!-- MENU -->
    <div class="menu">


        <a href="<%= request.getContextPath() %>/admin/dashboard.jsp" class="active">
            <i class="bi bi-grid-fill"></i> Dashboard
        </a>

        <a href="<%= request.getContextPath() %>/admin/users.jsp">
            <i class="bi bi-people-fill"></i> Users
        </a>

        <a href="<%= request.getContextPath() %>/admin/admins.jsp">
            <i class="bi bi-shield-lock-fill"></i> Admins
        </a>

        <div class="nav-label">Management</div>

        <a href="<%= request.getContextPath() %>/admin/events.jsp">
            <i class="bi bi-calendar4-event"></i> Events
        </a>

        <a href="<%= request.getContextPath() %>/admin/bookings.jsp">
            <i class="bi bi-journal-check"></i> Bookings
        </a>

        <a href="<%= request.getContextPath() %>/admin/payments.jsp">
            <i class="bi bi-wallet2"></i> Payments
        </a>

       <a href="<%= request.getContextPath() %>/admin/coupons.jsp">
           <i class="bi bi-tag"></i> Coupons
       </a>

        <a href="<%= request.getContextPath() %>/admin/tickets.jsp">
            <i class="bi bi-ticket-perforated"></i> Tickets
        </a>

        <a href="<%= request.getContextPath() %>/admin/ratings.jsp">
            <i class="bi bi-star-fill"></i> Ratings
        </a>

        <a href="<%= request.getContextPath() %>/admin/login.jsp" class="logout-btn">
            <i class="bi bi-box-arrow-right"></i> Logout
        </a>

    </div>

    <!-- BRAND FOOTER -->

<div class="sidebar-footer"
     style="display: flex; align-items: center; gap: 12px;
            padding: 12px;
            margin: 15px;
            margin-top: auto;
            border-radius: 12px;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            transition: all 0.2s ease-in-out;">

    <!-- SOFT ICON -->
    <div class="brand-icon"
         style="width: 36px; height: 36px;
                display: flex; align-items: center; justify-content: center;
                border-radius: 8px;
                background: #f1f5f9;
                color: #4f46e5;
                font-size: 18px;">
        <i class="bi bi-shield-check"></i>
    </div>

    <!-- TEXT: CLEAR HIERARCHY -->
    <div class="brand-text">
        <span style="display: block;
                     font-size: 13px;
                     font-weight: 600;
                     color: #1e293b;
                     margin-bottom: -2px;">
            EventPass
        </span>

        <span style="font-size: 11px;
                     color: #64748b;
                     font-weight: 400;">
            System Secure
        </span>
    </div>

    <!-- SIMPLE STATUS INDICATOR -->
    <div style="margin-left: auto; padding-right: 4px;">
        <span style="display: block; width: 8px; height: 8px; background: #22c55e; border-radius: 50%;"></span>
    </div>

</div>

<style>
    .sidebar-footer:hover {
        border-color: #cbd5e1;
        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.08);
        transform: translateY(-1px);
    }
</style>


</div>