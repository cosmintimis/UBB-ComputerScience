// Press Shift twice to open the Search Everywhere dialog and type `show whitespaces`,
// then press Enter. You can now see whitespace characters in your code.


//4. La o ferma se cresc pasari, vaci si porci.
//Sa se afiseze toate animalele care au greutatea
//mai mare decit 3kg.

import controller.Controller;
import repository.Repository;
import model.*;

public class Main {
    public static void main(String[] args) {
        Repository repo = new Repository(10);
        Controller controller = new Controller(repo);
        Bird bird1 = new Bird(20, "Coco");
        Bird bird2 = new Bird(2, "Dodo");
        Cow cow1 = new Cow(200, "Milka");
        Pig pig1 = new Pig(1, "Pinky");
        Cow cow2 = new Cow(300, "Betsy");
        Pig pig2 = new Pig(300, "Test");

        try {
            controller.addAnimal(bird1);
            controller.addAnimal(bird2);
            controller.addAnimal(cow1);
            controller.addAnimal(pig1);


            System.out.println(controller.printAllAnimals());

            System.out.println("Animals with more than 3kg:");
            System.out.println(controller.filterAnimals());

            controller.addAnimal(cow2);
            controller.addAnimal(pig2);

            controller.removeAnimal("Betsy");
            System.out.println(controller.filterAnimals());

            controller.removeAnimal("Karina");

        }
        catch (MyException e) {
            System.out.println(e);
        }



    }
}