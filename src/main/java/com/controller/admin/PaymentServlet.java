package com.controller.admin;

import com.model.Payment;
import com.service.PaymentService;
import com.service.impl.PaymentServiceImpl;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {

    private PaymentService service = new PaymentServiceImpl();

    private static final String FILE_PATH = "data/payments.txt";

    private File getFile() {
        return new File(getServletContext().getRealPath("/") + FILE_PATH);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String action = request.getParameter("action");
        File file = getFile();

        if ("create".equals(action)) {

            Payment p = new Payment(
                    0,
                    Integer.parseInt(request.getParameter("userId")),
                    Double.parseDouble(request.getParameter("amount")),
                    request.getParameter("method"),
                    request.getParameter("status"),
                    request.getParameter("date")
            );

            service.create(file, p);

        } else if ("update".equals(action)) {

            Payment p = new Payment(
                    Integer.parseInt(request.getParameter("id")),
                    Integer.parseInt(request.getParameter("userId")),
                    Double.parseDouble(request.getParameter("amount")),
                    request.getParameter("method"),
                    request.getParameter("status"),
                    request.getParameter("date")
            );

            service.update(file, p);

        } else if ("delete".equals(action)) {

            service.delete(file, Integer.parseInt(String.valueOf(Integer.parseInt(request.getParameter("id")))));
        }

        response.sendRedirect(request.getContextPath() + "/admin/payments.jsp");
    }
}