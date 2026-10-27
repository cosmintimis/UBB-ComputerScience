package model.adt;

import exceptions.MyException;
import javafx.util.Pair;
import model.statements.IStmt;
import model.statements.IfStmt;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;

public interface MyIProcTable {
    boolean isDefined(String key);

    void put(String key, Pair<List<String>, IStmt> value);

    Pair<List<String>, IStmt> get(String key) throws MyException;

    void update(String key, Pair<List<String>, IStmt> value) throws MyException;

    Collection<Pair<List<String>, IStmt>> values();

    void remove(String key) throws MyException;

    Set<String> keySet();

    Map<String, Pair<List<String>, IStmt>> getContent();

    MyIProcTable copy() throws MyException;
}
