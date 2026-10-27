//package org.example.serverapp.mapper;
//
//import org.example.serverapp.dto.UserDto;
//import org.example.serverapp.entity.User;
//
//public class UserMapper {
//    public static UserDto mapToUserDto(User user) {
//        return new UserDto(
//                user.getId(),
//                user.getUsername(),
//                user.getPassword(),
//                user.getEmail(),
//                user.getAvatar(),
//                user.getBirthdate(),
//                user.getRating(),
//                user.getAddress(),
//                user.getProducts().stream().map(ProductMapper::mapToProductDto).toList()
//                );
//    }
//
//    public static User mapToUser(UserDto userDto) {
//        return new User(
//                userDto.getId(),
//                userDto.getUsername(),
//                userDto.getPassword(),
//                userDto.getEmail(),
//                userDto.getAvatar(),
//                userDto.getBirthdate(),
//                userDto.getRating(),
//                userDto.getAddress(),
//                userDto.getProducts().stream().map(ProductMapper::mapToProduct).toList()
//        );
//    }
//}
