<%--
    File: users.jsp
    Integrated with Compact Security Mode UI and Photo Upload
--%>
<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Directory | EventPass</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="/eventTicketBookingSystem/css/adminview/users.css">
</head>

<body>

<div class="page-wrapper">
    <%@ include file="navbar.jsp" %>

    <main class="main-content">
        <!-- HEADER -->
        <div class="glass-header">
            <div>
                <h5 class="fw-800 mb-0" style="letter-spacing: -0.5px;">User Directory</h5>
                <p class="text-muted" style="font-size: 0.75rem; margin: 0;">Identity Management System</p>
            </div>

            <button class="btn btn-primary btn-sm rounded-3 px-3 fw-700" onclick="openAdd()" style="background: var(--accent); border:none;">
                <i class="bi bi-person-plus-fill me-1"></i> New User
            </button>
        </div>

        <!-- USER TABLE -->
        <div class="crystal-card">
            <table class="crystal-table">
                <thead>
                <tr>
                    <th>Profile</th>
                    <th>User Details</th>
                    <th>Role</th>
                    <th>Contact</th>
                    <th>Actions</th>
                </tr>
                </thead>

                <tbody>
                <%
                    // File format: id,name,email,phone,role,password,image
                    //              d[0] d[1] d[2]  d[3]  d[4] d[5]     d[6]
                    String path = application.getRealPath("/") + "data/users.txt";
                    File file = new File(path);

                    if (file.exists()) {
                        BufferedReader br = new BufferedReader(new FileReader(file));
                        String line;

                        while ((line = br.readLine()) != null) {
                            if (line.trim().isEmpty()) continue;
                            String[] d = line.split(",");
                            if (d.length < 7) continue;

                            String img = d[6].trim();
                            String imgPath = request.getContextPath() + "/" + img;
                %>

                <tr>
                    <!-- PROFILE IMAGE -->
                    <td style="width: 60px;">
                        <img src="<%= img.isEmpty()
                                ? request.getContextPath() + "/img/profile.png"
                                : imgPath %>"
                             class="user-avatar"
                             onerror="this.src='<%= request.getContextPath() %>/img/profile.png'">
                    </td>

                    <!-- USER INFO -->
                    <td>
                        <div class="fw-800"><%= d[1] %></div>
                        <div class="text-muted" style="font-size: 0.7rem;">
                            UID: U00<%= d[0] %>
                        </div>
                    </td>

                    <!-- ROLE  (d[4]) -->
                    <%-- FIX: was showing d[4] as "Clearance" and d[5] as "Role".
                         File format is id,name,email,phone,ROLE,password,image
                         so d[4]=role and d[5]=password — they were swapped. --%>
                    <td>
                        <span class="badge"
                              style="background:#e0e7ff;color:#4338ca;font-size:0.65rem;">
                            <%= d[4] %>
                        </span>
                    </td>

                    <!-- CONTACT -->
                    <td style="font-size: 0.75rem;">
                        <i class="bi bi-envelope me-1"></i><%= d[2] %>
                    </td>

                    <!-- ACTIONS -->
                    <td class="text-end">
                        <div class="d-flex gap-1 justify-content-end">

                            <%--
                              FIX: openEdit signature is (id, name, email, phone, password, role, image).
                              Password is d[5], role is d[4].
                              Previously the call passed d[4] then d[5] — role and password were swapped,
                              so the password field showed the role text and vice versa in the edit modal.
                            --%>
                            <button class="btn btn-white btn-sm border shadow-sm"
                                    onclick="openEdit(
                                        '<%= d[0] %>',
                                        '<%= d[1] %>',
                                        '<%= d[2] %>',
                                        '<%= d[3] %>',
                                        '<%= d[5] %>',
                                        '<%= d[4] %>',
                                        '<%= img %>'
                                    )">
                                <i class="bi bi-pencil text-primary"></i>
                            </button>

                            <form action="<%= request.getContextPath() %>/UserServlet"
                                  method="post"
                                  class="d-inline">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= d[0] %>">
                                <button class="btn btn-white btn-sm border shadow-sm">
                                    <i class="bi bi-trash text-danger"></i>
                                </button>
                            </form>

                        </div>
                    </td>
                </tr>

                <%
                        }
                        br.close();
                    }
                %>
                </tbody>
            </table>
        </div>
    </main>
</div>

