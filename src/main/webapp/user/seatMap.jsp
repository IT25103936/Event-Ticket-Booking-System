<%@ page import="com.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>System Guide | EventPass</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/eventTicketBookingSystem/css/userview/seatMap.css">


</head>

<body>

<%@ include file="navbar.jsp" %>

<div class="main-content">
    <div class="container">

        <div class="instr-hero mt-5">
            <h1>How to Select Your Seats</h1>
            <p>Follow our unified process to clear your booking orders and reserve perfect viewpoints inside the auditorium venue maps.</p>
        </div>

        <div class="row g-4 mb-5">
            <div class="col-xl-3 col-md-6">
                <div class="instruction-card">
                    <span class="card-number">01</span>
                    <span class="step-label">Phase One</span>
                    <div class="icon-wrapper icon-purple">
                        <i class="bi bi-shield-lock-fill"></i>
                    </div>
                    <h4>Onboarding</h4>
                    <p>Securely register your user profile account to begin tracking session reservations.</p>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="instruction-card">
                    <span class="card-number">02</span>
                    <span class="step-label">Phase Two</span>
                    <div class="icon-wrapper icon-teal">
                        <i class="bi bi-compass-fill"></i>
                    </div>
                    <h4>Discovery</h4>
                    <p>Explore full event catalog lists filterable by locations, times, and entry value costs.</p>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="instruction-card active-phase">
                    <span class="card-number">03</span>
                    <span class="step-label">Phase Three</span>
                    <div class="icon-wrapper icon-blue">
                        <i class="bi bi-grid-fill"></i>
                    </div>
                    <h4>Seat Choice</h4>
                    <p>Interact directly with layout panels to choose exactly where you wish to sit.</p>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="instruction-card">
                    <span class="card-number">04</span>
                    <span class="step-label">Phase Four</span>
                    <div class="icon-wrapper icon-amber">
                        <i class="bi bi-lightning-charge-fill"></i>
                    </div>
                    <h4>Confirmation</h4>
                    <p>Execute financial clearing pathways to download processed barcode passes.</p>
                </div>
            </div>
        </div>

        <span class="section-title">Interactive Seat Map Demo — Try it yourself</span>
        <div class="demo-panel">
            <div class="screen-bar"></div>
            <div class="screen-label">Stage / Screen Direction</div>

            <div class="seat-demo" id="seatGrid"></div>

            <div class="legend">
                <div class="legend-item"><span class="dot dot-avail"></span> Available Unit</div>
                <div class="legend-item"><span class="dot dot-sel"></span> Chosen Unit</div>
                <div class="legend-item"><span class="dot dot-booked"></span> Reserved Unit</div>
            </div>

            <div class="summary-bar">
                <div class="d-flex gap-3 flex-wrap">
                    <span class="summary-pill">Selected Rows: <span id="selList">—</span></span>
                    <span class="summary-pill">Calculated Sum: <span id="selTotal">LKR 0</span></span>
                </div>
                <a href="events.jsp" class="btn-checkout" id="checkoutBtn" onclick="return selected.length > 0;">
                    Continue to Checkout <i class="bi bi-arrow-right ms-1"></i>
                </a>
            </div>
        </div>

        <span class="section-title">Tips for Choosing Seats</span>
        <div class="row g-3 mb-4">
            <div class="col-md-3 col-sm-6">
                <div class="tip-card">
                    <div class="tip-icon icon-purple"><i class="bi bi-hand-index-thumb-fill"></i></div>
                    <div>
                        <h5>Toggle Selection</h5>
                        <p>Click any clear coordinate element block to register it, or tap again to clear choices.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="tip-card">
                    <div class="tip-icon icon-teal"><i class="bi bi-people-fill"></i></div>
                    <div>
                        <h5>Group Isolation</h5>
                        <p>Purchase multiple adjoining matrix units concurrently to maintain group seating arrangements.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="tip-card">
                    <div class="tip-icon icon-blue"><i class="bi bi-tags-fill"></i></div>
                    <div>
                        <h5>Tiered Distribution</h5>
                        <p>Front-row rows (A) feature higher close-up premiums, while outer sectors (D) offer lower budgets.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="tip-card">
                    <div class="tip-icon icon-amber"><i class="bi bi-clock-fill"></i></div>
                    <div>
                        <h5>Hold Thresholds</h5>
                        <p>Units remain locked into individual session loops for ten minutes before automatic pool recycling.</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="info-strip">
            <i class="bi bi-info-circle-fill"></i>
            <p><strong>Reservation Policy Reminder:</strong> Once chosen inside active execution pathways, selected seats remain locked for 10 minutes to support payment transactions. Unprocessed tickets return directly to inventory pools.</p>
        </div>

    </div>
</div>

<%@ include file="footer.jsp" %>

<script>
    // Configuration structures for the interactive sandbox rendering matrix
    const ROWS   = [{id:'A', p:4000}, {id:'B', p:3000}, {id:'C', p:2000}, {id:'D', p:1000}];
    const BOOKED = ['A3','A4','B6','C2','D8'];
    let selected = [];

    const grid = document.getElementById('seatGrid');

    // Generating responsive nodes sequentially
    ROWS.forEach(row => {
        const rowDiv = document.createElement('div');
        rowDiv.className = 'seat-row-demo';

        const lbl = document.createElement('span');
        lbl.className = 'row-lbl';
        lbl.textContent = row.id;
        rowDiv.appendChild(lbl);

        for (let i = 1; i <= 10; i++) {
            const id  = row.id + i;
            const btn = document.createElement('button');
            btn.className = 'seat-btn'
                + (i === 6 ? ' aisle' : '')
                + (BOOKED.includes(id) ? ' booked' : '');
            btn.textContent = i;
            btn.title = BOOKED.includes(id)
                ? 'Seat ' + id + ' is taken'
                : 'Seat ' + id + ' — LKR ' + row.p.toLocaleString();

            if (!BOOKED.includes(id)) {
                btn.onclick = () => {
                    if (selected.includes(id)) {
                        selected = selected.filter(x => x !== id);
                        btn.classList.remove('selected');
                    } else {
                        selected.push(id);
                        btn.classList.add('selected');
                    }
                    updateSummary();
                };
            } else {
                btn.disabled = true;
            }

            rowDiv.appendChild(btn);
        }
        grid.appendChild(rowDiv);
    });

    // Refresh dynamic telemetry variables following selection adjustments
    function updateSummary() {
        const total = selected.reduce((sum, id) => {
            const row = ROWS.find(r => id.startsWith(r.id));
            return sum + (row ? row.p : 0);
        }, 0);

        document.getElementById('selList').textContent  = selected.length ? selected.join(', ') : '—';
        document.getElementById('selTotal').textContent = 'LKR ' + total.toLocaleString();

        const checkoutBtn = document.getElementById('checkoutBtn');
        if (selected.length > 0) {
            checkoutBtn.classList.add('active');
            checkoutBtn.style.cursor = 'pointer';
        } else {
            checkoutBtn.classList.remove('active');
            checkoutBtn.style.cursor = 'not-allowed';
        }
    }
</script>

</body>
</html>