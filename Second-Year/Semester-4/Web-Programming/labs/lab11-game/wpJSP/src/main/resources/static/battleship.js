var board1 = {
    boardSize: 7,
    numShips: 3,
    shipLength: 3,
    shipsSunk: 0,
    ships:[
        { locations: [0, 0, 0], hits: ["", "", ""] },
        { locations: [0, 0, 0], hits: ["", "", ""] },
        { locations: [0, 0, 0], hits: ["", "", ""] }
    ],
    shots: [],
    playerNumber: 1
}

var board2 = {
    boardSize: 7,
    numShips: 3,
    shipLength: 3,
    shipsSunk: 0,
    ships:[
        { locations: [0, 0, 0], hits: ["", "", ""] },
        { locations: [0, 0, 0], hits: ["", "", ""] },
        { locations: [0, 0, 0], hits: ["", "", ""] }
    ],
    shots: [],
    playerNumber: 2

}

var currentPlayerTurn = 1;

function generateShip(board) {
    const direction = Math.floor(Math.random() * 2);
    let row, col;

    if (direction === 1) {
        row = Math.floor(Math.random() * board.boardSize);
        col = Math.floor(Math.random() * (board.boardSize - board.shipLength));
    } else {
        row = Math.floor(Math.random() * (board.boardSize - board.shipLength));
        col = Math.floor(Math.random() * board.boardSize);
    }

    const newShipLocations = [];
    for (let i = 0; i < board.shipLength; i++) {
        const position = direction === 1 ? `${row}${col + i}` : `${row + i}${col}`;
        newShipLocations.push(position.padStart(2, "0"));
    }

    return newShipLocations;
}

function collision(board, locations) {
    for (var i = 0; i < board.numShips; i++) {
        var ship = board.ships[i];
        for (var j = 0; j < locations.length; j++) {
            if (ship.locations.indexOf(locations[j]) >= 0) {
                return true;
            }
        }
    }
    return false;
}

function generateShipLocations(board) {
    var locations;
    for (var i = 0; i < board.numShips; i++) {
        do {
            locations = generateShip(board);
        } while (collision(board, locations));
        board.ships[i].locations = locations;
    }
}

function isSunk(ship, board) {
    for (i = 0; i < board.shipLength; i++) {
        if (ship.hits[i] !== "hit") {
            return false;
        }
    }
    return true;
}

async function fire(guess, board, playerNumber){
    $('.board-1 td').css("pointer-events", "none");
    $('.board-2 td').css("pointer-events", "none");
    const anotherPlayer = playerNumber == 1 ? 2 : 1;
    board.shots.push(guess);
    for (var i = 0; i < board.numShips; i++) {
        var ship = board.ships[i];
        var index = ship.locations.indexOf(guess);
        if (ship.hits[index] === "hit") {
            view.displayMessage("You hit this ship before.");
            return true;
        } else if (index >= 0) {
            ship.hits[index] = "hit";
            view.displayHit(guess + "-" + anotherPlayer);
            view.displayMessage("It's a hit!");
            if (isSunk(ship, board)) {
                view.displayMessage("You sunk enemy battleship!");
                board.shipsSunk++;
            }
            const gameData = {...board};
            await saveGame(gameData);
            await changePlayerTurn();
            return true;
        }
    }
    view.displayMiss(guess+ "-" + anotherPlayer);
    view.displayMessage("It's a miss!");
    const gameData = {...board};
    await saveGame(gameData);
    await changePlayerTurn();
    return false;
}

var view = {
    displayMessage: function(msg) {

        if(playerNumber == 1){
            $('.messageArea-2').html(msg);
        }
        else {
            $('.messageArea-1').html(msg);
        }
    },

    displayHit: function(location, goodShot = false) {
        var cell = document.getElementById(location);
        cell.setAttribute("class","hit");
        if(goodShot){
          cell.parentElement.style.backgroundColor = "red";
        }

    },

    displayMiss: function(location) {
        var cell = document.getElementById(location);
        cell.setAttribute("class","miss");
        cell.parentElement.onclick = null;
    }
};

var controller = {
    guesses1: 0,
    guesses2: 0,
    processGuess: async function(location) {
        if (location) {
            if(playerNumber == 1){
                this.guesses1++;
                var hit = await fire(location, board2, playerNumber)
                if(hit && board2.shipsSunk === board2.numShips){
                    await setWinner(1);
                    view.displayMessage("You sunk all enemy battleships in " + this.guesses1 + " tries.");
                }
            }
            else{
                this.guesses2++;
                var hit = await fire(location, board1, playerNumber)
                if(hit && board1.shipsSunk === board1.numShips){
                    await setWinner(2);
                    view.displayMessage("You sunk all enemy battleships in " + this.guesses2 + " tries.");
                }
            }
        }
    }
}

