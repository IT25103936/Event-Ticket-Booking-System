<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin Signup | EventPass</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">

<link rel="stylesheet"
href="<%= request.getContextPath() %>/css/adminview/signup.css">

</head>

<body>

<div class="master-slab">

    <!-- LEFT -->
    <div class="visual-side">

        <img src="<%= request.getContextPath() %>/img/dashboard7.jpg">

        <div class="visual-overlay">
            <h3>
                <i class="bi bi-person-plus-fill"></i>
                Admin System
            </h3>

            <p>Create secure access for platform management.</p>
        </div>

    </div>

    <!-- RIGHT -->
    <div class="form-side">

        <div class="brand">
            <i class="bi bi-shield-lock"></i> EVENTPASS
        </div>

        <div class="form-title">Create Account</div>

        <div class="form-sub">
            Register admin access
        </div>

        <!-- MESSAGE -->
        <%
            String msg = (String) request.getAttribute("msg");
            String type = (String) request.getAttribute("type");
        %>

        <% if(msg != null){ %>

            <div class="alert alert-<%= type %>">
                <%= msg %>
            </div>

        <% } %>

        <!-- PASSWORD ERROR -->
        <div id="errorMsg"
             class="alert alert-danger"
             style="display:none;">

            Passwords do not match

        </div>

        <!-- FORM -->
        <form id="signupForm"
              action="<%= request.getContextPath() %>/AdminAuthServlet"
              method="post">

            <!-- IMPORTANT -->
            <input type="hidden"
                   name="action"
                   value="register">

            <!-- NAME -->
            <div class="input-box">

                <i class="bi bi-person"></i>

                <input type="text"
                       name="name"
                       placeholder="Full Name"
                       required>

            </div>

            <!-- EMAIL -->
            <div class="input-box">

                <i class="bi bi-envelope"></i>

                <input type="email"
                       name="email"
                       placeholder="Email Address"
                       required>

            </div>

            <!-- ROLE -->
            <div class="input-box">
                <i class="bi bi-telephone"></i>
                <input type="text"
                       id="phone"
                       name="phone"
                       placeholder="Enter Phone Number"
                       required>
            </div>

           <div class="input-box">
               <i class="bi bi-shield"></i>

               <input type="text"
                      name="role"
                      value="ADMIN"
                      readonly>
           </div>

            <!-- PASSWORD -->
            <div class="row-small">

                <div class="input-box">

                    <input type="password"
                           id="password"
                           name="password"
                           placeholder="Password"
                           required>

                </div>

                <div class="input-box">

                    <input type="password"
                           id="confirmPassword"
                           placeholder="Confirm Password"
                           required>

                </div>

            </div>

            <!-- BUTTON -->
            <button type="submit"
                    class="btn-main">

                <i class="bi bi-person-check"></i>
                Create Account

            </button>

        </form>

        <!-- FOOTER -->
        <div class="footer">

            Already have account?

            <a href="<%= request.getContextPath() %>/admin/login.jsp">
                Login
            </a>

        </div>

    </div>

</div>

<script>

document.getElementById("signupForm")
.addEventListener("submit", function(e){

    let p =
        document.getElementById("password").value;

    let c =
        document.getElementById("confirmPassword").value;

    if(p !== c){

        e.preventDefault();

        document.getElementById("errorMsg")
        .style.display = "block";
    }
});

</script>

</body>
</html>