<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Login | EventPass</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@200;400;800&display=swap" rel="stylesheet">

<!-- Load CSS file -->
   <link rel="stylesheet" href="/EventTicketBookingSystem/css/userview/login.css">
</head>

<body>

<div class="glow"></div>

<div class="master-slab">

<!-- LEFT -->
<div class="visual-side">
  <div id="carousel" class="carousel slide h-100" data-bs-ride="carousel">
    <div class="carousel-inner">

      <div class="carousel-item active">
        <img src="<%= request.getContextPath() %>/img/dashboard7.jpg">
      </div>

      <div class="carousel-item">
        <img src="<%= request.getContextPath() %>/img/dashboard8.jpg">
      </div>

    </div>
  </div>
</div>

<!-- RIGHT -->
<div class="form-side">

<div class="brand-logo">
<i class="bi bi-ticket-perforated"></i> EVENTPASS
</div>

<div class="form-title">Welcome Back</div>
<div class="form-subtitle">Login to access your dashboard</div>

<%
    String msg = (String) request.getAttribute("msg");
    String type = (String) request.getAttribute("type");

    if (msg == null) {
        msg = (String) session.getAttribute("msg");
        type = (String) session.getAttribute("type");

        session.removeAttribute("msg");
        session.removeAttribute("type");
    }

    if (msg != null) {
%>

<div class="alert alert-<%= type %> py-2 text-center">
    <%= msg %>
</div>

<% } %>

<form action="<%= request.getContextPath() %>/LoginServlet" method="post">

<div class="input-pill">
<i class="bi bi-envelope"></i>
<input type="email" name="email" placeholder="Email Address" required>
</div>

<div class="input-pill">
<i class="bi bi-lock"></i>
<input type="password" name="password" placeholder="Password" required>
</div>

<button type="submit" class="btn-modern">
<i class="bi bi-box-arrow-in-right"></i> Login
</button>

<div class="link-footer">
New here? <a href="<%= request.getContextPath() %>/user/signup.jsp">Create account</a>
</div>

</form>

</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>