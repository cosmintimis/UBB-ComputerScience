package model.statements;

import exceptions.MyException;
import model.ProgramState;
import model.adt.MyIDictionary;
import model.adt.MyIStack;
import model.expressions.ValueExp;
import model.types.IType;
import model.values.IntValue;

public class WaitStmt implements IStmt{

    int number;

    public WaitStmt(int number){
        this.number = number;
    }

    @Override
    public ProgramState execute(ProgramState state) throws MyException {

        if(number > 0){
            state.getExeStack().push(new CompStmt(new PrintStmt(new ValueExp(new IntValue(number))), new WaitStmt(number - 1)));
        }

        return null;
    }

    @Override
    public MyIDictionary<String, IType> typecheck(MyIDictionary<String, IType> typeEnv) throws MyException {
        return typeEnv;
    }

    @Override
    public IStmt deepcopy() {
        return new WaitStmt(number);
    }

    @Override
    public String toString() {
        return "wait(" + number + ")";
    }
}
