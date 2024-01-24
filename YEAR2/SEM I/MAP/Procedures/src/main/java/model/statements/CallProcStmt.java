package model.statements;

import exceptions.MyException;
import model.ProgramState;
import model.adt.MyDictionary;
import model.adt.MyIDictionary;
import model.adt.MyIHeap;
import model.adt.MyIProcTable;
import model.expressions.IExp;
import model.types.IType;
import model.values.IValue;

import java.util.List;

public class CallProcStmt implements IStmt{

    String procName;
    List<IExp> expressions;

    public CallProcStmt(String procName, List<IExp> expressions) {
        this.procName = procName;
        this.expressions = expressions;
    }
    @Override
    public ProgramState execute(ProgramState state) throws MyException {
        MyIDictionary<String, IValue> symTable = state.getTopOfSymTable();
        MyIHeap<Integer, IValue> heap = state.getHeap();
        MyIProcTable procTable = state.getProcTable();
        if (!procTable.isDefined(procName))
            throw new MyException("CallProcStmt: Procedure undefined!");

        List<String> variables = procTable.get(procName).getKey();
        IStmt statement = procTable.get(procName).getValue();
        MyIDictionary<String, IValue> newSymTable = new MyDictionary<>();
        for(String var: variables) {
            int index = variables.indexOf(var);
            newSymTable.update(var, expressions.get(index).evaluation(symTable, heap));
        }
        state.getSymTable().push(newSymTable);
        state.getExeStack().push(new ReturnStmt());
        state.getExeStack().push(statement);
        return null;
    }

    @Override
    public MyIDictionary<String, IType> typecheck(MyIDictionary<String, IType> typeEnv) throws MyException {
        return typeEnv;
    }

    @Override
    public IStmt deepcopy() {
        return new CallProcStmt(procName, expressions);
    }

    @Override
    public String toString() {
        return "call " + procName + "(" + expressions.toString() + ")";
    }
}
