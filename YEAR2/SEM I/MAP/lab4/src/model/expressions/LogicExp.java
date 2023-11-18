package model.expressions;

import exceptions.MyException;
import model.adt.MyIDictionary;
import model.types.BoolType;
import model.values.BoolValue;
import model.values.IValue;

public class LogicExp implements IExp {
    IExp e1, e2;
    String op;

    public LogicExp(IExp e1, IExp e2, String op) {
        this.e1 = e1;
        this.e2 = e2;
        this.op = op;
    }

    @Override
    public String toString() {
        return e1 + op + e2;
    }

    @Override
    public IValue evaluation(MyIDictionary<String, IValue> table) throws MyException {
        IValue firstEvaluation = e1.evaluation(table);

        if (firstEvaluation.getType().equals(new BoolType())) {
            IValue secondEvaluation = e2.evaluation(table);

            if (secondEvaluation.getType().equals(new BoolType())) {
                return switch (op) {
                    case "||" ->
                            new BoolValue(((BoolValue) firstEvaluation).getVal() || ((BoolValue) secondEvaluation).getVal());
                    case "&&" ->
                            new BoolValue(((BoolValue) firstEvaluation).getVal() && ((BoolValue) secondEvaluation).getVal());
                    default -> throw new MyException("Logic operation not exist!");
                };

            } else throw new MyException("Operand2 isn't a boolean!");
        } else throw new MyException("Operand1 isn't a boolean!");
    }

    @Override
    public IExp deepcopy() {
        return new LogicExp(this.e1.deepcopy(), this.e2.deepcopy(), op);
    }
}
