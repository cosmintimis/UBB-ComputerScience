package org.example.serverapp.utils;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import org.example.serverapp.entity.EnumRole;
import org.example.serverapp.entity.Role;
import org.example.serverapp.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Optional;

@Component
public class RoleDeserializer extends JsonDeserializer<Role> {

    @Autowired
    private RoleService roleService;

    @Override
    public Role deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
        String value = p.getText();
        EnumRole enumRole;
        try {
            enumRole = EnumRole.valueOf(value);
        } catch (IllegalArgumentException e) {
            throw new IOException("Invalid role name: " + value);
        }

        Optional<Role> role = roleService.findByName(enumRole);
        if (role.isPresent()) {
            return role.get();
        } else {
            throw new IOException("Role not found: " + value);
        }
    }
}