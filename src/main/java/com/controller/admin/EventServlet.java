package com.controller.admin;

import com.model.Event;
import com.service.EventService;
import com.service.impl.EventServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet("/EventServlet")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class EventServlet extends HttpServlet {

    private final EventService service = new EventServiceImpl();
    private static final String FILE_PATH = "data/events.txt";
    private static final String UPLOAD_DIR = "uploads";

    private File getFile() {
        return new File(getServletContext().getRealPath("/") + FILE_PATH);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String action = request.getParameter("action");
        File file = getFile();

        if ("create".equals(action)) {
            String imageName = handleImageUpload(request, null);
            Event e = buildEvent(request, imageName);
            service.create(file, e);

        } else if ("update".equals(action)) {
            // Keep existing image if no new file uploaded
            String existingImage = request.getParameter("existingImage");
            String imageName = handleImageUpload(request, existingImage);
            Event e = buildEvent(request, imageName);
            e.setId(parseInt(request.getParameter("id")));
            service.update(file, e);

        } else if ("delete".equals(action)) {
            service.delete(file, parseInt(request.getParameter("id")));
        }

        response.sendRedirect(request.getContextPath() + "/admin/events.jsp");
    }


    private String handleImageUpload(HttpServletRequest request, String fallback)
            throws IOException, ServletException {

        Part filePart = request.getPart("image");

        if (filePart != null && filePart.getSize() > 0) {
            String original = filePart.getSubmittedFileName();
            String ext = original.contains(".")
                    ? original.substring(original.lastIndexOf('.'))
                    : ".jpg";
            String fileName = UUID.randomUUID() + ext;

            File uploadDir = new File(getServletContext().getRealPath("/") + UPLOAD_DIR);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            try (InputStream in = filePart.getInputStream()) {
                Files.copy(in,
                        new File(uploadDir, fileName).toPath(),
                        StandardCopyOption.REPLACE_EXISTING);
            }
            return fileName;
        }

        return (fallback != null && !fallback.isEmpty()) ? fallback : "default.jpg";
    }

    private Event buildEvent(HttpServletRequest request, String imageName) {
        return new Event(
                0,
                request.getParameter("name"),
                request.getParameter("date"),
                request.getParameter("time"),
                request.getParameter("location"),
                parseDouble(request.getParameter("price")),
                request.getParameter("description"),
                imageName,
                40,
                "Active"

        );
    }

    private int parseInt(String v) {
        try { return (v == null || v.isEmpty()) ? 0 : Integer.parseInt(v.trim()); }
        catch (Exception e) { return 0; }
    }

    private double parseDouble(String v) {
        try { return (v == null || v.isEmpty()) ? 0.0 : Double.parseDouble(v.trim()); }
        catch (Exception e) { return 0.0; }
    }
}

