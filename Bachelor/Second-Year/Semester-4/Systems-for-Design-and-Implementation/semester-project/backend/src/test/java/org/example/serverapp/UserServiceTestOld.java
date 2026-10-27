//package org.example.serverapp;
//
//import org.example.serverapp.dto.UserDto;
//import org.example.serverapp.repository.UserRepository;
//import org.example.serverapp.service.UserService;
//import org.junit.jupiter.api.Test;
//
//import java.time.LocalDate;
//import java.util.Map;
//
//import static org.assertj.core.api.Assertions.*;
//
//
//public class UserServiceTestOld {
//
//
//
//    @Test
//    public void testGetUsersBetweenTwoDates(){
//        final UserRepository userRepository = new UserRepository();
//        final UserService userService = new UserService(userRepository);
//
//        LocalDate startDate = LocalDate.of(2009,1,1);
//        LocalDate endDate = LocalDate.of(2009, 12, 31);
//
//        assertThat(userService.getUserListWithSize(null, null, null, null, startDate, endDate).getSize()).isEqualTo(1);
//    }
//
//    @Test
//    public void testGetSearchedUsersByUsername(){
//        final UserRepository userRepository = new UserRepository();
//        final UserService userService = new UserService(userRepository);
//
//        assertThat(userService.getUserListWithSize(null, "cosmin", null, null, null, null).getSize()).isEqualTo(1);
//        assertThat(userService.getUserListWithSize(null, "pop", null, null, null, null).getSize()).isEqualTo(6);
//
//    }
//
//    @Test
//    public void testGetSortedUsersByUsername(){
//        final UserRepository userRepository = new UserRepository();
//        final UserService userService = new UserService(userRepository);
//
//        assertThat(userService.getUserListWithSize("ascending", null, null, null, null, null).getUsers().get(0).getUsername()).isEqualTo("Alex Popescu");
//        assertThat(userService.getUserListWithSize("descending", null, null, null, null, null).getUsers().get(0).getUsername()).isEqualTo("Roberto Pitic");
//    }
//
//    @Test
//    public void testGetUsersWithLimitAndSkip(){
//        final UserRepository userRepository = new UserRepository();
//        final UserService userService = new UserService(userRepository);
//
//        assertThat(userService.getUserListWithSize(null, null, 3, 0, null, null).getUsers().size()).isEqualTo(3);
//        assertThat(userService.getUserListWithSize(null, null, 3, 0, null, null).getUsers().get(0).getUsername()).isEqualTo("Cosmin Timis");
//
//        assertThat(userService.getUserListWithSize(null, null, 3, 3, null, null).getUsers().size()).isEqualTo(3);
//        assertThat(userService.getUserListWithSize(null, null, 3, 3, null, null).getUsers().get(0).getUsername()).isEqualTo("Mihai Pop");
//
//        assertThat(userService.getUserListWithSize(null, null, 3, 6, null, null).getUsers().size()).isEqualTo(3);
//        assertThat(userService.getUserListWithSize(null, null, 3, 6, null, null).getUsers().get(0).getUsername()).isEqualTo("Dan Pop");
//
//        assertThat(userService.getUserListWithSize(null, null, 3, 9, null, null).getUsers().size()).isEqualTo(2);
//        assertThat(userService.getUserListWithSize(null, null, 3, 9, null, null).getUsers().get(0).getUsername()).isEqualTo("Codrut Hojda");
//
//        assertThat(userService.getUserListWithSize(null, null, 3, 12, null, null).getUsers().size()).isEqualTo(0);
//    }
//
//
//    @Test
//    public void testGetBirthsPerYear() {
//        final UserRepository userRepository = new UserRepository();
//        final UserService userService = new UserService(userRepository);
//
//        Map<Integer, Integer> birthsPerYear = userService.getBirthsPerYear();
//
//        assertThat(birthsPerYear.get(2003)).isEqualTo(6);
//        assertThat(birthsPerYear.get(2004)).isEqualTo(3);
//        assertThat(birthsPerYear.get(2009)).isEqualTo(1);
//        assertThat(birthsPerYear.get(2006)).isEqualTo(1);
//
//    }
//
//
//    @Test
//    public void testAddUser() {
//        final UserRepository userRepository = new UserRepository();
//        final UserService userService = new UserService(userRepository);
//
//        int currentSize = userService.getUserListWithSize().size();
//
//        UserDto newUserDto = new UserDto(userRepository.firstFreeId(), "test2024", "test2024", "test2024", "test2024", null, 0.1, "test2024");
//
//        assertThatThrownBy(() -> userService.addUser(newUserDto))
//                .isInstanceOf(Exception.class);
//
//        UserDto goodUserDto = new UserDto(
//                userRepository.firstFreeId(),
//                "cosmin alexandru",
//                "testing123",
//                "t@t.com",
//                "test",
//                LocalDate.of(2024, 1, 1),
//                1.7,
//                "address test"
//        );
//
//        userService.addUser(goodUserDto);
//        assertThat(userService.getUserListWithSize().size()).isEqualTo(currentSize + 1);
//
//        UserDto invalidUsername = new UserDto(
//                userRepository.firstFreeId(),
//                "",
//                "testing123",
//                "t@t.com",
//                "test",
//                LocalDate.of(2024, 1, 1),
//                1.7,
//                "address test");
//        UserDto invalidPassword = new UserDto(
//                userRepository.firstFreeId(),
//                "cosmin alexandru",
//                "",
//                "t@t.com",
//                "test",
//                LocalDate.of(2024, 1, 1),
//                1.7,
//                "address test");
//        UserDto invalidEmail = new UserDto(
//                userRepository.firstFreeId(),
//                "cosmin alexandru",
//                "testing123",
//                "",
//                "test",
//                LocalDate.of(2024, 1, 1),
//                1.7,
//                "address test");
//        UserDto invalidAvatar = new UserDto(
//                userRepository.firstFreeId(),
//                "cosmin alexandru",
//                "testing123",
//                "t@t.com",
//                "",
//                LocalDate.of(2024, 1, 1),
//                1.7,
//                "address test");
//        UserDto invalidBirthdate = new UserDto(
//                userRepository.firstFreeId(),
//                "cosmin alexandru",
//                "testing123",
//                "t@t.com",
//                "test",
//                null,
//                1.7,
//                "address test");
//        UserDto invalidRating = new UserDto(
//                userRepository.firstFreeId(),
//                "cosmin alexandru",
//                "testing123",
//                "t@t.com",
//                "test",
//                LocalDate.of(2024, 1, 1),
//                11.0,
//                "address test");
//        UserDto invalidAddress = new UserDto(
//                userRepository.firstFreeId(),
//                "cosmin alexandru",
//                "testing123",
//                "t@t.com",
//                "test",
//                LocalDate.of(2024, 1, 1),
//                1.7,
//                "");
//
//        assertThatThrownBy(() -> userService.addUser(invalidUsername))
//                .isInstanceOf(Exception.class)
//                .hasMessage("Username must be at least 6 characters long");
//        assertThatThrownBy(() -> userService.addUser(invalidPassword))
//                .isInstanceOf(Exception.class)
//                .hasMessage("Password must be at least 6 characters long");
//        assertThatThrownBy(() -> userService.addUser(invalidEmail))
//                .isInstanceOf(Exception.class)
//                .hasMessage("Invalid email address");
//        assertThatThrownBy(() -> userService.addUser(invalidAvatar))
//                .isInstanceOf(Exception.class)
//                .hasMessage("Avatar must be at least 1 character long");
//        assertThatThrownBy(() -> userService.addUser(invalidBirthdate))
//                .isInstanceOf(Exception.class)
//                .hasMessage("Birthdate must be set");
//        assertThatThrownBy(() -> userService.addUser(invalidRating))
//                .isInstanceOf(Exception.class)
//                .hasMessage("Rating must be between 0 and 10");
//        assertThatThrownBy(() -> userService.addUser(invalidAddress))
//                .isInstanceOf(Exception.class)
//                .hasMessage("Address must be at least 1 character long");
//
//    }
//
//    @Test
//    public void testGetUserById() {
//        final UserRepository userRepository = new UserRepository();
//        final UserService userService = new UserService(userRepository);
//
//        UserDto firstUser = userService.getUserById(1);
//
//        assertThat(firstUser.getId()).isEqualTo(1);
//        assertThat(firstUser.getUsername()).isEqualTo("Cosmin Timis");
//        assertThat(firstUser.getPassword()).isEqualTo("parolaaiabuna");
//        assertThat(firstUser.getEmail()).isEqualTo("cosmin.timis@gmail.com");
//        assertThat(firstUser.getAvatar()).isEqualTo("https://robohash.org/e5a84795597420d98d606433f8ad1f70?set=set4&bgset=&size=400x400");
//        assertThat(firstUser.getBirthdate()).isEqualTo(LocalDate.parse("2003-01-01"));
//        assertThat(firstUser.getRating()).isEqualTo(8.8);
//        assertThat(firstUser.getAddress()).isEqualTo("address1");
//
//
//        assertThatThrownBy(() -> userService.getUserById(100))
//                .isInstanceOf(Exception.class)
//                .hasMessage("User with id 100 not found");
//    }
//
//    @Test
//    public void testGetAllUsers() {
//        final UserRepository userRepository = new UserRepository();
//        final UserService userService = new UserService(userRepository);
//
//        assertThat(userService.getUserListWithSize().size()).isEqualTo(11);
//    }
//
//    @Test
//    public void testDeleteUser() {
//        final UserRepository userRepository = new UserRepository();
//        final UserService userService = new UserService(userRepository);
//
//        int currentSize = userService.getUserListWithSize().size();
//
//        assertThatThrownBy(() -> userService.deleteUser(100))
//                .isInstanceOf(Exception.class)
//                .hasMessage("User with id 100 not found");
//
//        userService.deleteUser(1);
//
//        assertThat(userService.getUserListWithSize().size()).isEqualTo(currentSize - 1);
//    }
//
//    @Test
//    public void testUpdateUser() {
//        final UserRepository userRepository = new UserRepository();
//        final UserService userService = new UserService(userRepository);
//
//        UserDto firstUser = userService.getUserById(1);
//
//        UserDto updateUserInvalidUsername = new UserDto(
//                firstUser.getId(),
//                "",
//                firstUser.getPassword(),
//                firstUser.getEmail(),
//                firstUser.getAvatar(),
//                firstUser.getBirthdate(),
//                firstUser.getRating(),
//                firstUser.getAddress()
//        );
//        UserDto updateUserInvalidPassword = new UserDto(
//                firstUser.getId(),
//                firstUser.getUsername(),
//                "",
//                firstUser.getEmail(),
//                firstUser.getAvatar(),
//                firstUser.getBirthdate(),
//                firstUser.getRating(),
//                firstUser.getAddress()
//        );
//        UserDto updateUserInvalidEmail = new UserDto(
//                firstUser.getId(),
//                firstUser.getUsername(),
//                firstUser.getPassword(),
//                "",
//                firstUser.getAvatar(),
//                firstUser.getBirthdate(),
//                firstUser.getRating(),
//                firstUser.getAddress()
//        );
//        UserDto updateUserInvalidAvatar = new UserDto(
//                firstUser.getId(),
//                firstUser.getUsername(),
//                firstUser.getPassword(),
//                firstUser.getEmail(),
//                "",
//                firstUser.getBirthdate(),
//                firstUser.getRating(),
//                firstUser.getAddress()
//        );
//        UserDto updateUserInvalidBirthdate = new UserDto(
//                firstUser.getId(),
//                firstUser.getUsername(),
//                firstUser.getPassword(),
//                firstUser.getEmail(),
//                firstUser.getAvatar(),
//                null,
//                firstUser.getRating(),
//                firstUser.getAddress()
//        );
//        UserDto updateUserInvalidRating = new UserDto(
//                firstUser.getId(),
//                firstUser.getUsername(),
//                firstUser.getPassword(),
//                firstUser.getEmail(),
//                firstUser.getAvatar(),
//                firstUser.getBirthdate(),
//                11.0,
//                firstUser.getAddress()
//        );
//        UserDto updateUserInvalidAddress = new UserDto(
//                firstUser.getId(),
//                firstUser.getUsername(),
//                firstUser.getPassword(),
//                firstUser.getEmail(),
//                firstUser.getAvatar(),
//                firstUser.getBirthdate(),
//                firstUser.getRating(),
//                ""
//        );
//
//        assertThatThrownBy(() -> userService.updateUser(firstUser.getId(), updateUserInvalidUsername))
//                .isInstanceOf(Exception.class)
//                .hasMessage("Username must be at least 6 characters long");
//
//        assertThatThrownBy(() -> userService.updateUser(firstUser.getId(), updateUserInvalidPassword))
//                .isInstanceOf(Exception.class)
//                .hasMessage("Password must be at least 6 characters long");
//
//        assertThatThrownBy(() -> userService.updateUser(firstUser.getId(), updateUserInvalidEmail))
//                .isInstanceOf(Exception.class)
//                .hasMessage("Invalid email address");
//
//        assertThatThrownBy(() -> userService.updateUser(firstUser.getId(), updateUserInvalidAvatar))
//                .isInstanceOf(Exception.class)
//                .hasMessage("Avatar must be at least 1 character long");
//
//        assertThatThrownBy(() -> userService.updateUser(firstUser.getId(), updateUserInvalidBirthdate))
//                .isInstanceOf(Exception.class)
//                .hasMessage("Birthdate must be set");
//
//        assertThatThrownBy(() -> userService.updateUser(firstUser.getId(), updateUserInvalidRating))
//                .isInstanceOf(Exception.class)
//                .hasMessage("Rating must be between 0 and 10");
//
//        assertThatThrownBy(() -> userService.updateUser(firstUser.getId(), updateUserInvalidAddress))
//                .isInstanceOf(Exception.class)
//                .hasMessage("Address must be at least 1 character long");
//
//        UserDto updateUser = new UserDto(
//                firstUser.getId(),
//                "alexandru horj",
//                "parolabuna",
//                "test@gmail.ro",
//                "avatarnou",
//                LocalDate.of(2000, 1, 1),
//                9.9,
//                "adresanoua");
//
//
//        userService.updateUser(firstUser.getId(), updateUser);
//        UserDto firstUserUpdated = userService.getUserById(1);
//
//        assertThat(firstUserUpdated.getId()).isEqualTo(1);
//        assertThat(firstUserUpdated.getUsername()).isEqualTo("alexandru horj");
//        assertThat(firstUserUpdated.getPassword()).isEqualTo("parolabuna");
//        assertThat(firstUserUpdated.getEmail()).isEqualTo("test@gmail.ro");
//        assertThat(firstUserUpdated.getAvatar()).isEqualTo("avatarnou");
//        assertThat(firstUserUpdated.getBirthdate()).isEqualTo(LocalDate.of(2000, 1, 1));
//        assertThat(firstUserUpdated.getRating()).isEqualTo(9.9);
//        assertThat(firstUserUpdated.getAddress()).isEqualTo("adresanoua");
//
//
//
//    }
//
//
//}
