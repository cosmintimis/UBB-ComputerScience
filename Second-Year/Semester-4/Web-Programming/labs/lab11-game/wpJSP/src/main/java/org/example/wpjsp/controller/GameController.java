package org.example.wpjsp.controller;

import org.example.wpjsp.model.GameData;
import org.example.wpjsp.service.GameService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@CrossOrigin("*")
@RestController
@RequestMapping("/game")
public class GameController {

    @Autowired
    private GameService gameService;

    private int playerTurn = 1;

    private int winner = 0;


    @PostMapping("/save")
    public ResponseEntity<String> updateGame(@RequestBody GameData gameData) {
        gameService.saveGame(gameData);
        return new ResponseEntity<>("Game data saved successfully", HttpStatus.OK);
    }

    @GetMapping("/data")
    public ResponseEntity<GameData> getGameData(@RequestParam("playerNumber") int playerNumber) {
        GameData gameData = gameService.getLastGameDataByPlayer(playerNumber);

        if (gameData != null) {
            return new ResponseEntity<>(gameData, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }
    @GetMapping("/playerTurn")
    public ResponseEntity<Integer> getPlayerTurn() {
        return new ResponseEntity<>(playerTurn, HttpStatus.OK);
    }

    @PostMapping("/changeTurn")
    public ResponseEntity<String> changeTurn() {
        playerTurn = (playerTurn == 1) ? 2 : 1;
        return new ResponseEntity<>("Player turn changed to " + playerTurn, HttpStatus.OK);
    }

    @GetMapping("/getWinner")
    public ResponseEntity<Integer> getWinner() {
        return new ResponseEntity<>(winner, HttpStatus.OK);
    }

    @PostMapping("/setWinner")
    public ResponseEntity<String> updateWinner(@RequestParam("playerNumber") int playerNumber) {
        this.winner = playerNumber;
        return new ResponseEntity<>( "Winner updated", HttpStatus.OK);
    }

}