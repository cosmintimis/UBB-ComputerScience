package model.statements;

import exceptions.MyException;
import model.ProgramState;
import model.adt.MyIStack;

public class CompStmt implements IStmt{
    IStmt firstStmt, secondStmt;

    public CompStmt(IStmt firstStmt, IStmt secondStmt){
        this.firstStmt = firstStmt;
        this.secondStmt = secondStmt;
    }
    public String toString() {
        return "("+firstStmt.toString() + ";" + secondStmt.toString()+")";
    }

    @Override
    public ProgramState execute(ProgramState state) throws MyException {
        MyIStack<IStmt> stack=state.getExeStack();
        stack.push(secondStmt);
        stack.push(firstStmt);
        return null;
    }

    @Override
    public IStmt deepcopy() {
        return new CompStmt(firstStmt.deepcopy(), secondStmt.deepcopy());
    }
}
