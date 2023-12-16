package model.adt;

import java.util.HashMap;
import java.util.Map;

public class FileTable<K, V> implements MyIDictionary<K,V> {

    Map<K, V> dictionary;

    public FileTable(){
        this.dictionary = new HashMap<>();
    }

    public Map<K, V> getContent() {
        return dictionary;
    }

    @Override
    public V lookup(K id) {
        return dictionary.get(id);
    }

    @Override
    public boolean isDefined(K id) {
        return dictionary.containsKey(id);
    }

    @Override
    public void update(K id, V value) {
        dictionary.put(id, value);
    }

    @Override
    public String toString(){
        StringBuilder string = new StringBuilder();
        for (Map.Entry<K, V> s : dictionary.entrySet()) {
            string.append(s.getKey().toString()).append("\n");
        }
        return string.toString();
    }

    @Override
    public Iterable<Map.Entry<K, V>> getIterableSet() {
        return dictionary.entrySet();
    }

    @Override
    public void remove(K id) {
        dictionary.remove(id);
    }
}
