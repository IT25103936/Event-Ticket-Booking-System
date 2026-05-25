<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Event Hub | EventPass</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/eventTicketBookingSystem/css/adminview/events.css">
</head>

<body>
<div class="page-wrapper">

    <main class="main-content">

        <div class="glass-header">
            <div>
                <h4 class="fw-800 mb-0">System Events</h4>
                <p class="text-muted small mb-0">Catalogue &amp; Resource Management</p>
            </div>
            <button class="btn-add" onclick="openAdd()">
                <i class="bi bi-plus-circle-fill me-2"></i> Register Event
            </button>
        </div>

        <div class="crystal-card">
            <table class="crystal-table">
                <thead>
                <tr>
                    <th>Asset</th>
                    <th>Identifier</th>
                    <th>Event Name</th>
                    <th>Location</th>
                    <th>Price</th>
                    <th class="text-end">Options</th>
                </tr>
                </thead>
                <tbody>
                <%
                    // File format: id , name , date , time , location , price , desc , img
                    //              d[0]  d[1]   d[2]   d[3]   d[4]      d[5]    d[6]   d[7]

                    // FIX 4: safe getRealPath — works on all servlet containers
                    String filePath = application.getRealPath("/") + "data/events.txt";
                    File dataFile   = new File(filePath);

                    if (dataFile.exists()) {
                        BufferedReader br = new BufferedReader(new FileReader(dataFile));
                        String line;

                        while ((line = br.readLine()) != null) {

                            // FIX 5: skip blank lines — prevents ArrayIndexOutOfBoundsException
                            if (line.trim().isEmpty()) continue;

                            String[] d = line.split(",", -1);

                            // FIX 2 & 3: correct indices after the "time" column was inserted at d[3]
                            String eId       = d.length > 0 ? d[0].trim() : "";
                            String eName     = d.length > 1 ? d[1].trim() : "";
                            String eDate     = d.length > 2 ? d[2].trim() : "";
                            String eTime     = d.length > 3 ? d[3].trim() : "";
                            String eLocation = d.length > 4 ? d[4].trim() : "";
                            String ePrice    = d.length > 5 ? d[5].trim() : "0";
                            String eDesc     = d.length > 6 ? d[6].trim() : "";
                            String eImg      = d.length > 7 ? d[7].trim() : "";

                            // FIX 6: guard against empty or literal "null" image string
                            if (eImg.isEmpty() || eImg.equals("null")) {
                                eImg = "default.jpg";
                            }

                            // JS-safe escaping so apostrophes in names don't break onclick
                            String eNameJs     = eName    .replace("\\", "\\\\").replace("'", "\\'");
                            String eLocationJs = eLocation.replace("\\", "\\\\").replace("'", "\\'");
                            String eDescJs     = eDesc    .replace("\\", "\\\\").replace("'", "\\'");
                %>
                <tr>
                    <!-- IMAGE -->
                    <td>
                        <img src="<%= request.getContextPath() %>/uploads/<%= eImg %>"
                             class="row-img"
                             onerror="this.src='<%= request.getContextPath() %>/img/demoImg.jpg'">
                    </td>

                    <!-- ID -->
                    <td class="fw-800 text-muted">#<%= eId %></td>

                    <!-- NAME -->
                    <td class="fw-700"><%= eName %></td>

                    <!-- LOCATION — d[4] (correct after time-column shift) -->
                    <td class="text-muted"><%= eLocation %></td>

                    <!-- PRICE — d[5] -->
                    <td class="fw-800 text-primary">$<%= ePrice %></td>

                    <!-- ACTIONS -->
                    <td class="text-end">
                        <div class="d-flex justify-content-end gap-2">

                            <!-- EDIT
                                 FIX 1: closing > was missing on the <button> tag —
                                 the onclick never fired and the icon was swallowed -->
                            <button class="btn btn-outline-secondary btn-sm rounded-3"
                                    onclick="openEdit(
                                            '<%= eId %>',
                                            '<%= eNameJs %>',
                                            '<%= eDate %>',
                                            '<%= eTime %>',
                                            '<%= eLocationJs %>',
                                            '<%= ePrice %>',
                                            '<%= eImg %>',
                                            '<%= eDescJs %>'
                                            )">
                                <i class="bi bi-pencil-square"></i>
                            </button>

                            <!-- DELETE -->
                            <form action="<%= request.getContextPath() %>/EventServlet"
                                  method="post"
                                  onsubmit="return confirm('Delete this event forever?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id"     value="<%= eId %>">
                                <button type="submit" class="btn btn-outline-danger btn-sm rounded-3">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </form>

                        </div>
                    </td>
                </tr>
                <%
                        } // end while
                        br.close();
                    } // end if
                %>
                </tbody>
            </table>
        </div>

    </main>
</div>


