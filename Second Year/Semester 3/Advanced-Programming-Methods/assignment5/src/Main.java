import controller.Controller;
import model.ProgramState;
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

import java.util.Scanner;

public class Main {
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

        Scanner input = new Scanner(System.in);
        System.out.print("Enter output file name: ");
        String fileName = input.next();
        System.out.println();

        ProgramState ps1 = new ProgramState(example1);
        ProgramState ps2 = new ProgramState(example2);
        ProgramState ps3 = new ProgramState(example3);
        ProgramState ps4 = new ProgramState(example4);
        ProgramState ps5 = new ProgramState(example5);
        ProgramState ps6 = new ProgramState(example6);
        ProgramState ps7 = new ProgramState(example7);
        ProgramState ps8 = new ProgramState(example8);
        ProgramState ps9 = new ProgramState(example9);
        ProgramState ps10 = new ProgramState(example10);
        ProgramState ps11 = new ProgramState(example11);

        Repository repository1 = new Repository(ps1, fileName);
        Controller controller1 = new Controller(repository1);

        Repository repository2 = new Repository(ps2, fileName);
        Controller controller2 = new Controller(repository2);

        Repository repository3 = new Repository(ps3, fileName);
        Controller controller3 = new Controller(repository3);

        Repository repository4 = new Repository(ps4, fileName);
        Controller controller4 = new Controller(repository4);

        Repository repository5 = new Repository(ps5, fileName);
        Controller controller5 = new Controller(repository5);

        Repository repository6 = new Repository(ps6, fileName);
        Controller controller6 = new Controller(repository6);

        Repository repository7 = new Repository(ps7, fileName);
        Controller controller7 = new Controller(repository7);

        Repository repository8 = new Repository(ps8, fileName);
        Controller controller8 = new Controller(repository8);

        Repository repository9 = new Repository(ps9, fileName);
        Controller controller9 = new Controller(repository9);

        Repository repository10 = new Repository(ps10, fileName);
        Controller controller10 = new Controller(repository10);

        Repository repository11 = new Repository(ps11, fileName);
        Controller controller11 = new Controller(repository11);

        TextMenu menu = new TextMenu();
        menu.addCommand(new ExitCommand("0", "exit"));
        menu.addCommand(new RunExample("1", example1.toString(), controller1));
        menu.addCommand(new RunExample("2", example2.toString(), controller2));
        menu.addCommand(new RunExample("3", example3.toString(), controller3));
        menu.addCommand(new RunExample("4", example4.toString(), controller4));
        menu.addCommand(new RunExample("5", example5.toString(), controller5));
        menu.addCommand(new RunExample("6", example6.toString(), controller6));
        menu.addCommand(new RunExample("7", example7.toString(), controller7));
        menu.addCommand(new RunExample("8", example8.toString(), controller8));
        menu.addCommand(new RunExample("9", example9.toString(), controller9));
        menu.addCommand(new RunExample("10", example10.toString(), controller10));
        menu.addCommand(new RunExample("11", example11.toString(), controller11));

        menu.show();


    }
}