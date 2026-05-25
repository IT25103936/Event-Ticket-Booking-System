<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Portal Access | EventPass</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap 5.3 & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary: #6366f1;
            --dark: #0f172a;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Plus Jakarta Sans', sans-serif; }

        body {
            height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            background: linear-gradient(rgba(15, 23, 42, 0.7), rgba(15, 23, 42, 0.8)),
                        url("<%= request.getContextPath() %>/img/dashboard.jpg") no-repeat center center;
            background-size: cover;
            padding: 20px;
        }

        .header-section {
            text-align: center;
            margin-bottom: 40px;
            color: white;
        }

        .header-section h1 { font-weight: 800; font-size: 2.5rem; letter-spacing: -1px; }
        .header-section p { opacity: 0.7; font-weight: 300; }

        /* BENTO GRID SELECTION */
        .selection-container {
            display: flex;
            gap: 25px;
            width: 100%;
            max-width: 800px;
        }

        .role-tile {
            flex: 1;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 30px;
            padding: 40px 30px;
            text-decoration: none;
            color: white;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        /* Hover Effects */
        .role-tile:hover {
            transform: translateY(-12px) scale(1.02);
            background: rgba(255, 255, 255, 0.2);
            border-color: var(--primary);
            box-shadow: 0 30px 60px rgba(0,0,0,0.4);
        }

        /* Icon Styling */
        .icon-circle {
            width: 80px;
            height: 80px;
            border-radius: 22px;
            background: rgba(255, 255, 255, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 25px;
            font-size: 2rem;
            transition: 0.3s;
        }

        .user-tile:hover .icon-circle { background: var(--primary); color: white; }
        .admin-tile:hover .icon-circle { background: #fff; color: var(--dark); }

        .role-tile h3 { font-weight: 800; margin-bottom: 10px; font-size: 1.5rem; }
        .role-tile p { font-size: 0.9rem; opacity: 0.6; line-height: 1.5; }

        /* Arrow Indicator */
        .go-arrow {
            margin-top: 25px;
            width: 45px;
            height: 45px;
            border-radius: 50%;
            border: 1px solid rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            transition: 0.3s;
        }
        .role-tile:hover .go-arrow { background: white; color: var(--dark); border-color: white; }

        /* Mobile Adjustments */
        @media (max-width: 600px) {
            .selection-container { flex-direction: column; }
            .header-section h1 { font-size: 1.8rem; }
        }

        .footer-brand {
            margin-top: 50px;
            color: rgba(255,255,255,0.4);
            font-size: 0.8rem;
            letter-spacing: 2px;
            text-transform: uppercase;
        }
    </style>
</head>

<body>

    <div class="header-section">
        <h1>Online Event Ticket Booking System</h1>
        <p>Select your portal to manage your experience.</p>
    </div>

    <div class="selection-container">

        <!-- USER PORTAL -->
        <a href="<%= request.getContextPath() %>/user/login.jsp" class="role-tile user-tile">
            <div class="icon-circle">
                <i class="bi bi-person-bounding-box"></i>
            </div>
            <h3>Customer</h3>
            <p>Book tickets, explore events, and manage your personal bookings.</p>
            <div class="go-arrow">
                <i class="bi bi-arrow-right"></i>
            </div>
        </a>

        <!-- ADMIN PORTAL -->
        <a href="<%= request.getContextPath() %>/admin/login.jsp" class="role-tile admin-tile">
            <div class="icon-circle">
                <i class="bi bi-shield-lock-fill"></i>
            </div>
            <h3>Administrator</h3>
            <p>Manage event listings, track analytics, and oversee system users.</p>
            <div class="go-arrow">
                <i class="bi bi-arrow-right"></i>
            </div>
        </a>

    </div>

    <div class="footer-brand">
        EventPass &copy; 2026
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>