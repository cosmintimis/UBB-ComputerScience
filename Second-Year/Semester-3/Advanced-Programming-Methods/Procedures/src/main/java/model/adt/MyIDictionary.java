package model.adt;

import exceptions.MyException;

import java.util.Map;
import java.util.Set;

public interface MyIDictionary<K, V> {

    boolean isDefined(K id);

    V lookup(K id) throws MyException;

    void update(K id, V value);

    Map<K, V> getContent();
    Iterable<Map.Entry<K, V>> getIterableSet();

    void remove(K id);

    V get(K key);
    Set<K> keySet();
    MyIDictionary<K, V> copy();

}
