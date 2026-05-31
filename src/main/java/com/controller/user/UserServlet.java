package com.controller.user;

import com.model.User;
import com.service.UserService;
import com.service.impl.UserServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/UserServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize       = 1024 * 1024 * 5,
        maxRequestSize    = 1024 * 1024 * 10
)
public class UserServlet extends HttpServlet {

    private static final String FILE_PATH = "data/users.txt";

    private final UserService service = new UserServiceImpl();

    private File getFile() {
        return new File(getServletContext().getRealPath("/") + FILE_PATH);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {


        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action parameter");
            return;
        }

        switch (action.trim()) {
            case "create": createUser(request, response); break;
            case "update": updateUser(request, response); break;
            case "delete": deleteUser(request, response); break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
        }
    }

    //  CREATE
    private void createUser(HttpServletRequest request,
                            HttpServletResponse response)
            throws ServletException, IOException {

        String imagePath = uploadImage(request);

        User u = new User();
        u.setName(request.getParameter("name"));
        u.setEmail(request.getParameter("email"));
        u.setPhone(request.getParameter("phone"));
        u.setPassword(request.getParameter("password"));
        u.setRole(request.getParameter("role"));
        u.setImage((imagePath == null || imagePath.trim().isEmpty())
                ? "default.png"
                : imagePath);

        service.addUser(getFile(), u);

        response.sendRedirect(request.getContextPath() + "/admin/users.jsp");
    }


    //  UPDATE
    private void updateUser(HttpServletRequest request,
                            HttpServletResponse response)
            throws ServletException, IOException {


        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing user id");
            return;
        }

        User u = new User();
        u.setId(Integer.parseInt(idParam.trim()));
        u.setName(request.getParameter("name"));
        u.setEmail(request.getParameter("email"));
        u.setPhone(request.getParameter("phone"));


        String role = request.getParameter("role");
        u.setRole(role != null ? role : "user");


        String newPassword = request.getParameter("password");
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            u.setPassword(newPassword.trim());
        } else {

            String oldPassword = request.getParameter("oldPassword");
            u.setPassword(oldPassword != null ? oldPassword : "");
        }


        String imagePath = uploadImage(request);
        if (imagePath == null || imagePath.isEmpty()) {
            String oldImage = request.getParameter("oldImage");
            u.setImage((oldImage != null && !oldImage.trim().isEmpty())
                    ? oldImage
                    : "default.png");
        } else {
            u.setImage(imagePath);
        }

;

        service.updateUser(getFile(), u);


        User sessionUser = (User) request.getSession().getAttribute("user");
        if (sessionUser != null && sessionUser.getId() == u.getId()) {
            u.setPassword(sessionUser.getPassword());
            request.getSession().setAttribute("user", u);
        }


        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains("profile.jsp")) {
            response.sendRedirect(request.getContextPath() + "/user/profile.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users.jsp");
        }
    }

    //  DELETE
    private void deleteUser(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException {


        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing user id");
            return;
        }

        service.deleteUser(getFile(), idParam.trim());
        response.sendRedirect(request.getContextPath() + "/admin/users.jsp");
    }

    //  IMAGE UPLOAD
    private String uploadImage(HttpServletRequest request)
            throws IOException, ServletException {

        Part part = request.getPart("image");

        if (part == null || part.getSize() == 0) {
            return "";
        }


        String submittedName = part.getSubmittedFileName();
        if (submittedName == null || submittedName.trim().isEmpty()) {
            return "";
        }

        String originalName = Paths.get(submittedName).getFileName().toString();
        String fileName      = UUID.randomUUID() + "_" + originalName;
        String uploadPath    = getServletContext().getRealPath("/") + "uploads";

        File folder = new File(uploadPath);
        if (!folder.exists()) {
            folder.mkdirs();
        }

        part.write(uploadPath + File.separator + fileName);

        return "uploads/" + fileName;
    }
}