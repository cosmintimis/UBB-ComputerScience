package model.expressions;

import exceptions.MyException;
import model.adt.MyIDictionary;
import model.adt.MyIHeap;
import model.values.IValue;

public interface IExp {
    IValue evaluation(MyIDictionary<String, IValue> table, MyIHeap heap) throws MyException;

    IExp deepcopy();
}
