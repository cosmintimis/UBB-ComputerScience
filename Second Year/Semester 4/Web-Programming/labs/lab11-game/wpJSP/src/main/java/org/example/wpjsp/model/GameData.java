package org.example.wpjsp.model;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class GameData {
    private int boardSize;
    private int numShips;
    private int shipLength;
    private int shipsSunk;
    private List<Ship> ships;
    private int playerNumber;
    private List<String> shots;
}
