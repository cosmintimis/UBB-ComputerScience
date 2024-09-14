package org.example.serverapp.service;

import com.github.javafaker.Faker;
import org.example.serverapp.entity.Product;
import org.example.serverapp.repository.ProductRepositoryDB;
import org.example.serverapp.repository.UserRepositoryDB;
import org.example.serverapp.validation.ProductValidation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class ProductService {

    private final ProductRepositoryDB productRepositoryDB;
    private final UserRepositoryDB userRepositoryDB;

    @Autowired
    public ProductService(ProductRepositoryDB productRepositoryDB, UserRepositoryDB userRepositoryDB) {
        this.productRepositoryDB = productRepositoryDB;
        this.userRepositoryDB = userRepositoryDB;
    }

    public void deleteProductById(Long id) {
        if (productRepositoryDB.findById(id).isEmpty()) {
            throw new RuntimeException("Product with id " + id + " not found");
        }
        productRepositoryDB.deleteById(id);
    }

    public Product addProduct(Product product, Integer userId) {

        if(userRepositoryDB.findById(userId).isEmpty()){
            throw new RuntimeException("User with id " + userId + " not found");

        }
        ProductValidation.validate(product);
        product.setUser(userRepositoryDB.findById(userId).get());
        return productRepositoryDB.save(product);
    }

    public Product updateProduct(Long id, Product newProduct) {
        if(productRepositoryDB.findById(id).isEmpty()){
            throw new RuntimeException("Product with id " + id + " not found");
        }
        ProductValidation.validate(newProduct);

        Product product = productRepositoryDB.findById(id).get();
        product.setName(newProduct.getName());
        product.setDescription(newProduct.getDescription());
        product.setPrice(newProduct.getPrice());



        return productRepositoryDB.save(product);

    }

    public List<Product> getAllProducts() {
        return productRepositoryDB.findAll();
    }
}
