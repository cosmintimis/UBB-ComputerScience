//package org.example.serverapp;
//
//import org.example.serverapp.entity.Product;
//import org.example.serverapp.entity.User;
//import org.example.serverapp.repository.ProductRepositoryDB;
//import org.example.serverapp.repository.UserRepositoryDB;
//import org.example.serverapp.service.ProductService;
//import org.junit.jupiter.api.Assertions;
//import org.junit.jupiter.api.Test;
//import org.junit.jupiter.api.extension.ExtendWith;
//import org.mockito.InjectMocks;
//import org.mockito.Mock;
//import org.mockito.Mockito;
//import org.mockito.junit.jupiter.MockitoExtension;
//
//import java.util.List;
//import java.util.Optional;
//
//import static org.assertj.core.api.Assertions.assertThat;
//import static org.mockito.Mockito.when;
//
//@ExtendWith(MockitoExtension.class)
//public class ProductServiceTest {
//
//    @Mock
//    private ProductRepositoryDB productRepositoryDB;
//
//    @Mock
//    private UserRepositoryDB userRepositoryDB;
//
//    @InjectMocks
//    private ProductService productService;
//
//    @Test
//    public void testAddProduct() {
//        Product product = Product.builder()
//                .name("Product1")
//                .description("Description1")
//                .price(99.99)
//                .build();
//
//        when(userRepositoryDB.findById(1)).thenReturn(Optional.of(User.builder().id(1).build()));
//        when(productRepositoryDB.save(product)).thenReturn(product);
//
//        productService.addProduct(product, 1);
//
//        Assertions.assertThrows(RuntimeException.class, () -> productService.addProduct(product, 2));
//    }
//
//
//    @Test
//    public void testUpdateProduct() {
//        Product product = Product.builder()
//                .name("Product1")
//                .description("Description1")
//                .price(99.99)
//                .build();
//
//        Product newProduct = Product.builder()
//                .name("Product2")
//                .description("Description2")
//                .price(199.99)
//                .build();
//
//        when(productRepositoryDB.findById(1L)).thenReturn(Optional.of(product));
//        when(productRepositoryDB.save(Mockito.any(Product.class))).thenReturn(product);
//
//        productService.updateProduct(1L, newProduct);
//
//        assertThat(product.getName()).isEqualTo("Product2");
//        assertThat(product.getDescription()).isEqualTo("Description2");
//        assertThat(product.getPrice()).isEqualTo(199.99);
//
//        Assertions.assertThrows(RuntimeException.class, () -> productService.updateProduct(2L, newProduct));
//    }
//
//    @Test
//    public void testDeleteProduct() {
//        Product product = Product.builder()
//                .name("Product1")
//                .description("Description1")
//                .price(99.99)
//                .build();
//
//        when(productRepositoryDB.findById(1L)).thenReturn(Optional.of(product));
//
//        productService.deleteProductById(1L);
//
//        Assertions.assertThrows(RuntimeException.class, () -> productService.deleteProductById(2L));
//
//    }
//
//    @Test
//    public void testGetAllProducts() {
//        Product product1 = Product.builder()
//                .name("Product1")
//                .description("Description1")
//                .price(99.99)
//                .build();
//        Product product2 = Product.builder()
//                .name("Product2")
//                .description("Description2")
//                .price(199.99)
//                .build();
//        when(productRepositoryDB.findAll()).thenReturn(List.of(product1, product2));
//
//        assertThat(productService.getAllProducts()).hasSize(2);
//
//
//    }
//
//
//}
