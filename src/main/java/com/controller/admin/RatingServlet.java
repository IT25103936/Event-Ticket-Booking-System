package com.controller.admin;

import com.model.Rating;
import com.model.User;
import com.service.RatingService;
import com.service.impl.RatingServiceImpl;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;

@WebServlet("/RatingServlet")
public class RatingServlet extends HttpServlet {

    private RatingService service =
            new RatingServiceImpl();

    private File getFile(HttpServletRequest request) {

        return new File(
                request.getServletContext()
                        .getRealPath("/data/ratings.txt")
        );
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        String action =
                request.getParameter("action");

        try {

            File file = getFile(request);

            HttpSession session =
                    request.getSession(false);

            User userObj =
                    (session != null)
                            ? (User) session.getAttribute("user")
                            : null;

            if (userObj == null) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/user/login.jsp"
                );
                return;
            }

            int userId = userObj.getId();

            // DELETE
            if ("delete".equals(action)) {

                service.delete(file, Integer.parseInt(request.getParameter("id")));

                response.sendRedirect(
                        request.getContextPath()
                                + "/user/events.jsp"
                );
                return;
            }

            int eventId =
                    Integer.parseInt(
                            request.getParameter("eventId")
                    );

            int ratingValue =
                    Integer.parseInt(
                            request.getParameter("rating")
                    );

            String comment =
                    request.getParameter("comment");

            if (comment == null) {
                comment = "";
            }

            String date =
                    java.time.LocalDate.now().toString();

            Rating rating =
                    new Rating(
                            0,
                            userId,
                            eventId,
                            ratingValue,
                            comment,
                            date
                    );


            // UPDATE

            if ("update".equals(action)) {

                rating = new Rating(
                        Integer.parseInt(
                                request.getParameter("id")
                        ),
                        userId,
                        eventId,
                        ratingValue,
                        comment,
                        date
                );

                service.update(file, rating);

            } else {


                // CREATE

                service.create(file, rating);
            }

            response.sendRedirect(
                    request.getContextPath()
                            + "/user/events.jsp"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                            + "/error.jsp"
            );
        }
    }
}