<!-- ===================== MODAL ===================== -->
<div class="modal fade" id="eventModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content glass-modal">
            <div class="modal-split-container">

                <!-- LEFT: image preview -->
                <div class="modal-visual-pane">
                    <div class="form-section-title">Visual Asset</div>
                    <div class="preview-circle">
                        <i class="bi bi-cloud-arrow-up fs-1 text-muted" id="placeholderIcon"></i>
                        <img id="modalPreviewImg"
                             src=""
                             alt="Preview"
                             style="display:none; width:100%; height:100%; object-fit:cover; border-radius:50%;">
                    </div>
                    <label for="imageInput" class="custom-file-btn">
                        <i class="bi bi-image me-1"></i> Change Photo
                    </label>
                </div>

                <!-- RIGHT: form -->
                <div class="modal-form-pane">
                    <form action="<%= request.getContextPath() %>/EventServlet"
                          method="post"
                          enctype="multipart/form-data">

                        <input type="hidden" name="action"        id="action"        value="create">
                        <input type="hidden" name="id"            id="id">
                        <input type="hidden" name="existingImage" id="existingImage">

                        <!-- Hidden file input triggered by the label on the left -->
                        <input type="file"
                               name="image"
                               id="imageInput"
                               accept="image/*"
                               style="display:none"
                               onchange="previewFile()">

                        <h5 class="fw-800 mb-4" id="formTitle">Event Registration</h5>

                        <div class="form-section-title">Primary Info</div>

                        <div class="input-group-modern">
                            <input type="text"
                                   name="name"
                                   id="name"
                                   class="form-control"
                                   placeholder="Event Name"
                                   required>
                        </div>

                        <div class="input-group-modern">
                <textarea name="description"
                          id="description"
                          class="form-control"
                          rows="2"
                          placeholder="Brief description..."></textarea>
                        </div>

                        <div class="form-section-title mt-4">Logistics &amp; Value</div>

                        <div class="row g-2">
                            <div class="col-6">
                                <div class="input-group-modern">
                                    <input type="date"
                                           name="date"
                                           id="date"
                                           class="form-control"
                                           required>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="input-group-modern">
                                    <input type="number"
                                           name="price"
                                           id="price"
                                           class="form-control"
                                           placeholder="Rate ($)"
                                           min="0"
                                           step="0.01"
                                           required>
                                </div>
                            </div>
                        </div>

                        <div class="input-group-modern">
                            <input type="time"
                                   name="time"
                                   id="time"
                                   class="form-control"
                                   required>
                        </div>

                        <div class="input-group-modern">
                            <input type="text"
                                   name="location"
                                   id="location"
                                   class="form-control"
                                   placeholder="Venue Location"
                                   required>
                        </div>

                        <div class="mt-4 d-flex gap-2">
                            <button type="submit" class="btn-add flex-grow-1">Commit Entry</button>
                            <button type="button"
                                    class="btn btn-light px-4"
                                    data-bs-dismiss="modal"
                                    style="border-radius:14px">
                                Discard
                            </button>
                        </div>

                    </form>
                </div>

            </div>
        </div>
    </div>
</div>
<!-- ================================================= -->


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const modal       = new bootstrap.Modal(document.getElementById('eventModal'));
    const previewImg  = document.getElementById('modalPreviewImg');
    const placeholder = document.getElementById('placeholderIcon');
    const BASE        = '<%= request.getContextPath() %>';

    function previewFile() {
        const file = document.getElementById('imageInput').files[0];
        if (!file) return;
        const reader = new FileReader();
        reader.onloadend = () => {
            previewImg.src            = reader.result;
            previewImg.style.display  = 'block';
            placeholder.style.display = 'none';
        };
        reader.readAsDataURL(file);
    }

    function openAdd() {
        document.getElementById('formTitle').innerText  = 'New Event Entry';
        document.getElementById('action').value         = 'create';
        document.getElementById('id').value             = '';
        document.getElementById('existingImage').value  = '';
        document.getElementById('name').value           = '';
        document.getElementById('description').value    = '';
        document.getElementById('date').value           = '';
        document.getElementById('time').value           = '';
        document.getElementById('location').value       = '';
        document.getElementById('price').value          = '';
        document.getElementById('imageInput').value     = '';
        previewImg.style.display  = 'none';
        previewImg.src            = '';
        placeholder.style.display = 'block';
        modal.show();
    }

    function openEdit(id, name, date, time, location, price, img, desc) {
        document.getElementById('formTitle').innerText  = 'Update Record #' + id;
        document.getElementById('action').value         = 'update';
        document.getElementById('id').value             = id;
        document.getElementById('existingImage').value  = img;
        document.getElementById('name').value           = name;
        document.getElementById('description').value    = desc;
        document.getElementById('date').value           = date;
        document.getElementById('time').value           = time;
        document.getElementById('location').value       = location;
        document.getElementById('price').value          = price;
        document.getElementById('imageInput').value     = '';

        if (img && img !== 'default.jpg') {
            previewImg.src            = BASE + '/uploads/' + img;
            previewImg.style.display  = 'block';
            placeholder.style.display = 'none';
        } else {
            previewImg.style.display  = 'none';
            placeholder.style.display = 'block';
        }

        modal.show();
    }
</script>
</body>
</html>



