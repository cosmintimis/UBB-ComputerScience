package model.statements;

import exceptions.MyException;
import model.ProgramState;
import model.adt.MyIDictionary;
import model.adt.MyILatchTable;
import model.types.IType;
import model.types.IntType;
import model.values.IValue;
import model.values.IntValue;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class AwaitStmt implements IStmt{

    String varName;

    static final Lock lock = new ReentrantLock();

    public AwaitStmt(String varName){
        this.varName = varName;
    }

    @Override
    public ProgramState execute(ProgramState state) throws MyException {

        MyIDictionary<String, IValue> symTable = state.getSymTable();

        if(!symTable.isDefined(varName))
            throw new MyException("AwaitStmt: variable undefined!");

        if(!symTable.lookup(varName).getType().equals(new IntType()))
            throw new MyException("AwaitStmt: variable type incorrect!");

        int foundIndex = ((IntValue) symTable.lookup(varName)).getVal();

        lock.lock();

        MyILatchTable latchTable = state.getLatchTable();

        if(!latchTable.isDefined(foundIndex))
            throw new MyException("AwaitStmt: invalid index!");

        if(latchTable.get(foundIndex) != 0)
            state.getExeStack().push(this);

        lock.unlock();

        return null;
    }

    @Override
    public MyIDictionary<String, IType> typecheck(MyIDictionary<String, IType> typeEnv) throws MyException {
        if(typeEnv.lookup(varName).equals(new IntType()))
            return typeEnv;

        throw new MyException("AwaitStmt: invalid variable type!");
    }

    @Override
    public IStmt deepcopy() {
        return new AwaitStmt(varName);
    }

    @Override
    public String toString() {
        return "await(" + varName + ")";
    }
}
