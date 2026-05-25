<%@ page import="com.model.User" %>

<!DOCTYPE html>
<html>
<head>
<title>Users</title>

<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

 <!-- Load CSS file -->
     <link rel="stylesheet" href="/eventTicketBookingSystem/css/userview/users.css">

</head>

<body>

<!-- NAVBAR -->
<%@ include file="navbar.jsp" %>

<!-- MAIN CONTENT -->
<div class="main-content">

<div class="container">

    <div class="booking-card">

        <!-- HEADER -->
        <div class="d-flex justify-content-between align-items-center mb-3">

            <h4 class="page-title mb-0">
                <i class="bi bi-people"></i> Users
            </h4>

        </div>

        <!-- TABLE -->
        <div class="table-responsive">
            <table class="table table-striped table-hover table-modern">

                <thead class="table-dark">
                    <tr>
                        <th>User ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>
                    <tr>
                        <td>1</td>
                        <td>John Doe</td>
                        <td>john@gmail.com</td>
                        <td>0771234567</td>
                        <td><span class="badge bg-success">Active</span></td>
                        <td>
                            <button class="btn btn-sm btn-danger">
                                <i class="bi bi-trash"></i> Delete
                            </button>
                        </td>
                    </tr>

                    <tr>
                        <td>2</td>
                        <td>Jane Smith</td>
                        <td>jane@gmail.com</td>
                        <td>0779876543</td>
                        <td><span class="badge bg-success">Active</span></td>
                        <td>
                            <button class="btn btn-sm btn-danger">
                                <i class="bi bi-trash"></i> Delete
                            </button>
                        </td>
                    </tr>
                </tbody>

            </table>
        </div>

    </div>

</div>

</div>

<!-- FOOTER -->
<%@ include file="footer.jsp" %>

</body>
</html>