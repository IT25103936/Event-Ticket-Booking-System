package com.controller.admin;

import com.model.Ticket;
import com.service.TicketService;
import com.service.impl.TicketServiceImpl;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;

@WebServlet("/TicketServlet")
public class TicketServlet extends HttpServlet {

    private final TicketService service = new TicketServiceImpl();

    private static final String FILE_PATH = "data/tickets.txt";

    private File getFile() {
        return new File(
                getServletContext().getRealPath("/") + FILE_PATH
        );
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        File file = getFile();

        try {

            if ("create".equals(action)) {

                Ticket ticket = new Ticket(
                        0,

                        Integer.parseInt(request.getParameter("bookingId").trim()),
                        Integer.parseInt(request.getParameter("userId").trim()),
                        Integer.parseInt(request.getParameter("eventId").trim()),
                        request.getParameter("seatNo").trim(),
                        Double.parseDouble(request.getParameter("price").trim()),
                        request.getParameter("status").trim()
                );

                service.create(file, ticket);

            } else if ("update".equals(action)) {


                String idParam = request.getParameter("id");
                if (idParam == null || idParam.trim().isEmpty()) {
                    throw new IllegalArgumentException("Ticket ID is missing for update");
                }

                Ticket ticket = new Ticket(
                        Integer.parseInt(idParam.trim()),
                        Integer.parseInt(request.getParameter("bookingId").trim()),
                        Integer.parseInt(request.getParameter("userId").trim()),
                        Integer.parseInt(request.getParameter("eventId").trim()),
                        request.getParameter("seatNo").trim(),
                        Double.parseDouble(request.getParameter("price").trim()),
                        request.getParameter("status").trim()
                );

                service.update(file, ticket);

            } else if ("delete".equals(action)) {

                String idParam = request.getParameter("id");
                if (idParam == null || idParam.trim().isEmpty()) {
                    throw new IllegalArgumentException("Ticket ID is missing for delete");
                }

                service.delete(file, Integer.parseInt(idParam.trim()));
            }

            response.sendRedirect(
                    request.getContextPath() + "/admin/tickets.jsp"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath() + "/admin/tickets.jsp?error=1"
            );
        }
    }
}