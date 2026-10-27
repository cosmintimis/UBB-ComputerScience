package org.example.serverapp.payload.response;

import lombok.Getter;
import lombok.Setter;
import org.example.serverapp.entity.Product;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
public class JwtResponse {
    private String token;
    private String type = "Bearer";
    private Integer id;
    private String username;
    private String password;
    private String email;
    private String avatar;
    private LocalDate birthdate;
    private Double rating;
    private String address;
    private List<Product> products;
    private List<String> roles;

    public JwtResponse(String accessToken, Integer id, String username, String email, String avatar, LocalDate birthdate, Double rating, String address, List<Product> products, List<String> roles) {
        this.token = accessToken;
        this.id = id;
        this.username = username;
        this.email = email;
        this.avatar = avatar;
        this.birthdate = birthdate;
        this.rating = rating;
        this.address = address;
        this.products = products;
        this.roles = roles;
    }

}