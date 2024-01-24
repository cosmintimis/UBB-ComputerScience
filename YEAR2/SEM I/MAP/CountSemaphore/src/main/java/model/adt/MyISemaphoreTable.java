package model.adt;

import exceptions.MyException;
import javafx.util.Pair;

import java.util.List;
import java.util.Map;

public interface MyISemaphoreTable {
    void put(int key,  Pair<Integer, List<Integer>> value) throws MyException;
    Pair<Integer, List<Integer>> get(int key) throws MyException;
    boolean isDefined(int key);
    int getFreeLocation();
    void update(int key,  Pair<Integer, List<Integer>> value) throws MyException;
    void setFreeLocation(int freeAddress);
    Map<Integer,  Pair<Integer, List<Integer>>> getContent();
    void setContent(Map<Integer,  Pair<Integer, List<Integer>>> newSemaphoreTable);
}
