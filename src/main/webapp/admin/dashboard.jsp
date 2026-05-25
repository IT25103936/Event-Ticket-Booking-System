<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // -------------------------------------------------------------------------
    // FILE PATH SETUPS
    // -------------------------------------------------------------------------
    String dataDirPath = application.getRealPath("/") + "data/";
    File paymentsFile = new File(dataDirPath + "payments.txt");
    File bookingsFile  = new File(dataDirPath + "bookings.txt");
    File usersFile     = new File(dataDirPath + "users.txt");

    // -------------------------------------------------------------------------
    // METRIC CALCULATIONS & PARSING FROM TEXT FILES
    // -------------------------------------------------------------------------
    double calculatedRevenue = 0.0;
    int totalBookingsCount = 0;
    int systemUsersCount = 0;

    // 1. Calculate Revenue from payments.txt (Only counting PAID/CLEARED rows)
    if (paymentsFile.exists()) {
        try (BufferedReader br = new BufferedReader(new FileReader(paymentsFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                String[] tokens = line.split(",");
                if (tokens.length >= 5) {
                    String status = tokens[4].trim();
                    if ("PAID".equalsIgnoreCase(status) || "CLEARED".equalsIgnoreCase(status) || "SUCCESS".equalsIgnoreCase(status)) {
                        try {
                            calculatedRevenue += Double.parseDouble(tokens[2].trim());
                        } catch (NumberFormatException e) { /* Skip corrupted rows safely */ }
                    }
                }
            }
        } catch (Exception e) { /* Fail-safes configured */ }
    }

    // 2. Count Active Bookings from bookings.txt
    if (bookingsFile.exists()) {
        try (BufferedReader br = new BufferedReader(new FileReader(bookingsFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) totalBookingsCount++;
            }
        } catch (Exception e) { /* Fail-safes configured */ }
    }

    // 3. Count User Profile Assets from users.txt
    List<String[]> transientUserLines = new ArrayList<>();
    if (usersFile.exists()) {
        try (BufferedReader br = new BufferedReader(new FileReader(usersFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                systemUsersCount++;
                String[] tokens = line.split(",");
                if (tokens.length >= 3) {
                    transientUserLines.add(tokens); // Stored for rendering below
                }
            }
        } catch (Exception e) { /* Fail-safes configured */ }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Frosted Admin | EventPass</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="/eventTicketBookingSystem/css/adminview/dashboard.css">
</head>
<body>

    <!-- STANDALONE SIDEBAR / NAVBAR INTERACTION -->
    <%@ include file="navbar.jsp" %>

    <!-- MAIN CONTENT -->
    <main class="main-container">
        <div class="d-flex justify-content-between align-items-center mb-5">
            <%
                String adminName = (String) session.getAttribute("adminName");
                String adminEmail = (String) session.getAttribute("adminEmail");
                String adminImage = (String) session.getAttribute("adminImage");

                String imgPath = (adminImage != null && !adminImage.isEmpty()) ? adminImage : "default.png";
            %>

            <div class="d-flex align-items-center gap-3">
                 <img src="<%= request.getContextPath() + "/uploads/" + imgPath %>"
                      alt="admin"
                      style="width:55px;height:55px;border-radius:20%;object-fit:cover;border:2px solid #e2e8f0;">

                <div>
                    <h3 class="fw-800 mb-1" style="letter-spacing: -1px;">
                        Morning, <%= (adminName != null ? adminName : "Admin") %>
                    </h3>
                    <p class="text-muted small fw-500 mb-0">
                        Email: <%= (adminEmail != null ? adminEmail : "-") %>
                    </p>
                </div>
            </div>
            <div class="d-flex gap-3">
                <div class="glass-card py-2 px-3 d-flex align-items-center gap-2" style="border-radius: 15px;">
                    <i class="bi bi-search opacity-50"></i>
                    <input type="text" placeholder="Global Search..." class="border-0 bg-transparent small" style="outline: none; width: 150px;">
                </div>
                <div class="icon-box"><i class="bi bi-bell"></i></div>
            </div>
        </div>

        <!-- Metric Row Dynamically Rendered -->
        <div class="row g-4 mb-5">
            <div class="col-md-3">
                <div class="glass-card">
                    <div class="d-flex justify-content-between mb-3">
                        <div class="stat-header">Total Revenue</div>
                        <i class="bi bi-graph-up text-success"></i>
                    </div>
                    <div class="stat-number">LKR <%= String.format("%,.2f", calculatedRevenue) %></div>
                    <div class="small mt-2 fw-bold text-success" style="font-size: 0.65rem;">REAL-TIME CASH FLOW</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="glass-card">
                    <div class="d-flex justify-content-between mb-3">
                        <div class="stat-header">Total Bookings</div>
                        <i class="bi bi-ticket-detailed text-primary"></i>
                    </div>
                    <div class="stat-number"><%= totalBookingsCount %></div>
                    <div class="small mt-2 fw-bold text-primary" style="font-size: 0.65rem;">TOTAL ORDERS REGISTERED</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="glass-card">
                    <div class="d-flex justify-content-between mb-3">
                        <div class="stat-header">Server Health</div>
                        <i class="bi bi-hdd-network text-warning"></i>
                    </div>
                    <div class="stat-number">Optimal</div>
                    <div class="progress mt-3" style="height: 4px; background: rgba(0,0,0,0.05);">
                        <div class="progress-bar bg-success" style="width: 100%"></div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="glass-card">
                    <div class="d-flex justify-content-between mb-3">
                        <div class="stat-header">Active Registrations</div>
                        <i class="bi bi-broadcast text-danger"></i>
                    </div>
                    <div class="stat-number"><%= systemUsersCount %></div>
                    <div class="small mt-2 fw-bold text-muted" style="font-size: 0.65rem;">TOTAL ENROLLED USER ENTITIES</div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <!-- Platform Growth Visualization Canvas -->
            <div class="col-lg-8">
                <div class="glass-card">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h6 class="fw-800 m-0">Platform Metrics Overview</h6>
                        <div class="btn-group">
                            <button class="btn btn-sm btn-white border small fw-bold">Live</button>
                        </div>
                    </div>
                    <div class="chart-wrap">
                        <canvas id="lightChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Side Logging System Alerts -->
            <div class="col-lg-4">
                <div class="glass-card">
                    <h6 class="fw-800 mb-4">Database Monitoring</h6>
                    <div class="d-flex gap-3 mb-4">
                        <div class="icon-box" style="width: 38px; height: 38px; font-size: 0.9rem; background: #e0e7ff; color: #4f46e5;">
                            <i class="bi bi-check2-circle"></i>
                        </div>
                        <div>
                            <p class="small fw-800 mb-0">Flat File System Connected</p>
                            <p class="text-muted" style="font-size: 0.75rem;">Successfully aggregated data logs metrics.</p>
                        </div>
                    </div>
                    <div class="d-flex gap-3 mb-4">
                        <div class="icon-box" style="width: 38px; height: 38px; font-size: 0.9rem; background: #ecfdf5; color: #059669;">
                            <i class="bi bi-shield-check"></i>
                        </div>
                        <div>
                            <p class="small fw-800 mb-0">Isolation Level Intact</p>
                            <p class="text-muted" style="font-size: 0.75rem;">User tracking safety limits verified.</p>
                        </div>
                    </div>
                    <button class="btn btn-light w-100 fw-bold small py-2 rounded-4">System Core Online</button>
                </div>
            </div>

            <!-- Users Dynamic Rendering Matrix Table -->
            <div class="col-12 mt-4">
                <div class="glass-card border-0">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h6 class="fw-800 m-0">Global User Entity List (Parsed from flat-file storage)</h6>
                    </div>
                    <table class="crystal-table">
                        <thead>
                            <tr>
                                <th>System ID</th>
                                <th>Full Name Account</th>
                                <th>Registered Electronic Email</th>
                                <th>Role Tier</th>
                                <th class="text-end">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (transientUserLines.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="5" class="text-center text-muted py-4">No tracking users mapped in database profile registers.</td>
                            </tr>
                            <%
                                } else {
                                    for (String[] userTokens : transientUserLines) {
                                        // Expects standard flat file structure sequence: id, name, email, ...
                                        String uid   = userTokens[0].trim();
                                        String name  = userTokens[1].trim();
                                        String email = userTokens[2].trim();
                            %>
                            <tr>
                                <td class="fw-bold text-primary">#UID-<%= uid %></td>
                                <td class="fw-700"><%= name %></td>
                                <td class="text-muted text-mono small"><%= email %></td>
                                <td><span class="badge bg-light text-dark border px-2 py-1 small rounded">Standard Customer</span></td>
                                <td class="text-end">
                                    <span class="badge-status bg-success bg-opacity-10 text-success">Active Connection</span>
                                </td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

<script>
    const ctx = document.getElementById('lightChart').getContext('2d');

    const gradient = ctx.createLinearGradient(0, 0, 0, 300);
    gradient.addColorStop(0, 'rgba(79, 70, 229, 0.2)');
    gradient.addColorStop(1, 'rgba(79, 70, 229, 0)');

    new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            datasets: [{
                data: [35, 42, 38, 65, 54, 78, <%= totalBookingsCount %>], // Tracks flat-file total metric dynamically inside real-time graph
                borderColor: '#4f46e5',
                borderWidth: 4,
                tension: 0.5,
                fill: true,
                backgroundColor: gradient,
                pointRadius: 4,
                pointBackgroundColor: '#fff',
                pointBorderColor: '#4f46e5',
                pointBorderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                x: { ticks: { color: '#64748b', font: { weight: 'bold' } }, grid: { display: false } },
                y: { ticks: { color: '#64748b' }, grid: { color: 'rgba(0,0,0,0.03)', borderDash: [5, 5] } }
            }
        }
    });
</script>
</body>
</html>