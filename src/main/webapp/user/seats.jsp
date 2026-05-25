<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.model.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Tickets | EventPass</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/userview/bookingProcess.css">
</head>
<body>

<%
String eventId = request.getParameter("eventId");
if (eventId == null || eventId.trim().isEmpty()) {
    eventId = "Not Found";
}

User user = (User) session.getAttribute("user");
String userId = (user != null) ? String.valueOf(user.getId()) : "";
%>

<%
// ── Load event details ────────────────────────────────────────────────────────
String path = application.getRealPath("/") + "data/events.txt";
File file = new File(path);

String ename = "", elocation = "", eprice = "", ecategory = "", date = "", time = "";

if (file.exists()) {
    BufferedReader br = new BufferedReader(new FileReader(file));
    String line;
    while ((line = br.readLine()) != null) {
        String[] d = line.split(",");
        if (d.length < 7) continue;
        if (d[0].trim().equals(eventId)) {
            ename     = d[1].trim();
            date      = d[2].trim();
            time      = d[3].trim();
            elocation = d[4].trim();
            eprice    = d[5].trim();
            ecategory = d[6].trim();
            break;
        }
    }
    br.close();
}
%>

<%
// ── FIX: Load already-booked seats for this event from tickets.txt ────────────
// Ticket format: id,bookingId,userId,eventId,seatNo,price,status
// seatNo can be plain "A3" or bracket list "[A3,B3]"
// Only count tickets that are ACTIVE (not CANCELLED)

Set<String> bookedSeatsSet = new LinkedHashSet<>();

File ticketFile = new File(application.getRealPath("/") + "data/tickets.txt");
if (ticketFile.exists()) {
    BufferedReader tbr = new BufferedReader(new FileReader(ticketFile));
    String tline;
    while ((tline = tbr.readLine()) != null) {
        tline = tline.trim();
        if (tline.isEmpty()) continue;

        // Bracket-aware parse — same pattern used across the project
        String tEventId, tSeatNo, tStatus;

        int bOpen  = tline.indexOf('[');
        int bClose = tline.indexOf(']');

        if (bOpen != -1 && bClose > bOpen) {
            // prefix: "id,bookingId,userId,eventId,"
            String[] prefix = tline.substring(0, bOpen).split(",");
            String   seat   = tline.substring(bOpen, bClose + 1);   // "[A3,B3]"
            String[] suffix = tline.substring(bClose + 1).split(","); // ",price,status"

            if (prefix.length < 4 || suffix.length < 3) continue;
            tEventId = prefix[3].trim();
            tSeatNo  = seat.trim();
            tStatus  = suffix[2].trim();
        } else {
            String[] d = tline.split(",", 7);
            if (d.length < 7) continue;
            tEventId = d[3].trim();
            tSeatNo  = d[4].trim();
            tStatus  = d[6].trim();
        }

        // Only block seats for THIS event that are still ACTIVE
        if (!tEventId.equals(eventId)) continue;
        if ("CANCELLED".equalsIgnoreCase(tStatus)) continue;

        // Strip brackets and split multi-seat entries like [A3,B3]
        if (tSeatNo.startsWith("[") && tSeatNo.endsWith("]")) {
            tSeatNo = tSeatNo.substring(1, tSeatNo.length() - 1);
        }
        for (String seat : tSeatNo.split(",")) {
            String s = seat.trim().toUpperCase();
            if (!s.isEmpty()) bookedSeatsSet.add(s);
        }
    }
    tbr.close();
}

