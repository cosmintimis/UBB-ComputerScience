package model.adt;

import exceptions.MyException;
import model.values.IValue;

import java.util.*;

public class MyStack<T> implements MyIStack<T> {

    Stack<T> stack;

    public MyStack() {
        this.stack = new Stack<>();
    }

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
    public List<T> reversedStackListForm() {
        List<T> reversedStackList = new ArrayList<>(stack);
        Collections.reverse(reversedStackList);
        return reversedStackList;
    }

    @Override
    public MyIStack<T> copy() {
        MyIStack<T> newStack = new MyStack<>();


        for (T elem : stack) {
            if (elem instanceof MyIDictionary<?, ?>) {
                newStack.push((T) ((MyIDictionary<?, ?>) elem).copy());
            } else
                newStack.push(elem);
        }

        return newStack;

    }

    @Override
    public List<T> getReversed() {
        List<T> list = Arrays.asList((T[]) stack.toArray());
        Collections.reverse(list);
        return list;
    }

    @Override
    public String toString() {

        String result = stack.stream().map(Object::toString).reduce((acc, item) -> item + "\n" + acc).orElse("");

        if (isEmpty())
            return result;

        return result + "\n";

    }

    public String toString2() {
        StringBuilder symTableStringBuilder = new StringBuilder();
        List<T> reversedStack = getReversed();
        for (T table : reversedStack) {
            for (String key : ((MyIDictionary<String, IValue>) table).keySet()) {
                symTableStringBuilder.append(String.format("%s -> %s\n", key, ((MyIDictionary<String, IValue>) table).get(key).toString()));
            }
            symTableStringBuilder.append("\n");
        }
        return symTableStringBuilder.toString();
    }
}
