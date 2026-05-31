<%@ page import="com.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String img = user.getImage();
    if (img == null || img.trim().isEmpty()) {
        img = "img/profile.png";
    }
    if (img.startsWith("/")) {
        img = img.substring(1);
    }
    String imgPath = request.getContextPath() + "/" + img;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>My Profile | EventPass</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- Load CSS file -->
    <link rel="stylesheet" href="/EventTicketBookingSystem/css/userview/profile.css">
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="main-content">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10">

                <div class="row profile-container g-0">

                    <!-- ========== SIDEBAR ========== -->
                    <div class="col-md-4 profile-sidebar">
                        <div class="avatar-wrapper">
                            <img src="<%= imgPath %>" class="avatar-large"
                                 onerror="this.src='<%= request.getContextPath() %>/img/profile.png'">
                            <div class="status-badge"></div>
                        </div>
                        <h4 class="fw-bold mb-1 text-dark"><%= user.getName() %></h4>
                        <p class="text-muted mb-4"><%= user.getEmail() %></p>

                        <div class="d-flex justify-content-center gap-2 mt-2">
                            <span class="badge bg-soft-primary text-primary px-3 py-2 rounded-pill"
                                  style="background:#e0e7ff">Verified Member</span>
                        </div>

                        <hr class="my-4 opacity-50">
                        <a href="dashboard.jsp" class="btn-back">
                            <i class="bi bi-arrow-left"></i> Back to Dashboard
                        </a>
                    </div>

                    <!-- ========== FORM AREA ========== -->
                    <div class="col-md-8 profile-form-area">
                        <h3 class="fw-bold text-dark mb-1">Account Settings</h3>
                        <p class="text-muted mb-4">Update your personal information and profile picture.</p>

                        <form action="<%= request.getContextPath() %>/UserServlet"
                              method="post" enctype="multipart/form-data">

                            <%-- FIX 1: action --%>
                            <input type="hidden" name="action"      value="update">
                            <%-- FIX 2: user id — required by servlet to find the record --%>
                            <input type="hidden" name="id"          value="<%= user.getId() %>">
                            <%-- FIX 3: preserve current password when user leaves the field blank --%>
                            <input type="hidden" name="oldPassword" value="<%= user.getPassword() %>">
                            <%-- FIX 4: preserve current role so it is not set to null --%>
                            <input type="hidden" name="role"        value="<%= user.getRole() %>">
                            <%-- FIX 5: preserve current image so it is not reset to default.png --%>
                            <input type="hidden" name="oldImage"    value="<%= user.getImage() %>">

                            <div class="row g-4">

                                <div class="col-md-6">
                                    <label class="form-label">Full Name</label>
                                    <input type="text" class="form-control" name="name"
                                           value="<%= user.getName() %>" required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Email Address (Locked)</label>
                                    <input type="email" class="form-control readonly-field" name="email"
                                           value="<%= user.getEmail() %>" readonly>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Phone Number</label>
                                    <input type="text" class="form-control" name="phone"
                                           value="<%= user.getPhone() %>" required>
                                </div>

                                <%-- FIX 6: do NOT prefill password — leave blank so it is only
                                     sent when the user deliberately types a new one.
                                     The servlet already falls back to oldPassword when empty. --%>
                                <div class="col-md-6">
                                    <label class="form-label">New Password
                                        <small class="text-muted fw-normal">(leave blank to keep current)</small>
                                    </label>
                                    <input type="password" class="form-control" name="password"
                                           placeholder="Enter new password">
                                </div>

                                <div class="col-12">
                                    <label class="form-label">Change Profile Picture</label>
                                    <input type="file" name="image" class="form-control"
                                           accept="image/jpeg,image/png,image/gif">
                                    <div class="form-text">JPG, PNG or GIF. Max size 5 MB.</div>
                                </div>

                                <div class="col-12 mt-5">
                                    <button type="submit" class="btn-save">
                                        <i class="bi bi-shield-check me-2"></i> Save Changes
                                    </button>
                                </div>

                            </div>
                        </form>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<div class="m-5 p-3"></div>
<%@ include file="footer.jsp" %>

</body>
</html>
