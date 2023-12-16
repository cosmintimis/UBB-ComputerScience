package controller;

import repository.*;
import model.*;

public class Controller {

    private IRepository repo;

    public Controller(IRepository repo) {
        this.repo = repo;
    }

    public void addAnimal(Animal animal) throws MyException {
        repo.addAnimal(animal);


    }

    public void removeAnimal(String name) throws MyException {

        repo.removeAnimal(name);


    }

    public String filterAnimals() {
        Animal[] animals = repo.getAnimals();
        String result = "";

        for (int i = 0; i < repo.getSize(); i++)
            if (animals[i].getWeight() > 3)
                result += animals[i].toString() + '\n';

        return result;

    }

    public String printAllAnimals() {
        Animal[] animals = repo.getAnimals();
        String result = "";
        for (int i = 0; i < repo.getSize(); i++)
            result += animals[i].toString() + '\n';
        return result;
    }

}