window.load = init()

async function init() {

    var guessClick = document.getElementsByTagName("td");
    for (var i = 0; i < guessClick.length; i++) {
        guessClick[i].onclick = await answer;
    }
}

async function generateInitData(){
    generateShipLocations(board1)
    const gameData1 = {...board1, playerNumber: 1};
    await saveGame(gameData1)

    generateShipLocations(board2);
    const gameData2 = {...board2, playerNumber: 2};
    await saveGame(gameData2)
}

async function answer(eventObj) {
    var shot = eventObj.target;
    var location = shot.id;
    await controller.processGuess(location.slice(0, -2));
}

function displayShips(board){
    console.log(board)
    var ships = board.ships;
    for (var i = 0; i < ships.length; i++) {
        var shipLocations = ships[i].locations;
        for (var j = 0; j < shipLocations.length; j++) {
            view.displayHit(shipLocations[j] + "-" + playerNumber);
        }
    }
}

function updateBoardState(board) {

    for (var i = 0; i < board.shots.length; i++) {
        var shot = board.shots[i];
        var hit = false;
        for (var j = 0; j < board.ships.length; j++) {
            var ship = board.ships[j];
            var index = ship.locations.indexOf(shot);
            if(index >= 0)
                hit = true;
        }
        if (!hit) {
            view.displayMiss(shot + "-" + board.playerNumber);
        }
        else{
            view.displayHit(shot + "-" + board.playerNumber, true);
        }
    }
}

async function saveGame(gameData) {
    try {
        const response = await fetch('/game/save', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(gameData)
        });

        if (response.ok) {
            console.log("Game saved successfully");
        } else {
            console.error("Error saving game:", response.status);
        }
    } catch (error) {
        console.error("Error saving game:", error);
    }
}

async function updateBoardFromServer(playerNumber) {
    try {
        const response = await fetch(`/game/data?playerNumber=${playerNumber}`);
        if (!response.ok) {
            throw new Error('Failed to fetch board data');
        }
        const boardData = JSON.parse(await response.text(), function(key, value) {
            if (key === 'locations' && Array.isArray(value)) {
                return value.map(location => location.toString().padStart(2, '0'));
            }
            return value;
        });

        if(playerNumber == 1){
            board1 = {...boardData};
            updateBoardState(board1);
        }
        else{
            board2 = {...boardData};
            updateBoardState(board2);
        }


    } catch (error) {
        console.error('Error updating board:', error);
    }
}

async function getPlayerTurn() {
    try {
        const response = await fetch('/game/playerTurn');
        if (!response.ok) {
            throw new Error('Failed to fetch player turn');
        }
        const playerTurn = await response.json();

        if(playerTurn == 1 && playerNumber == 1)
        {
            $('.board-2 td').css("pointer-events", "auto");
        }

        if(playerTurn == 2 && playerNumber == 2){
            $('.board-1 td').css("pointer-events", "auto");
        }

        console.log('Current player turn:', playerTurn);
        return playerTurn;
    } catch (error) {
        console.error('Error fetching player turn:', error);
    }
}

async function changePlayerTurn() {
    try {
        const response = await fetch('/game/changeTurn', {
            method: 'POST'
        });
        const message = await response.text();
    } catch (error) {
        console.error('Error changing player turn:', error);
    }
}

async function getWinner(){
    try {
        const response = await fetch('/game/getWinner');
        if (!response.ok) {
            throw new Error('Failed to get winner');
        }

        const winner = await response.json();
        return winner;

    } catch (error) {
        console.error('Error fetching get winner:', error);
    }
}

async function setWinner(playerNumber) {
    try {
        const response = await fetch('/game/setWinner', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: new URLSearchParams({ playerNumber: playerNumber })
        });
        const message = await response.text();
    } catch (error) {
        console.error('Error set winner:', error);
    }
}
async function pollForPlayerTurnChanges() {

    const pollingInterval = 2000;
    var winnerPlayer = 0;
    async function poll() {
        const playerTurn = await getPlayerTurn();
        if(board1.shipsSunk > board1.numShips - 2 || board2.shipsSunk > board2.numShips - 2)
            winnerPlayer = await getWinner();
        if(currentPlayerTurn != playerTurn){
            currentPlayerTurn = playerTurn;
            await updateBoardFromServer(playerTurn);
        }
        $('.turn').html("Current turn: Player " + playerTurn);
        if(winnerPlayer != 0)
        {
            $('.board-1 td').css("pointer-events", "none");
            $('.board-2 td').css("pointer-events", "none");
            $('.turn').html("Winner is: Player " + winnerPlayer);
        }
        else{
            setTimeout(poll, pollingInterval);
        }

    }
    poll();
}
pollForPlayerTurnChanges();