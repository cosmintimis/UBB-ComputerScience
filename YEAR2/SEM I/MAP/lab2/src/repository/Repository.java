package repository;

import model.Animal;
import model.MyException;

public class Repository implements IRepository {
    private Animal animals[];
    private int capacity;

    public Repository(int capacity) {
        this.capacity = capacity;
        this.animals = new Animal[this.capacity];
    }

    private int size = 0;

    public void addAnimal(Animal a) throws MyException {
        if (size == capacity)
            throw new MyException("The array is full!");
        animals[size++] = a;
    }

    public void removeAnimal(String nameOfAnimalToBeDeleted) throws MyException {
        boolean found = false;
        for (int i = 0; i < size; i++) {
            // animals[i].getName().equals(nameOfAnimalToBeDeleted)
            if (animals[i].getName().compareTo(nameOfAnimalToBeDeleted) == 0) {
                animals[i] = animals[size - 1];
                animals[size - 1] = null;
                size--;
                found = true;
                break;
            }

        }
        if (!found)
            throw new MyException("That animal doesn't exist!");
    }

    public Animal[] getAnimals() {
        return animals;
    }

    public int getSize() {
        return this.size;
    }
}
