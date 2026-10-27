package controller;

import exceptions.MyException;
import model.ProgramState;
import model.adt.MyIStack;
import model.statements.IStmt;
import repository.IRepository;

public class Controller {

    IRepository repository;

    public Controller(IRepository repo) {
        this.repository = repo;
    }

    public void addProgramState(ProgramState ps) {
        repository.addProgramState(ps);
    }

    public ProgramState oneStep(ProgramState state) throws MyException {
        MyIStack<IStmt> stack = state.getExeStack();

        if (stack.isEmpty())
            throw new MyException("ProgramState stack is empty!");
        IStmt createdStatement = stack.pop();
        return createdStatement.execute(state);
    }

    public void allSteps() throws MyException {
        ProgramState programState;

        programState = repository.getCurrentProgramState();

        if (programState.getExeStack().isEmpty())
            throw new MyException("ProgramState stack is empty!");

        while (!programState.getExeStack().isEmpty()) {

            oneStep(programState);

        }
    }
}
