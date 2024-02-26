package model.adt;

import model.values.IValue;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class MyHeap<K, V> implements MyIHeap<K, V>{

    Map<K, V> heap;
    Integer freeAddress = 1;

    public  MyHeap(){
        this.heap = new ConcurrentHashMap<>();
        this.freeAddress = 1;
    }

    public K getFreeAddress() {
        return (K)freeAddress;
    }

    @Override
    public Map<K, V> getContent() {
        return heap;
    }

    @Override
    public void setContent(Map<K, V> newHeap) {
        heap = newHeap;
    }

    @Override
    public boolean isDefined(K id) {
        return heap.containsKey(id);
    }

    @Override
    public V lookup(K id) { return heap.get(id); }

    @Override
    public void allocate(V val) {
        heap.put((K) freeAddress, val);
        freeAddress++;
    }

    @Override
    public void update(K id, V val) {
        heap.put(id, val);
    }

    @Override
    public Iterable<Map.Entry<K, V>> getIterableSet() {
        return heap.entrySet();
    }

    @Override
    public void remove(K id) {
        heap.remove(id);
    }

    @Override
    public String toString() {
        String string = "";
        for (Map.Entry<K, V> s : heap.entrySet()) {
            string += (s.getKey() + " --> " + s.getValue()) + "\n";
        }
        return string;
    }
}
