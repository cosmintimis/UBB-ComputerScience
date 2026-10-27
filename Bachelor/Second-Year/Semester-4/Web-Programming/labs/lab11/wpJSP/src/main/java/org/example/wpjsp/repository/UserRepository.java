package org.example.wpjsp.repository;

import org.example.wpjsp.model.User;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface UserRepository extends CrudRepository<User, Long> {
    @Query("SELECT u.id FROM User u WHERE u.username = :username AND u.password = :password")
    Optional<Long> findIdByUsernameAndPassword(@Param("username") String username, @Param("password") String password);
}
