package model;

import model.adt.*;
import model.statements.IStmt;
import model.values.IValue;
import model.values.StringValue;

import java.io.BufferedReader;

public class ProgramState {
    MyIStack<IStmt> exeStack = new MyStack<>();
    MyIDictionary<String, IValue> symTable = new MyDictionary<>();
    MyIList<IValue> outputList = new MyList<>();

    MyIDictionary<StringValue, BufferedReader> fileTable = new MyDictionary<>();

    IStmt originalProgram;

    public ProgramState(IStmt originalProgram){
        this.originalProgram = originalProgram;
        exeStack.push(originalProgram);
    }

    public MyIList<IValue> getOutputList(){
        return outputList;
    }

    public MyIDictionary<String, IValue> getSymTable(){
        return symTable;
    }

    public MyIStack<IStmt> getExeStack(){
        return exeStack;
    }

    public MyIDictionary<StringValue, BufferedReader> getFileTable(){
        return fileTable;
    }

}
