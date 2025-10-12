package model.statements;

import exceptions.MyException;
import javafx.util.Pair;
import model.ProgramState;
import model.adt.MyIDictionary;
import model.adt.MyIBarrierTable;
import model.types.IType;
import model.types.IntType;
import model.values.IValue;
import model.values.IntValue;

import java.util.List;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class AwaitStmt implements IStmt{

    String varName;

    final static Lock lock = new ReentrantLock();

    public AwaitStmt(String varName){
        this.varName = varName;
    }
    @Override
    public ProgramState execute(ProgramState state) throws MyException {
        MyIDictionary<String, IValue> symTable = state.getSymTable();

        if(!symTable.isDefined(varName))
            throw new MyException("AwaitStmt: given variable undefined in symTable!");

        int foundIndex = ((IntValue) symTable.lookup(varName)).getVal();

        lock.lock();

        MyIBarrierTable barrierTable = state.getBarrierTable();

        if(!barrierTable.isDefined(foundIndex))
            throw new MyException("AwaitStmt: invalid index!");

        Pair<Integer, List<Integer>> foundValue = barrierTable.get(foundIndex);

        int n1 = foundValue.getKey();
        int nl = foundValue.getValue().size();

        if(n1 > nl){
            if(!foundValue.getValue().contains(state.getId())){
                foundValue.getValue().add(state.getId());
            }
            state.getExeStack().push(this);
        }

        lock.unlock();
        return  null;
    }

    @Override
    public MyIDictionary<String, IType> typecheck(MyIDictionary<String, IType> typeEnv) throws MyException {

//        if(typeEnv.lookup(varName).equals(new IntType()))
//            return typeEnv;
//
//        throw new MyException("AwaitStmt: invalid type!");
        return typeEnv;
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
