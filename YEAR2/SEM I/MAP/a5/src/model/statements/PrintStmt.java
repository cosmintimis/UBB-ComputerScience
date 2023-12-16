package model.statements;

import exceptions.MyException;
import model.ProgramState;
import model.adt.MyIDictionary;
import model.adt.MyIHeap;
import model.adt.MyIList;
import model.expressions.IExp;
import model.values.IValue;

public class PrintStmt implements IStmt{

    IExp expression;
    public PrintStmt(IExp expression){
        this.expression = expression;
    }

    @Override
    public String toString() {
        return "print(" + expression + ");";
    }

    @Override
    public ProgramState execute(ProgramState state) throws MyException {
        MyIList<IValue> outputList = state.getOutputList();
        MyIDictionary<String, IValue> symTable = state.getSymTable();
        MyIHeap heap = state.getHeap();
        outputList.add(expression.evaluation(symTable, heap));
        return null;
    }

    @Override
    public IStmt deepcopy() {
        return new PrintStmt(expression.deepcopy());
    }
}
