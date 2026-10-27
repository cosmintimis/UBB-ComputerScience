package model.adt;

import exceptions.MyException;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class MyLatchTable implements MyILatchTable{

     Map<Integer, Integer> latchTable;
     int freeLocation;

     public MyLatchTable(){
         this.latchTable = new ConcurrentHashMap<>();
         this.freeLocation = 0;
     }
    @Override
    public void put(int key, int value) throws MyException {
        if(isDefined(key))
            throw new MyException("Latch table already contain that key!");
        latchTable.put(key, value);


    }

    @Override
    public int get(int key) throws MyException {
        if(!isDefined(key))
            throw new MyException("Latch table doesn't contain that key!");
        return latchTable.get(key);
    }

    @Override
    public boolean isDefined(int key) {
        return latchTable.containsKey(key);
    }

    @Override
    public int getFreeLocation() {
        synchronized (this) {
            freeLocation++;
            return freeLocation;
        }
    }

    @Override
    public void update(int key, int value) throws MyException {
        if(!isDefined(key))
            throw new MyException("Latch table doesn't contain that key!");
        latchTable.replace(key, value);
    }

    @Override
    public void setFreeLocation(int freeAddress) {
         synchronized (this){
             this.freeLocation = freeAddress;
         }

    }

    @Override
    public Map<Integer, Integer> getContent() {
        synchronized (this){
            return latchTable;
        }
    }

    @Override
    public void setContent(Map<Integer, Integer> newLatchTable) {
        synchronized (this){
            this.latchTable = newLatchTable;
        }
    }

    public String toString(){
        String string = "";
        for (Map.Entry<Integer, Integer> s : latchTable.entrySet()) {
            string += (s.getKey() + " --> " + s.getValue()) + "\n";
        }
        return string;
    }
}
