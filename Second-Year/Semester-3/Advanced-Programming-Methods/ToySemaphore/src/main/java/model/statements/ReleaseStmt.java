package model.statements;

import exceptions.MyException;
import model.ProgramState;
import model.adt.MyIDictionary;
import model.adt.MyISemaphoreTable;
import model.adt.MyTuple;
import model.types.IType;
import model.types.IntType;
import model.values.IValue;
import model.values.IntValue;

import java.util.List;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class ReleaseStmt implements IStmt {

    String varName;

    final static Lock lock = new ReentrantLock();

    public ReleaseStmt(String varName) {
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

        MyTuple<Integer, List<Integer>, Integer> foundValue = semaphoreTable.get(foundIndex);

        int n1 = foundValue.first();
        int n2 = foundValue.third();

        if (foundValue.second().contains(state.getId())) {
            foundValue.second().remove((Integer) state.getId());
           //semaphoreTable.update(foundIndex, new MyTuple<>(n1, foundValue.second(), n2));
        }


        lock.unlock();


        return null;
    }

    @Override
    public MyIDictionary<String, IType> typecheck(MyIDictionary<String, IType> typeEnv) throws MyException {
        return typeEnv;
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
