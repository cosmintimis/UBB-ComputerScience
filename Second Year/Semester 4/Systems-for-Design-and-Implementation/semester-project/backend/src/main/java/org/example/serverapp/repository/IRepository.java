package org.example.serverapp.repository;

import java.util.List;

public interface IRepository<EntityType, IdType> {
    EntityType getById(IdType id);

    void add(EntityType t);

    EntityType update(IdType id, EntityType t);

    void delete(IdType id);

    boolean existsById(IdType id);

    int count();

    List<EntityType> getAll();
}