package model.adt;

public interface MyIDictionary<K, V> {

    boolean isDefined(K id);

    V lookup(K id);

    void update(K id, V value);

}