// Build a JSON array string for JavaScript
StringBuilder bookedJson = new StringBuilder("[");
boolean first = true;
for (String seat : bookedSeatsSet) {
    if (!first) bookedJson.append(",");
    bookedJson.append("'").append(seat).append("'");
    first = false;
}
bookedJson.append("]");
%>

    <div class="page">
        <!-- STEP INDICATORS -->
        <div class="step-pills no-print">
          <a href="dashboard.jsp" class="btn btn-outline">
              <i class="bi bi-arrow-left"></i> Back to Dashboard
          </a>
            <div class="pill active" id="pill-1"><div class="pill-num">1</div> Seats</div>
            <div class="pill" id="pill-2"><div class="pill-num">2</div> Payment</div>
            <div class="pill" id="pill-3"><div class="pill-num">3</div> Ticket</div>
        </div>

        <div class="grid" id="main-grid">
            <div id="main-content">

                <!-- STEP 1: SEAT SELECTION -->
                <div id="step-1" class="history-card">
                    <div class="screen-wrap">
                        <div class="screen-bar"></div>
                        <div class="screen-label">STAGE / SCREEN</div>
                    </div>
                    <div class="seat-scroll">
                        <div id="seat-grid"></div>
                    </div>
                    <div class="legend no-print">
                        <div class="legend-item"><span class="dot dot-avail"></span> Available</div>
                        <div class="legend-item"><span class="dot dot-sel"></span> Selected</div>
                        <div class="legend-item"><span class="dot dot-booked"></span> Booked</div>
                    </div>
                    <div class="text-center" style="text-align:center; margin-top: 2.5rem;">
                        <button class="btn btn-primary" id="to-checkout" disabled onclick="navigate(2)">
                            Continue to Checkout <i class="bi bi-arrow-right"></i>
                        </button>
                    </div>
                </div>

              <!-- STEP 2: SECURE PAYMENT -->
              <div id="step-2" class="history-card d-none">
                  <button class="btn btn-ghost" onclick="navigate(1)"
                      style="margin-bottom:1.5rem; padding-left: 0;">
                      <i class="bi bi-chevron-left"></i> Back to selection
                  </button>
                  <h2 style="margin-bottom: 2rem;">Secure Payment</h2>
                  <div class="payment-methods">
                      <div class="method-card" onclick="setPayment('card')" id="pay-card">
                          <i class="bi bi-credit-card-2-front"></i> Card
                      </div>
                      <div class="method-card" onclick="setPayment('cash')" id="pay-cash">
                          <i class="bi bi-cash-stack"></i> Cash
                      </div>
                      <div class="method-card" onclick="setPayment('online')" id="pay-online">
                          <i class="bi bi-globe"></i> Online
                      </div>
                  </div>
                  <div id="section-card" class="payment-section">
                      <label style="font-size: 0.8rem; font-weight: 600;">Name on Card</label>
                      <input type="text" class="input-field" placeholder="John Silva" id="card-name">
                      <div style="display:grid; grid-template-columns:2fr 1fr; gap:10px; margin-top:1rem;">
                          <input type="text" class="input-field" placeholder="Card Number" id="card-number" maxlength="16">
                          <input type="text" class="input-field" placeholder="CVV" id="card-cvv" maxlength="3">
                      </div>
                  </div>
                  <div id="section-cash" class="d-none payment-section">
                      <div style="padding:20px; background:rgba(245,158,11,0.1);
                                  border-radius:15px; border:1px dashed #f59e0b;">
                          <p style="font-weight:600; color:#b45309;">
                              <i class="bi bi-info-circle"></i> Pay at the counter
                          </p>
                          <small>Please present your ticket at the venue.</small>
                      </div>
                  </div>
                  <div id="section-online" class="d-none payment-section">
                      <label style="font-size: 0.8rem; font-weight: 600;">Online ID / Phone</label>
                      <input type="text" class="input-field"
                             placeholder="yourname@bank or 077XXXXXXX"
                             id="online-id">
                      <p style="font-size: 0.75rem; color:#64748b; margin-top:10px;">
                          Payment request will be sent to your mobile app.
                      </p>
                  </div>
                  <button class="btn btn-primary"
                          id="confirm-pay-btn"
                          style="width:100%; justify-content:center; margin-top:2.5rem;"
                          onclick="simulatePayment()">
                      Confirm & Generate Ticket
                  </button>
              </div>

                <!-- STEP 3: TICKET -->
                <div id="step-3" class="d-none">
                    <div class="history-card" style="text-align: center;">
                        <i class="bi bi-check-circle-fill" style="font-size: 3.5rem; color: #10b981;"></i>
                        <h2 style="margin: 1rem 0;">Booking Successful!</h2>
                        <p style="color:#64748b; margin-bottom: 2rem;">
                            Your ticket has been saved. Booking ID: <strong id="tkt-booking-id">—</strong>
                        </p>
                        <div id="printable-ticket" class="ticket" style="
                            background: white; border-radius: 20px; overflow: hidden;
                            box-shadow: 0 10px 30px rgba(0,0,0,0.12); max-width: 420px;
                            margin: 0 auto; text-align: left; border: 1px solid #e5e7eb;">
                            <div style="background: linear-gradient(135deg,#6366f1,#8b5cf6); color:white; padding:1.5rem 1.8rem;">
                                <div style="font-size:0.7rem; font-weight:700; opacity:0.8; letter-spacing:0.1em; margin-bottom:4px;">
                                    EVENTPASS · E-TICKET
                                </div>
                                <h4 style="margin:0; font-size:1.3rem; font-weight:800;" id="tkt-event-name">—</h4>
                                <small id="tkt-date" style="opacity:0.85;"></small>
                            </div>
                            <div style="padding: 1.5rem 1.8rem;">
                                <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem; margin-bottom:1rem;">
                                    <div>
                                        <small style="color:#64748b; font-weight:700; font-size:0.7rem; letter-spacing:0.05em;">SEATS</small>
                                        <div id="tkt-seats" style="font-weight:800; font-size:1rem; color:#0f172a;">—</div>
                                    </div>
                                    <div>
                                        <small style="color:#64748b; font-weight:700; font-size:0.7rem; letter-spacing:0.05em;">QUANTITY</small>
                                        <div id="tkt-qty" style="font-weight:800; font-size:1rem; color:#0f172a;">—</div>
                                    </div>
                                </div>
                                <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem; margin-bottom:1rem;">
                                    <div>
                                        <small style="color:#64748b; font-weight:700; font-size:0.7rem; letter-spacing:0.05em;">LOCATION</small>
                                        <div style="font-weight:700; font-size:0.9rem; color:#0f172a;">
                                            <%= (elocation != null && !elocation.isEmpty()) ? elocation : "—" %>
                                        </div>
                                    </div>
                                    <div>
                                        <small style="color:#64748b; font-weight:700; font-size:0.7rem; letter-spacing:0.05em;">PAYMENT</small>
                                        <div id="tkt-method" style="font-weight:700; font-size:0.9rem; color:#0f172a; text-transform:uppercase;">—</div>
                                    </div>
                                </div>
                                <div style="border-top: 2px dashed #e5e7eb; margin: 1rem 0;"></div>
                                <div style="display:flex; justify-content:space-between; align-items:center;">
                                    <div>
                                        <small style="color:#64748b; font-weight:700; font-size:0.7rem; letter-spacing:0.05em;">TOTAL PAID</small>
                                        <div id="tkt-price" style="color:#6366f1; font-weight:800; font-size:1.4rem;">LKR 0</div>
                                    </div>
                                    <div id="tkt-status" style="background:#d1fae5; color:#065f46; padding:4px 12px;
                                         border-radius:999px; font-size:0.75rem; font-weight:800;">GENERATED</div>
                                </div>
                            </div>
                            <div style="background:#f8fafc; border-top:1px solid #e5e7eb; padding:0.8rem 1.8rem;
                                        font-size:0.7rem; color:#94a3b8; font-weight:600;">
                                Booking ID: <span id="tkt-footer-id">—</span> &nbsp;·&nbsp;
                                Issued: <span id="tkt-issued"></span>
                            </div>
                        </div>
                        <div class="no-print" style="margin-top:2rem; display:flex; gap:1rem; justify-content:center; flex-wrap:wrap;">
                            <button class="btn btn-outline" onclick="window.print()"
                                    style="border:1px solid #ddd; background:#fff;">
                                <i class="bi bi-printer"></i> Print Ticket
                            </button>
                            <button class="btn btn-primary" onclick="location.href='dashboard.jsp'">
                                <i class="bi bi-house"></i> Dashboard
                            </button>
                            <button class="btn btn-outline" onclick="location.reload()"
                                    style="border:1px solid #ddd; background:#fff;">
                                <i class="bi bi-plus"></i> New Booking
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- SIDEBAR -->
            <div id="sidebar" class="no-print">
                <div class="history-card" style="padding:30px; position:sticky; top:100px;">
                    <h5 style="margin-bottom:1.5rem; font-weight:800;">Order Summary</h5>

                    <div style="background: linear-gradient(135deg, #ffffff, #f8fafc);
                               border: 1px solid #e5e7eb; border-radius: 18px; padding: 18px;
                               box-shadow: 0 10px 25px rgba(0,0,0,0.06); margin-bottom: 20px;">
                        <h2 style="font-size: 1.4rem; font-weight: 800; color: #0f172a;
                                   margin-bottom: 8px; letter-spacing: -0.01em;">
                            <%= (ename != null && !ename.isEmpty()) ? ename : "Event Name" %>
                        </h2>
                        <p style="margin: 6px 0; color: #64748b; font-size: 0.95rem; font-weight: 500;">
                            Location: <span style="color:#111827; font-weight:600;">
                                <%= (elocation != null && !elocation.isEmpty()) ? elocation : "-" %>
                            </span>
                        </p>
                        <p style="margin: 6px 0; color: #64748b; font-size: 0.95rem; font-weight: 500;">
                            Price: <span style="color:#10b981; font-weight:700;">
                                LKR <%= (eprice != null && !eprice.isEmpty()) ? eprice : "0" %>
                            </span>
                        </p>
                        <p style="margin: 6px 0 0; color: #64748b; font-size: 0.95rem; font-weight: 500;">
                            <span style="background:#e0e7ff; color:#4f46e5; padding:2px 8px;
                                         border-radius:999px; font-size:0.8rem; font-weight:600;">
                                <%= (ecategory != null && !ecategory.isEmpty()) ? ecategory : "-" %>
                            </span>
                        </p>
                        <div style="display:flex; gap:12px; margin-top:10px;">
                            <div style="flex:1; background:#f8fafc; border:1px solid #e5e7eb;
                                        border-radius:14px; padding:12px; text-align:center;">
                                <div style="font-size:0.75rem; color:#64748b; font-weight:700;">DATE</div>
                                <div style="font-size:1rem; font-weight:800; color:#0f172a;">
                                    <%
                                        String displayDate = "N/A";
                                        if (date != null && date.contains("-")) {
                                            String[] parts = date.split("-");
                                            String[] months = {"Jan","Feb","Mar","Apr","May","Jun",
                                                               "Jul","Aug","Sep","Oct","Nov","Dec"};
                                            int monthIndex = Integer.parseInt(parts[1]) - 1;
                                            displayDate = months[monthIndex] + " " + parts[2];
                                        }
                                    %>
                                    <%= displayDate %>
                                </div>
                            </div>
                            <div style="flex:1; background:linear-gradient(135deg, #e0e7ff, #f8fafc);
                                        border:1px solid #e5e7eb; border-radius:14px; padding:12px; text-align:center;">
                                <div style="font-size:0.75rem; color:#64748b; font-weight:700;">TIME</div>
                                <div style="font-size:1rem; font-weight:800; color:#4f46e5;">
                                    <%= time != null ? time : "N/A" %>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div id="sum-pills" style="display:flex; flex-wrap:wrap; gap:6px; margin-bottom:2rem;">
                        <span style="color:#94a3b8; font-size:0.85rem;">No seats selected</span>
                    </div>

                    <!-- PROMO -->
                    <div style="margin-bottom:1.5rem;">
                        <label style="font-size:0.7rem; font-weight:800; color:#64748b;">PROMO CODE</label>
                        <div style="display:flex; gap:8px; margin-top:5px;">
                            <input type="text" id="coupon-input" class="input-field"
                                   placeholder="SAVE10" style="margin-top:0; height:38px;">
                            <button class="btn btn-primary" onclick="applyCoupon()"
                                    style="padding:0 15px; border-radius:12px; height:38px;">Apply</button>
                        </div>
                        <div id="coupon-msg" style="font-size:0.7rem; margin-top:5px; font-weight:600;"></div>
                    </div>

                    <hr style="opacity:0.1; margin:1.5rem 0;">

                    <div style="display:flex; justify-content:space-between; margin-bottom:1rem;
                                font-size:0.9rem; padding:6px 0;">
                        <span style="color:#64748b;">Selected Method</span>
                        <span id="selected-method-value" style="color:#6366f1; font-weight:700;">NOT SELECTED</span>
                    </div>
                    <div style="display:flex; justify-content:space-between; margin-bottom:0.5rem; font-size:0.9rem;">
                        <span style="color:#64748b;">Subtotal</span>
                        <span id="sum-subtotal">LKR 0</span>
                    </div>
                    <div id="discount-row" class="d-none"
                         style="display:flex; justify-content:space-between; margin-bottom:0.5rem; font-size:0.9rem; color:#10b981;">
                        <span>Discount</span>
                        <span id="sum-discount">- LKR 0</span>
                    </div>
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-top:1rem;">
                        <span style="font-weight:700;">Total</span>
                        <span id="sum-total" style="color:#6366f1; font-size:1.3rem; font-weight:800;">LKR 0</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

