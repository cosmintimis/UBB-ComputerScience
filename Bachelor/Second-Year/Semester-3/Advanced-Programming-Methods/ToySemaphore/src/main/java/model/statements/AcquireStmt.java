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

public class AcquireStmt implements IStmt{

    String varName;

    final static Lock lock = new ReentrantLock();
    public AcquireStmt(String varName){
        this.varName = varName;
    }

    @Override
    public ProgramState execute(ProgramState state) throws MyException {

        MyIDictionary<String, IValue> symTable = state.getSymTable();

        if(!symTable.isDefined(varName))
            throw new MyException("AcquireStmt: given variable undefined in symTable!");

        if(!symTable.lookup(varName).getType().equals(new IntType()))
            throw new MyException("AcquireStmt: invalid type of variable!");

        int foundIndex = ((IntValue) symTable.lookup(varName)).getVal();

        lock.lock();

        MyISemaphoreTable semaphoreTable = state.getSemaphoreTable();

        if(!semaphoreTable.isDefined(foundIndex))
            throw new MyException("AcquireStmt: invalid index!");

        MyTuple<Integer, List<Integer>, Integer> foundValue = semaphoreTable.get(foundIndex);

        int n1 = foundValue.first();
        int n2 = foundValue.third();
        int nl = foundValue.second().size();

        if((n1 - n2) > nl){
            if(!foundValue.second().contains(state.getId())){
                foundValue.second().add(state.getId());
               // semaphoreTable.update(foundIndex, new MyTuple<>(n1, foundValue.second(), n2));
            }
        }
        else
            state.getExeStack().push(this);

        lock.unlock();


        return null;
    }

    @Override
    public MyIDictionary<String, IType> typecheck(MyIDictionary<String, IType> typeEnv) throws MyException {
        return typeEnv;
    }

    @Override
    public IStmt deepcopy() {
        return new AcquireStmt(varName);
    }

    @Override
    public String toString() {
        return "acquire(" + varName + ")";
    }
}
