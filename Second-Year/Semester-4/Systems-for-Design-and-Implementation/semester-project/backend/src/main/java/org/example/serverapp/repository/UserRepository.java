//package org.example.serverapp.repository;
//
//import org.example.serverapp.entity.User;
//import org.springframework.stereotype.Repository;
//
//import java.time.LocalDate;
//import java.util.ArrayList;
//import java.util.List;
//import java.util.Objects;
//
//@Repository
//public class UserRepository implements IRepository<User, Integer> {
//
//    List<User> users = new ArrayList<>(List.of(
//            new User(1, "Cosmin Timis", "parolaaiabuna", "cosmin.timis@gmail.com", "https://robohash.org/e5a84795597420d98d606433f8ad1f70?set=set4&bgset=&size=400x400",
//                    LocalDate.parse("2003-01-01"), 8.8, "address1"),
//            new User(2, "Roberto Pitic", "parola2", "roberto.pitic@gmail.com", "https://robohash.org/123a37a18fdbba6a742e7446c8166393?set=set4&bgset=&size=400x400",
//                    LocalDate.parse("2004-01-01"), 9.4, "address2"),
//            new User(3, "Alex Popescu", "parola3", "alex.popescu@gmail.com", "https://robohash.org/6bce224daedfea2d8296ceb4597929b7?set=set4&bgset=&size=400x400",
//                    LocalDate.parse("2004-04-04"), 5.5, "address3"),
//            new User(4, "Mihai Pop", "parola4", "mihai.pop@gmail.com", "https://robohash.org/3afc9b17743e55d9c40cb9a8df20517c?set=set4&bgset=&size=400x400",
//                    LocalDate.parse("2004-05-05"), 6.8, "address4"),
//            new User(5, "Andrei Pop", "parola5", "andrei.pop@gmail.com", "https://robohash.org/e5a84795597420d98d606433f8ad1f70?set=set4&bgset=&size=400x400",
//                    LocalDate.parse("2009-05-07"), 7.8, "address5"),
//            new User(6, "Dragos Pop", "parola6", "dragos.pop@gmail.com", "https://robohash.org/d98db5779a7d4e3257552f63bc1bdefe?set=set4&bgset=&size=400x400",
//                    LocalDate.parse("2003-01-01"), 8.3, "address6"),
//            new User(7, "Dan Pop", "parola7", "dan.pop@gmail.com", "https://robohash.org/0b456df7de7f1f41c3da509934272113?set=set4&bgset=&size=400x400",
//                    LocalDate.parse("2003-01-01"), 6.6, "address7"),
//            new User(8, "Darius Hantig", "parola8", "darius.hantig@gmail.com", "https://robohash.org/1c375eb51d2e0786a06e94d7bbf51233?set=set4&bgset=&size=400x400",
//                    LocalDate.parse("2003-01-01"), 7.7, "address8"),
//            new User(9, "Luca Pop", "parola9", "luca.pop@gmail.com", "https://robohash.org/user9", LocalDate.parse("2003-05-21"), 8.78, "address9"),
//            new User(10, "Codrut Hojda", "parola10", "codrut.hojda@gmail.com", "https://robohash.org/user10", LocalDate.parse("2006-08-09"), 9.66, "address10"),
//            new User(11, "Nicolae Petri", "parola11", "nicu.petri@gmail.com", "https://robohash.org/nicup", LocalDate.parse("2003-06-14"), 9.95, "address11")
//
//
//
//    ));
//    @Override
//    public User getById(Integer id) {
//        return users.stream().filter(u -> Objects.equals(u.getId(), id)).findFirst().get();
//    }
//
//    @Override
//    public void add(User user) {
//        users.add(user);
//    }
//
//    @Override
//    public User update(Integer id, User updatedUser) {
//        User currentUser = getById(id);
//
//        currentUser.setUsername(updatedUser.getUsername());
//        currentUser.setPassword(updatedUser.getPassword());
//        currentUser.setEmail(updatedUser.getEmail());
//        currentUser.setAvatar(updatedUser.getAvatar());
//        currentUser.setBirthdate(updatedUser.getBirthdate());
//        currentUser.setRating(updatedUser.getRating());
//        currentUser.setAddress(updatedUser.getAddress());
//
//        return currentUser;
//    }
//
//    @Override
//    public void delete(Integer id) {
//        users.removeIf(u -> Objects.equals(u.getId(), id));
//    }
//
//    @Override
//    public boolean existsById(Integer id) {
//        return users.stream().anyMatch(u -> u.getId() == id);
//    }
//
//    @Override
//    public int count() {
//        return users.size();
//    }
//
//    @Override
//    public List<User> getAll() {
//        return users;
//    }
//
//    public int firstFreeId(){
//        return users.stream().map(User::getId).max(Integer::compareTo).get() + 1;
//    }
//}