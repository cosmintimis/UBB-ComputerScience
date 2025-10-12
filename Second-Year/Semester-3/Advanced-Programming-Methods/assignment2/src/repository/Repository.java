package repository;

import exceptions.MyException;
import model.ProgramState;

import java.util.ArrayList;
import java.util.List;

public class Repository implements IRepository{

    List<ProgramState> programStates = new ArrayList<>();

    @Override
    public void addProgramState(ProgramState ps) {
        programStates.add(ps);
    }

    @Override
    public ProgramState getCurrentProgramState() throws MyException {
        if(programStates.isEmpty())
            throw new MyException("No program state available!");
        return programStates.get(programStates.size() - 1);
    }
}
