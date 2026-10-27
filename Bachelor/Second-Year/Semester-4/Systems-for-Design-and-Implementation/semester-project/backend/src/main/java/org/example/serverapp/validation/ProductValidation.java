package org.example.serverapp.validation;

import org.example.serverapp.entity.Product;
import org.example.serverapp.entity.User;

public class ProductValidation {

    public static void validate(Product product){

            if(product.getName().isEmpty())
                throw new RuntimeException("Name must be at least 1 character long");

            if(product.getDescription().isEmpty())
                throw new RuntimeException("Description must be at least 1 character long");

            if(product.getPrice() < 0)
                throw new RuntimeException("Price must be greater than 0");

    }
}
