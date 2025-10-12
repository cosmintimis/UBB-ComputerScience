package model.adt;

import exceptions.MyException;

import java.util.List;

public interface MyIStack<T> {
    T pop();
    void push(T value);
    boolean isEmpty();
    T peek();

    List<T> reversedStackListForm();

    MyIStack<T> copy();
    List<T> getReversed();

    String toString2();

}
