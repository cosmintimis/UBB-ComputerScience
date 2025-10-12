package model.statements;

import exceptions.MyException;
import model.ProgramState;
import model.adt.MyIDictionary;
import model.types.IType;

public class ReturnStmt implements IStmt{
    @Override
    public ProgramState execute(ProgramState state) throws MyException {
        state.getSymTable().pop();
        return null;
    }

    @Override
    public MyIDictionary<String, IType> typecheck(MyIDictionary<String, IType> typeEnv) throws MyException {
        return typeEnv;
    }

    @Override
    public IStmt deepcopy() {
        return new ReturnStmt();
    }

    @Override
    public String toString() {
        return "return";
    }
}
