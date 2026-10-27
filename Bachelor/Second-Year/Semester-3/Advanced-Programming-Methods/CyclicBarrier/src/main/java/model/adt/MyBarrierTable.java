package model.adt;

import exceptions.MyException;
import javafx.util.Pair;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class MyBarrierTable implements MyIBarrierTable {
    Map<Integer, Pair<Integer, List<Integer>>> barrierTable;
    int freeLocation;

    public MyBarrierTable(){
        this.barrierTable = new ConcurrentHashMap<>();
        this.freeLocation = 0;
    }
    @Override
    public void put(int key, Pair<Integer, List<Integer>> value) throws MyException {
        if(isDefined(key))
            throw new MyException("Barrier table already contain that key!");
        barrierTable.put(key, value);


    }

    @Override
    public  Pair<Integer, List<Integer>> get(int key) throws MyException {
        if(!isDefined(key))
            throw new MyException("Barrier table doesn't contain that key!");
        return barrierTable.get(key);
    }

    @Override
    public boolean isDefined(int key) {
        return barrierTable.containsKey(key);
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
            throw new MyException("Barrier table doesn't contain that key!");
        barrierTable.replace(key, value);
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
            return barrierTable;
        }
    }

    @Override
    public void setContent(Map<Integer, Pair<Integer, List<Integer>>> newBarrierTable) {
        synchronized (this){
            this.barrierTable = newBarrierTable;
        }
    }

    public String toString(){
        String string = "";
        for (Map.Entry<Integer, Pair<Integer, List<Integer>>> s : barrierTable.entrySet()) {
            string += (s.getKey() + " --> " + s.getValue().getKey() + ", " + s.getValue().getValue() + "\n" );
        }
        return string;
    }
}
