package com.controller.admin;

import com.model.Coupon;
import com.service.CouponService;
import com.service.impl.CouponServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;

@WebServlet("/CouponServlet")
public class CouponServlet extends HttpServlet {

    private CouponService service;

    private String getFilePath() {
        return getServletContext().getRealPath("/")
                + "data/coupons.txt";
    }

    @Override
    public void init() {
        service = new CouponServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        File file = new File(getFilePath());

        if ("create".equals(action)) {

            Coupon coupon = new Coupon(
                    0,
                    request.getParameter("code"),
                    Integer.parseInt(request.getParameter("discount")),
                    request.getParameter("active")
            );

            service.create(file, coupon);

        } else if ("update".equals(action)) {

            Coupon coupon = new Coupon(
                    Integer.parseInt(request.getParameter("id")),
                    request.getParameter("code"),
                    Integer.parseInt(request.getParameter("discount")),
                    request.getParameter("active")
            );

            service.update(file, coupon);

        } else if ("delete".equals(action)) {

            int id = Integer.parseInt(request.getParameter("id"));

            service.delete(file, id);
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/coupons.jsp"
        );
    }
}