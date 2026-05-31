<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Infrastructure | EventPass</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono&display=swap" rel="stylesheet">

    <!-- Load CSS file -->
       <link rel="stylesheet" href="/EventTicketBookingSystem/css/adminview/admins.css">
</head>

<body>

<div class="page-wrapper">
    <%@ include file="navbar.jsp" %>

    <main class="main-content">
        <%
            String currentRole = (String) session.getAttribute("adminLevel");
            boolean isSuperAdmin = "SUPERADMIN".equals(currentRole);
        %>
        <div class="glass-header">
            <div>
                <h4 class="fw-800 mb-0" style="letter-spacing: -1px;">Admin Infrastructure</h4>
                <p class="text-muted small mb-0">System-wide privilege and identity management</p>
            </div>
            <% if (isSuperAdmin) { %>
            <button class="btn btn-primary rounded-pill px-4 fw-700" onclick="openAdd()" style="background: var(--accent); border:none;">
                <i class="bi bi-person-plus-fill me-2"></i> New Admin
            </button>
            <% } %>
        </div>

        <div class="crystal-card">
            <table class="crystal-table">
                <thead>
                    <tr class="text-muted small fw-800 text-uppercase">
                        <th>Identity</th>
                        <th>Operator</th>
                        <th>Alias</th>
                        <th>Clearance</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    String path = application.getRealPath("/") + "data/admin.txt";
                    File file = new File(path);
                    if (file.exists()) {
                        BufferedReader br = new BufferedReader(new FileReader(file));
                        String line;
                        while ((line = br.readLine()) != null) {
                            String[] d = line.split(",");
                            String img = (d.length > 6) ? d[6].trim() : "";
                            String imgPath = request.getContextPath() + "/uploads/" + img;
                %>
                    <tr>
                        <td style="width: 80px;">
                            <img src="<%= img.isEmpty() ? request.getContextPath()+"/img/profile.png" : imgPath %>"
                                 class="admin-avatar"
                                 onerror="this.src='<%= request.getContextPath() %>/img/profile.png'">
                        </td>
                        <td>
                            <div class="fw-800"><%= d[1] %></div>
                            <div class="small text-muted" style="font-family: 'JetBrains Mono';">ID: AD00<%= d[0] %></div>
                        </td>
                        <td class="fw-600 text-muted small"><%= d[2] %></td>
                        <td>
                            <span class="badge rounded-pill px-3 py-2"
                                  style="color: #4338ca; background: #e0e7ff; font-size: 0.7rem; border: 1px solid #c7d2fe;">
                                <i class="bi bi-shield-lock-fill me-1"></i> <%= d[7] %>
                            </span>
                        </td>
                        <td class="text-end">
                            <div class="d-flex gap-2 justify-content-end">
                                <% if (isSuperAdmin) { %>
                                <button class="btn btn-white btn-sm rounded-3 shadow-sm border"
                                    onclick="openEdit('<%= d[0] %>','<%= d[1] %>','<%= d[2] %>','<%= d[3] %>','<%= d[4] %>','<%= img %>')">
                                    <i class="bi bi-pencil-square text-primary"></i>
                                </button>
                                <form action="<%= request.getContextPath() %>/AdminServlet" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= d[0] %>">
                                    <button class="btn btn-white btn-sm rounded-3 shadow-sm border">
                                        <i class="bi bi-trash3 text-danger"></i>
                                    </button>
                                </form>
                                <% } else { %>
                                <span class="text-muted small fst-italic">View only</span>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                <%
                        } br.close();
                    }
                %>
                </tbody>
            </table>
        </div>
    </main>
</div>


<!-- COMPACT MODAL -->
<div class="modal fade" id="adminModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-sm-custom">
        <div class="modal-content glass-modal border-0 shadow-lg">

            <!-- HEADER -->
            <div class="modal-header-admin">
                <div class="preview-container-sm shadow-lg">
                    <img id="previewImg"
                         src="<%= request.getContextPath() %>/img/profile.png"
                         class="img-fluid">
                </div>

                <h6 class="fw-800 mb-0 text-white" id="formTitle">
                    Admin Credentials
                </h6>

                <p style="font-size: 0.7rem;" class="text-white-50 mb-0">
                    Secure Identity Configuration
                </p>
            </div>

            <!-- BODY -->
            <div class="modal-body p-3 mt-4">

                <form action="<%= request.getContextPath() %>/AdminServlet"
                      method="post"
                      enctype="multipart/form-data">

                    <input type="hidden" name="action" id="action" value="create">
                    <input type="hidden" name="id" id="id">

                    <!-- NAME -->
                    <div class="mb-2">
                        <label class="compact-label">
                            <i class="bi bi-person-fill me-1"></i> Full Name
                        </label>
                        <div class="input-group-crystal-sm">
                            <input type="text" name="name" id="name"
                                   class="form-control"
                                   placeholder="John Doe" required>
                        </div>
                    </div>

                    <!-- EMAIL -->
                    <div class="mb-2">
                        <label class="compact-label">
                            <i class="bi bi-envelope-at-fill me-1"></i> Email
                        </label>
                        <div class="input-group-crystal-sm">
                            <input type="email" name="email" id="email"
                                   class="form-control"
                                   placeholder="admin@eventpass.com" required>
                        </div>
                    </div>

                    <!-- PHONE -->
                    <div class="mb-2">
                        <label class="compact-label">
                            <i class="bi bi-telephone-fill me-1"></i> Phone
                        </label>
                        <div class="input-group-crystal-sm">
                            <input type="text" name="phone" id="phone"
                                   class="form-control"
                                   placeholder="+94 7X XXX XXXX">
                        </div>
                    </div>

                    <!-- ROLE + PROMOTE -->
                    <div class="row g-2 align-items-end mb-2">

                        <!-- ROLE -->
                        <div class="col-6">
                            <label class="compact-label">
                                <i class="bi bi-shield-lock-fill me-1"></i> Role
                            </label>

                            <div class="input-group-crystal-sm">
                                <select name="role" id="role" class="form-select">
                                    <option value="ADMIN" selected>ADMIN</option>
                                </select>
                            </div>
                        </div>

                        <!-- PROMOTE -->
                        <% if (isSuperAdmin) { %>
                        <div class="col-6">

                            <label class="compact-label d-block mb-1">
                                <i class="bi bi-arrow-up-circle me-1"></i> Privilege
                            </label>

                            <div class="form-check d-flex align-items-center gap-2 mt-2">

                                <input class="form-check-input m-0"
                                       type="checkbox"
                                       name="promoteSuper"
                                       id="promoteSuper"
                                       value="on">

                                <label class="form-check-label small mb-0"
                                       for="promoteSuper">
                                     SUPERADMIN
                                </label>

                            </div>

                        </div>
                        <% } %>

                    </div>

                    <!-- PASSWORD -->
                    <div class="mb-2">
                        <label class="compact-label">
                            <i class="bi bi-key-fill me-1"></i> Passkey
                        </label>

                        <div class="input-group-crystal-sm">
                            <input type="password" name="password" id="password"
                                   class="form-control"
                                   placeholder="••••" required>
                        </div>
                    </div>

                    <!-- IMAGE -->
                    <div class="my-3">
                        <label class="compact-label">
                            <i class="bi bi-image me-1"></i> Identity Photo
                        </label>

                        <div class="input-group-crystal-sm">
                            <input type="file" name="image" id="imageInput"
                                   class="form-control"
                                   accept="image/*">
                        </div>
                    </div>

                    <!-- BUTTONS -->
                    <div class="d-grid gap-1 mt-3">
                        <button type="submit" class="btn-save shadow-indigo">
                            <i class="bi bi-shield-check me-2"></i> Confirm Changes
                        </button>

                        <button type="button"
                                class="btn btn-sm text-muted fw-600 opacity-75"
                                data-bs-dismiss="modal">
                            Discard
                        </button>
                    </div>

                </form>
            </div>

        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let modal = new bootstrap.Modal(document.getElementById('adminModal'));

    // Image Preview Logic
    document.getElementById("imageInput").addEventListener("change", function(e) {
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = (event) => document.getElementById("previewImg").src = event.target.result;
            reader.readAsDataURL(file);
        }
    });

    function openAdd() {
        document.getElementById("formTitle").innerText = "Create Administrator";
        document.getElementById("action").value = "create";
        document.getElementById("id").value = "";
        document.getElementById("name").value = "";
        document.getElementById("email").value = "";
        document.getElementById("phone").value = "";
        document.getElementById("password").value = "";
        document.getElementById("previewImg").src = "<%= request.getContextPath() %>/img/profile.png";
        modal.show();
    }

    function openEdit(id, name, email, phone, password, image) {
        document.getElementById("formTitle").innerText = "Modify Permissions";
        document.getElementById("action").value = "update";
        document.getElementById("id").value = id;
        document.getElementById("name").value = name;
        document.getElementById("email").value = email;
        document.getElementById("phone").value = phone;
        document.getElementById("password").value = password;

        document.getElementById("previewImg").src =
            image ? "<%= request.getContextPath() %>/uploads/" + image
                  : "<%= request.getContextPath() %>/img/profile.png";

        modal.show();
    }
</script>
</body>
</html>