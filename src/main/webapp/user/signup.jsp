<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>User Signup | EventPass</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@200;400;800&display=swap" rel="stylesheet">

 <!-- Load CSS file -->
     <link rel="stylesheet" href="/EventTicketBookingSystem/css/userview/signup.css">


</head>

<body>

<div class="glow"></div>

<div class="master-slab">

<!-- LEFT -->
<div class="visual-side">
  <div id="signupCarousel" class="carousel slide h-100" data-bs-ride="carousel">

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

<div class="form-title">Create Account</div>
<div class="form-subtitle">Start your experience</div>

<!-- ✅ FIXED FORM -->
<form action="<%= request.getContextPath() %>/LoginServlet"
      method="post"
      enctype="multipart/form-data">

<input type="hidden" name="action" value="register">

<!-- NAME -->
<div class="input-pill">
<i class="bi bi-person"></i>
<input type="text" name="name" placeholder="Full Name" required>
</div>

<!-- EMAIL -->
<div class="input-pill">
<i class="bi bi-envelope"></i>
<input type="email" name="email" placeholder="Email Address" required>
</div>

<!-- PHONE -->
<div class="input-pill">
<i class="bi bi-telephone"></i>
<input type="text" name="phone" placeholder="Phone Number" required>
</div>

<!-- PASSWORD -->
<div class="input-pill">
<i class="bi bi-lock"></i>
<input type="password" name="password" placeholder="Password" required>
</div>

<!-- PROFILE IMAGE (optional) -->
<div class="input-pill">
<i class="bi bi-image"></i>
<input type="file" name="image" accept="image/*">
</div>

<button class="btn-modern" type="submit">
<i class="bi bi-person-plus"></i> Sign Up
</button>

</form>

<div class="link-footer">
Already have account? <a href="login.jsp">Login</a>
</div>

</div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>