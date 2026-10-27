package org.example.serverapp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
public class ServerAppApplication {

    public static void main(String[] args) {
        SpringApplication.run(ServerAppApplication.class, args);
    }
}
