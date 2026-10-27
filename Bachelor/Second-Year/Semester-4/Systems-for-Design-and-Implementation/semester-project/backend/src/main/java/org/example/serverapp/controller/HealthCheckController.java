package org.example.serverapp.controller;


import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@CrossOrigin("*")
@RestController
@RequestMapping("/api/health-check")
public class HealthCheckController {

    @RequestMapping
    public String healthCheck() {
        return "OK";
    }
}
