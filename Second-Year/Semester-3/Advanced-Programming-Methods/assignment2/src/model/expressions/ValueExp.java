package model.expressions;

import exceptions.MyException;
import model.adt.MyIDictionary;
import model.values.IValue;

public class ValueExp implements IExp{
    IValue value;

    public ValueExp(IValue value){
        this.value = value;
    }

    @Override
    public String toString() {
        return value.toString();
    }

    @Override
    public IValue evaluation(MyIDictionary<String, IValue> table) throws MyException {
        return value;
    }

    @Override
    public IExp deepcopy() {
        return new ValueExp(this.value.deepcopy());
    }
}
