package org.example.wpjsp.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/checkUsers")
public class CheckUsersController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int numUsers = LoginController.getSessionsCount();
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"numUsers\": " + numUsers + "}");
        out.flush();
    }
}
