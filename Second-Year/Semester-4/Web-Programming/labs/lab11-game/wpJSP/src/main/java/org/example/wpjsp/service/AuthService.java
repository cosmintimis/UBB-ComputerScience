package org.example.wpjsp.service;

import org.example.wpjsp.model.User;
import org.example.wpjsp.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class AuthService {

    @Autowired
    private final UserRepository userRepository;

    public AuthService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User authenticate(String username, String password) {
        Optional<Long> id = userRepository.findIdByUsernameAndPassword(username, password);

        if (id.isPresent()) {
            return userRepository.findById(id.get()).get();
        }
        return null;
    }
}
