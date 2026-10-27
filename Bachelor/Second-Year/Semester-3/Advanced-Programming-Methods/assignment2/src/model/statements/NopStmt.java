package model.statements;

import exceptions.MyException;
import model.ProgramState;

public class NopStmt implements IStmt{

    @Override
    public ProgramState execute(ProgramState state) {
        return state;
    }

    @Override
    public String toString() {
        return "nop";
    }

    @Override
    public IStmt deepcopy() {
        return new NopStmt() ;
    }
}
