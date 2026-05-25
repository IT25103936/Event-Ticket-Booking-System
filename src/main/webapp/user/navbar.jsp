<%@ page import="com.model.User" %>


<%
    User userNav = (User) session.getAttribute("user");
    String navName = "Guest";
    String navImg = "img/profile.png";

    if (userNav != null) {
        navName = userNav.getName();
        String dbImg = userNav.getImage();
        if (dbImg != null && !dbImg.trim().isEmpty()) {
            navImg = dbImg;
        }
    }
    String navImgPath = request.getContextPath() + "/" + (navImg.startsWith("/") ? navImg.substring(1) : navImg);
%>

<nav class="navbar navbar-expand-lg modern-navbar fixed-top" id="mainNavbar">
    <div class="container navbar-glass-container">

     <a class="navbar-brand d-flex align-items-center gap-2"
        href="<%= request.getContextPath() %>/user/dashboard.jsp">

         <div class="brand-logo-wrapper d-flex align-items-center justify-content-center">
             <i class="bi bi-ticket-perforated-fill"></i>
         </div>

         <div class="brand-text-wrapper d-flex flex-column justify-content-center">
     <span class="brand-wrapper">
         <span class="brand-main">Event <span class="brand-sub">Pass</span></span>
         <span class="brand-sub-sub">Online Ticket Booking Platform</span>
     </span>

         </div>

     </a>

        <div class="ms-auto d-flex align-items-center gap-2">

        <!-- HOME BUTTON -->
        <a href="<%= request.getContextPath() %>/user/homepage.jsp"
           class="home-nav-btn d-flex align-items-center">
            <i class="bi bi-house-door-fill me-1"></i>
            <span class="d-none d-md-inline"></span>Home
        </a>

        <!-- DASHBOARD BUTTON -->
        <a href="<%= request.getContextPath() %>/user/dashboard.jsp"
           class="home-nav-btn d-flex align-items-center">
            <i class="bi bi-speedometer2 me-1"></i>
            <span class="d-none d-md-inline">Dashboard</span>
        </a>

            <a href="<%= request.getContextPath() %>/user/profile.jsp"
               class="profile-action-pill">
                <div class="avatar-container">
                    <img src="<%= navImgPath %>"
                         class="avatar-img"
                         onerror="this.onerror=null;this.src='<%= request.getContextPath() %>/img/profile.png'">
                    <span class="status-indicator"></span>
                </div>
                <div class="user-meta d-none d-md-block">
                    <span class="user-label">Authorized User</span>
                    <span class="user-display-name"><%= navName %></span>
                </div>
            </a>

            <div class="nav-divider"></div>

            <a href="<%= request.getContextPath() %>/user/login.jsp"
               class="logout-trigger"
               title="Sign Out">
                <i class="bi bi-power"></i>
            </a>

        </div>
    </div>
</nav>

<style>
/* MODERN DESIGN SYSTEM */
:root {
    --nav-height: 72px;
    --nav-bg: rgba(15, 23, 42, 0.75);
    --glass-border: rgba(255, 255, 255, 0.1);
    --accent-primary: #6366f1;
    --accent-secondary: #a855f7;
    --text-white: #ffffff;
    --text-dim: #94a3b8;
}

