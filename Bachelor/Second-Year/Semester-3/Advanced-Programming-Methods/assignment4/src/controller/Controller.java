package controller;

import exceptions.MyException;
import model.ProgramState;
import model.adt.MyIStack;
import model.statements.IStmt;
import model.values.IValue;
import model.values.RefValue;
import repository.IRepository;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Controller {

    IRepository repository;

    public Controller(IRepository repo) {
        this.repository = repo;
    }

    public void addProgramState(ProgramState ps) {
        repository.addProgramState(ps);
    }


    Map<Integer, IValue> garbageCollector(List<Integer> addressesToKeep, Map<Integer, IValue> heap) {
        return heap.entrySet().stream()
                .filter(e -> addressesToKeep.contains(e.getKey()))
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
    }

    List<Integer> getAddresses(Collection<IValue> collection) {
        return collection.stream().filter(v -> v instanceof RefValue).map(v -> {
            RefValue v1 = (RefValue) v;
            return v1.getAddress();
        }).collect(Collectors.toList());
    }


    public ProgramState oneStep(ProgramState state) throws MyException {
        MyIStack<IStmt> stack = state.getExeStack();

        if (stack.isEmpty()) throw new MyException("ProgramState stack is empty!");
        IStmt createdStatement = stack.pop();
        return createdStatement.execute(state);
    }

    public void allSteps() throws MyException, Exception {
        ProgramState programState;

        programState = repository.getCurrentProgramState();
        repository.logProgramStateExecution();

        if (programState.getExeStack().isEmpty()) throw new MyException("ProgramState stack is empty!");

        while (!programState.getExeStack().isEmpty()) {

            oneStep(programState);
            repository.logProgramStateExecution();

            List<Integer> addressesToKeep = Stream.concat(getAddresses(programState.getSymTable().getContent().values()).stream(),
                    getAddresses(programState.getHeap().getContent().values()).stream()).toList();

            programState.getHeap().setContent(garbageCollector(addressesToKeep, programState.getHeap().getContent()));
            repository.logProgramStateExecution();

        }
    }
}
