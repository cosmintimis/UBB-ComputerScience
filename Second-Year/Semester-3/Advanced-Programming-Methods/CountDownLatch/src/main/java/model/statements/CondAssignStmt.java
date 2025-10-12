package model.statements;

import exceptions.MyException;
import model.ProgramState;
import model.adt.MyIDictionary;
import model.expressions.IExp;
import model.types.BoolType;
import model.types.IType;

public class CondAssignStmt implements IStmt{


    String varName;

    IExp exp1, exp2, exp3;

    public CondAssignStmt(String varName, IExp exp1, IExp exp2, IExp exp3){
        this.varName = varName;
        this.exp1 = exp1;
        this.exp2 = exp2;
        this.exp3 = exp3;
    }

    @Override
    public ProgramState execute(ProgramState state) throws MyException {
        IStmt newStmt = new IfStmt(exp1, new AssignStmt(varName, exp2), new AssignStmt(varName, exp3));
        state.getExeStack().push(newStmt);
        return null;
    }

    @Override
    public MyIDictionary<String, IType> typecheck(MyIDictionary<String, IType> typeEnv) throws MyException {
        IType type1 = exp1.typecheck(typeEnv);
        IType type2 = exp2.typecheck(typeEnv);
        IType type3 = exp3.typecheck(typeEnv);

        IType varType = typeEnv.lookup(varName);

        if(type1.equals(new BoolType()) && varType.equals(type2) && varType.equals(type3))
        {
            return typeEnv;
        }

        throw new MyException("CondAssignStmt: invalid types of expressions/variable!");

    }

    @Override
    public IStmt deepcopy() {
        return new CondAssignStmt(varName, exp1.deepcopy(), exp2.deepcopy(), exp3.deepcopy());
    }

    @Override
    public String toString() {
        return varName + "= " + exp1 + " ? " + exp2 + " : " + exp3;
    }
}