.modern-navbar {
    height: var(--nav-height);
    background: transparent !important; /* Managed by container */
    padding: 0 !important;
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

/* THE FLOATING GLASS CONTAINER */
.navbar-glass-container {
    background: var(--nav-bg);
    backdrop-filter: blur(16px) saturate(180%);
    -webkit-backdrop-filter: blur(16px) saturate(180%);
    border: 1px solid var(--glass-border);
    border-radius: 20px;
    padding: 8px 16px;
    margin-top: 10px;
    transition: all 0.4s ease;
}

/* BRANDING */
.brand-logo-wrapper {
    background: linear-gradient(135deg, var(--accent-primary), var(--accent-secondary));
    width: 40px;
    height: 40px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 20px;
    transition: transform 0.3s ease;
}

/* HOME and DASHBOARD NAV BUTTON */
.home-nav-btn {
    margin : 7px;
    padding: 8px 14px;
    border-radius: 12px;
    background: rgba(255, 255, 255, 0.05);
    color: var(--text-white);
    text-decoration: none;
    font-weight: 500;
    font-size: 14px;
    border: 1px solid transparent;
    transition: all 0.3s ease;
}

.home-nav-btn i {
    font-size: 16px;
}

.home-nav-btn:hover {
    background: linear-gradient(135deg, var(--accent-primary), var(--accent-secondary));
    color: white;
    border-color: transparent;
    box-shadow: 0 6px 20px rgba(99, 102, 241, 0.4);
    transform: translateY(-2px);
}
.navbar-brand:hover .brand-logo-wrapper {
    transform: rotate(-8deg) scale(1.1);
}

.brand-text-wrapper {
    margin-left: 12px;
    display: flex;
    flex-direction: column;
    line-height: 1;
}

.brand-main {
    font-weight: 800;
    font-size: 1.3rem;
    color: var(--text-white);
    letter-spacing: -0.5px;
}

.brand-sub {
    font-weight: 300;
    font-size: 1.3rem;
    color: var(--text-dim);
}
.brand-sub-sub {
    font-weight: 300;
    font-size: 0.8em;
    opacity: 0.45;
    margin:14px;
     color: var(--text-dim);

}
/* PROFILE PILL */
.profile-action-pill {
    display: flex;
    align-items: center;
    padding: 6px 12px 6px 6px;
    background: rgba(255, 255, 255, 0.03);
    border: 1px solid transparent;
    border-radius: 14px;
    text-decoration: none;
    transition: all 0.3s ease;
}

.profile-action-pill:hover {
    background: rgba(255, 255, 255, 0.08);
    border-color: var(--glass-border);
}

.avatar-container {
    position: relative;
    width: 36px;
    height: 36px;
}

.avatar-img {
    width: 100%;
    height: 100%;
    border-radius: 10px;
    object-fit: cover;
    border: 2px solid rgba(99, 102, 241, 0.3);
}

.status-indicator {
    position: absolute;
    bottom: -2px;
    right: -2px;
    width: 10px;
    height: 10px;
    background: #10b981;
    border: 2px solid #0f172a;
    border-radius: 50%;
}

.user-meta {
    margin-left: 12px;
}

.user-label {
    display: block;
    font-size: 10px;
    font-weight: 700;
    color: var(--accent-primary);
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.user-display-name {
    display: block;
    font-size: 14px;
    font-weight: 600;
    color: var(--text-white);
}

/* LOGOUT BUTTON */
.logout-trigger {
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 12px;
    color: #f43f5e;
    background: rgba(244, 63, 94, 0.1);
    font-size: 1.2rem;
    transition: all 0.3s ease;
    text-decoration: none;
}

.logout-trigger:hover {
    background: #f43f5e;
    color: white;
    box-shadow: 0 8px 20px rgba(244, 63, 94, 0.3);
    transform: translateY(-2px);
}

.nav-divider {
    width: 1px;
    height: 24px;
    background: var(--glass-border);
    margin: 0 8px;
}

/* SCROLL STATES */
.nav-scrolled .navbar-glass-container {
    margin-top: 0;
    border-radius: 0 0 20px 20px;
    background: rgba(15, 23, 42, 0.98);
    box-shadow: 0 10px 30px rgba(0,0,0,0.4);
}

@media (max-width: 991px) {
    .navbar-glass-container { margin: 10px; }
}
</style>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const nav = document.getElementById('mainNavbar');

        window.addEventListener('scroll', function() {
            if (window.scrollY > 20) {
                nav.classList.add('nav-scrolled');
            } else {
                nav.classList.remove('nav-scrolled');
            }
        });
    });
</script>