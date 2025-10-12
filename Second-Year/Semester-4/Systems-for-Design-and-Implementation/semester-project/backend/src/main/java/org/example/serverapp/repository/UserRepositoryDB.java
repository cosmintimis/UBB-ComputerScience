package org.example.serverapp.repository;

import jakarta.annotation.Nullable;
import org.example.serverapp.entity.User;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.Optional;

@Repository
public interface UserRepositoryDB extends JpaRepository<User, Integer>, JpaSpecificationExecutor<User> {

    interface Specs{
        static Specification<User> searchByUsername(@Nullable String username){
            return (root, query, criteriaBuilder) -> username == null ? null :
                    criteriaBuilder.like(criteriaBuilder.lower(root.get("username")), "%" + username.toLowerCase() + "%");
        }

        static Specification<User> birthDateBetween(@Nullable LocalDate startBirthDate, @Nullable LocalDate endBirthDate){
            return (root, query, criteriaBuilder) -> startBirthDate == null || endBirthDate == null ? null :
                    criteriaBuilder.between(root.get("birthdate"), startBirthDate, endBirthDate);
        }

        static Specification<User> sortedByUsername(Specification<User> spec){
            return (root, query, criteriaBuilder) -> {
                query.orderBy(criteriaBuilder.asc(root.get("username")));
                if(spec != null){
                    return criteriaBuilder.and(spec.toPredicate(root, query, criteriaBuilder));
                }
                return criteriaBuilder.conjunction();
            };

        }
    }

    Optional<User> findByUsername(String username);

    Boolean existsByUsername(String username);

    Boolean existsByEmail(String email);
}
