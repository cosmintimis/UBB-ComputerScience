package model.adt;

import java.util.Map;

public interface MyIDictionary<K, V> {

    boolean isDefined(K id);

    V lookup(K id);

    void update(K id, V value);

    Iterable<Map.Entry<K, V>> getIterableSet();

    void remove(K id);

}
