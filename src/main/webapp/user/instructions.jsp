<%@ page import="com.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>System Guide | EventPass</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">


 <!-- Load CSS file -->
   <link rel="stylesheet" href="/EventTicketBookingSystem/css/userview/instructions.css">
</head>

<body>

<%@ include file="navbar.jsp" %>

<div class="main-content">
    <div class="container">

       <div class="header-section text-center mb-5">


       </div>

        <div class="row g-5">

            <!-- Step 1 -->
            <div class="col-xl-3 col-md-6">
                <div class="instruction-card">
                    <span class="card-number">01</span>
                    <span class="step-label">Phase One</span>
                    <div class="icon-wrapper">
                        <i class="bi bi-shield-lock-fill"></i>
                    </div>
                    <h4>Onboarding</h4>
                    <p>Securely register your account to start your personalized event journey.</p>
                </div>
            </div>

            <!-- Step 2 -->
            <div class="col-xl-3 col-md-6">
                <div class="instruction-card">
                    <span class="card-number">02</span>
                    <span class="step-label">Phase Two</span>
                    <div class="icon-wrapper">
                        <i class="bi bi-compass-fill"></i>
                    </div>
                    <h4>Discovery</h4>
                    <p>Explore high-fidelity event listings curated specifically for your tastes.</p>
                </div>
            </div>

            <!-- Step 3 -->
            <div class="col-xl-3 col-md-6">
                <div class="instruction-card">
                    <span class="card-number">03</span>
                    <span class="step-label">Phase Three</span>
                    <div class="icon-wrapper">
                        <i class="bi bi-grid-fill"></i>
                    </div>
                    <h4>Seat Choice</h4>
                    <p>Interact with our precise venue maps to claim your preferred vantage point.</p>
                </div>
            </div>

            <!-- Step 4 -->
            <div class="col-xl-3 col-md-6">
                <div class="instruction-card">
                    <span class="card-number">04</span>
                    <span class="step-label">Phase Four</span>
                    <div class="icon-wrapper">
                        <i class="bi bi-lightning-charge-fill"></i>
                    </div>
                    <h4>Confirmation</h4>
                    <p>Instant checkout and digital ticket generation for immediate access.</p>
                </div>
            </div>

        </div>

    </div>
</div>
<div class="m-5 p-5"></div>
<%@ include file="footer.jsp" %>

</body>
</html>