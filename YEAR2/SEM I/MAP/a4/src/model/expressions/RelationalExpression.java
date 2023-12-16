package model.expressions;

import exceptions.MyException;
import model.adt.MyIDictionary;
import model.adt.MyIHeap;
import model.types.IntType;
import model.values.BoolValue;
import model.values.IValue;
import model.values.IntValue;

public class RelationalExpression implements IExp{

    IExp firstExpression, secondExpression;
    String relationalOperation;

    @Override
    public String toString() {
        return "(" + firstExpression.toString() + relationalOperation + secondExpression.toString() + ");";
    }

    public RelationalExpression(IExp firstExpression, IExp secondExpression, String relationalOperation){
        this.firstExpression = firstExpression;
        this.secondExpression = secondExpression;
        this.relationalOperation = relationalOperation;
    }

    @Override
    public IValue evaluation(MyIDictionary<String, IValue> table, MyIHeap heap) throws MyException {
        IValue firstValue, secondValue;
        firstValue = firstExpression.evaluation(table, heap);
        if(firstValue.getType().equals(new IntType()))
        {
            secondValue = secondExpression.evaluation(table, heap);
            if (secondValue.getType().equals(new IntType()))
            {
                int firstNumber = ((IntValue)firstValue).getVal();
                int secondNumber = ((IntValue)secondValue).getVal();

                return switch (relationalOperation){
                    case "<" -> new BoolValue(firstNumber < secondNumber);
                    case "<=" -> new BoolValue(firstNumber <= secondNumber);
                    case ">" -> new BoolValue(firstNumber > secondNumber);
                    case ">=" -> new BoolValue(firstNumber >= secondNumber);
                    case "==" -> new BoolValue(firstNumber == secondNumber);
                    case "!=" -> new BoolValue(firstNumber != secondNumber);
                    default-> throw new MyException("Invalid relational operation!");

                };
            }
            else
                throw new MyException("Second operand isn't an integer!");
        }
        else
            throw new MyException("First operand isn't an integer!");
    }

    @Override
    public IExp deepcopy() {
        return new RelationalExpression(firstExpression.deepcopy(), secondExpression.deepcopy(), relationalOperation);
    }
}
