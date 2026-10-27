package model.statements;

import exceptions.MyException;
import model.ProgramState;
import model.adt.MyIDictionary;
import model.adt.MyIHeap;
import model.adt.MyISemaphoreTable;
import model.adt.MyTuple;
import model.expressions.IExp;
import model.types.IType;
import model.types.IntType;
import model.values.IValue;
import model.values.IntValue;

import java.util.ArrayList;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class NewSemaphoreStmt implements IStmt{

    String varName;

    IExp exp1, exp2;

    final static Lock lock = new ReentrantLock();

    public NewSemaphoreStmt(String varName, IExp exp1, IExp exp2){
        this.varName = varName;
        this.exp1 = exp1;
        this.exp2 = exp2;
    }

    @Override
    public ProgramState execute(ProgramState state) throws MyException {
        MyIDictionary<String, IValue> symTable = state.getSymTable();
        MyIHeap<Integer, IValue> heap = state.getHeap();

        IValue valExp1 = exp1.evaluation(symTable, heap);
        IValue valExp2 = exp2.evaluation(symTable, heap);

        int number1 = ((IntValue) valExp1).getVal();
        int number2 = ((IntValue) valExp2).getVal();

        lock.lock();

        MyISemaphoreTable semaphoreTable = state.getSemaphoreTable();

        int freeLocation = semaphoreTable.getFreeLocation();

        semaphoreTable.put(freeLocation, new MyTuple<>(number1, new ArrayList<>(), number2));

        /// change this to add var to symTable if needed
        if(!symTable.isDefined(varName))
            throw new MyException("NewSemaphoreStmt: given variable undefined in symTable!");

        if(!symTable.lookup(varName).getType().equals(new IntType()))
            throw new MyException("NewSemaphoreStmt: invalid type of variable!");

        symTable.update(varName, new IntValue(freeLocation));

        lock.unlock();

        return null;
    }

    @Override
    public MyIDictionary<String, IType> typecheck(MyIDictionary<String, IType> typeEnv) throws MyException {
        return typeEnv;
    }

    @Override
    public IStmt deepcopy() {
        return new NewSemaphoreStmt(varName, exp1.deepcopy(), exp2.deepcopy());
    }

    @Override
    public String toString() {
        return "newSemaphore(" + varName + "," + exp1 + "," + exp2 + ")";
    }
}
