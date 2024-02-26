package model;

import model.adt.*;
import model.statements.IStmt;
import model.values.IValue;
import model.values.StringValue;

import java.io.BufferedReader;

public class ProgramState {
    MyIStack<IStmt> exeStack;
    MyIDictionary<String, IValue> symTable;
    MyIList<IValue> outputList;

    MyIDictionary<StringValue, BufferedReader> fileTable;

    MyIHeap<Integer, IValue> heap;

    IStmt originalProgram;

    public ProgramState(IStmt originalProgram) {
        this.exeStack = new MyStack<>();
        this.symTable = new MyDictionary<>();
        this.outputList = new MyList<>();
        this.fileTable = new FileTable<>();
        this.heap = new MyHeap<>();
        this.originalProgram = originalProgram.deepcopy();
        exeStack.push(originalProgram);
    }

    @Override
    public String toString() {
        return "ExeStack:\n" + exeStack.toString() +
                "SymbolTable:\n" + symTable.toString() +
                "Heap:\n" + heap.toString() +
                "Out:\n" + outputList.toString() +
                "FileTable:\n" + fileTable.toString() +
                "-------------------------------------------------------------\n\n";
    }

    public MyIList<IValue> getOutputList() {
        return outputList;
    }

    public MyIDictionary<String, IValue> getSymTable() {
        return symTable;
    }

    public MyIStack<IStmt> getExeStack() {
        return exeStack;
    }

    public MyIDictionary<StringValue, BufferedReader> getFileTable() {
        return fileTable;
    }

    public MyIHeap getHeap(){
        return heap;
    }

}
