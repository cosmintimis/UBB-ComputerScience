//package org.example.serverapp.mapper;
//
//import org.example.serverapp.dto.ProductDto;
//import org.example.serverapp.entity.Product;
//
//import java.util.ArrayList;
//
//
//public class ProductMapper {
//    public static ProductDto mapToProductDto(Product product) {
//        return new ProductDto(
//                product.getId(),
//                product.getName(),
//                product.getDescription(),
//                product.getPrice()
//                );
//    }
//
//    public static Product mapToProduct(ProductDto productDto) {
//        return new Product(
//                productDto.getId(),
//                productDto.getName(),
//                productDto.getDescription(),
//                productDto.getPrice(),
//                null
//        );
//    }
//}
