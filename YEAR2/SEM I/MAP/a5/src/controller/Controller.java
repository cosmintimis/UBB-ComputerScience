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
import java.util.Objects;
import java.util.concurrent.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Controller {

    IRepository repository;
    ExecutorService executor;

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

    List<ProgramState> removeCompletedPrograms(List<ProgramState> programStates) {
        return programStates.stream()
                .filter(ProgramState::isNotCompleted)
                .collect(Collectors.toList());
    }


    void oneStepForAllPrograms(List<ProgramState> programStatesList) throws Exception, MyException {

        programStatesList.forEach(program -> repository.logProgramStateExecution(program));

        List<Callable<ProgramState>> callList = programStatesList.stream()
                .map((ProgramState prg) -> (Callable<ProgramState>) (prg::oneStep))
                .toList();

        List<ProgramState> newProgramStatesList = executor.invokeAll(callList).stream()
                .map(future -> {
                    try {
                        return future.get();
                    } catch (Exception e) {
                        try {
                            throw new MyException(e.toString());
                        } catch (MyException ex) {
                            throw new RuntimeException(ex);
                        }
                    }
                })
                .filter(Objects::nonNull)
                .toList();

        ProgramState firstProgram = programStatesList.get(0);
        List<Integer> addressesToKeep = Stream.concat(
                getAddresses(firstProgram.getSymTable().getContent().values()).stream(),
                getAddresses(firstProgram.getHeap().getContent().values()).stream()
        ).toList();
        firstProgram.getHeap().setContent(garbageCollector(addressesToKeep, firstProgram.getHeap().getContent()));

        programStatesList.addAll(newProgramStatesList);

        programStatesList.forEach(program -> repository.logProgramStateExecution(program));

        repository.setCurrentProgramStatesList(programStatesList);

    }

    public void allSteps() throws Exception {

        executor = Executors.newFixedThreadPool(2);

        List<ProgramState> programStatesList = removeCompletedPrograms(repository.getCurrentProgramStatesList());

        while (!programStatesList.isEmpty()) {
//            ProgramState firstProgram = programStatesList.get(0);
//            List<Integer> addressesToKeep = Stream.concat(
//                    getAddresses(firstProgram.getSymTable().getContent().values()).stream(),
//                    getAddresses(firstProgram.getHeap().getContent().values()).stream()
//            ).toList();
//            firstProgram.getHeap().setContent(garbageCollector(addressesToKeep, firstProgram.getHeap().getContent()));
            oneStepForAllPrograms(programStatesList);
            programStatesList = removeCompletedPrograms(repository.getCurrentProgramStatesList());
        }

        executor.shutdown();
        repository.setCurrentProgramStatesList(programStatesList);

    }

}
