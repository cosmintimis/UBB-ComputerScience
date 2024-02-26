package model.expressions;

import exceptions.MyException;
import model.adt.MyIDictionary;
import model.types.IntType;
import model.values.IValue;
import model.values.IntValue;

public class ArithExp implements IExp {
    IExp firstExpression, secondExpression;
    String op;

    public ArithExp(IExp firstExpression, IExp secondExpression, String op)
    {
        this.firstExpression = firstExpression;
        this.secondExpression = secondExpression;
        this.op = op;
    }


    @Override
    public String toString() {
        return firstExpression + op + secondExpression;
    }
    @Override
    public IValue evaluation(MyIDictionary<String, IValue> table) throws MyException {
        IValue firstValue, secondValue;

        firstValue = firstExpression.evaluation(table);

        if (firstValue.getType().equals(new IntType())) {
            secondValue = secondExpression.evaluation(table);

            if (secondValue.getType().equals(new IntType())) {
                IntValue firstIntValue = (IntValue) firstValue;
                IntValue secondIntValue = (IntValue) secondValue;
                int firstNumber, secondNumber;
                firstNumber = firstIntValue.getVal();
                secondNumber = secondIntValue.getVal();

                return switch (op) {
                    case "+" -> new IntValue(firstNumber + secondNumber);
                    case "-" -> new IntValue(firstNumber - secondNumber);
                    case "*" -> new IntValue(firstNumber * secondNumber);
                    case "/" -> {
                        if (secondNumber == 0)
                            throw new MyException("Division by zero!");
                        yield new IntValue(firstNumber / secondNumber);
                    }
                    default -> throw new MyException("Arithmetic operation not exist!");
                };

            } else
                throw new MyException("Second operand isn't an integer!");
        } else
            throw new MyException("First operand isn't an integer!");
    }
    @Override
    public IExp deepcopy() {
        return new ArithExp(this.firstExpression.deepcopy(), this.secondExpression.deepcopy(), op);
    }
}