<!-- COMPACT USER MODAL -->
<div class="modal fade" id="userModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-sm-custom">
        <div class="modal-content glass-modal border-0 shadow-lg">

            <!-- Header -->
            <div class="modal-header-user">
                <div class="preview-container-sm">
                    <img id="previewImg" src="<%= request.getContextPath() %>/img/profile.png">
                </div>
                <h6 class="fw-800 mb-0 text-white" id="formTitle">User Account</h6>
                <p style="font-size: 0.7rem;" class="text-white-50 mb-0">
                    Identity & Permission Control
                </p>
            </div>

            <div class="modal-body p-3 mt-4">
                <form action="<%= request.getContextPath() %>/UserServlet"
                      method="post"
                      enctype="multipart/form-data">

                    <input type="hidden" name="action" id="action" value="create">
                    <input type="hidden" name="id" id="id">
                    <input type="hidden" name="oldImage" id="oldImage">

                    <!-- NAME -->
                    <label class="compact-label">
                        <i class="bi bi-person me-1"></i> FULL NAME
                    </label>
                    <div class="input-group-crystal-sm">
                        <input type="text" name="name" id="name"
                               class="form-control"
                               placeholder="Enter Your Name" required>
                    </div>

                    <!-- EMAIL + PHONE -->
                    <div class="row g-2">
                        <div class="col-7">
                            <label class="compact-label">
                                <i class="bi bi-envelope me-1"></i> EMAIL
                            </label>
                            <div class="input-group-crystal-sm">
                                <input type="email" name="email" id="email"
                                       class="form-control"
                                       placeholder="Enter Email" required>
                            </div>
                        </div>

                        <div class="col-5">
                            <label class="compact-label">
                                <i class="bi bi-phone me-1"></i> PHONE
                            </label>
                            <div class="input-group-crystal-sm">
                                <input type="text" name="phone" id="phone"
                                       class="form-control"
                                       placeholder="Phone" required>
                            </div>
                        </div>
                    </div>

                    <!-- ROLE + PASSWORD -->
                    <div class="row g-2">
                        <div class="col-6">
                            <label class="compact-label">
                                <i class="bi bi-shield me-1"></i> ROLE
                            </label>
                            <div class="input-group-crystal-sm">
                                <select name="role" id="role" class="form-select">
                                    <option value="USER" selected>USER</option>
                                </select>
                            </div>
                        </div>

                        <div class="col-6">
                            <label class="compact-label">
                                <i class="bi bi-key me-1"></i> PASSWORD
                            </label>
                            <div class="input-group-crystal-sm">
                                <input type="password" name="password" id="password"
                                       class="form-control"
                                       placeholder="••••••" required>
                            </div>
                        </div>
                    </div>

                    <!-- IMAGE -->
                    <label class="compact-label">
                        <i class="bi bi-image me-1"></i> PHOTO
                    </label>
                    <div class="input-group-crystal-sm mb-3">
                        <input type="file" name="image" id="imageInput"
                               class="form-control" accept="image/*">
                    </div>

                    <!-- BUTTONS -->
                    <div class="d-grid gap-1">
                        <button type="submit" class="btn-save-compact">
                            <i class="bi bi-check-circle-fill me-2"></i>
                            Save Account
                        </button>

                        <button type="button"
                                class="btn btn-sm text-muted fw-600 mt-1"
                                data-bs-dismiss="modal"
                                style="font-size: 0.75rem;">
                            Cancel
                        </button>
                    </div>

                </form>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
  let modal = new bootstrap.Modal(document.getElementById('userModal'));

  // IMAGE PREVIEW
  document.getElementById("imageInput").addEventListener("change", function (e) {
      const file = e.target.files[0];
      if (file) {
          const reader = new FileReader();
          reader.onload = (event) =>
              document.getElementById("previewImg").src = event.target.result;
          reader.readAsDataURL(file);
      }
  });

  // ADD
  function openAdd() {
      document.getElementById("formTitle").innerText = "New Account";
      document.getElementById("action").value = "create";
      document.getElementById("id").value = "";
      document.getElementById("name").value = "";
      document.getElementById("email").value = "";
      document.getElementById("phone").value = "";
      document.getElementById("password").value = "";
      document.getElementById("role").value = "USER";
      document.getElementById("oldImage").value = "";
      document.getElementById("previewImg").src =
          "<%= request.getContextPath() %>/img/profile.png";
      modal.show();
  }

  // EDIT — signature: openEdit(id, name, email, phone, password, role, image)
  function openEdit(id, name, email, phone, password, role, image) {
      document.getElementById("formTitle").innerText = "Edit Profile";
      document.getElementById("action").value = "update";
      document.getElementById("id").value = id;
      document.getElementById("name").value = name;
      document.getElementById("email").value = email;
      document.getElementById("phone").value = phone;
      document.getElementById("password").value = password;
      document.getElementById("role").value = role;
      document.getElementById("oldImage").value = image;
      document.getElementById("previewImg").src =
          image ? "<%= request.getContextPath() %>/" + image
                : "<%= request.getContextPath() %>/img/profile.png";
      modal.show();
  }
</script>
</body>
</html>
