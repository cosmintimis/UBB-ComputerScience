package model.statements;

import exceptions.MyException;
import model.ProgramState;
import model.adt.MyIDictionary;
import model.adt.MyIStack;
import model.expressions.IExp;
import model.expressions.NotExp;
import model.types.BoolType;
import model.types.IType;

public class RepeatUntilStmt implements IStmt{

    IExp expression;
    IStmt statement;

    public RepeatUntilStmt(IStmt statement, IExp expression ){
        this.statement = statement;
        this.expression = expression;
    }

    @Override
    public ProgramState execute(ProgramState state) throws MyException {
        IStmt newStmt = new CompStmt(statement, new WhileStmt(new NotExp(expression), statement));
        state.getExeStack().push(newStmt);
        return null;
    }

    @Override
    public MyIDictionary<String, IType> typecheck(MyIDictionary<String, IType> typeEnv) throws MyException {
        IType type = expression.typecheck(typeEnv);
        if (type.equals(new BoolType())) {
            statement.typecheck(typeEnv.copy());
            return typeEnv;
        } else {
            throw new MyException("RepeatUntilStmt: Expression must be bool type!");
        }
    }

    @Override
    public IStmt deepcopy() {
        return new RepeatUntilStmt(statement.deepcopy(), expression.deepcopy());
    }

    @Override
    public String toString() {
        return "repeat{ " + statement + " } until " + expression;
    }
}
