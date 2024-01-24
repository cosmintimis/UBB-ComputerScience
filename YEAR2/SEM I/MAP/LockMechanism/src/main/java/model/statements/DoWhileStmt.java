package model.statements;

import exceptions.MyException;
import model.ProgramState;
import model.adt.MyIDictionary;
import model.adt.MyIStack;
import model.expressions.IExp;
import model.types.BoolType;
import model.types.IType;

public class DoWhileStmt implements IStmt{

    IStmt stmt;
    IExp exp;

    public DoWhileStmt(IExp exp, IStmt stmt){
        this.stmt = stmt;
        this.exp = exp;
    }
    @Override
    public ProgramState execute(ProgramState state) throws MyException {
        IStmt newStmt = new CompStmt(stmt, new WhileStmt(exp, stmt));
        state.getExeStack().push(newStmt);
        return null;
    }

    @Override
    public MyIDictionary<String, IType> typecheck(MyIDictionary<String, IType> typeEnv) throws MyException {
        IType type = exp.typecheck(typeEnv);
        if(type.equals(new BoolType()))
        {
            stmt.typecheck(typeEnv.copy());
            return typeEnv;
        }
        throw new MyException("DoWhileStmt: expression must be of bool type!");

    }

    @Override
    public IStmt deepcopy() {
        return new DoWhileStmt(exp.deepcopy(), stmt.deepcopy());
    }

    @Override
    public String toString() {
        return "do{ " + stmt + " }while(" + exp + ")";
    }
}
