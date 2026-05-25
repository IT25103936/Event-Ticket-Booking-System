package com.auth;

import com.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;

@WebServlet("/LoginServlet")
public class UserAuthServlet extends HttpServlet {

    private static final String USER_FILE = "data/users.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null) {
            forwardLogin(request, response, "Enter credentials", "danger");
            return;
        }

        email = email.trim();
        password = password.trim();


        // check
        User user = findUser(email, password, request, USER_FILE);
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", "USER");

            response.sendRedirect(request.getContextPath() + "/user/homepage.jsp");
            return;
        }

        forwardLogin(request, response, "Invalid email or password!", "danger");
    }

    private User findUser(String email, String password,
                          HttpServletRequest request, String filePath) throws IOException {

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

    private void forwardLogin(HttpServletRequest request,
                              HttpServletResponse response,
                              String msg, String type)
            throws ServletException, IOException {

        request.setAttribute("msg", msg);
        request.setAttribute("type", type);
        request.getRequestDispatcher("/user/login.jsp")
                .forward(request, response);
    }
}