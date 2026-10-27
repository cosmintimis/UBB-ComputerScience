package org.example.serverapp.service;

import com.github.javafaker.Faker;
import org.example.serverapp.entity.Product;
import org.example.serverapp.entity.User;
import org.example.serverapp.repository.ProductRepositoryDB;
import org.example.serverapp.repository.UserRepositoryDB;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;


@Service
public class GenerateFakeDataService {

    private final ProductRepositoryDB productRepositoryDB;
    private final UserRepositoryDB userRepositoryDB;

    private int firstId;

    @Autowired
    public GenerateFakeDataService(ProductRepositoryDB productRepositoryDB, UserRepositoryDB userRepositoryDB) {
        this.productRepositoryDB = productRepositoryDB;
        this.userRepositoryDB = userRepositoryDB;
    }

    public List<Product> generateProducts(int numberOfProducts, User user ){

        List<Product> products = new ArrayList<>();
        for (int i = 0; i < numberOfProducts; i++) {
            Faker faker = new Faker();
            Product product = Product.builder()
                    .name(faker.commerce().productName())
                    .description(faker.lorem().sentence())
                    .price(faker.number().randomDouble(2, 1, 1000))
                    .user(user)
                    .build();
            products.add(product);
        }

        return products;

    }

    public List<User> generateUsers(int numberOfUsers){

        List<User> users = new ArrayList<>();
        for (int i = 0; i < numberOfUsers; i++) {
            Faker faker = new Faker();
            User user = User.builder()
                    .username(faker.name().username())
                    .password(faker.internet().password())
                    .email(faker.internet().emailAddress())
                    .avatar(faker.internet().avatar())
                    .birthdate(faker.date().birthday().toInstant().atZone(ZoneId.systemDefault()).toLocalDate())
                    .rating(faker.number().randomDouble(1, 1, 9))
                    .address(faker.address().fullAddress())
                    .build();
            users.add(user);
        }
        return users;
    }

    public void generateFakeData() {
        productRepositoryDB.deleteAll();
        userRepositoryDB.deleteAll();

        List<User> users = generateUsers(1000);

        userRepositoryDB.saveAllAndFlush(users);

        firstId = users.get(0).getId();

        List<Product> products = new ArrayList<>();
        for (User user : users)  {
            user.setId(firstId);
            firstId++;
            products.addAll(generateProducts(10, user));
        }
        productRepositoryDB.saveAllAndFlush(products);
    }
}
