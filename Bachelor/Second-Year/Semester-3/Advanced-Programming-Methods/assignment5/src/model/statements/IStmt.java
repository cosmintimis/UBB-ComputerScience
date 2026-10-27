package model.statements;

import exceptions.MyException;
import model.ProgramState;

public interface IStmt {
    ProgramState execute(ProgramState state) throws MyException;

    IStmt deepcopy();
}
