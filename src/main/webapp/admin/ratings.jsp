<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Feedback Hub | EventPass</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/adminview/ratings.css">
</head>

<body>

<div class="page-wrapper">
    <%@ include file="navbar.jsp" %>

    <main class="main-content">

        <div class="glass-header">
            <div>
                <h4 class="fw-800 mb-0">Rating Management</h4>
                <p class="text-muted small mb-0">Monitor user sentiment and feedback</p>
            </div>

            <button class="btn-add" onclick="openAdd()">
                <i class="bi bi-plus-circle-fill me-2"></i> Log Feedback
            </button>
        </div>

        <div class="crystal-card">
            <table class="crystal-table">

                <thead>
                <tr>
                    <th>ID</th>
                    <th>User</th>
                    <th>Event</th>
                    <th>Score</th>
                    <th>Comment</th>
                    <th class="text-end">Actions</th>
                </tr>
                </thead>

                <tbody>

                <%
                    File file = new File(application.getRealPath("/") + "data/ratings.txt");

                    if (file.exists()) {

                        BufferedReader br = null;

                        try {

                            br = new BufferedReader(new FileReader(file));

                            String line;

                            while ((line = br.readLine()) != null) {

                                if (line.trim().isEmpty()) continue;

                                String[] d = line.split(",");

                                if (d.length < 5) continue; // ✅ PREVENT CRASH

                                int id = Integer.parseInt(d[0]);
                                String user = d[1];
                                String event = d[2];

                                int stars = 0;
                                try {
                                    stars = Integer.parseInt(d[3]);
                                } catch (Exception e) {
                                    stars = 0;
                                }

                                String comment = (d.length > 4) ? d[4] : "";

                %>

                <tr>
                    <td class="small fw-800 opacity-50">#<%= id %></td>
                    <td class="fw-700"><%= user %></td>
                    <td class="fw-600 text-muted"><%= event %></td>

                    <td>
                        <div class="star-glow">
                            <% for(int i=0; i<stars; i++){ %>
                                <i class="bi bi-star-fill"></i>
                            <% } %>
                            <% for(int i=stars; i<5; i++){ %>
                                <i class="bi bi-star"></i>
                            <% } %>
                        </div>
                    </td>

                    <td>
                        <div class="comment-text">
                            <%= comment %>
                        </div>
                    </td>

                    <td class="text-end">
                        <div class="d-flex gap-2 justify-content-end">

                            <button class="btn btn-light btn-sm"
                                onclick="openEdit('<%=id%>','<%=user%>','<%=event%>','<%=stars%>','<%=comment%>')">
                                <i class="bi bi-pencil-fill text-success"></i>
                            </button>

                            <form action="<%=request.getContextPath()%>/RatingServlet" method="post">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%=id%>">
                                <button class="btn btn-light btn-sm">
                                    <i class="bi bi-trash3-fill text-danger"></i>
                                </button>
                            </form>

                        </div>
                    </td>
                </tr>

                <%
                            }

                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (br != null) br.close();
                        }
                    }
                %>

                </tbody>

            </table>
        </div>

    </main>
</div>

</body>
</html>