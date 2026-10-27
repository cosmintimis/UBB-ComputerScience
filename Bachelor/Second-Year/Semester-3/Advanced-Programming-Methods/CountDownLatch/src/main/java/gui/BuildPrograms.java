package gui;

import model.expressions.*;
import model.statements.*;
import model.types.BoolType;
import model.types.IntType;
import model.types.RefType;
import model.types.StringType;
import model.values.BoolValue;
import model.values.IntValue;
import model.values.StringValue;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class BuildPrograms {

    public static List<IStmt> build()
    {
        IStmt example1 = new CompStmt(new VarDeclStmt("v", new IntType()),
                new CompStmt(new AssignStmt("v", new ValueExp(new IntValue(3))), new PrintStmt(new
                        VarExp("a"))));

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
                                        new PrintStmt(new HeapReadingExp(new VarExp("a")))))),
                                        new AssignStmt("counter", new ArithExp(new VarExp("counter"), new ValueExp(new IntValue(1)), "+"))
                                )
                        )));
        ///ForStmt
        IStmt example13 = new CompStmt(new VarDeclStmt("a", new RefType(new IntType())),
                    new CompStmt(new HeapAllocationStmt("a", new ValueExp(new IntValue(20))),
                            new CompStmt(new ForStmt("v", new ValueExp(new IntValue(0)), new ValueExp(new IntValue(3)),
                                    new ArithExp(new VarExp("v"), new ValueExp(new IntValue(1)), "+"), new ForkStmt(new CompStmt(new PrintStmt(new VarExp("v")),
                                    new AssignStmt("v", new ArithExp(new VarExp("v"), new HeapReadingExp(new VarExp("a")), "*"))
                                    ))), new PrintStmt(new HeapReadingExp(new VarExp("a"))))
                            )
                );

        ///SleepStmt
        IStmt example14 = new CompStmt(new VarDeclStmt("v", new IntType()),
                new CompStmt(new AssignStmt("v", new ValueExp(new IntValue(10))),
                        new CompStmt(new ForkStmt(new CompStmt(new AssignStmt("v", new ArithExp(new VarExp("v"), new ValueExp(new IntValue(1)), "-")),
                                new CompStmt(new AssignStmt("v", new ArithExp(new VarExp("v"), new ValueExp(new IntValue(1)), "-")), new PrintStmt(new VarExp("v"))
                                ))), new CompStmt(new SleepStmt(10), new PrintStmt(new ArithExp(new VarExp("v"), new ValueExp(new IntValue(10)), "*")))
                        )
                ));

        ///WaitStmt
        IStmt example15 = new CompStmt(new VarDeclStmt("v", new IntType()),
            new CompStmt(new AssignStmt("v", new ValueExp(new IntValue(20))), new CompStmt(new WaitStmt(10),
                    new PrintStmt(new ArithExp(new VarExp("v"), new ValueExp(new IntValue(10)), "*"))))
            );

        ///RepeatUntilStmt
        IStmt example16 = new CompStmt(new VarDeclStmt("v", new IntType()),
                new CompStmt(new AssignStmt("v", new ValueExp(new IntValue(0))),
                        new CompStmt(new RepeatUntilStmt(
                                new CompStmt(new ForkStmt(new CompStmt(new PrintStmt(new VarExp("v")),
                                        new AssignStmt("v", new ArithExp( new VarExp("v"), new ValueExp(new IntValue(1)), "-")))),
                                        new AssignStmt("v", new ArithExp( new VarExp("v"), new ValueExp(new IntValue(1)), "+"))),
                                new RelationalExpression( new VarExp("v"), new ValueExp(new IntValue(3)), "==")
                        ),
                                new CompStmt(new VarDeclStmt("x", new IntType()),
                                        new CompStmt(new VarDeclStmt("y", new IntType()),
                                                new CompStmt(new VarDeclStmt("z", new IntType()),
                                                        new CompStmt(new VarDeclStmt("w", new IntType()),
                                                                new CompStmt(new AssignStmt("x", new ValueExp(new IntValue(1))),
                                                                        new CompStmt(new AssignStmt("y", new ValueExp(new IntValue(2))),
                                                                                new CompStmt(new AssignStmt("z", new ValueExp(new IntValue(3))),
                                                                                        new CompStmt(new AssignStmt("w", new ValueExp(new IntValue(4))),
                                                                                                new PrintStmt(new ArithExp( new VarExp("v"), new ValueExp(new IntValue(10)), "*")))))))))))));
        ///MulExp
        IStmt example17 = new CompStmt(new VarDeclStmt("v1", new IntType()),
                new CompStmt(new VarDeclStmt("v2", new IntType()),
                        new CompStmt(new AssignStmt("v1", new ValueExp(new IntValue(2))),
                                new CompStmt(new AssignStmt("v2", new ValueExp(new IntValue(3))),
                                        new IfStmt(new RelationalExpression( new VarExp("v1"), new ValueExp(new IntValue(0)), "!="),
                                                new PrintStmt(new MulExp(new VarExp("v1"), new VarExp("v2"))),
                                                new PrintStmt(new VarExp("v1")))))));
        ///DoWhileStmt
        IStmt example18 = new CompStmt(new VarDeclStmt("v", new IntType()),
                new CompStmt(new AssignStmt("v", new ValueExp(new IntValue(4))),
                        new CompStmt(new DoWhileStmt(new RelationalExpression( new VarExp("v"), new ValueExp(new IntValue(0)), ">"),
                                new CompStmt(new PrintStmt(new VarExp("v")), new AssignStmt("v",new ArithExp( new VarExp("v"), new ValueExp(new IntValue(1)), "-")))),
                                new PrintStmt(new VarExp("v")))));
        /// SwitchStmt
        IStmt example19 = new CompStmt(new VarDeclStmt("a", new IntType()),
            new CompStmt(new VarDeclStmt("b", new IntType()),
                    new CompStmt(new VarDeclStmt("c", new IntType()),
                            new CompStmt(new AssignStmt("a", new ValueExp(new IntValue(1))),
                                    new CompStmt(new AssignStmt("b", new ValueExp(new IntValue(2))),
                                            new CompStmt(new AssignStmt("c", new ValueExp(new IntValue(5))),
                                                    new CompStmt(new SwitchStmt(
                                                            new ArithExp( new VarExp("a"), new ValueExp(new IntValue(10)), "*"),
                                                            new ArithExp( new VarExp("b"), new VarExp("c"), "*"),
                                                            new CompStmt(new PrintStmt(new VarExp("a")), new PrintStmt(new VarExp("b"))),
                                                            new ValueExp(new IntValue(10)),
                                                            new CompStmt(new PrintStmt(new ValueExp(new IntValue(100))), new PrintStmt(new ValueExp(new IntValue(200)))),
                                                            new PrintStmt(new ValueExp(new IntValue(300)))
                                                    ), new PrintStmt(new ValueExp(new IntValue(300))))))))));

        /// CondAssign
        IStmt example20 = new CompStmt(new VarDeclStmt("a", new RefType(new IntType())),
                new CompStmt(new VarDeclStmt("b", new RefType(new IntType())),
                        new CompStmt(new VarDeclStmt("v", new IntType()),
                                new CompStmt(new HeapAllocationStmt("a", new ValueExp(new IntValue(0))),
                                        new CompStmt(new HeapAllocationStmt("b", new ValueExp(new IntValue(0))),
                                                new CompStmt(new HeapWritingStmt("a", new ValueExp(new IntValue(1))),
                                                        new CompStmt(new HeapWritingStmt("b", new ValueExp(new IntValue(2))),
                                                                new CompStmt(new CondAssignStmt(
                                                                        "v",
                                                                        new RelationalExpression(new HeapReadingExp(new VarExp("a")), new HeapReadingExp(new VarExp("b")), "<"),
                                                                        new ValueExp(new IntValue(100)), new ValueExp(new IntValue(200))),
                                                                        new CompStmt(new PrintStmt(new VarExp("v")), new CompStmt(
                                                                                new CondAssignStmt("v", new RelationalExpression(new ArithExp(new HeapReadingExp(new VarExp("b")), new ValueExp(new IntValue(2)), "-"), new HeapReadingExp(new VarExp("a")), ">"),
                                                                                        new ValueExp(new IntValue(100)), new ValueExp(new IntValue(200))
                                                                                        ), new PrintStmt(new VarExp("v"))

                                                                        ))
                                                                        ))

                                                                ))
                                                )
                                        )
                                )
                        );

        IStmt example21 = new CompStmt(new VarDeclStmt("b", new BoolType()),
                new CompStmt(new VarDeclStmt("c", new IntType()),
                        new CompStmt(new AssignStmt("b", new ValueExp(new BoolValue(true))),
                                new CompStmt(new CondAssignStmt("c",
                                        new VarExp("b"),
                                        new ValueExp(new IntValue(100)),
                                        new ValueExp(new IntValue(200))),
                                        new CompStmt(new PrintStmt(new VarExp("c")),
                                                new CompStmt(new CondAssignStmt("c",
                                                        new ValueExp(new BoolValue(false)),
                                                        new ValueExp(new IntValue(100)),
                                                        new ValueExp(new IntValue(200))),
                                                        new PrintStmt(new VarExp("c"))))))));



        IStmt example22 = new CompStmt(
                new VarDeclStmt("v1", new RefType(new IntType())),
                new CompStmt(
                        new VarDeclStmt("v2", new RefType(new IntType())),
                        new CompStmt(
                                new VarDeclStmt("v3", new RefType(new IntType())),
                                new CompStmt(
                                        new VarDeclStmt("cnt", new IntType()),
                                        new CompStmt(
                                                new HeapAllocationStmt("v1", new ValueExp(new IntValue(2))),
                                                new CompStmt (
                                                        new HeapAllocationStmt("v2", new ValueExp(new IntValue(3))),
                                                        new CompStmt(
                                                                new HeapAllocationStmt("v3", new ValueExp(new IntValue(4))),
                                                                new CompStmt(
                                                                        new NewLatchStmt("cnt", new HeapReadingExp(new VarExp("v2"))),
                                                                        new CompStmt(
                                                                                new ForkStmt(
                                                                                        new CompStmt(
                                                                                                new HeapWritingStmt("v1", new ArithExp( new HeapReadingExp(new VarExp("v1")), new ValueExp(new IntValue(10)), "*")),
                                                                                                new CompStmt(
                                                                                                        new PrintStmt(new HeapReadingExp(new VarExp("v1"))),
                                                                                                        new CompStmt(
                                                                                                                new CountDownStmt("cnt"),
                                                                                                                new ForkStmt(
                                                                                                                        new CompStmt(
                                                                                                                                new HeapWritingStmt("v2", new ArithExp( new HeapReadingExp(new VarExp("v2")), new ValueExp(new IntValue(10)), "*")),
                                                                                                                                new CompStmt(
                                                                                                                                        new PrintStmt(new HeapReadingExp(new VarExp("v2"))),
                                                                                                                                        new CompStmt(
                                                                                                                                                new CountDownStmt("cnt"),
                                                                                                                                                new ForkStmt(
                                                                                                                                                        new CompStmt(
                                                                                                                                                                new HeapWritingStmt("v3", new ArithExp( new HeapReadingExp(new VarExp("v3")), new ValueExp(new IntValue(10)), "*")),
                                                                                                                                                                new CompStmt(
                                                                                                                                                                        new PrintStmt(new HeapReadingExp(new VarExp("v3"))),
                                                                                                                                                                        new CountDownStmt("cnt")
                                                                                                                                                                )
                                                                                                                                                        )
                                                                                                                                                )
                                                                                                                                        )
                                                                                                                                )
                                                                                                                        )
                                                                                                                )
                                                                                                        )
                                                                                                )
                                                                                        )
                                                                                ),
                                                                                new CompStmt(
                                                                                        new AwaitStmt("cnt"),
                                                                                        new CompStmt(
                                                                                                new PrintStmt(new ValueExp(new IntValue(100))),
                                                                                                new CompStmt(
                                                                                                        new CountDownStmt("cnt"),
                                                                                                        new PrintStmt(new ValueExp(new IntValue(100)))
                                                                                                )
                                                                                        )
                                                                                )
                                                                        )
                                                                )
                                                        )
                                                )
                                        )
                                )
                        )
                )
        );

        return Arrays.asList(example1, example2, example3, example4, example5, example6, example7, example8, example9, example10, example11, example12, example13, example14, example15, example16, example17, example18, example19, example20, example21, example22);



    }

}
