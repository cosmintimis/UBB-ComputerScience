package gui;

import controller.Controller;
import exceptions.MyException;
import javafx.beans.binding.Binding;
import javafx.beans.binding.Bindings;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.ListView;
import model.ProgramState;
import model.adt.MyDictionary;
import model.adt.MyIProcTable;
import model.adt.MyProcTable;
import model.statements.IStmt;
import repository.IRepository;
import repository.Repository;

public class SelectProgramController {

    MainController selectedProgramController;

    @FXML
    ListView<IStmt> allPrograms;
    @FXML
    ObservableList<IStmt> allProgramsModel = FXCollections.observableArrayList();

    private MyIProcTable procTable;

    public void setController(MainController selectedProgramController) {
        this.selectedProgramController = selectedProgramController;
        this.procTable = new MyProcTable();
        BuildPrograms.addProcedures(procTable);
        allProgramsModel.setAll(BuildPrograms.build());
        allPrograms.setItems(allProgramsModel);

    }


    public void handleSelectStmt() {
        IStmt selectedStmt = allPrograms.getSelectionModel().getSelectedItem();

        try {
            selectedStmt.typecheck(new MyDictionary<>());
            ProgramState prgState = new ProgramState(selectedStmt, procTable);
            IRepository repo = new Repository(prgState, "logfile.txt");
            Controller controller = new Controller(repo);
            controller.startExecutor();
            selectedProgramController.setController(controller);

        } catch (MyException e) {
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.setTitle("Error (type checker)! Invalid program");
            alert.setContentText(e.toString());
            alert.showAndWait();
        }
    }


}




