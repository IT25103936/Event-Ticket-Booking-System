package com.auth;

import com.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;

@WebServlet("/AdminAuthServlet")
public class AdminAuthServlet extends HttpServlet {

    private static final String FILE_PATH = "data/admin.txt";

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException, ServletException {

        String action = request.getParameter("action");

        if ("register".equalsIgnoreCase(action)) {

            register(request, response);

        } else if ("login".equalsIgnoreCase(action)) {

            login(request, response);

        } else {

            response.sendRedirect(request.getContextPath()
                    + "/admin/login.jsp");
        }
    }


    private void login(HttpServletRequest request,
                       HttpServletResponse response)
            throws IOException, ServletException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");


        if (email == null || password == null ||
                email.trim().isEmpty() ||
                password.trim().isEmpty()) {

            request.setAttribute("msg", "Enter email and password!");
            request.setAttribute("type", "danger");

            request.getRequestDispatcher("/admin/login.jsp")
                    .forward(request, response);

            return;
        }

        email = email.trim();
        password = password.trim();

        String fullPath = getServletContext().getRealPath("/") + FILE_PATH;

        File file = new File(fullPath);

        boolean found = false;

        String adminName = "";
        String role = "";
        String adminImage = "assets/img/default.png";
        String adminLevel = "";

        if (file.exists()) {

            try (BufferedReader br =
                         new BufferedReader(new FileReader(file))) {

                String line;

                while ((line = br.readLine()) != null) {

                    if (line.trim().isEmpty()) continue;

                    String[] d = line.split(",");

                    // FORMAT:
                    // id,name,email,role,password,image
                    if (d.length >= 5 &&
                            d[2].trim().equalsIgnoreCase(email) &&
                            d[5].trim().equals(password)) {

                        found = true;

                        adminName = d[1].trim();
                        role = d[3].trim();
                        adminLevel = d[7].trim();
                        if (d.length > 5) {
                            adminImage = d[5].trim();
                        }

                        break;
                    }
                }
            }
        }

        if (found) {

            HttpSession session = request.getSession();

            session.setAttribute("adminName", adminName);
            session.setAttribute("adminEmail", email);
            session.setAttribute("role", role);
            session.setAttribute("adminImage", adminImage);
            session.setAttribute("adminLevel", adminLevel);

            response.sendRedirect(request.getContextPath()
                    + "/admin/dashboard.jsp");

        } else {

            request.setAttribute("msg",
                    "Invalid admin credentials!");

            request.setAttribute("type", "danger");

            request.getRequestDispatcher("/admin/login.jsp")
                    .forward(request, response);
        }
    }

    // REGISTER
    private void register(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException, ServletException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        if (name == null || email == null || phone == null || password == null ||
                name.trim().isEmpty() ||
                email.trim().isEmpty() ||
                phone.trim().isEmpty() ||
                password.trim().isEmpty()) {

            request.setAttribute("msg", "All fields are required!");
            request.setAttribute("type", "danger");

            request.getRequestDispatcher("/admin/register.jsp")
                    .forward(request, response);
            return;
        }

        String fullPath = getServletContext().getRealPath("/") + FILE_PATH;
        File file = new File(fullPath);
        file.getParentFile().mkdirs();

        boolean emailExists = false;
        int nextId = 1;

        if (file.exists()) {

            try (BufferedReader br = new BufferedReader(new FileReader(file))) {

                String line;

                while ((line = br.readLine()) != null) {

                    if (line.trim().isEmpty()) continue;

                    String[] d = line.split(",");

                    if (d.length >= 5) {

                        if (d[2].trim().equalsIgnoreCase(email)) {
                            emailExists = true;
                            break;
                        }

                        try {
                            int id = Integer.parseInt(d[0].trim());
                            if (id >= nextId) {
                                nextId = id + 1;
                            }
                        } catch (Exception ignored) {
                        }
                    }
                }
            }
        }

        if (emailExists) {

            request.setAttribute("msg", "Email already exists!");
            request.setAttribute("type", "warning");

            request.getRequestDispatcher("/admin/register.jsp")
                    .forward(request, response);
            return;
        }

        //  BUILD ADMIN OBJECT
        Admin a = new Admin();

        a.setId(nextId);
        a.setName(name.trim());
        a.setEmail(email.trim());
        a.setPhone(phone.trim());
        a.setPassword(password.trim());

        // always ADMIN for registration
        a.setRole("ADMIN");
        a.setAdminLevel("ADMIN");

        // default image
        a.setImage("default.png");
        a.setActive(true);

        // SAVE
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file, true))) {

            bw.write(
                    a.getId() + "," +
                            a.getName() + "," +
                            a.getEmail() + "," +
                            a.getPhone() + "," +
                            a.getRole() + "," +
                            a.getPassword() + "," +
                            a.getImage() + "," +
                            a.getAdminLevel()
            );

            bw.newLine();
        }

        request.setAttribute("msg", "Registration successful!");
        request.setAttribute("type", "success");

        request.getRequestDispatcher("/admin/login.jsp")
                .forward(request, response);
    }
}