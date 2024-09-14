package org.example.serverapp.validation;
import org.example.serverapp.entity.User;


public class UserValidation {


    private static final String EMAIL_REGEX = "^[\\w!#$%&'*+/=?^`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^`{|}~-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,}$";
    public static void validate(User user){

        if(user.getUsername().length() < 6)
            throw new RuntimeException("Username must be at least 6 characters long");

        if(user.getPassword().length() < 6)
            throw new RuntimeException("Password must be at least 6 characters long");

        if(!user.getEmail().matches(EMAIL_REGEX))
            throw new RuntimeException("Invalid email address");

        if(user.getAvatar().isEmpty())
            throw new RuntimeException("Avatar must be at least 1 character long");

        if(user.getRating() < 0 || user.getRating() > 10)
            throw new RuntimeException("Rating must be between 0 and 10");

        if(user.getAddress().isEmpty())
            throw new RuntimeException("Address must be at least 1 character long");

        if(user.getBirthdate() == null)
            throw new RuntimeException("Birthdate must be set");

    }
}
