package model;

import exceptions.MyException;
import model.adt.*;
import model.statements.IStmt;
import model.values.IValue;
import model.values.StringValue;

import java.io.BufferedReader;
import java.util.Vector;

public class ProgramState {
    MyIStack<IStmt> exeStack;
    MyIDictionary<String, IValue> symTable;
    MyIList<IValue> outputList;

    MyIDictionary<StringValue, BufferedReader> fileTable;

    MyIHeap<Integer, IValue> heap;

    MyIBarrierTable barrierTable;

    IStmt originalProgram;

    private final int id;
    static final Vector<Integer> usedIds = new Vector<>();

    public ProgramState(IStmt originalProgram) {
        this.exeStack = new MyStack<>();
        this.symTable = new MyDictionary<>();
        this.outputList = new MyList<>();
        this.fileTable = new FileTable<>();
        this.heap = new MyHeap<>();
        this.barrierTable = new MyBarrierTable();
        this.originalProgram = originalProgram.deepcopy();
        exeStack.push(originalProgram);

        id = generateNewId();
        usedIds.add(id);
    }

    public ProgramState(MyIStack<IStmt> exeStack, MyIDictionary<String, IValue> symTable, MyIList<IValue> outputList, MyIDictionary<StringValue, BufferedReader> fileTable, MyIHeap<Integer, IValue> heap, MyIBarrierTable barrierTable, IStmt program) {
        this.exeStack = exeStack;
        this.symTable = symTable;
        this.outputList = outputList;
        this.fileTable = fileTable;
        this.heap = heap;
        this.barrierTable = barrierTable;
        this.originalProgram = program.deepcopy();
        exeStack.push(program);

        id = generateNewId();
        usedIds.add(id);
    }

    @Override
    public String toString() {
        return  "Id --> " + id + "\n" +
                "ExeStack:\n" + exeStack.toString() +
                "SymbolTable:\n" + symTable.toString() +
                "Heap:\n" + heap.toString() +
                "BarrierTable:\n" + barrierTable.toString() +
                "Out:\n" + outputList.toString() +
                "FileTable:\n" + fileTable.toString() +
                "-------------------------------------------------------------\n\n";
    }


    private int generateNewId(){
        int newId = 1;
        synchronized (usedIds) {
            while (usedIds.contains(newId))
                newId++;
        }
        return newId;
    }
    public ProgramState oneStep() throws MyException {
        if(exeStack.isEmpty()) {
            throw new MyException("Program state stack is empty!");
        }
        IStmt createdStatement = exeStack.pop();
        return createdStatement.execute(this);
    }

    public Boolean isNotCompleted(){ return !exeStack.isEmpty();}
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

    public MyIHeap<Integer, IValue> getHeap(){
        return heap;
    }

    public MyIBarrierTable getBarrierTable() {
        return barrierTable;
    }

    public int getId() {
        return id;
    }
}
