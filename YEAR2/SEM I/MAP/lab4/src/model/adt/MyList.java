package model.adt;
import java.util.ArrayList;
import java.util.List;
public class MyList<T> implements MyIList<T>{

    List<T> list = new ArrayList<>();

    @Override
    public void add(T value) {
        list.add(value);
    }

    @Override
    public boolean isEmpty() {
        return list.isEmpty();
    }

    @Override
    public String toString() {
        return list.toString();
    }

    @Override
    public T get(int i) {
        return list.get(i);
    }

    @Override
    public int getSize() {
        return list.size();
    }
}
