package model.statements;

import exceptions.MyException;
import javafx.util.Pair;
import model.ProgramState;
import model.adt.MyIDictionary;
import model.adt.MyIHeap;
import model.adt.MyISemaphoreTable;
import model.expressions.IExp;
import model.types.IType;
import model.types.IntType;
import model.values.IValue;
import model.values.IntValue;

import java.util.ArrayList;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class CreateSemaphoreStmt implements IStmt{

    String varName;

    IExp expression;

    final static Lock lock = new ReentrantLock();

    public CreateSemaphoreStmt(String varName, IExp expression){
        this.varName = varName;
        this.expression = expression;
    }

    @Override
    public ProgramState execute(ProgramState state) throws MyException {
        MyIDictionary<String, IValue> symTable = state.getSymTable();
        MyIHeap<Integer, IValue> heap = state.getHeap();

        IValue valExp = expression.evaluation(symTable, heap);

        int number1 = ((IntValue) valExp).getVal();


        lock.lock();

        MyISemaphoreTable semaphoreTable = state.getSemaphoreTable();

        int freeLocation = semaphoreTable.getFreeLocation();

        semaphoreTable.put(freeLocation, new Pair<>(number1, new ArrayList<>()));

        /// change this to add var to symTable if needed
        if(!symTable.isDefined(varName))
            throw new MyException("CreateSemaphoreStmt: given variable undefined in symTable!");

        if(!symTable.lookup(varName).getType().equals(new IntType()))
            throw new MyException("CreateSemaphoreStmt: invalid type of variable!");

        symTable.update(varName, new IntValue(freeLocation));

        lock.unlock();
        return null;
    }

    @Override
    public MyIDictionary<String, IType> typecheck(MyIDictionary<String, IType> typeEnv) throws MyException {
        IType expType = expression.typecheck(typeEnv);
        IType varType = typeEnv.lookup(varName);

        if(expType.equals(new IntType()) && varType.equals(new IntType()))
            return typeEnv;

        throw new MyException("CreateSemaphoreStmt: invalid type!");
    }

    @Override
    public IStmt deepcopy() {
        return new CreateSemaphoreStmt(varName, expression.deepcopy());
    }

    @Override
    public String toString() {
        return "createSemaphore(" + varName + "," + expression + ")";
    }
}
