package model.statements;

import exceptions.MyException;
import javafx.util.Pair;
import model.ProgramState;
import model.adt.MyIDictionary;
import model.adt.MyISemaphoreTable;
import model.types.IType;
import model.types.IntType;
import model.values.IValue;
import model.values.IntValue;

import java.util.List;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class ReleaseStmt implements IStmt{

    String varName;

    final static Lock lock = new ReentrantLock();

    public ReleaseStmt(String varName){
        this.varName = varName;
    }

    @Override
    public ProgramState execute(ProgramState state) throws MyException {
        MyIDictionary<String, IValue> symTable = state.getSymTable();

        if (!symTable.isDefined(varName))
            throw new MyException("ReleaseStmt: given variable undefined in symTable!");

        if (!symTable.lookup(varName).getType().equals(new IntType()))
            throw new MyException("ReleaseStmt: invalid type of variable!");

        int foundIndex = ((IntValue) symTable.lookup(varName)).getVal();

        lock.lock();

        MyISemaphoreTable semaphoreTable = state.getSemaphoreTable();

        if (!semaphoreTable.isDefined(foundIndex))
            throw new MyException("ReleaseStmt: invalid index!");

        Pair<Integer, List<Integer>> foundValue = semaphoreTable.get(foundIndex);


        if (foundValue.getValue().contains(state.getId())) {
            foundValue.getValue().remove((Integer) state.getId());
        }


        lock.unlock();

        return null;
    }

    @Override
    public MyIDictionary<String, IType> typecheck(MyIDictionary<String, IType> typeEnv) throws MyException {
        if(typeEnv.lookup(varName).equals(new IntType()))
            return typeEnv;
        throw new MyException("ReleaseStmt: invalid type!");
    }

    @Override
    public IStmt deepcopy() {
        return new ReleaseStmt(varName);
    }

    @Override
    public String toString() {
        return "release(" + varName + ")";
    }
}
