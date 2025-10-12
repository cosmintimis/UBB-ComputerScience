from src.game.gameException import GameException


class UserInterface:
    def __init__(self, obstructionGame):
        self.__obstructionGame = obstructionGame
        self.__symbolOfMoveForFirstPlayer = 'X'
        self.__symbolOfMoveForSecondPlayer = 'O'
        self.__indexOfPlayAgain = '1'
        self.__redoMove = None

    def playHuman(self, symbolOfMove):
        print("Your turn. Insert the line and column: ")
        lineOfHumanPlayerMove = int(input("Line: "))
        columnOfHumanPlayerMove = int(input("Column: "))
        self.__obstructionGame.makeMoveOnTheGameBoard(lineOfHumanPlayerMove, columnOfHumanPlayerMove, symbolOfMove)
        print(self.__obstructionGame.getGameBoard)

    def playComputer(self):
        print("Computer turn:")
        self.__obstructionGame.computerMove()
        print(self.__obstructionGame.getGameBoard)

    def start(self):
        print(self.__obstructionGame.getGameBoard)
        while True:
            if self.__obstructionGame.symbolOfMoveForHumanPlayer == self.__symbolOfMoveForFirstPlayer:

                try:
                    self.playHuman(self.__symbolOfMoveForFirstPlayer)
                    if self.__obstructionGame.checkIfTheGameIsOver():
                        print("You've won!!!!!!!")
                        break
                    self.playComputer()
                    if self.__obstructionGame.checkIfTheGameIsOver():
                        print("Computer won.")
                        break
                except ValueError:
                    print("try again -- invalid move!")
                except GameException as errorMessage:
                    print(errorMessage)
            else:
                try:
                    if self.__redoMove is None:
                        self.playComputer()
                        if self.__obstructionGame.checkIfTheGameIsOver():
                            print("Computer won.")
                            break
                    self.__redoMove = None
                    self.playHuman(self.__symbolOfMoveForSecondPlayer)
                    if self.__obstructionGame.checkIfTheGameIsOver():
                        print("You've won!!!!!!!")
                        break
                except ValueError:
                    print("try again -- invalid move!")
                    self.__redoMove = 1
                except GameException as errorMessage:
                    print(errorMessage)
                    self.__redoMove = 1

        playAgain = input("Enter 1 if you want to play again :) (anything else to exit) ")
        if playAgain == self.__indexOfPlayAgain:
            self.__obstructionGame.clearTheGameBoard()
            self.start()
