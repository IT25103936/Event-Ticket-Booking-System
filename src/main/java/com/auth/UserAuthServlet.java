package com.auth;

import com.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/LoginServlet")
@MultipartConfig
public class UserAuthServlet extends HttpServlet {

    private static final String USER_FILE = "data/users.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String action = request.getParameter("action");

        // REGISTER
        if ("register".equalsIgnoreCase(action)) {
            registerUser(request, response);
            return;
        }

        // LOGIN
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null) {
            forwardLogin(request, response, "Enter credentials", "danger");
            return;
        }

        email = email.trim();
        password = password.trim();

        User user = findUser(email, password, request, USER_FILE);

        if (user != null) {

            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());

            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/user/homepage.jsp");
            }

            return;
        }

        forwardLogin(request, response, "Invalid email or password!", "danger");
    }

    //  REGISTER

    private void registerUser(HttpServletRequest request,
                              HttpServletResponse response)
            throws IOException, ServletException {

        String imagePath = uploadImage(request);

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        if (name == null || email == null || password == null) {
            forwardLogin(request, response, "All fields are required!", "danger");
            return;
        }

        File file = getUserFile(request);

        // check existing email
        if (emailExists(file, email.trim())) {
            forwardLogin(request, response, "Email already exists!", "danger");
            return;
        }

        int nextId = getNextUserId(file);

        User u = new User();
        u.setId(nextId);
        u.setName(name);
        u.setEmail(email);
        u.setPhone(phone);
        u.setPassword(password);

        // default role
        u.setRole("USER");

        u.setImage((imagePath == null || imagePath.trim().isEmpty())
                ? "default.png"
                : imagePath);

        saveUser(file, u);

        response.sendRedirect(request.getContextPath() + "/user/login.jsp");
    }

    //  LOGIN

    private User findUser(String email,
                          String password,
                          HttpServletRequest request,
                          String filePath) throws IOException {

        String fullPath = getServletContext().getRealPath("/") + filePath;

        File file = new File(fullPath);

        if (!file.exists()) return null;

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {

            String line;

            while ((line = br.readLine()) != null) {

                String[] d = line.split(",");

                // id,name,email,phone,password,role,image
                if (d.length >= 7) {

                    if (d[2].trim().equalsIgnoreCase(email)
                            && d[5].trim().equals(password)) {

                        return new User(
                                Integer.parseInt(d[0].trim()),
                                d[1].trim(),
                                d[2].trim(),
                                d[3].trim(),
                                d[4].trim(),
                                d[5].trim(),
                                d[6].trim()
                        );
                    }
                }
            }
        }

        return null;
    }

    // SAVE USER

    private void saveUser(File file, User u) throws IOException {

        file.getParentFile().mkdirs();

        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file, true))) {

            bw.write(
                    u.getId() + "," +
                            u.getName() + "," +
                            u.getEmail() + "," +
                            u.getPhone() + "," +
                            u.getPassword() + "," +
                            u.getRole() + "," +
                            u.getImage()
            );

            bw.newLine();
        }
    }

    //  CHECK EMAIL

    private boolean emailExists(File file, String email) throws IOException {

        if (!file.exists()) return false;

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {

            String line;

            while ((line = br.readLine()) != null) {

                String[] d = line.split(",");

                if (d.length >= 3 &&
                        d[2].trim().equalsIgnoreCase(email)) {

                    return true;
                }
            }
        }

        return false;
    }

    // NEXT ID

    private int getNextUserId(File file) throws IOException {

        int maxId = 0;

        if (!file.exists()) return 1;

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {

            String line;

            while ((line = br.readLine()) != null) {

                String[] d = line.split(",");

                if (d.length > 0) {

                    try {
                        int id = Integer.parseInt(d[0].trim());

                        if (id > maxId) {
                            maxId = id;
                        }

                    } catch (Exception ignored) {
                    }
                }
            }
        }

        return maxId + 1;
    }

    //  FILE

    private File getUserFile(HttpServletRequest request) {

        String path = getServletContext().getRealPath("/") + USER_FILE;

        return new File(path);
    }

    //  IMAGE UPLOAD

    private String uploadImage(HttpServletRequest request)
            throws IOException, ServletException {

        Part part = request.getPart("image");

        if (part == null || part.getSize() == 0) {
            return "default.png";
        }

        String originalName = Paths.get(part.getSubmittedFileName())
                .getFileName()
                .toString();

        String fileName = UUID.randomUUID() + "_" + originalName;

        String uploadPath = getServletContext()
                .getRealPath("/") + "uploads";

        File folder = new File(uploadPath);

        if (!folder.exists()) {
            folder.mkdirs();
        }

        part.write(uploadPath + File.separator + fileName);

        return "uploads/" + fileName;
    }

    //  MESSAGE

    private void forwardLogin(HttpServletRequest request,
                              HttpServletResponse response,
                              String msg,
                              String type)
            throws ServletException, IOException {

        request.setAttribute("msg", msg);
        request.setAttribute("type", type);

        request.getRequestDispatcher("/user/login.jsp")
                .forward(request, response);
    }
}