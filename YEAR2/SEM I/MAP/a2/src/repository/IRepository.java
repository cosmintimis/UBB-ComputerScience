package repository;

import exceptions.MyException;
import model.ProgramState;

public interface IRepository {
    ProgramState getCurrentProgramState() throws MyException;
    void addProgramState(ProgramState ps);
}
