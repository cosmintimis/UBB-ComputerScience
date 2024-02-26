package model.expressions;

import exceptions.MyException;
import model.adt.MyIDictionary;
import model.adt.MyIHeap;
import model.types.IType;
import model.types.IntType;
import model.values.IValue;

public class MulExp implements IExp{

    IExp exp1, exp2;

    public MulExp(IExp exp1, IExp exp2){
        this.exp1 = exp1;
        this.exp2 = exp2;
    }

    @Override
    public IValue evaluation(MyIDictionary<String, IValue> table, MyIHeap<Integer, IValue> heap) throws MyException {
        IExp newExp = new ArithExp(
                new ArithExp( exp1, exp2, "*"),
                new ArithExp( exp1, exp2, "+"), "-");
        return newExp.evaluation(table, heap);
    }

    @Override
    public IType typecheck(MyIDictionary<String, IType> typeEnv) throws MyException {
        IType type1 = exp1.typecheck(typeEnv);
        IType type2 = exp2.typecheck(typeEnv);
        if (type1.equals(new IntType()) && type2.equals(new IntType()))
            return new IntType();
        else
            throw new MyException("MulExp: Both expressions must be of int type!");
    }

    @Override
    public IExp deepcopy() {
        return new MulExp(exp1.deepcopy(), exp2.deepcopy());
    }

    @Override
    public String toString() {
        return "MUL(" + exp1 + "," + exp2 + ")";
    }
}
