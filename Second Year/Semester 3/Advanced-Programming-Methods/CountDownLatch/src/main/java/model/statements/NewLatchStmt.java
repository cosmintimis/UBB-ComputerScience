package model.statements;

import exceptions.MyException;
import model.ProgramState;
import model.adt.MyIDictionary;
import model.adt.MyIHeap;
import model.adt.MyILatchTable;
import model.expressions.IExp;
import model.types.IType;
import model.types.IntType;
import model.values.IValue;
import model.values.IntValue;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class NewLatchStmt implements IStmt{

    String varName;

    IExp expression;

    static final Lock lock = new ReentrantLock();

    public NewLatchStmt(String varName, IExp expression){
        this.varName = varName;
        this.expression = expression;
    }

    @Override
    public ProgramState execute(ProgramState state) throws MyException {

        MyIDictionary<String, IValue> symTable = state.getSymTable();
        MyIHeap<Integer, IValue> heap = state.getHeap();

        IValue valueOfExpression = expression.evaluation(symTable, heap);

        if(!valueOfExpression.getType().equals(new IntType()))
            throw new MyException("NewLatchStmt: invalid expression type!");

        lock.lock();

        MyILatchTable latchTable = state.getLatchTable();

        int number = ((IntValue) valueOfExpression).getVal();
        int freeLocation = latchTable.getFreeLocation();

        latchTable.put(freeLocation, number);


        /// change this to add var to symTable if needed
        if(!symTable.isDefined(varName))
            throw new MyException("NewLatchStmt: given variable undefined in symTable!");

        if(!symTable.lookup(varName).getType().equals(new IntType()))
            throw new MyException("NewLatchStmt: invalid type of variable!");

        symTable.update(varName, new IntValue(freeLocation));

        lock.unlock();

        return null;
    }

    @Override
    public MyIDictionary<String, IType> typecheck(MyIDictionary<String, IType> typeEnv) throws MyException {
        IType varType = typeEnv.lookup(varName);
        IType expType = expression.typecheck(typeEnv);

        if(varType.equals(new IntType()) && expType.equals(new IntType()))
            return typeEnv;

        throw new MyException("NewLatchStmt: variable/expression invalid type!");
    }

    @Override
    public IStmt deepcopy() {
        return new NewLatchStmt(varName, expression.deepcopy());
    }

    @Override
    public String toString() {
        return "newLatch(" + varName + "," + expression + ")";
    }
}
