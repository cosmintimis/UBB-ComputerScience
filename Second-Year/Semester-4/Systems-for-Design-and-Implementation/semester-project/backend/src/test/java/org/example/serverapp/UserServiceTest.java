//package org.example.serverapp;
//
//
//import org.example.serverapp.dto.UserDto;
//import org.example.serverapp.entity.User;
//import org.example.serverapp.repository.UserRepositoryDB;
//import org.example.serverapp.service.UserService;
//import org.junit.jupiter.api.Assertions;
//import org.junit.jupiter.api.Test;
//import org.junit.jupiter.api.extension.ExtendWith;
//import org.mockito.InjectMocks;
//import org.mockito.Mock;
//import org.mockito.Mockito;
//import org.mockito.junit.jupiter.MockitoExtension;
//
//import java.time.LocalDate;
//import java.util.List;
//import java.util.Optional;
//
//import static org.assertj.core.api.Assertions.assertThat;
//import static org.mockito.Mockito.when;
//
//@ExtendWith(MockitoExtension.class)
//public class UserServiceTest {
//
//    @Mock
//    private UserRepositoryDB userRepositoryDB;
//
//    @InjectMocks
//    private UserService userService;
//
//    @Test
//    public void testAddUser() {
//        User user = User.builder()
//                .id(1)
//                .username("cosmin123")
//                .password("cosmin123")
//                .email("test@gmail.com")
//                .avatar("avatar")
//                .birthdate(LocalDate.now())
//                .rating(0.2)
//                .address("address")
//                .build();
//        UserDto userDto = UserDto.builder()
//                .id(1)
//                .username("cosmin123")
//                .password("cosmin123")
//                .email("test@gmail.com")
//                .avatar("avatar")
//                .birthdate(LocalDate.now())
//                .rating(0.2)
//                .address("address")
//                .build();
//
//        when(userRepositoryDB.save(Mockito.any(User.class))).thenReturn(user);
//
//
//        User savedUser = userService.addUser(user);
//
//        assertThat(savedUser).isNotNull();
//    }
//
//    @Test
//    public void getAllUsers() {
//        User user1 = User.builder()
//                .id(1)
//                .username("cosmin123")
//                .password("cosmin123")
//                .email("test@gmail.com")
//                .avatar("avatar")
//                .birthdate(LocalDate.now())
//                .rating(0.2)
//                .address("address")
//                .build();
//
//        User user2 = User.builder()
//                .id(2)
//                .username("cosmin1234")
//                .password("cosmin1234")
//                .email("test2@gmail.com")
//                .avatar("avatar2")
//                .birthdate(LocalDate.now())
//                .rating(0.22)
//                .address("address2")
//                .build();
//
//        List<User> users = List.of(user1, user2);
//
//        when(userRepositoryDB.findAll()).thenReturn(users);
//
//        List<User> allUsers = userService.getAllUsers();
//
//        assertThat(allUsers).isNotNull();
//        assertThat(allUsers.size()).isEqualTo(2);
//    }
//
//    @Test
//    public void testGetUserById() {
//        User user1 = User.builder()
//                .id(1)
//                .username("cosmin123")
//                .password("cosmin123")
//                .email("test@gmail.com")
//                .avatar("avatar")
//                .birthdate(LocalDate.now())
//                .rating(0.2)
//                .address("address")
//                .build();
//        when(userRepositoryDB.findById(1)).thenReturn(Optional.ofNullable(user1));
//
//        User user = userService.getUserById(1);
//        assertThat(user).isNotNull();
//
//        Assertions.assertThrows(RuntimeException.class, () -> userService.getUserById(2));
//
//    }
//
//    @Test
//    public void testUpdateUser() {
//        User user1 = User.builder()
//                .id(1)
//                .username("cosmin123")
//                .password("cosmin123")
//                .email("test@gmail.com")
//                .avatar("avatar")
//                .birthdate(LocalDate.now())
//                .rating(0.2)
//                .address("address")
//                .build();
//        User userDto = User.builder()
//                .id(1)
//                .username("cosmin1234")
//                .password("cosmin1234")
//                .email("testUpdated@gmail.com")
//                .avatar("avatarUpdated")
//                .birthdate(LocalDate.of(1999, 12, 12))
//                .rating(0.22)
//                .address("addressUpdated")
//                .build();
//
//        when(userRepositoryDB.findById(1)).thenReturn(Optional.ofNullable(user1));
//        when(userRepositoryDB.save(Mockito.any(User.class))).thenReturn(userDto);
//
//        User updatedUser = userService.updateUser(1, userDto);
//
//        assertThat(updatedUser).isNotNull();
//        assertThat(updatedUser.getUsername()).isEqualTo("cosmin1234");
//        assertThat(updatedUser.getPassword()).isEqualTo("cosmin1234");
//        assertThat(updatedUser.getEmail()).isEqualTo("testUpdated@gmail.com");
//        assertThat(updatedUser.getAvatar()).isEqualTo("avatarUpdated");
//        assertThat(updatedUser.getRating()).isEqualTo(0.22);
//        assertThat(updatedUser.getAddress()).isEqualTo("addressUpdated");
//        assertThat(updatedUser.getBirthdate()).isEqualTo(LocalDate.of(1999, 12, 12));
//
//        Assertions.assertThrows(RuntimeException.class, () -> userService.updateUser(2, user1));
//
//    }
//
//
//    @Test
//    public void testDeleteUser() {
//        User user1 = User.builder()
//                .id(1)
//                .username("cosmin123")
//                .password("cosmin123")
//                .email("test@gmail.com")
//                .avatar("avatar")
//                .birthdate(LocalDate.now())
//                .rating(0.2)
//                .address("address")
//                .build();
//        when(userRepositoryDB.findById(1)).thenReturn(Optional.ofNullable(user1));
//
//        userService.deleteUser(1);
//
//        Assertions.assertThrows(RuntimeException.class, () -> userService.deleteUser(2));
//
//    }
//
//    @Test
//    public void testGetBirthsPerYear() {
//        User user1 = User.builder()
//                .id(1)
//                .username("cosmin123")
//                .password("cosmin123")
//                .email("test@gmail.com")
//                .avatar("avatar")
//                .birthdate(LocalDate.of(2000, 1, 1))
//                .rating(0.2)
//                .address("address")
//                .build();
//
//        User user2 = User.builder()
//                .id(2)
//                .username("cosmin1234")
//                .password("cosmin1234")
//                .email("test2@gmail.com")
//                .avatar("avatar2")
//                .birthdate(LocalDate.of(2003, 2, 2))
//                .rating(0.22)
//                .address("address2")
//                .build();
//
//        when(userRepositoryDB.findAll()).thenReturn(List.of(user1, user2));
//
//        assertThat(userService.getBirthsPerYear().size()).isEqualTo(2);
//        assertThat(userService.getBirthsPerYear().get(2000)).isEqualTo(1);
//        assertThat(userService.getBirthsPerYear().get(2003)).isEqualTo(1);
//    }
//
//
//    @Test
//    public void testGetUsersBetweenTwoDates() {
//        User user1 = User.builder()
//                .id(1)
//                .username("cosmin123")
//                .password("cosmin123")
//                .email("test@gmail.com")
//                .avatar("avatar")
//                .birthdate(LocalDate.of(2000, 1, 1))
//                .rating(0.2)
//                .address("address")
//                .build();
//
//        User user2 = User.builder()
//                .id(2)
//                .username("cosmin1234")
//                .password("cosmin1234")
//                .email("test2@gmail.com")
//                .avatar("avatar2")
//                .birthdate(LocalDate.of(2003, 2, 2))
//                .rating(0.22)
//                .address("address2")
//                .build();
//
//        when(userRepositoryDB.findAll()).thenReturn(List.of(user1, user2));
//
//        assertThat(userService.getUserListWithSize(null, null, null, null, LocalDate.of(2000, 1, 1), LocalDate.of(2003, 2, 2)).getSize()).isEqualTo(2);
//
//        assertThat(userService.getUserListWithSize(null, null, null, null, LocalDate.of(2006, 1, 1), LocalDate.of(2007, 2, 2)).getSize()).isEqualTo(0);
//
//        assertThat(userService.getUserListWithSize(null, null, null, null, LocalDate.of(2001, 1, 1), LocalDate.of(2003, 2, 2)).getSize()).isEqualTo(1);
//
//        assertThat(userService.getUserListWithSize(null, null, null, null, LocalDate.of(2000, 1, 1), LocalDate.of(2002, 2, 2)).getSize()).isEqualTo(1);
//
//
//
//    }
//
//
//    @Test
//    public void testGetSearchedUsersByUsername() {
//        User user1 = User.builder()
//                .id(1)
//                .username("cosmin timis")
//                .password("cosmin123")
//                .email("test@gmail.com")
//                .avatar("avatar")
//                .birthdate(LocalDate.of(2000, 1, 1))
//                .rating(0.2)
//                .address("address")
//                .build();
//
//        User user2 = User.builder()
//                .id(2)
//                .username("alexandru timis")
//                .password("cosmin1234")
//                .email("test2@gmail.com")
//                .avatar("avatar2")
//                .birthdate(LocalDate.of(2003, 2, 2))
//                .rating(0.22)
//                .address("address2")
//                .build();
//
//        when(userRepositoryDB.findAll()).thenReturn(List.of(user1, user2));
//
//        assertThat(userService.getUserListWithSize(null, "cosmin", null, null, null, null).getSize()).isEqualTo(1);
//        assertThat(userService.getUserListWithSize(null, "alexandru", null, null, null, null).getSize()).isEqualTo(1);
//        assertThat(userService.getUserListWithSize(null, "nimsoc", null, null, null, null).getSize()).isEqualTo(0);
//        assertThat(userService.getUserListWithSize(null, "timis", null, null, null, null).getSize()).isEqualTo(2);
//    }
//
//    @Test
//    public void testGetSortedUsersByUsername() {
//        User user1 = User.builder()
//                .id(1)
//                .username("cosmin timis")
//                .password("cosmin123")
//                .email("test@gmail.com")
//                .avatar("avatar")
//                .birthdate(LocalDate.of(2000, 1, 1))
//                .rating(0.2)
//                .address("address")
//                .build();
//
//        User user2 = User.builder()
//                .id(2)
//                .username("roberto pitic")
//                .password("roberto1234")
//                .email("test2@gmail.com")
//                .avatar("avatar2")
//                .birthdate(LocalDate.of(2003, 2, 2))
//                .rating(0.22)
//                .address("address2")
//                .build();
//
//        when(userRepositoryDB.findAll()).thenReturn(List.of(user1, user2));
//
//        assertThat(userService.getUserListWithSize("ascending", null, null, null, null, null).getUsers().get(0).getUsername()).isEqualTo("cosmin timis");
//        assertThat(userService.getUserListWithSize("descending", null, null, null, null, null).getUsers().get(0).getUsername()).isEqualTo("roberto pitic");
//
//    }
//
//    @Test
//    public void testGetUsersWithLimitAndSkip(){
//        User user1 = User.builder()
//                .id(1)
//                .username("cosmin timis")
//                .password("cosmin123")
//                .email("test@gmail.com")
//                .avatar("avatar")
//                .birthdate(LocalDate.of(2000, 1, 1))
//                .rating(0.2)
//                .address("address")
//                .build();
//
//        User user2 = User.builder()
//                .id(2)
//                .username("roberto pitic")
//                .password("roberto1234")
//                .email("test2@gmail.com")
//                .avatar("avatar2")
//                .birthdate(LocalDate.of(2003, 2, 2))
//                .rating(0.22)
//                .address("address2")
//                .build();
//
//        when(userRepositoryDB.findAll()).thenReturn(List.of(user1, user2));
//
//
//        assertThat(userService.getUserListWithSize(null, null, 1, 0, null, null).getUsers().size()).isEqualTo(1);
//        assertThat(userService.getUserListWithSize(null, null, 1, 1, null, null).getUsers().size()).isEqualTo(1);
//        assertThat(userService.getUserListWithSize(null, null, 1, 2, null, null).getUsers().size()).isEqualTo(0);
//        assertThat(userService.getUserListWithSize(null, null, 2, 0, null, null).getUsers().size()).isEqualTo(2);
//
//    }
//
//
//
//}