<script>
const COUPONS = [];
<%
String couponPath = application.getRealPath("/") + "data/coupons.txt";
File couponFile = new File(couponPath);
if (couponFile.exists()) {
    BufferedReader cbr = new BufferedReader(new FileReader(couponFile));
    String cline;
    while ((cline = cbr.readLine()) != null) {
        if (cline.trim().isEmpty()) continue;
        String[] data = cline.split(",");
        if (data.length < 4) continue;
        String cid = data[0].trim(), code = data[1].trim(),
               discount = data[2].trim(), cstatus = data[3].trim();
        if ("true".equalsIgnoreCase(cstatus) || "active".equalsIgnoreCase(cstatus)) {
%>
COUPONS.push({ id: "<%= cid %>", code: "<%= code %>", discount: <%= discount %> });
<%      }
    }
    cbr.close();
}
%>
</script>

<script>
    const ROWS = [{id:'A', p:4000}, {id:'B', p:3000}, {id:'C', p:2000}, {id:'D', p:1000}];

    // FIX: loaded from tickets.txt filtered by eventId and ACTIVE status
    const BOOKED = <%= bookedJson.toString() %>;

    let selected = [], totalPrice = 0, discountPercent = 0, currentMethod = 'card';

    // Build seat grid
    const grid = document.getElementById('seat-grid');
    ROWS.forEach(row => {
        const rowDiv = document.createElement('div');
        rowDiv.className = 'seat-row';
        rowDiv.innerHTML = `<div class="row-label">${row.id}</div><div class="seats"></div>`;
        const seatsCont = rowDiv.querySelector('.seats');
        for (let i = 1; i <= 10; i++) {
            const id = row.id + i;
            const s  = document.createElement('div');
            s.className = 'seat' + (i === 6 ? ' aisle' : '') + (BOOKED.includes(id) ? ' booked' : '');
            s.textContent = i;

            // FIX: booked seats get a tooltip so users know WHY they can't click
            if (BOOKED.includes(id)) {
                s.title = 'Seat ' + id + ' is already booked';
            } else {
                s.onclick = () => {
                    if (selected.includes(id)) {
                        selected = selected.filter(x => x !== id);
                        totalPrice -= row.p;
                        s.classList.remove('selected');
                    } else {
                        selected.push(id);
                        totalPrice += row.p;
                        s.classList.add('selected');
                    }
                    updateUI();
                };
            }
            seatsCont.appendChild(s);
        }
        grid.appendChild(rowDiv);
    });

    function setPayment(method) {
        currentMethod = method;
        document.querySelectorAll('.method-card').forEach(c => c.classList.remove('active'));
        document.getElementById('pay-' + method).classList.add('active');
        document.getElementById('section-card').classList.add('d-none');
        document.getElementById('section-cash').classList.add('d-none');
        document.getElementById('section-online').classList.add('d-none');
        document.getElementById('section-' + method).classList.remove('d-none');
        document.getElementById("selected-method-value").innerText = method.toUpperCase();
    }

    function applyCoupon() {
        const code   = document.getElementById('coupon-input').value.trim().toUpperCase();
        const msg    = document.getElementById('coupon-msg');
        const coupon = COUPONS.find(c => c.code.toUpperCase() === code);
        if (coupon) {
            discountPercent = coupon.discount / 100;
            msg.textContent = coupon.discount + "% Discount Applied!";
            msg.style.color = "#10b981";
            document.getElementById('discount-row').classList.remove('d-none');
        } else {
            discountPercent = 0;
            msg.textContent = "Invalid Code";
            msg.style.color = "#ef4444";
            document.getElementById('discount-row').classList.add('d-none');
        }
        updateUI();
    }

    function updateUI() {
        const disc  = totalPrice * discountPercent;
        const final = totalPrice - disc;
        document.getElementById('sum-pills').innerHTML =
            selected.length
                ? selected.map(s =>
                    `<span style="background:#6366f1;color:white;padding:2px 8px;border-radius:5px;font-size:11px;">${s}</span>`
                  ).join('')
                : '<span style="color:#94a3b8;font-size:0.85rem;">No seats selected</span>';
        document.getElementById('sum-subtotal').textContent = 'LKR ' + totalPrice.toLocaleString();
        document.getElementById('sum-discount').textContent = '- LKR ' + disc.toLocaleString();
        document.getElementById('sum-total').textContent    = 'LKR ' + final.toLocaleString();
        document.getElementById('to-checkout').disabled     = !selected.length;
    }

    function navigate(step) {
        document.querySelectorAll('[id^="step-"]').forEach(s => s.classList.add('d-none'));
        document.querySelectorAll('.pill').forEach(p => p.classList.remove('active'));
        document.getElementById('step-' + step).classList.remove('d-none');
        document.getElementById('pill-' + step).classList.add('active');
        if (step === 3) {
            document.getElementById('sidebar').classList.add('d-none');
            document.getElementById('main-grid').classList.add('full');
            document.getElementById('tkt-date').textContent = new Date().toLocaleString();
        }
    }

    function simulatePayment() {
        if (!currentMethod) { alert("Please select a payment method."); return; }
        if (currentMethod === 'card' &&
            document.getElementById('card-name').value.trim() === '') {
            alert("Please enter the cardholder name.");
            return;
        }
        if (selected.length === 0) { alert("Please select at least one seat."); return; }

        const btn = document.getElementById('confirm-pay-btn');
        btn.innerHTML = '<i class="bi bi-arrow-repeat spin"></i> Processing...';
        btn.disabled  = true;

        const disc       = totalPrice * discountPercent;
        const finalTotal = totalPrice - disc;
        const now        = new Date();
        const bookDate   = now.toISOString().split('T')[0];
        const bookTime   = String(now.getHours()).padStart(2,'0') + ':' +
                           String(now.getMinutes()).padStart(2,'0');

        const formData = new FormData();
        formData.append('action',        'create');
        formData.append('eventId',       '<%= eventId %>');
        formData.append('userId',        '<%= userId %>');
        formData.append('selectedSeats', selected.join(','));
        formData.append('quantity',      selected.length);
        formData.append('totalPrice',    finalTotal.toFixed(2));
        formData.append('location',      '<%= elocation %>');
        formData.append('eventName',     '<%= ename.replace("'", "\\'") %>');
        formData.append('paymentMethod', currentMethod.toUpperCase());
        formData.append('date',          bookDate);
        formData.append('time',          bookTime);

        fetch('<%= request.getContextPath() %>/BookingProcessServlet', {
            method: 'POST',
            body: formData
        })
        .then(res => {
            if (!res.ok) throw new Error('Server error: ' + res.status);
            return res.text();
        })
        .then(bookingId => {
            const issued = now.toLocaleString();
            document.getElementById('tkt-booking-id').textContent  = bookingId;
            document.getElementById('tkt-footer-id').textContent   = bookingId;
            document.getElementById('tkt-event-name').textContent  = '<%= ename.replace("'", "\\'") %>';
            document.getElementById('tkt-date').textContent        = issued;
            document.getElementById('tkt-issued').textContent      = issued;
            document.getElementById('tkt-seats').textContent       = selected.join(', ');
            document.getElementById('tkt-qty').textContent         = selected.length + ' Ticket(s)';
            document.getElementById('tkt-method').textContent      = currentMethod.toUpperCase();
            document.getElementById('tkt-price').textContent       = 'LKR ' + finalTotal.toLocaleString();
            navigate(3);
            btn.innerHTML = 'Confirm & Generate Ticket';
            btn.disabled  = false;
        })
        .catch(err => {
            console.error('Booking failed:', err);
            alert('Booking failed. Please try again.');
            btn.innerHTML = 'Confirm & Generate Ticket';
            btn.disabled  = false;
        });
    }
</script>

</body>
</html>
