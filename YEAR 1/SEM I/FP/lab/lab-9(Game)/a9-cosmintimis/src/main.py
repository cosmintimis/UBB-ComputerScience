from src.board.board import Board
from src.game.game import Game
from src.ui.ui import UserInterface


def gameSetUp():
    firstPlayerHuman = '1'
    print("Enter the dimensions for the board:")
    while True:
        try:
            heightOfBoard = int(input("Height:"))
            widthOfBoard = int(input("Length:"))
            if heightOfBoard > 30 or widthOfBoard > 30:
                print("Board size too big(<=30x30)!")
            else:
                break
        except ValueError as errorMessage:
            print(errorMessage)

    firstPlayer = input("Enter 1 if you want to start the game(anything else if not):")
    if firstPlayer == firstPlayerHuman:
        symbolOfMoveForHumanPlayer = 'X'
        symbolOfMoveForComputerPlayer = 'O'
    else:
        symbolOfMoveForHumanPlayer = 'O'
        symbolOfMoveForComputerPlayer = 'X'
    gameBoard = Board(heightOfBoard, widthOfBoard)
    obstructionGame = Game(gameBoard, symbolOfMoveForHumanPlayer, symbolOfMoveForComputerPlayer)
    userInterface = UserInterface(obstructionGame)
    userInterface.start()


if __name__ == "__main__":
    gameSetUp()
