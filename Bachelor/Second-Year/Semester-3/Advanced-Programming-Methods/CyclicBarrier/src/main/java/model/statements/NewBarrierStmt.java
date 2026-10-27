package model.statements;

import exceptions.MyException;
import javafx.util.Pair;
import model.ProgramState;
import model.adt.MyIDictionary;
import model.adt.MyIHeap;
import model.adt.MyIBarrierTable;
import model.expressions.IExp;
import model.types.IType;
import model.types.IntType;
import model.values.IValue;
import model.values.IntValue;

import java.util.ArrayList;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class NewBarrierStmt implements IStmt {

    String varName;

    IExp expression;

    final static Lock lock = new ReentrantLock();

    public NewBarrierStmt(String varName, IExp expression) {
        this.varName = varName;
        this.expression = expression;
    }

    @Override
    public ProgramState execute(ProgramState state) throws MyException {
        MyIDictionary<String, IValue> symTable = state.getSymTable();
        MyIHeap<Integer, IValue> heap = state.getHeap();

        IValue valExp = expression.evaluation(symTable, heap);

        int number = ((IntValue) valExp).getVal();


        lock.lock();

        MyIBarrierTable barrierTable = state.getBarrierTable();

        int freeLocation = barrierTable.getFreeLocation();

        barrierTable.put(freeLocation, new Pair<>(number, new ArrayList<>()));

        symTable.update(varName, new IntValue(freeLocation));

        lock.unlock();

        return null;
    }

    @Override
    public MyIDictionary<String, IType> typecheck(MyIDictionary<String, IType> typeEnv) throws MyException {
//        IType expType = expression.typecheck(typeEnv);
//        IType varType = typeEnv.lookup(varName);
//
//        if(expType.equals(new IntType()) && varType.equals(new IntType()))
//            return typeEnv;
//
//        throw new MyException("NewBarrierStmt: invalid type!");
        return typeEnv;
    }

    @Override
    public IStmt deepcopy() {
        return new NewBarrierStmt(varName, expression.deepcopy());
    }

    @Override
    public String toString() {
        return "newBarrier(" + varName + "," + expression + ")";
    }
}
