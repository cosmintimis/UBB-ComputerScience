package view;


import controller.Controller;
import exceptions.MyException;
import model.ProgramState;
import model.expressions.ArithExp;
import model.expressions.ValueExp;
import model.expressions.VarExp;
import model.statements.*;
import model.types.BoolType;
import model.types.IntType;
import model.values.BoolValue;
import model.values.IntValue;

import java.util.Scanner;

public class ViewOld {

    Controller controller;

    public ViewOld(Controller c) {
        controller = c;
    }

    void printMenu() {
        System.out.println("1 -> See the source code.");
        System.out.println("2 -> Execute one step.");
        System.out.println("3 -> Execute all steps.");
        System.out.println("0 -> Exit.");
    }

    void printChooseProgram() {
        System.out.println("1 -> Choose program 1.");
        System.out.println("2 -> Choose program 2.");
        System.out.println("3 -> Choose program 3.");
    }


    public IStmt chooseProgram(String choice) {
        return switch (choice) {
            case "1" -> new CompStmt(new VarDeclStmt("v", new IntType()),
                    new CompStmt(new AssignStmt("v", new ValueExp(new IntValue(2))), new PrintStmt(new
                            VarExp("v"))));

            case "2" -> new CompStmt(new VarDeclStmt("a", new IntType()),
                    new CompStmt(new VarDeclStmt("b", new IntType()),
                            new CompStmt(new AssignStmt("a", new ArithExp( new ValueExp(new IntValue(2)), new
                                    ArithExp(new ValueExp(new IntValue(3)), new ValueExp(new IntValue(5)), "*"), "+")),
                                    new CompStmt(new AssignStmt("b", new ArithExp(new VarExp("a"), new ValueExp(new
                                            IntValue(1)), "+")), new PrintStmt(new VarExp("b"))))));

            case "3" -> new CompStmt(new VarDeclStmt("a", new BoolType()),
                    new CompStmt(new VarDeclStmt("v", new IntType()),
                            new CompStmt(new AssignStmt("a", new ValueExp(new BoolValue(true))),
                                    new CompStmt(new IfStmt(new VarExp("a"), new AssignStmt("v", new ValueExp(new
                                            IntValue(2))), new AssignStmt("v", new ValueExp(new IntValue(3)))), new PrintStmt(new
                                            VarExp("v"))))));
            default -> null;
        };
    }

    public void executeProgram(ProgramState programState, boolean displayFlag) throws MyException, Exception {

        if(displayFlag)
            this.controller.oneStep(programState);
        else
            this.controller.allSteps();
        System.out.println("ExeStack: " +  programState.getExeStack());
        System.out.println("SymTable: " + programState.getSymTable());
        System.out.println("OutputList: " + programState.getOutputList());
    }

    public void run() {
        printChooseProgram();
        Scanner scanner = new Scanner(System.in);
        String input = scanner.nextLine();

        IStmt programChosen = chooseProgram(input);

        ProgramState programState = new ProgramState(programChosen);

        this.controller.addProgramState(programState);

        while (true) {
            printMenu();

            input = scanner.nextLine();

            switch (input) {
                case "1":
                    System.out.println(programChosen);
                    break;

                case "2":
                    try {
                        executeProgram(programState, true);
                    } catch (Exception e) {
                        System.out.println(e.toString());
                    }
                    break;

                case "3":
                    try {
                        executeProgram(programState, false);
                    } catch (Exception e) {
                        System.out.println(e.toString());
                    }
                    break;

                case "0":
                    return;

                default:
                    System.out.println("Wrong input!");
                    break;
            }

        }
    }
}
