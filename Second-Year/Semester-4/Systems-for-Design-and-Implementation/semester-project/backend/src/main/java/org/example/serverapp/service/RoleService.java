package org.example.serverapp.service;

import org.example.serverapp.entity.EnumRole;
import org.example.serverapp.entity.Role;
import org.example.serverapp.repository.RoleRepositoryDB;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class RoleService {

    @Autowired
    private RoleRepositoryDB roleRepository;

    public Optional<Role> findByName(EnumRole name) {
        return roleRepository.findByName(name);
    }
}
