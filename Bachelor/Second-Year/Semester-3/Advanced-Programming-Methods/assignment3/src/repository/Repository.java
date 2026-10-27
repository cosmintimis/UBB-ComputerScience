package repository;

import exceptions.MyException;
import model.ProgramState;
import model.adt.MyIDictionary;
import model.adt.MyIList;
import model.adt.MyIStack;
import model.adt.MyStack;
import model.statements.IStmt;
import model.values.IValue;
import model.values.StringValue;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class Repository implements IRepository{

    List<ProgramState> programStates = new ArrayList<>();
    String filePath;

    public Repository(ProgramState ps, String filePath){
        programStates.add(ps);
        this.filePath = filePath;
    }

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

    @Override
    public void logProgramStateExecution() throws Exception {
        PrintWriter logFile = new PrintWriter(new BufferedWriter(new FileWriter(filePath, true)));

        MyIStack<IStmt> executionStack = getCurrentProgramState().getExeStack();
        MyIStack<IStmt> auxiliaryStack = new MyStack<>();
        MyIDictionary<String, IValue> symTable = getCurrentProgramState().getSymTable();
        MyIDictionary<StringValue, BufferedReader> fileTable = getCurrentProgramState().getFileTable();
        MyIList<IValue> outputList = getCurrentProgramState().getOutputList();

        logFile.println("ExeStack:");
        while (!executionStack.isEmpty()){
            IStmt currentStatement = executionStack.pop();
            logFile.println(currentStatement);
            auxiliaryStack.push(currentStatement);
        }
        while (!auxiliaryStack.isEmpty()){
            executionStack.push(auxiliaryStack.pop());
        }

        logFile.println("SymTable:");
        for(Map.Entry<String, IValue> s : symTable.getIterableSet()){
            logFile.println(s.getKey() + "->" + s.getValue());
        }

        logFile.println("Out:");
        for(int i = 0; i < outputList.getSize(); i++){
            logFile.println(outputList.get(i));
        }

        logFile.println("FileTable:");
        for(Map.Entry<StringValue, BufferedReader> s : fileTable.getIterableSet()){
            logFile.println(s.getKey());
        }

        logFile.println();
        String dashLine = "-".repeat(50);
        logFile.println(dashLine);
        logFile.println();

        logFile.flush();


    }
}
