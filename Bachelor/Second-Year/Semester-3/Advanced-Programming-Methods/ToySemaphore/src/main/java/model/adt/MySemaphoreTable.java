package model.adt;

import exceptions.MyException;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class MySemaphoreTable implements MyISemaphoreTable {
    Map<Integer, MyTuple<Integer, List<Integer>, Integer>> semaphoreTable;
    int freeLocation;

    public MySemaphoreTable(){
        this.semaphoreTable = new ConcurrentHashMap<>();
        this.freeLocation = 0;
    }
    @Override
    public void put(int key, MyTuple<Integer, List<Integer>, Integer> value) throws MyException {
        if(isDefined(key))
            throw new MyException("Semaphore table already contain that key!");
        semaphoreTable.put(key, value);


    }

    @Override
    public MyTuple<Integer, List<Integer>, Integer> get(int key) throws MyException {
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
    public void update(int key, MyTuple<Integer, List<Integer>, Integer> value) throws MyException {
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
    public Map<Integer, MyTuple<Integer, List<Integer>, Integer>> getContent() {
        synchronized (this){
            return semaphoreTable;
        }
    }

    @Override
    public void setContent(Map<Integer, MyTuple<Integer, List<Integer>, Integer>> newSemaphoreTable) {
        synchronized (this){
            this.semaphoreTable = newSemaphoreTable;
        }
    }

    public String toString(){
        String string = "";
        for (Map.Entry<Integer, MyTuple<Integer, List<Integer>, Integer>> s : semaphoreTable.entrySet()) {
            string += (s.getKey() + " --> " + s.getValue().first() + ", " + s.getValue().second() + ", " + s.getValue().third()) + "\n";
        }
        return string;
    }
}
