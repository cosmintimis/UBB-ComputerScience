package org.example.wpjsp.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.java.Log;
import org.example.wpjsp.model.User;
import org.example.wpjsp.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;


import java.io.IOException;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

@WebServlet(urlPatterns = {"/login", "/logout"}, loadOnStartup = 1)
public class LoginController extends HttpServlet {

    private static final List<HttpSession> sessions = new CopyOnWriteArrayList<>();


    @Autowired
    private AuthService authService;


    public LoginController(AuthService authService) {
        super();
        this.authService = authService;
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        RequestDispatcher rd = null;

        if ("/logout".equals(request.getServletPath())) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                sessions.remove(session);
            }
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }

        if (isUsernameAlreadyLoggedIn(username)) {
            rd = request.getRequestDispatcher("/WEB-INF/jsp/home.jsp");
            rd.forward(request, response);
            return;
        }

        if (sessions.size() >= 2) {
            rd = request.getRequestDispatcher("/WEB-INF/jsp/max_users_error.jsp");
            rd.forward(request, response);
            return;
        }

        User user = authService.authenticate(username, password);
        if (user != null) {

            rd = request.getRequestDispatcher("/WEB-INF/jsp/home.jsp");
            HttpSession httpSession = request.getSession(true);
            httpSession.setAttribute("user", user);
            sessions.add(httpSession);
        }
        else{
            rd = request.getRequestDispatcher("/WEB-INF/jsp/error.jsp");
        }
        if (sessions.size() == 1) {
            sessions.getFirst().setAttribute("playerNumber", 1);
        } else {
            if(sessions.size() == 2) {
                if((Integer) sessions.getFirst().getAttribute("playerNumber")  == 1) {
                    sessions.get(1).setAttribute("playerNumber", 2);
                }
                else
                    sessions.get(1).setAttribute("playerNumber", 1);
            }
        }

        rd.forward(request, response);

    }

    private boolean isUsernameAlreadyLoggedIn(String username) {

        for (HttpSession session : sessions) {
            User user = (User) session.getAttribute("user");
            if (user != null && user.getUsername().equals(username)) {
                return true;
            }
        }
        return false;
    }

    public static int getSessionsCount() {
        return sessions.size();
    }

}
