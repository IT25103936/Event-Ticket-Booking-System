<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Discover Events | EventPass</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/userview/eventView.css">

<style>
/* ── Review Modal Container ── */
.review-modal .modal-content {
    background: rgba(255,255,255,0.85);
    backdrop-filter: blur(20px) saturate(180%);
    -webkit-backdrop-filter: blur(20px) saturate(180%);
    border: 1px solid rgba(255,255,255,0.4);
    border-radius: 28px;
    overflow: hidden;
    box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25);
}

/* ── Header ── */
.rm-header {
    background: linear-gradient(135deg,#6366f1,#a855f7);
    padding: 1.5rem;
    display: flex;
    align-items: center;
    gap: 14px;
    color: white;
}
.rm-avatar {
    width:48px; height:48px;
    background: rgba(255,255,255,0.2);
    backdrop-filter: blur(5px);
    border: 1px solid rgba(255,255,255,0.3);
    border-radius: 14px;
    display: flex; align-items: center; justify-content: center;
    font-size: 1.4rem;
}
.rm-title  { font-size:1.15rem; font-weight:800; margin:0; line-height:1.2; }
.rm-subtitle { font-size:0.8rem; margin:4px 0 0; opacity:0.9; font-weight:500; }
.rm-close {
    background: rgba(0,0,0,0.2); border:none; color:white;
    width:32px; height:32px; border-radius:10px;
    display:flex; align-items:center; justify-content:center;
    transition: all 0.2s;
}
.rm-close:hover { background:rgba(0,0,0,0.4); transform:rotate(90deg); }

/* ── Body ── */
.rm-body { display:flex; flex-direction:row; min-height:450px; }
@media(max-width:768px){
    .rm-body{ flex-direction:column; }
    .rm-left{ border-right:none !important; border-bottom:1px solid rgba(0,0,0,0.05); }
}

/* ── Left (feed) ── */
.rm-left {
    flex:1.2; padding:1.5rem;
    max-height:500px; overflow-y:auto;
    border-right:1px solid rgba(0,0,0,0.05);
    background: rgba(255,255,255,0.3);
}
.rm-section-label {
    font-size:0.7rem; font-weight:800;
    text-transform:uppercase; letter-spacing:0.1em;
    color:#6366f1; margin-bottom:1rem;
}
.rm-avg-badge {
    display:inline-flex; align-items:center; gap:8px;
    background:white; padding:6px 14px; border-radius:12px;
    font-weight:700; font-size:0.85rem; color:#1e293b;
    margin-bottom:1.5rem;
    box-shadow:0 4px 12px rgba(0,0,0,0.05);
}
.rm-avg-badge i { color:#fbbf24; }

/* ── Review card ── */
.rm-review-card {
    background:white; padding:1rem; border-radius:16px;
    margin-bottom:12px; border:1px solid rgba(0,0,0,0.03);
    transition: transform 0.2s;
    position: relative;
}
.rm-review-card:hover { transform:translateY(-2px); }
.rm-comment { font-size:0.85rem; color:#475569; margin-top:8px; line-height:1.5; }

/* ── Edit / Delete action buttons on card ── */
.rm-card-actions {
    position: absolute;
    top: 10px; right: 10px;
    display: flex;
    gap: 6px;
    opacity: 0;
    transition: opacity 0.2s;
}
.rm-review-card:hover .rm-card-actions { opacity: 1; }

.rm-card-btn {
    width: 28px; height: 28px;
    border: none; border-radius: 8px;
    display: flex; align-items: center; justify-content: center;
    font-size: 0.75rem; cursor: pointer;
    transition: all 0.2s;
}
.rm-card-btn.edit   { background:#eef2ff; color:#6366f1; }
.rm-card-btn.delete { background:#fef2f2; color:#ef4444; }
.rm-card-btn:hover  { transform: scale(1.15); }

/* ── Right (form) ── */
.rm-right { flex:0.8; padding:1.5rem; background:white; }

.rm-field-label {
    display:block; font-size:0.85rem; font-weight:700;
    color:#1e293b; margin-bottom:8px;
}

/* ── Star picker ── */
.rm-star-picker {
    display:flex; flex-direction:row-reverse;
    justify-content:flex-end; gap:5px; margin-bottom:1.5rem;
}
.rm-star-picker input { display:none; }
.rm-star-picker label { font-size:1.8rem; color:#e2e8f0; cursor:pointer; transition:color 0.2s; }
.rm-star-picker input:checked ~ label,
.rm-star-picker label:hover,
.rm-star-picker label:hover ~ label { color:#fbbf24; }

/* ── Textarea & submit ── */
.rm-textarea {
    width:100%; border:2px solid #f1f5f9; border-radius:14px;
    padding:12px; font-size:0.9rem; resize:none;
    transition: all 0.2s; background:#f8fafc;
}
.rm-textarea:focus {
    outline:none; border-color:#6366f1; background:white;
    box-shadow:0 0 0 4px rgba(99,102,241,0.1);
}
.rm-submit {
    width:100%; margin-top:1rem; padding:12px;
    background:linear-gradient(135deg,#6366f1,#a855f7);
    color:white; border:none; border-radius:14px; font-weight:700;
    display:flex; align-items:center; justify-content:center; gap:8px;
    box-shadow:0 10px 20px rgba(99,102,241,0.2); transition:all 0.3s;
}
.rm-submit:hover { transform:translateY(-2px); box-shadow:0 15px 25px rgba(99,102,241,0.3); }

/* ── Form mode toggle ── */
.rm-form-title { font-size:0.95rem; font-weight:800; color:#1e293b; margin-bottom:1rem; }
.rm-cancel-edit {
    width:100%; margin-top:8px; padding:10px;
    background:#f1f5f9; color:#64748b; border:none;
    border-radius:14px; font-weight:700; font-size:0.85rem;
    display:none; cursor:pointer;
}
.rm-cancel-edit:hover { background:#e2e8f0; }
</style>
</head>

<body>

<%@ include file="navbar.jsp" %>
<%
    int sessionUserId = 0;

    if (session != null && session.getAttribute("user") != null) {
        User u = (User) session.getAttribute("user");
        sessionUserId = u.getId(); // INT
    }

    boolean loggedIn = sessionUserId > 0;
%>
<div class="main-content">
<div class="container">

    <div class="mb-5 text-center">
        <h1 style="
            font-weight:500; font-size:1.2rem; color:#ffffff;
            display:inline-block; padding:9px 28px; border-radius:999px;
            background: linear-gradient(135deg, rgba(37,99,235,0.7), rgba(30,58,138,0.4));">
            Featured Events
        </h1>
        <p style="color:#9ca3af; font-size:1.05rem; font-weight:600; margin-bottom:0;">
            Handpicked experiences just for you.
        </p>
    </div>

    <div class="row g-4 justify-content-center">

    <%
        String eventPath = application.getRealPath("/") + "data/events.txt";
        File eventFile   = new File(eventPath);

        String[] months = {
            "Jan","Feb","Mar","Apr","May","Jun",
            "Jul","Aug","Sep","Oct","Nov","Dec"
        };

        if (eventFile.exists()) {
            BufferedReader br = new BufferedReader(new FileReader(eventFile));
            String line;

            while ((line = br.readLine()) != null) {

                if (line.trim().isEmpty()) continue;

                String[] d = line.split(",");
                if (d.length < 6) continue;

                String eventId   = d[0].trim();
                String name      = d[1].trim();
                String time      = d[3].trim();
                String location  = d[4].trim();
                String price     = d[5].trim();

                String img     = (d.length > 7) ? d[7].trim() : "default.jpg";
                String reviews = (d.length > 8) ? d[8].trim() : "0";

                String month = "Jan";
                String day   = "01";
                try {
                    if (d.length > 2 && d[2].contains("-")) {
                        String[] dp = d[2].split("-");
                        month = months[Integer.parseInt(dp[1]) - 1];
                        day   = dp[2];
                    }
                } catch (Exception ignored) {}
    %>

    <div class="col-xl-3 col-lg-4 col-md-6">
        <div class="event-card">

            <div class="img-stack">
                <img src="<%= request.getContextPath() %>/uploads/<%= img %>"
                     class="row-img"
                     onerror="this.src='<%= request.getContextPath() %>/img/demoImg.jpg'">

                <div class="category-pill">Time <%= time %></div>

                <div class="calendar-box">
                    <span class="mm"><%= month %></span>
                    <span class="dd"><%= day %></span>
                </div>

                <div class="price-tag">$<%= price %></div>
            </div>

            <div class="card-content">
                <h4 class="mb-1 text-truncate" style="font-size:18px; font-weight:800;">
                    <%= name %>
                </h4>

                <div class="mb-2">
                    <span class="rating-stars">
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-half"></i>
                    </span>

                    <a href="#"
                       class="review-link ms-1 card-stars-container"
                       data-bs-toggle="modal"
                       data-bs-target="#reviewModal"
                       data-event="<%= name %>"
                       data-id="<%= eventId %>">
                        <span id="stars-<%= eventId %>"></span>
                        <span class="rev-count" id="count-<%= eventId %>">reviews</span>
                    </a>
                </div>

                <div class="location-info">
                    <i class="bi bi-geo-alt-fill text-primary"></i>
                    <%= location %>
                </div>

                <%
                    String seatUrl = request.getContextPath() + "/user/seats.jsp?eventId=" + eventId;
                %>
                <a href="<%= seatUrl %>" class="btn-modern mt-auto w-100 text-center">
                    Reserve Seat
                </a>
            </div>

        </div>
    </div>

    <%
            }
            br.close();
        }
    %>

    </div>
</div>
</div>


<!-- ════════════════════════════════════════
     REVIEW MODAL
     ════════════════════════════════════════ -->
<div class="modal fade review-modal" id="reviewModal" tabindex="-1">
<div class="modal-dialog modal-dialog-centered" style="max-width:680px;">
<div class="modal-content">

    <!-- Header -->
    <div class="rm-header">
        <div class="rm-avatar">
            <i class="bi bi-ticket-perforated-fill"></i>
        </div>
        <div style="flex:1;">
            <p class="rm-title"    id="rmTitleLabel">Guest Reviews</p>
            <p class="rm-subtitle" id="modalEventMeta">Event ID</p>
        </div>
        <button class="rm-close" data-bs-dismiss="modal">
            <i class="bi bi-x-lg"></i>
        </button>
    </div>

    <div class="rm-body">

        <!-- ── LEFT: review feed ── -->
        <div class="rm-left">
            <p class="rm-section-label">Guest reviews</p>

            <div class="rm-avg-badge">
                <i class="bi bi-star-fill"></i>
                <span id="rmAvgLabel">— reviews</span>
            </div>

            <div id="rmReviewsList">

            <%
                // ── load all reviews from file into hidden cards ──
                String ratingPath = application.getRealPath("/") + "data/ratings.txt";
                File ratingFile   = new File(ratingPath);

                if (ratingFile.exists()) {
                    BufferedReader rbr = new BufferedReader(new FileReader(ratingFile));
                    String rline;

                    while ((rline = rbr.readLine()) != null) {

                        if (rline.trim().isEmpty()) continue;

                        String[] r = rline.split(",");
                        if (r.length < 6) continue;

                        // Format: id , userId , eventId , rating , comment , date
                        //          0       1         2        3         4       5
                        String rId       = r[0].trim();
                        String rUserId   = r[1].trim();
                        String rEventId  = r[2].trim();
                        String rRating   = r[3].trim();
                        String rComment  = r[4].trim();
                        String rDate     = r[5].trim();

                        // only show edit/delete buttons to the review owner
                       boolean isOwner = loggedIn && Integer.parseInt(rUserId) == sessionUserId;
            %>

            <div class="rm-review-card"
                 data-event-id="<%= rEventId %>"
                 data-score="<%= rRating %>">

                <%-- edit / delete buttons — visible only on hover and only for owner --%>
                <% if (isOwner) { %>
                <div class="rm-card-actions">

                    <%-- EDIT: fills the right-side form with this review's data --%>
                    <button class="rm-card-btn edit"
                            title="Edit"
                            onclick="startEdit(
                                '<%= rId %>',
                                '<%= rUserId %>',
                                '<%= rEventId %>',
                                '<%= rRating %>',
                                '<%= rComment.replace("'", "\\'") %>',
                                '<%= rDate %>'
                            )">
                        <i class="bi bi-pencil-fill"></i>
                    </button>

                    <%-- DELETE: submits a form to RatingServlet?action=delete --%>
                    <form method="post"
                          action="<%= request.getContextPath() %>/RatingServlet"
                          style="margin:0;"
                          onsubmit="return confirm('Delete this review?');">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id"     value="<%= rId %>">
                        <button type="submit" class="rm-card-btn delete" title="Delete">
                            <i class="bi bi-trash-fill"></i>
                        </button>
                    </form>

                </div>
                <% } %>

                <div class="d-flex justify-content-between align-items-center pe-5">
                    <span style="font-size:0.8rem; font-weight:700; color:#1e293b;">
                        User #<%= rUserId %>
                    </span>
                    <div>
                        <span style="color:#fbbf24;">⭐</span>
                        <strong><%= rRating %></strong>
                        <span style="font-size:0.7rem; color:#94a3b8; margin-left:6px;">
                            <%= rDate %>
                        </span>
                    </div>
                </div>

                <p class="rm-comment"><%= rComment %></p>
            </div>

            <%
                    }
                    rbr.close();
                }
            %>

            </div><!-- end rmReviewsList -->
        </div><!-- end rm-left -->

        <!-- ── RIGHT: create / edit form ── -->
        <div class="rm-right">

            <p class="rm-form-title" id="rmFormTitle">
                <i class="bi bi-chat-left-text-fill me-1" style="color:#6366f1;"></i>
                Write a Review
            </p>

            <form id="reviewForm" method="post"
                  action="<%= request.getContextPath() %>/RatingServlet">

                <%-- hidden fields; action switches between "create" and "update" --%>
                <input type="hidden" name="action"  id="formAction"  value="create">
                <input type="hidden" name="id"      id="formId"      value="">
                <input type="hidden" name="userId"  id="formUserId"  value="<%= sessionUserId %>">
                <input type="hidden" name="eventId" id="formEventId" value="">
                <input type="hidden" name="date"    id="formDate"    value="">

                <label class="rm-field-label">Rating</label>

                <div class="rm-star-picker">
                    <input type="radio" name="rating" value="5" id="r5" required><label for="r5">★</label>
                    <input type="radio" name="rating" value="4" id="r4"><label for="r4">★</label>
                    <input type="radio" name="rating" value="3" id="r3"><label for="r3">★</label>
                    <input type="radio" name="rating" value="2" id="r2"><label for="r2">★</label>
                    <input type="radio" name="rating" value="1" id="r1"><label for="r1">★</label>
                </div>

                <label class="rm-field-label">Comment</label>
                <textarea class="rm-textarea" name="comment" id="formComment"
                          rows="5" required></textarea>

                <button type="submit" class="rm-submit" id="rmSubmitBtn">
                    <i class="bi bi-send-fill"></i> Post review
                </button>

                <button type="button" class="rm-cancel-edit" id="rmCancelBtn"
                        onclick="cancelEdit()">
                    Cancel edit
                </button>

            </form>

        </div><!-- end rm-right -->

    </div><!-- end rm-body -->
</div>
</div>
</div><!-- end modal -->


<%@ include file="footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
document.addEventListener("DOMContentLoaded", function () {

    // ── 1. Compute per-event average from hidden cards ────────
    const cards = document.querySelectorAll('.rm-review-card');
    const stats = {};

    cards.forEach(c => {
        const id    = c.dataset.eventId;
        const score = parseFloat(c.dataset.score || 0);
        if (!stats[id]) stats[id] = { sum: 0, count: 0 };
        stats[id].sum   += score;
        stats[id].count += 1;
    });

    Object.keys(stats).forEach(id => {
        const avg   = (stats[id].sum / stats[id].count).toFixed(1);
        const count = document.getElementById(`count-${id}`);
        if (count) count.innerText = `(${avg} · ${stats[id].count})`;

        const link = document.querySelector(`.review-link[data-id="${id}"]`);
        if (link) link.dataset.avg = avg;
    });

    // ── 2. When the modal opens, filter cards to the clicked event ──
    const modal = document.getElementById('reviewModal');

    modal.addEventListener('show.bs.modal', function (e) {
        const btn = e.relatedTarget;
        if (!btn) return;

        const eid  = btn.dataset.id;
        const name = btn.dataset.event;

        document.getElementById('rmTitleLabel').innerText   = name;
        document.getElementById('modalEventMeta').innerText = "Event ID: " + eid;
        document.getElementById('formEventId').value        = eid;

        document.getElementById('rmAvgLabel').innerText =
            (btn.dataset.avg || "0.0") + " Average Rating";

        // show only this event's reviews
        cards.forEach(c => {
            c.style.display = (c.dataset.eventId === eid) ? 'block' : 'none';
        });

        // reset form to "create" mode when modal opens
        cancelEdit();
    });
});

// ── 3. Switch form to EDIT mode ───────────────────────────────
function startEdit(id, userId, eventId, rating, comment, date) {

    document.getElementById('rmFormTitle').innerHTML =
        '<i class="bi bi-pencil-fill me-1" style="color:#6366f1;"></i> Edit Review';

    document.getElementById('formAction').value  = 'update';
    document.getElementById('formId').value      = id;
    document.getElementById('formUserId').value  = userId;
    document.getElementById('formEventId').value = eventId;
    document.getElementById('formDate').value    = date;
    document.getElementById('formComment').value = comment;

    // pre-select the star
    const starInput = document.getElementById('r' + rating);
    if (starInput) starInput.checked = true;

    // show cancel button, change submit label
    document.getElementById('rmSubmitBtn').innerHTML =
        '<i class="bi bi-check-circle-fill"></i> Update Review';
    document.getElementById('rmCancelBtn').style.display = 'block';

    // scroll the form into view on mobile
    document.querySelector('.rm-right').scrollIntoView({ behavior: 'smooth', block: 'start' });
}

// ── 4. Cancel edit → back to CREATE mode ─────────────────────
function cancelEdit() {

    document.getElementById('rmFormTitle').innerHTML =
        '<i class="bi bi-chat-left-text-fill me-1" style="color:#6366f1;"></i> Write a Review';

    document.getElementById('formAction').value  = 'create';
    document.getElementById('formId').value      = '';
    document.getElementById('formDate').value    = '';
    document.getElementById('formComment').value = '';

    // clear star selection
    document.querySelectorAll('.rm-star-picker input').forEach(i => i.checked = false);

    document.getElementById('rmSubmitBtn').innerHTML =
        '<i class="bi bi-send-fill"></i> Post review';
    document.getElementById('rmCancelBtn').style.display = 'none';
}
</script>

</body>
</html>
