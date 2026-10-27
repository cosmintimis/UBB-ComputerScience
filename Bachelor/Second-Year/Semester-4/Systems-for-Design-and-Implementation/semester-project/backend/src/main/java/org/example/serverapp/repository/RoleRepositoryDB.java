package org.example.serverapp.repository;

import org.example.serverapp.entity.EnumRole;
import org.example.serverapp.entity.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

public interface RoleRepositoryDB extends JpaRepository<Role, Long> {
    Optional<Role> findByName(EnumRole name);

    @Modifying
    @Transactional
    @Query(value = "INSERT INTO user_roles (user_id, role_id) VALUES (:userId, :roleId)", nativeQuery = true)
    void mapRoleToUser(Integer userId, Long roleId);

}