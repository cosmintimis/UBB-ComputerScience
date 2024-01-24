package model.adt;

import exceptions.MyException;

import java.util.Map;

public interface MyILatchTable {

    void put(int key, int value) throws MyException;
    int get(int key) throws MyException;
    boolean isDefined(int key);
    int getFreeLocation();
    void update(int key, int value) throws MyException;
    void setFreeLocation(int freeAddress);
    Map<Integer, Integer> getContent();
    void setContent(Map<Integer, Integer> newLatchTable);

}
