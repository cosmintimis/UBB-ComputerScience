package repository;

import model.Animal;
import model.MyException;

public interface IRepository {


    Animal[] getAnimals();

    void addAnimal(Animal animal) throws MyException;

    void removeAnimal(String name) throws MyException;

    int getSize();

}
