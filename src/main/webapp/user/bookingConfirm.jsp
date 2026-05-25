<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String eventId = request.getParameter("eventId");
    String seats = request.getParameter("selectedSeats");
    String qty = request.getParameter("quantity");
    String total = request.getParameter("totalPrice");
    String method = request.getParameter("paymentMethod");
    String date = request.getParameter("eventDate");
    String time = request.getParameter("eventTime");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Booking Confirmed</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">

<div class="container py-5">

    <div class="card shadow-lg border-0 rounded-4">
        <div class="card-body p-5 text-center">

            <h2 class="text-success mb-3">
                Booking Confirmed 🎉
            </h2>

            <p class="text-muted">Your ticket has been successfully generated</p>

            <hr>

            <div class="text-start">

                <p><b>Event ID:</b> <%= eventId %></p>
                <p><b>Seats:</b> <%= seats %></p>
                <p><b>Quantity:</b> <%= qty %></p>
                <p><b>Total Price:</b> LKR <%= total %></p>
                <p><b>Payment Method:</b> <%= method %></p>
                <p><b>Date:</b> <%= date %></p>
                <p><b>Time:</b> <%= time %></p>

            </div>

            <a href="dashboard.jsp" class="btn btn-primary mt-3">
                Back to Dashboard
            </a>

        </div>
    </div>

</div>

</body>
</html>