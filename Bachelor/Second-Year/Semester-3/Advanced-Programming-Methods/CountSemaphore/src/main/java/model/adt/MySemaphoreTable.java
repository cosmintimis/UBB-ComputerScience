package model.adt;

import exceptions.MyException;
import javafx.util.Pair;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class MySemaphoreTable implements MyISemaphoreTable {
    Map<Integer, Pair<Integer, List<Integer>>> semaphoreTable;
    int freeLocation;

    public MySemaphoreTable(){
        this.semaphoreTable = new ConcurrentHashMap<>();
        this.freeLocation = 0;
    }
    @Override
    public void put(int key, Pair<Integer, List<Integer>> value) throws MyException {
        if(isDefined(key))
            throw new MyException("Semaphore table already contain that key!");
        semaphoreTable.put(key, value);


    }

    @Override
    public  Pair<Integer, List<Integer>> get(int key) throws MyException {
        if(!isDefined(key))
            throw new MyException("Semaphore table doesn't contain that key!");
        return semaphoreTable.get(key);
    }

    @Override
    public boolean isDefined(int key) {
        return semaphoreTable.containsKey(key);
    }

    @Override
    public int getFreeLocation() {
        synchronized (this) {
            freeLocation++;
            return freeLocation;
        }
    }

    @Override
    public void update(int key, Pair<Integer, List<Integer>> value) throws MyException {
        if(!isDefined(key))
            throw new MyException("Semaphore table doesn't contain that key!");
        semaphoreTable.replace(key, value);
    }

    @Override
    public void setFreeLocation(int freeAddress) {
        synchronized (this){
            this.freeLocation = freeAddress;
        }

    }

    @Override
    public Map<Integer,  Pair<Integer, List<Integer>>> getContent() {
        synchronized (this){
            return semaphoreTable;
        }
    }

    @Override
    public void setContent(Map<Integer, Pair<Integer, List<Integer>>> newSemaphoreTable) {
        synchronized (this){
            this.semaphoreTable = newSemaphoreTable;
        }
    }

    public String toString(){
        String string = "";
        for (Map.Entry<Integer, Pair<Integer, List<Integer>>> s : semaphoreTable.entrySet()) {
            string += (s.getKey() + " --> " + s.getValue().getKey() + ", " + s.getValue().getValue() + "\n" );
        }
        return string;
    }
}
