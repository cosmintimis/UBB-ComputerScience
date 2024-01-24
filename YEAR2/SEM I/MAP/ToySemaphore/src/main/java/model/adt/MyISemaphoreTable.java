package model.adt;

import exceptions.MyException;

import java.util.List;
import java.util.Map;

public interface MyISemaphoreTable {
    void put(int key, MyTuple<Integer, List<Integer>, Integer> value) throws MyException;
    MyTuple<Integer, List<Integer>, Integer> get(int key) throws MyException;
    boolean isDefined(int key);
    int getFreeLocation();
    void update(int key, MyTuple<Integer, List<Integer>, Integer> value) throws MyException;
    void setFreeLocation(int freeAddress);
    Map<Integer, MyTuple<Integer, List<Integer>, Integer>> getContent();
    void setContent(Map<Integer, MyTuple<Integer, List<Integer>, Integer>> newSemaphoreTable);
}
