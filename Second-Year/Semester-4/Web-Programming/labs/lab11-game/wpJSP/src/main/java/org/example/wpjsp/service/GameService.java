package org.example.wpjsp.service;

import org.example.wpjsp.model.GameData;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class GameService {

    List<GameData> gameDataList;

    public GameService() {
        this.gameDataList = new ArrayList<>();
    }

    public void saveGame(GameData gameData) {
        gameDataList.add(gameData);
    }

    public GameData getLastGameDataByPlayer(int playerNumber) {
        if (gameDataList.isEmpty())
            return null;

        GameData gm1 = gameDataList.get(gameDataList.size() - 1);
        GameData gm2 = gameDataList.get(gameDataList.size() - 2);

        if(gm1.getPlayerNumber() == playerNumber) {
            return gm1;
        }
        return gm2;
    }

}
