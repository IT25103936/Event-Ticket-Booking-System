<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Login | EventPass</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">

 <!-- Load CSS file -->
       <link rel="stylesheet" href="/eventTicketBookingSystem/css/adminview/login.css">


</head>

<body>

<div class="main-box">

  <!-- LEFT IMAGE -->
  <div class="left-side">
    <img src="<%= request.getContextPath() %>/img/dashboard7.jpg">

    <div class="left-overlay">
      <h2><i class="bi bi-stars"></i> Welcome Back</h2>
      <p>Access your dashboard and manage events easily.</p>
    </div>
  </div>

  <!-- RIGHT FORM -->
  <div class="right-side">

    <div class="brand">
      <i class="bi bi-ticket-perforated"></i> EVENTPASS
    </div>

    <div class="title">Admin Login</div>
    <div class="subtitle">Enter your credentials</div>

    <form action="<%= request.getContextPath() %>/AdminAuthServlet" method="post">
      <input type="hidden" name="action" value="login">

      <div class="input-box">
        <i class="bi bi-envelope"></i>
        <input type="email" name="email" placeholder="Email Address" required>
      </div>

      <div class="input-box">
        <i class="bi bi-lock"></i>
        <input type="password" name="password" placeholder="Password" required>
      </div>

      <button class="btn-login">
        Login <i class="bi bi-arrow-right ms-1"></i>
      </button>
    </form>

    <div class="footer">
      New operator? <a href="<%= request.getContextPath() %>/admin/signup.jsp">Create Account</a>
    </div>

  </div>

</div>

</body>
</html>