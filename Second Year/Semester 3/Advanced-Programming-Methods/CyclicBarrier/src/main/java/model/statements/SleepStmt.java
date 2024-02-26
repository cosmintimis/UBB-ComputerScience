package model.statements;

import exceptions.MyException;
import model.ProgramState;
import model.adt.MyIDictionary;
import model.adt.MyIStack;
import model.types.IType;

public class SleepStmt implements IStmt{

    int number;

    public SleepStmt(int number){
        this.number = number;
    }


    @Override
    public ProgramState execute(ProgramState state) throws MyException {

        if(number > 0){
            state.getExeStack().push(new SleepStmt(number - 1));
        }

        return null;
    }

    @Override
    public MyIDictionary<String, IType> typecheck(MyIDictionary<String, IType> typeEnv) throws MyException {
        return typeEnv;
    }

    @Override
    public IStmt deepcopy() {
        return new SleepStmt(number);
    }

    @Override
    public String toString() {
        return "sleep(" + number + ")";
    }
}
