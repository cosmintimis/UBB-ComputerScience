package org.example.wpjsp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;

@ServletComponentScan
@SpringBootApplication
public class WpJspApplication {

    public static void main(String[] args) {
        SpringApplication.run(WpJspApplication.class, args);
    }

}
