package model.statements;

import exceptions.MyException;
import model.ProgramState;

public class NopStmt implements IStmt{

    @Override
    public ProgramState execute(ProgramState state) throws MyException {
        return null;
    }

    @Override
    public String toString() {
        return "";
    }

    @Override
    public IStmt deepcopy() {
        return null;
    }
}
