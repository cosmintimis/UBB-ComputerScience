import controller.Controller;
import exceptions.MyException;
import model.ProgramState;
import model.adt.MyDictionary;
import model.adt.MyHeap;
import model.adt.MyIHeap;
import model.expressions.*;
import model.statements.*;
import model.types.BoolType;
import model.types.IntType;
import model.types.RefType;
import model.types.StringType;
import model.values.BoolValue;
import model.values.IntValue;
import model.values.StringValue;
import repository.Repository;
import view.ExitCommand;
import view.RunExample;
import view.TextMenu;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class Main {

    private static int id = 1;
    private static void buildProgram(IStmt prgExample, String fileName, TextMenu menu){
        try{
            prgExample.typecheck(new MyDictionary<>());
            ProgramState prgState = new ProgramState(prgExample);
            Repository repository = new Repository(prgState, fileName);
            Controller controller = new Controller(repository);
            menu.addCommand(new RunExample(String.valueOf(id), prgExample.toString(), controller));
            id++;

        }catch (MyException e) {
            System.out.println(e.toString());
        }

    }

    public static void main(String[] args) {


        IStmt example1 = new CompStmt(new VarDeclStmt("v", new IntType()),
                new CompStmt(new AssignStmt("v", new ValueExp(new IntValue(2))), new PrintStmt(new
                        VarExp("v"))));

        IStmt example2 = new CompStmt(new VarDeclStmt("a", new IntType()),
                new CompStmt(new VarDeclStmt("b", new IntType()),
                        new CompStmt(new AssignStmt("a", new ArithExp(new ValueExp(new IntValue(2)), new
                                ArithExp(new ValueExp(new IntValue(3)), new ValueExp(new IntValue(5)), "*"), "+")),
                                new CompStmt(new AssignStmt("b", new ArithExp(new VarExp("a"), new ValueExp(new
                                        IntValue(1)), "+")), new PrintStmt(new VarExp("b"))))));

        IStmt example3 = new CompStmt(new VarDeclStmt("a", new BoolType()),
                new CompStmt(new VarDeclStmt("v", new IntType()),
                        new CompStmt(new AssignStmt("a", new ValueExp(new BoolValue(true))),
                                new CompStmt(new IfStmt(new VarExp("a"), new AssignStmt("v", new ValueExp(new
                                        IntValue(2))), new AssignStmt("v", new ValueExp(new IntValue(3)))), new PrintStmt(new
                                        VarExp("v"))))));

        IStmt example4 = new CompStmt(new VarDeclStmt("varf", new StringType()),
                new CompStmt(new AssignStmt("varf", new ValueExp(new StringValue("test.in"))),
                        new CompStmt(new OpenReadFileStmt(new VarExp("varf")),
                                new CompStmt(new VarDeclStmt("varc", new IntType()),
                                        new CompStmt(new ReadFileStmt(new VarExp("varf"), "varc"),
                                                new CompStmt(new PrintStmt(new VarExp("varc")),
                                                        new CompStmt(new ReadFileStmt(new VarExp("varf"), "varc"),
                                                                new CompStmt(new PrintStmt(new VarExp("varc")),
                                                                        new CloseReadFileStmt(new VarExp("varf"))))))))));

        IStmt example5 = new CompStmt(new VarDeclStmt("a", new IntType()),
                new CompStmt(new VarDeclStmt("b", new IntType()), new CompStmt(new AssignStmt("a", new ValueExp(new IntValue(12))),
                        new CompStmt(new AssignStmt("b", new ValueExp(new IntValue(15))), new CompStmt(new VarDeclStmt("r", new BoolType()),
                                new CompStmt(new AssignStmt("r", new RelationalExpression(new VarExp("a"), new VarExp("b"), "<")),
                                        new PrintStmt(new VarExp("r")))
                        )))));

        IStmt example6 = new CompStmt(new VarDeclStmt("v", new RefType(new IntType())),
                new CompStmt(new HeapAllocationStmt("v", new ValueExp(new IntValue(20))),
                        new CompStmt(new VarDeclStmt("a", new RefType(new RefType(new IntType()))),
                                new CompStmt(new HeapAllocationStmt("a", new VarExp("v")),
                                        new CompStmt(new PrintStmt(new VarExp("v")),
                                                new PrintStmt(new VarExp("a"))
                                        )
                                )
                        )
                )
        );

        IStmt example7 = new CompStmt(new VarDeclStmt("v", new IntType()),
                new CompStmt(new AssignStmt("v", new ValueExp(new IntValue(4))),
                        new CompStmt(new WhileStmt(
                                new RelationalExpression(new VarExp("v"), new ValueExp(new IntValue(0)), ">"),
                                new CompStmt(new PrintStmt(new VarExp("v")),
                                        new AssignStmt("v", new ArithExp(new VarExp("v"), new ValueExp(new IntValue(1)), "-"))
                                )
                        ), new PrintStmt(new VarExp("v"))
                        )
                )
        );

        IStmt example8 = new CompStmt(new VarDeclStmt("v", new RefType(new IntType())),
                new CompStmt(new HeapAllocationStmt("v", new ValueExp(new IntValue(20))),
                        new CompStmt(new VarDeclStmt("a", new RefType(new RefType(new IntType()))),
                                new CompStmt(new HeapAllocationStmt("a", new VarExp("v")),
                                        new CompStmt(new PrintStmt(new HeapReadingExp(new VarExp("v"))),
                                                new PrintStmt(new ArithExp(new HeapReadingExp(new HeapReadingExp(new VarExp("a"))),
                                                        new ValueExp(new IntValue(5)), "+"
                                                )
                                                )
                                        )
                                )
                        )
                )
        );


        IStmt example9 = new CompStmt(new VarDeclStmt("v", new RefType(new IntType())),
                new CompStmt(new HeapAllocationStmt("v", new ValueExp(new IntValue(20))),
                        new CompStmt(new PrintStmt(new HeapReadingExp(new VarExp("v"))),
                                new CompStmt(new HeapWritingStmt("v", new ValueExp(new IntValue(30))),
                                        new PrintStmt(new ArithExp(
                                                new HeapReadingExp(new VarExp("v")),
                                                new ValueExp(new IntValue(5)), "+"
                                        )
                                        )
                                )
                        )
                )
        );

        IStmt example10 = new CompStmt(new VarDeclStmt("v", new RefType(new IntType())),
                new CompStmt(new HeapAllocationStmt("v", new ValueExp(new IntValue(20))),
                        new CompStmt(new VarDeclStmt("a", new RefType(new RefType(new IntType()))),
                                new CompStmt(new HeapAllocationStmt("a", new VarExp("v")),
                                        new CompStmt(new HeapAllocationStmt("v", new ValueExp(new IntValue(30))),
                                                new CompStmt(new PrintStmt(new HeapReadingExp(new HeapReadingExp(new VarExp("a")))),
                                                        new HeapAllocationStmt("v", new ValueExp(new IntValue(90))))))
                        )
                )

        );

        IStmt example11 = new CompStmt(new VarDeclStmt("v", new IntType()),
                new CompStmt(new VarDeclStmt("a", new RefType(new IntType())),
                        new CompStmt(new AssignStmt("v", new ValueExp(new IntValue(10))),
                                new CompStmt(new HeapAllocationStmt("a", new ValueExp(new IntValue(22))),
                                        new CompStmt(new ForkStmt(
                                                new CompStmt(new HeapWritingStmt("a", new ValueExp(new IntValue(30))),
                                                        new CompStmt(new AssignStmt("v", new ValueExp(new IntValue(32))),
                                                                new CompStmt(new PrintStmt(new VarExp("v")),
                                                                        new PrintStmt(new HeapReadingExp(new VarExp("a")))
                                                                )
                                                        )
                                                )
                                        ),
                                                new CompStmt(new PrintStmt(new VarExp("v")),
                                                        new PrintStmt(new HeapReadingExp(new VarExp("a")))
                                                )
                                        )
                                )
                        )
                )
        );

        IStmt example12 = new CompStmt(new VarDeclStmt("a", new RefType(new IntType())),
                new CompStmt( new VarDeclStmt("counter", new IntType()),
                new WhileStmt(new RelationalExpression(new VarExp("counter"), new ValueExp(new IntValue(10)), "<"),
                        new CompStmt( new ForkStmt(new ForkStmt(new CompStmt(new HeapAllocationStmt("a", new VarExp("counter")),
                                new PrintStmt(new HeapReadingExp(new VarExp("a")))))),new AssignStmt("counter", new ArithExp(new VarExp("counter"), new ValueExp(new IntValue(1)), "+"))
                        )



                )));


        Scanner input = new Scanner(System.in);
        System.out.print("Enter output file name: ");
        String fileName = input.next();
        System.out.println();

        TextMenu menu = new TextMenu();
        menu.addCommand(new ExitCommand("0", "exit"));

        buildProgram(example1, fileName, menu);
        buildProgram(example2, fileName, menu);
        buildProgram(example3, fileName, menu);
        buildProgram(example4, fileName, menu);
        buildProgram(example5, fileName, menu);
        buildProgram(example6, fileName, menu);
        buildProgram(example7, fileName, menu);
        buildProgram(example8, fileName, menu);
        buildProgram(example9, fileName, menu);
        buildProgram(example10, fileName, menu);
        buildProgram(example11, fileName, menu);
        buildProgram(example12, fileName, menu);

        menu.show();

    }
}