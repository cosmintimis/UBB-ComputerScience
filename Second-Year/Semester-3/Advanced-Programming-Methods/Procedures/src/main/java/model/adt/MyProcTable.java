package model.adt;

import exceptions.MyException;
import javafx.util.Pair;
import model.statements.IStmt;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class MyProcTable implements  MyIProcTable{

    Map<String, Pair<List<String>, IStmt>> procTable;

    public MyProcTable(){
        procTable = new ConcurrentHashMap<>();
    }

    @Override
    public boolean isDefined(String key) {
        return procTable.containsKey(key);
    }

    @Override
    public void put(String key, Pair<List<String>, IStmt> value) {
        procTable.put(key, value);
    }

    @Override
    public Pair<List<String>, IStmt> get(String key) throws MyException {
        if(!isDefined(key))
            throw new MyException("ProcTable: key undefined!");
        return procTable.get(key);
    }

    @Override
    public void update(String key, Pair<List<String>, IStmt> value) throws MyException {
        if(!isDefined(key))
            throw new MyException("ProcTable: key undefined!");
        procTable.replace(key, value);

    }

    @Override
    public Collection<Pair<List<String>, IStmt>> values() {
        return procTable.values();
    }

    @Override
    public void remove(String key) throws MyException {
        if(!isDefined(key))
            throw new MyException("ProcTable: key undefined!");
        procTable.remove(key);
    }

    @Override
    public Set<String> keySet() {
        return procTable.keySet();
    }

    @Override
    public Map<String, Pair<List<String>, IStmt>> getContent() {
        return procTable;
    }

    @Override
    public MyIProcTable copy() throws MyException {
        MyIProcTable newProcTable = new MyProcTable();

        for(String key : procTable.keySet())
            newProcTable.update(key, procTable.get(key));

        return newProcTable;
    }

    @Override
    public String toString() {
        StringBuilder procTableStringBuilder = new StringBuilder();
        for (String key: procTable.keySet()) {
            procTableStringBuilder.append(String.format("%s -> Params: %s, Statement: %s\n", key, procTable.get(key).getKey(), procTable.get(key).getValue()));
        }
        return procTableStringBuilder.toString();
    }
}
