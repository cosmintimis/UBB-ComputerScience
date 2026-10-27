package model.adt;
import java.util.Stack;

public class MyStack<T> implements MyIStack<T>{

    Stack<T> stack = new Stack<>();

    @Override
    public T pop() {
        return stack.pop();
    }

    @Override
    public boolean isEmpty() {
        return stack.isEmpty();
    }

    @Override
    public void push(T value) {
        stack.push(value);
    }

    @Override
    public T peek() {
        return stack.peek();
    }

    @Override
    public String toString() {
        return stack.toString();
    }
}
