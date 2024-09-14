package org.example.serverapp.repository;

import org.example.serverapp.entity.Product;

import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductRepositoryDB extends JpaRepository<Product, Long> {
}
