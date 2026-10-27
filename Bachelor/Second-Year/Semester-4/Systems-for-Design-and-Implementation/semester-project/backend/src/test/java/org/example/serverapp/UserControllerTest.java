//package org.example.serverapp;
//
//
//import org.example.serverapp.controller.UserController;
//import org.example.serverapp.dto.UserDto;
//import org.example.serverapp.dto.UserListWithSizeDto;
//import org.example.serverapp.entity.User;
//import org.example.serverapp.service.UserService;
//import org.hamcrest.Matchers;
//import org.junit.jupiter.api.Test;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
//import org.springframework.boot.test.mock.mockito.MockBean;
//import org.springframework.test.web.servlet.MockMvc;
//import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
//import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
//
//import java.time.LocalDate;
//import java.util.List;
//
//import static org.junit.jupiter.api.Assertions.assertNotNull;
//import static org.mockito.ArgumentMatchers.any;
//import static org.mockito.ArgumentMatchers.eq;
//import static org.mockito.Mockito.*;
//
//@WebMvcTest(UserController.class)
//class UserControllerTest {
//
//    @MockBean
//    private UserService userService;
//
//    @Autowired
//    private MockMvc mockMvc;
//
//    @Test
//    void shouldCreateMockMvc() {
//        assertNotNull(mockMvc);
//    }
//
//    @Test
//    void testGetAll() throws Exception {
//        User user1 =  new User(1, "Cosmin Timis", "parolaaiabuna", "cosmin.timis@gmail.com", "https://robohash.org/e5a84795597420d98d606433f8ad1f70?set=set4&bgset=&size=400x400",
//                LocalDate.parse("2003-01-01"), 8.8, "address1", null);
//        when(userService.getUserListWithSize(null, null, null, null, null, null)).thenReturn(new UserListWithSizeDto(List.of(user1), 1));
//
//        mockMvc.perform(MockMvcRequestBuilders.get("/api/users"))
//                .andExpect(MockMvcResultMatchers.status().isOk())
//                .andExpect(MockMvcResultMatchers.jsonPath("$.size()", Matchers.is(2)))
//                .andExpect(MockMvcResultMatchers.jsonPath("$.users[0].id", Matchers.is(1)))
//                .andExpect(MockMvcResultMatchers.jsonPath("$.users[0].username", Matchers.is("Cosmin Timis")))
//                .andExpect(MockMvcResultMatchers.jsonPath("$.users[0].password", Matchers.is("parolaaiabuna")))
//                .andExpect(MockMvcResultMatchers.jsonPath("$.users[0].email", Matchers.is("cosmin.timis@gmail.com")))
//                .andExpect(MockMvcResultMatchers.jsonPath("$.users[0].avatar", Matchers.is("https://robohash.org/e5a84795597420d98d606433f8ad1f70?set=set4&bgset=&size=400x400")))
//                .andExpect(MockMvcResultMatchers.jsonPath("$.users[0].birthdate", Matchers.is("2003-01-01")))
//                .andExpect(MockMvcResultMatchers.jsonPath("$.users[0].rating", Matchers.is(8.8)))
//                .andExpect(MockMvcResultMatchers.jsonPath("$.users[0].address", Matchers.is("address1")))
//                .andExpect(MockMvcResultMatchers.jsonPath("$.size", Matchers.is(1)));
//
//
//        mockMvc.perform(MockMvcRequestBuilders.get("/api/users?sortedByUsername=&searchByUsername=&limit=&skip="))
//                .andExpect(MockMvcResultMatchers.status().isOk());
//
//        mockMvc.perform(MockMvcRequestBuilders.get("/api/users?sortedByUsername=ascending&searchByUsername=&limit=&skip="))
//                .andExpect(MockMvcResultMatchers.status().isOk());
//
//        mockMvc.perform(MockMvcRequestBuilders.get("/api/users?sortedByUsername=descending&searchByUsername=&limit=&skip="))
//                .andExpect(MockMvcResultMatchers.status().isOk());
//
//        mockMvc.perform(MockMvcRequestBuilders.get("/api/users?sortedByUsername=random&searchByUsername=&limit=&skip="))
//                .andExpect(MockMvcResultMatchers.status().isBadRequest());
//
//
//        mockMvc.perform(MockMvcRequestBuilders.get("/api/users?sortedByUsername=&searchByUsername=&limit=2&skip=2"))
//                .andExpect(MockMvcResultMatchers.status().isOk());
//
//        mockMvc.perform(MockMvcRequestBuilders.get("/api/users?sortedByUsername=&searchByUsername=&limit=&skip=2"))
//                .andExpect(MockMvcResultMatchers.status().isBadRequest());
//
//        mockMvc.perform(MockMvcRequestBuilders.get("/api/users?sortedByUsername=&searchByUsername=&limit=2&skip="))
//                .andExpect(MockMvcResultMatchers.status().isBadRequest());
//
//        mockMvc.perform(MockMvcRequestBuilders.get("/api/users?sortedByUsername=&searchByUsername=&limit=-2&skip=2"))
//                .andExpect(MockMvcResultMatchers.status().isBadRequest());
//
//        mockMvc.perform(MockMvcRequestBuilders.get("/api/users?sortedByUsername=&searchByUsername=&limit=2&skip=-2"))
//                .andExpect(MockMvcResultMatchers.status().isBadRequest());
//
//        mockMvc.perform(MockMvcRequestBuilders.get("/api/users?sortedByUsername=&searchByUsername=&limit=10000&skip=2"))
//                .andExpect(MockMvcResultMatchers.status().isBadRequest());
//
//
//
//    }
//
//    @Test
//    void testGetById() throws Exception {
//        User user2 =  new User(2, "Roberto Pitic", "parola2", "roberto.pitic@gmail.com", "https://robohash.org/123a37a18fdbba6a742e7446c8166393?set=set4&bgset=&size=400x400",
//                LocalDate.parse("2004-01-01"), 9.4, "address2", null);
//        when(userService.getUserById(2)).thenReturn(user2);
//        mockMvc.perform(MockMvcRequestBuilders.get("/api/users/2"))
//                .andExpect(MockMvcResultMatchers.status().isOk())
//                .andExpect(MockMvcResultMatchers.jsonPath("$.id", Matchers.is(2)))
//                .andExpect(MockMvcResultMatchers.jsonPath("$.username", Matchers.is("Roberto Pitic")))
//                .andExpect(MockMvcResultMatchers.jsonPath("$.password", Matchers.is("parola2")))
//                .andExpect(MockMvcResultMatchers.jsonPath("$.email", Matchers.is("roberto.pitic@gmail.com")))
//                .andExpect(MockMvcResultMatchers.jsonPath("$.avatar", Matchers.is("https://robohash.org/123a37a18fdbba6a742e7446c8166393?set=set4&bgset=&size=400x400")))
//                .andExpect(MockMvcResultMatchers.jsonPath("$.birthdate", Matchers.is("2004-01-01")))
//                .andExpect(MockMvcResultMatchers.jsonPath("$.rating", Matchers.is(9.4)))
//                .andExpect(MockMvcResultMatchers.jsonPath("$.address", Matchers.is("address2")));
//    }
//
//    @Test
//    void createNewUser() throws Exception{
//
//        mockMvc.perform(MockMvcRequestBuilders.post("/api/users")
//                .contentType("application/json")
//                .content("{\n" +
//                        "    \"id\": 1,\n" +
//                        "    \"username\": \"Cosmin Timis\",\n" +
//                        "    \"password\": \"parolaaiabuna\",\n" +
//                        "    \"email\": \"cosmin.timis@gmail.com\",\n" +
//                        "    \"avatar\": \"https://robohash.org/e5a84795597420d98d606433f8ad1f70?set=set4&bgset=&size=400x400\",\n" +
//                        "    \"birthdate\": \"2003-01-01\",\n" +
//                        "    \"rating\": 8.8,\n" +
//                        "    \"address\": \"address1\"\n" +
//                        "}"))
//                .andExpect(MockMvcResultMatchers.status().isCreated());
//
//        verify(userService).addUser(any(User.class));
//
//
//        mockMvc.perform(MockMvcRequestBuilders.post("/api/users")
//                        .contentType("application/json")
//                        .content("{\n" +
//                                "    \"id\": 1,\n" +
//                                "    \"username\": \"Cosmin Timis\",\n" +
//                                "    \"password\": \"parolaaiabuna\",\n" +
//                                "    \"email\": \"cosmin.timis@gmail.com\",\n" +
//                                "    \"avatar\": \"https://robohash.org/e5a84795597420d98d606433f8ad1f70?set=set4&bgset=&size=400x400\",\n" +
//                                "    \"birthdate\": \"null\",\n" +
//                                "    \"rating\": 8.8,\n" +
//                                "    \"address\": \"address1\"\n" +
//                                "}"))
//                .andExpect(MockMvcResultMatchers.status().isBadRequest());
//
//    }
//
//    @Test
//    void testDeleteUser() throws Exception{
//        mockMvc.perform(MockMvcRequestBuilders.delete("/api/users/1"))
//                .andExpect(MockMvcResultMatchers.status().isOk());
//        verify(userService).deleteUser(1);
//    }
//
//    @Test
//    void testUpdateUser() throws Exception {
//        mockMvc.perform(MockMvcRequestBuilders.put("/api/users/1")
//                        .contentType("application/json")
//                        .content("{\n" +
//                                "    \"id\": 1,\n" +
//                                "    \"username\": \"Cosmin Timis\",\n" +
//                                "    \"password\": \"parolaaiabuna\",\n" +
//                                "    \"email\": \"cosmin.timis@gmail.com\",\n" +
//                                "    \"avatar\": \"https://robohash.org/e5a84795597420d98d606433f8ad1f70?set=set4&bgset=&size=400x400\",\n" +
//                                "    \"birthdate\": \"2003-01-01\",\n" +
//                                "    \"rating\": 8.8,\n" +
//                                "    \"address\": \"address1\"\n" +
//                                "}"))
//                .andExpect(MockMvcResultMatchers.status().isOk());
//
//        verify(userService).updateUser(eq(1), any(User.class));
//    }
//
//
//
//}
//
