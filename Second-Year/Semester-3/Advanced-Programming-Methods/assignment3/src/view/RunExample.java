package view;

import controller.Controller;

public class RunExample extends Command {

    private final Controller controller;
    public RunExample(String key, String desc,Controller ctr){
        super(key, desc);
        this.controller =ctr;
    }
    @Override
    public void execute() {
        try{
            controller.allSteps(); }
        catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
