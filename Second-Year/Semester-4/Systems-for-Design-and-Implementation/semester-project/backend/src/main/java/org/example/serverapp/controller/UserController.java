package org.example.serverapp.controller;

import lombok.AllArgsConstructor;
import org.example.serverapp.dto.UserListWithSizeDto;
import org.example.serverapp.entity.User;
import org.example.serverapp.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.util.Map;

@CrossOrigin("*")
@AllArgsConstructor
@RestController
@RequestMapping("/api/users")
public class UserController {

    private UserService userService;

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<User> addUser(@RequestBody User user) {
        return new ResponseEntity<>(userService.registerUser(user), HttpStatus.CREATED);
    }

    @GetMapping("{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<User> getUserById(@PathVariable Integer id) {
        return ResponseEntity.ok(userService.getUserById(id));
    }

    @GetMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('USER') or hasRole('MANAGER')")
    public ResponseEntity<UserListWithSizeDto> getAllUsers(@RequestParam(required = false) String sortedByUsername,
                                                           @RequestParam(required = false) String searchByUsername,
                                                           @RequestParam(required = false) Integer pageSize,
                                                           @RequestParam(required = false) Integer currentPage,
                                                           @RequestParam(required = false) LocalDate startBirthDate,
                                                           @RequestParam(required = false) LocalDate endBirthDate
                                                           ){

        if(sortedByUsername != null && !sortedByUsername.isEmpty() && (!sortedByUsername.equals("ascending") && !sortedByUsername.equals("descending"))){
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid sortedByUsername parameter");
        }

        if(pageSize != null && currentPage == null){
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "If limit is provided, skip must be provided too");
        }

        if(pageSize == null && currentPage != null){
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "If skip is provided, limit must be provided too");
        }

        if(pageSize != null && (pageSize < 0 || currentPage < 0 || pageSize > 1000)){
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid limit or skip parameter");
        }

        if(startBirthDate == null && endBirthDate != null){
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "If endBirthDate is provided, startBirthDate must be provided too");
        }

        if(startBirthDate != null && endBirthDate == null){
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "If startBirthDate is provided, endBirthDate must be provided too");
        }

        return ResponseEntity.ok(userService.getUserListWithSize(sortedByUsername, searchByUsername, pageSize, currentPage, startBirthDate, endBirthDate));

    }

    @GetMapping("/births-per-year")
    @PreAuthorize("hasRole('ADMIN') or hasRole('USER') or hasRole('MANAGER')")
    public ResponseEntity<Map<Integer, Integer>> getBirthsPerYear() {
        return ResponseEntity.ok(userService.getBirthsPerYear());
    }

    @PutMapping("{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<User> updateUser(@PathVariable Integer id, @RequestBody User updatedUser) {
        return ResponseEntity.ok(userService.updateUser(id, updatedUser));
    }

    @DeleteMapping("{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<String> deleteUser(@PathVariable Integer id) {
        userService.deleteUser(id);
        return ResponseEntity.ok("User with id " + id + " deleted successfully");
    }

}