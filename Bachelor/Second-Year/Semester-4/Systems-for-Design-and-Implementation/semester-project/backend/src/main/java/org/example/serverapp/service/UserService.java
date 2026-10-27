package org.example.serverapp.service;

import com.github.javafaker.Faker;
import org.example.serverapp.dto.UserListWithSizeDto;
import org.example.serverapp.entity.User;
import org.example.serverapp.repository.RoleRepositoryDB;
import org.example.serverapp.repository.UserRepositoryDB;
import org.example.serverapp.validation.UserValidation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.*;

@Service
public class UserService {
    private final UserRepositoryDB userRepositoryDB;

    @Autowired
    private RoleRepositoryDB roleRepository;

    @Autowired
    private PasswordEncoder encoder;

    @Autowired
    public UserService(UserRepositoryDB userRepositoryDB, RoleRepositoryDB roleRepositoryDB, PasswordEncoder passwordEncoder) {
        this.userRepositoryDB = userRepositoryDB;
        this.roleRepository = roleRepositoryDB;
        this.encoder = passwordEncoder;
    }

    public User registerUser(User user) {
        UserValidation.validate(user);

        if (userRepositoryDB.existsByUsername(user.getUsername())) {
            throw new IllegalArgumentException("Username is already taken!");
        }


        if (userRepositoryDB.existsByEmail(user.getEmail())) {
            throw new IllegalArgumentException("Email is already in use!");
        }

        user.setPassword(encoder.encode(user.getPassword()));

        userRepositoryDB.save(user);
        return user;
    }

    public User getUserById(Integer id) {
        Optional<User> userOptional = userRepositoryDB.findById(id);
        if (userOptional.isPresent()) {
            return userOptional.get();
        }
        throw new RuntimeException("User with id " + id + " not found");

    }

    public List<User> getAllUsers() {
        return userRepositoryDB.findAll();
    }

    public UserListWithSizeDto getUserListWithSize(String sortedByUsername, String searchByUsername, Integer pageSize, Integer currentPage, LocalDate startBirthDate, LocalDate endBirthDate) {
        Specification<User> spec = null;

        if (startBirthDate != null || endBirthDate != null) {
            spec = UserRepositoryDB.Specs.birthDateBetween(startBirthDate, endBirthDate);
        }

        if (searchByUsername != null) {
            if (spec == null) {
                spec = UserRepositoryDB.Specs.searchByUsername(searchByUsername);
            } else {
                spec = spec.and(UserRepositoryDB.Specs.searchByUsername(searchByUsername));
            }
        }

        if (sortedByUsername != null) {
            if (sortedByUsername.equals("ascending")) {
                if (spec == null) {
                    spec = UserRepositoryDB.Specs.sortedByUsername(null);
                } else {
                    spec = UserRepositoryDB.Specs.sortedByUsername(spec);
                }
            }
        }
        if (spec == null) {
            spec = Specification.where(null);
        }

        if (pageSize != null && currentPage != null) {
            Pageable pageable = PageRequest.of(currentPage, pageSize);
            List<User> users = userRepositoryDB.findAll(spec, pageable).toList();
            long size = userRepositoryDB.count(spec);
            return new UserListWithSizeDto(users, size);
        }

        List<User> users = userRepositoryDB.findAll(spec);
        long size = userRepositoryDB.count(spec);
        return new UserListWithSizeDto(users, size);
    }


    public User updateUser(Integer id, User updatedUser) {

        Optional<User> userOptional = userRepositoryDB.findById(id);
        if (userOptional.isPresent()) {

            String userPassword = userOptional.get().getPassword();
            updatedUser.setPassword(userPassword);

            UserValidation.validate(updatedUser);
            User user = userOptional.get();

            user.setUsername(updatedUser.getUsername());
            user.setPassword(updatedUser.getPassword());
            user.setEmail(updatedUser.getEmail());
            user.setAvatar(updatedUser.getAvatar());
            user.setBirthdate(updatedUser.getBirthdate());
            user.setRating(updatedUser.getRating());
            user.setAddress(updatedUser.getAddress());
            user.setRoles(updatedUser.getRoles());

            userRepositoryDB.save(user);
            return user;
        }
        throw new RuntimeException("User with id " + id + " not found");


    }

    public void deleteUser(Integer id) {
        if (userRepositoryDB.findById(id).isEmpty()) {
            throw new RuntimeException("User with id " + id + " not found");
        }
        userRepositoryDB.deleteById(id);
    }

    public Map<Integer, Integer> getBirthsPerYear() {
        Map<Integer, Integer> birthsPerYear = new TreeMap<>();
        List<User> users = userRepositoryDB.findAll(
                Sort.by(Sort.Order.asc("birthdate")) //
        );

        for (User user : users) {
            if (user.getBirthdate() == null) {
                continue;
            }
            int year = user.getBirthdate().getYear();
            if (birthsPerYear.containsKey(year)) {
                birthsPerYear.put(year, birthsPerYear.get(year) + 1);
            } else {
                birthsPerYear.put(year, 1);
            }
        }

        return birthsPerYear;

    }
}
