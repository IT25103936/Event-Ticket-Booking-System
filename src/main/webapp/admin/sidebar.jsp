<style>
.sidebar {
    width: 260px;
    height: 100vh;
    position: fixed;
    left: 0;
    top: 0;

    background: rgba(15, 23, 42, 0.88);
    backdrop-filter: blur(18px);

    border-right: 1px solid rgba(255,255,255,0.08);

    display: flex;
    flex-direction: column;

    padding: 18px;
    color: white;
}

/* HEADER */
.sidebar-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 18px;
}

.sidebar-brand {
    font-weight: 800;
    letter-spacing: 1px;
}

/* NAV */
.sidebar-nav {
    display: flex;
    flex-direction: column;
    gap: 6px;
}

/* LINKS */
.nav-item {
    display: flex;
    align-items: center;
    gap: 12px;

    padding: 12px 14px;
    border-radius: 12px;

    text-decoration: none;
    color: rgba(255,255,255,0.75);
    font-weight: 500;

    transition: 0.25s ease;
}

.nav-item i {
    font-size: 1.1rem;
}

/* HOVER */
.nav-item:hover {
    background: rgba(255,255,255,0.08);
    color: #fff;
    transform: translateX(4px);
}

/* ACTIVE */
.nav-item.active {
    background: linear-gradient(135deg, #6366f1, #a855f7);
    color: #fff;
    box-shadow: 0 10px 25px rgba(99,102,241,0.3);
}

/* LOGOUT */
.nav-item.logout {
    color: #f87171;
}

.nav-item.logout:hover {
    background: rgba(248, 113, 113, 0.15);
}

/* DIVIDER */
.sidebar-divider {
    border-color: rgba(255,255,255,0.08);
    margin: 10px 0;
}

/* THEME BUTTON */
.theme-toggle {
    background: rgba(255,255,255,0.1);
    border: none;
    color: white;
    width: 36px;
    height: 36px;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: 0.3s;
}

.theme-toggle:hover {
    background: rgba(255,255,255,0.2);
}
</style>
<aside class="sidebar">

    <div class="sidebar-header">
        <span class="sidebar-brand">EVENTPASS</span>
        <button class="theme-toggle" onclick="toggleTheme()">
            <i class="bi bi-moon-stars"></i>
        </button>
    </div>

    <nav class="sidebar-nav">

        <a href="<%= request.getContextPath() %>/admin/dashboard.jsp" class="nav-item active">
            <i class="bi bi-speedometer2"></i> Dashboard
        </a>

        <a href="<%= request.getContextPath() %>/admin/events.jsp" class="nav-item">
            <i class="bi bi-calendar-event"></i> Events
        </a>

        <a href="<%= request.getContextPath() %>/admin/users.jsp" class="nav-item">
            <i class="bi bi-people"></i> Users
        </a>

        <a href="<%= request.getContextPath() %>/admin/admins.jsp" class="nav-item">
            <i class="bi bi-shield-lock"></i> Admins
        </a>

        <a href="<%= request.getContextPath() %>/admin/bookings.jsp" class="nav-item">
            <i class="bi bi-journal-check"></i> Bookings
        </a>

        <a href="<%= request.getContextPath() %>/admin/payments.jsp" class="nav-item">
            <i class="bi bi-cash-coin"></i> Payments
        </a>

        <a href="<%= request.getContextPath() %>/admin/tickets.jsp" class="nav-item">
            <i class="bi bi-ticket-perforated"></i> Tickets
        </a>

        <a href="<%= request.getContextPath() %>/admin/ratings.jsp" class="nav-item">
            <i class="bi bi-star-half"></i> Ratings
        </a>

        <hr class="sidebar-divider">

        <a href="<%= request.getContextPath() %>/admin/login.jsp" class="nav-item logout">
            <i class="bi bi-box-arrow-right"></i> Logout
        </a>

    </nav>
</aside>