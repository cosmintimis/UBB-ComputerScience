package model.statements;

import exceptions.MyException;
import model.ProgramState;
import model.adt.MyIDictionary;
import model.adt.MyILatchTable;
import model.expressions.ValueExp;
import model.types.IType;
import model.types.IntType;
import model.values.IValue;
import model.values.IntValue;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class CountDownStmt implements IStmt{

    String varName;
    static final Lock lock = new ReentrantLock();

    public CountDownStmt(String varName){
        this.varName = varName;
    }

    @Override
    public ProgramState execute(ProgramState state) throws MyException {

        MyIDictionary<String, IValue> symTable = state.getSymTable();

        if(!symTable.isDefined(varName))
            throw new MyException("CountDownStmt: variable undefined!");

        if(!symTable.lookup(varName).getType().equals(new IntType()))
            throw new MyException("CountDownStmt: variable type incorrect!");

        int foundIndex = ((IntValue) symTable.lookup(varName)).getVal();

        lock.lock();

        MyILatchTable latchTable = state.getLatchTable();

        if(!latchTable.isDefined(foundIndex))
            throw new MyException("CountDownStmt: invalid index!");

        if(latchTable.get(foundIndex) > 0){
            latchTable.update(foundIndex, latchTable.get(foundIndex) - 1);
            //state.getExeStack().push(new PrintStmt(new ValueExp(new IntValue(state.getId()))));
        }

        state.getExeStack().push(new PrintStmt(new ValueExp(new IntValue(state.getId()))));

        lock.unlock();
        return null;
    }

    @Override
    public MyIDictionary<String, IType> typecheck(MyIDictionary<String, IType> typeEnv) throws MyException {
        if(typeEnv.lookup(varName).equals(new IntType()))
            return typeEnv;
        throw new MyException("CountDownStmt: invalid variable type!");
    }

    @Override
    public IStmt deepcopy() {
        return new CountDownStmt(varName);
    }

    @Override
    public String toString() {
        return "countDown(" + varName + ")";
    }
}
