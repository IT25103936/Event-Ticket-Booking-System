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

    private TicketService service = new TicketServiceImpl();

    private static final String FILE_PATH = "data/tickets.txt";

    private File getFile() {
        return new File(
                getServletContext().getRealPath("/")
                        + FILE_PATH
        );
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        String action = request.getParameter("action");

        File file = getFile();

        try {

            if ("create".equals(action)) {

                Ticket ticket = new Ticket(
                        0,
                        Integer.parseInt(request.getParameter("bookingId")),
                        request.getParameter("seatNo"),
                        Double.parseDouble(request.getParameter("price")),
                        request.getParameter("status")
                );

                service.create(file, ticket);

            } else if ("update".equals(action)) {

                Ticket ticket = new Ticket(
                        Integer.parseInt(request.getParameter("id")),
                        Integer.parseInt(request.getParameter("bookingId")),
                        request.getParameter("seatNo"),
                        Double.parseDouble(request.getParameter("price")),
                        request.getParameter("status")
                );

                service.update(file, ticket);

            } else if ("delete".equals(action)) {

                int id =
                        Integer.parseInt(
                                request.getParameter("id")
                        );

                service.delete(file, id);
            }

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/tickets.jsp"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/tickets.jsp?error=1"
            );
        }
    }
}