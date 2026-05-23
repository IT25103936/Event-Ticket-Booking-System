package com.controller.admin;

import com.model.Admin;
import com.service.AdminService;
import com.service.impl.AdminServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;

@WebServlet("/AdminServlet")
@MultipartConfig
public class AdminServlet extends HttpServlet {

    private final AdminService service = new AdminServiceImpl();

    private String getPath() {
        return getServletContext().getRealPath("/data/admin.txt");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Login required");
            return;
        }

        String adminLevel = (String) session.getAttribute("adminLevel");

        if (!"SUPERADMIN".equals(adminLevel)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Only SUPERADMIN can manage admin accounts.");
            return;
        }

        String action = request.getParameter("action");
        String path = getPath();

        if ("create".equalsIgnoreCase(action)) {

            Admin a = buildAdmin(request, adminLevel);
            service.createAdmin(a, path);

        } else if ("update".equalsIgnoreCase(action)) {

            Admin a = buildAdmin(request, adminLevel);
            a.setId(Integer.parseInt(request.getParameter("id")));
            service.updateAdmin(a, path);

        } else if ("delete".equalsIgnoreCase(action)) {

            int id = Integer.parseInt(request.getParameter("id"));
            service.deleteAdmin(id, path);
        }

        response.sendRedirect(request.getContextPath() + "/admin/admins.jsp");
    }


    private Admin buildAdmin(HttpServletRequest request, String adminLevel)
            throws IOException, ServletException {

        Admin a = new Admin();


        a.setName(request.getParameter("name"));
        a.setEmail(request.getParameter("email"));
        a.setPhone(request.getParameter("phone"));
        a.setPassword(request.getParameter("password"));


        String promote = request.getParameter("promoteSuper");

        String finalLevel = "ADMIN";

        if ("on".equals(promote) && "SUPERADMIN".equals(adminLevel)) {
            finalLevel = "SUPERADMIN";
        }

        a.setAdminLevel(finalLevel);


        Part p = request.getPart("image");
        String img = "default.png";

        if (p != null && p.getSize() > 0) {
            img = p.getSubmittedFileName();

            String upload = getServletContext().getRealPath("/uploads/");
            new File(upload).mkdirs();
            p.write(upload + img);
        }

        a.setImage(img);

        return a;
    }
}