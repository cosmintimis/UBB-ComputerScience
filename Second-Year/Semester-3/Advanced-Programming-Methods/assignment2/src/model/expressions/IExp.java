package model.expressions;

import exceptions.MyException;
import model.adt.MyIDictionary;
import model.values.IValue;

public interface IExp {
    IValue evaluation(MyIDictionary<String, IValue> table) throws MyException;

    IExp deepcopy();
}
