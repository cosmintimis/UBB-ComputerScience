from src.game.gameException import GameException
from random import choice

class Game:
    def __init__(self, gameBoard, symbolOfMoveForHumanPlayer, symbolOfMoveForComputerPlayer):
        self.__gameBoard = gameBoard
        self.__symbolOfMoveForHumanPlayer = symbolOfMoveForHumanPlayer
        self.__symbolOfMoveForComputerPlayer = symbolOfMoveForComputerPlayer
        self.__lastMoveThatWasMadeOnTheGameBoard = None
        self.__symbolOfMoveForFirstPlayer = 'X'
        self.__indexOfRowOfTheMove = 0
        self.__indexOfColumnOfTheMove = 1

    @property
    def getGameBoard(self):
        return self.__gameBoard

    @property
    def symbolOfMoveForHumanPlayer(self):
        return self.__symbolOfMoveForHumanPlayer

    @property
    def symbolOfMoveForComputerPlayer(self):
        return self.__symbolOfMoveForComputerPlayer

    def checkIfAMoveIsOnTheGameBoard(self, rowOfTheMove, columnOfTheMove):
        if rowOfTheMove < 1 or rowOfTheMove > self.__gameBoard.heightOfBoard or columnOfTheMove < 1 or columnOfTheMove > self.__gameBoard.widthOfBoard:
            raise GameException("The move isn't on the board!")
        return True

    def checkIfTheGameIsOver(self):
        for index1 in range(1, self.__gameBoard.heightOfBoard + 1):
            for index2 in range(1, self.__gameBoard.widthOfBoard + 1):
                if self.__gameBoard.board[index1][index2] == 0:
                    return False
        return True

    def clearTheGameBoard(self):
        for index1 in range(1, self.__gameBoard.heightOfBoard + 1):
            for index2 in range(1, self.__gameBoard.widthOfBoard + 1):
                self.__gameBoard.board[index1][index2] = 0

    def makeMoveOnTheGameBoard(self, rowOfTheMove, columnOfTheMove, symbolOfTheMove):
        if self.checkIfAMoveIsOnTheGameBoard(rowOfTheMove, columnOfTheMove):
            if self.__gameBoard.board[rowOfTheMove][columnOfTheMove] == 0:
                self.__gameBoard.board[rowOfTheMove][columnOfTheMove] = symbolOfTheMove
                self.__lastMoveThatWasMadeOnTheGameBoard = (rowOfTheMove, columnOfTheMove)
                for index1 in (-1, 0, 1):
                    for index2 in (-1, 0, 1):
                        try:
                            self.checkIfAMoveIsOnTheGameBoard(rowOfTheMove + index1, columnOfTheMove + index2)
                            if self.__gameBoard.board[rowOfTheMove + index1][columnOfTheMove + index2] == 0:
                                self.__gameBoard.board[rowOfTheMove + index1][columnOfTheMove + index2] = u"\u25A0"
                        except GameException:
                            pass
            else:
                raise GameException("Invalid move!")

    def getListOfAllAvailableMovesOnTheGameBoard(self):
        listOfAllAvailableMovesOnTheGameBoard = []
        for index1 in range(1, self.__gameBoard.heightOfBoard + 1):
            for index2 in range(1, self.__gameBoard.widthOfBoard + 1):
                if self.__gameBoard.board[index1][index2] == 0:
                    listOfAllAvailableMovesOnTheGameBoard.append((index1, index2))
        return listOfAllAvailableMovesOnTheGameBoard


    def computerMove(self):

        bestComputerMove = self.checkIfOneMoveCanEndTheGame()
        allMovesThatComputerCanMadeSoHumanCantWinWithNextMove = self.lookingForAllMovesThatComputerCanMadeSoHumanCantWinWithNextMove()
        if self.__gameBoard.heightOfBoard % 2 and self.__gameBoard.widthOfBoard % 2 and self.symbolOfMoveForComputerPlayer == self.__symbolOfMoveForFirstPlayer:
            if self.__lastMoveThatWasMadeOnTheGameBoard is None:
                self.makeMoveOnTheGameBoard(self.__gameBoard.heightOfBoard // 2 + 1, self.__gameBoard.widthOfBoard // 2 + 1, self.symbolOfMoveForComputerPlayer)
            else:
                self.makeMoveOnTheGameBoard(
                    self.__gameBoard.heightOfBoard - self.__lastMoveThatWasMadeOnTheGameBoard[self.__indexOfRowOfTheMove] + 1,
                    self.__gameBoard.widthOfBoard - self.__lastMoveThatWasMadeOnTheGameBoard[self.__indexOfColumnOfTheMove] + 1,
                    self.__symbolOfMoveForComputerPlayer)

        elif bestComputerMove is not None:
            self.makeMoveOnTheGameBoard(bestComputerMove[self.__indexOfRowOfTheMove], bestComputerMove[self.__indexOfColumnOfTheMove],self.__symbolOfMoveForComputerPlayer )
        elif len(allMovesThatComputerCanMadeSoHumanCantWinWithNextMove) > 0:
            computerMove = choice(allMovesThatComputerCanMadeSoHumanCantWinWithNextMove)
            self.makeMoveOnTheGameBoard(computerMove[self.__indexOfRowOfTheMove],
                                        computerMove[self.__indexOfColumnOfTheMove],
                                        self.__symbolOfMoveForComputerPlayer)
        else:
            listOfAllAvailableMovesOnTheGameBoard = self.getListOfAllAvailableMovesOnTheGameBoard()
            computerMove = choice(listOfAllAvailableMovesOnTheGameBoard)
            self.makeMoveOnTheGameBoard(computerMove[self.__indexOfRowOfTheMove], computerMove[self.__indexOfColumnOfTheMove], self.__symbolOfMoveForComputerPlayer)


    def makeFakeMove(self, rowOfTheMove, columnOfTheMove):
        listOfAllAffectedSquares = []
        self.__gameBoard.board[rowOfTheMove][columnOfTheMove] = self.__symbolOfMoveForFirstPlayer
        listOfAllAffectedSquares.append((rowOfTheMove, columnOfTheMove))
        for index1 in (-1, 0, 1):
            for index2 in (-1, 0, 1):
                try:
                    self.checkIfAMoveIsOnTheGameBoard(rowOfTheMove + index1, columnOfTheMove + index2)
                    if self.__gameBoard.board[rowOfTheMove + index1][columnOfTheMove + index2] == 0:
                        self.__gameBoard.board[rowOfTheMove + index1][columnOfTheMove + index2] = u"\u25A0"
                        listOfAllAffectedSquares.append((rowOfTheMove + index1, columnOfTheMove + index2 ))
                except GameException:
                    pass
        return listOfAllAffectedSquares

    def undoMove(self, listOfAllAffectedSquares):
        for element in listOfAllAffectedSquares:
            self.__gameBoard.board[element[self.__indexOfRowOfTheMove]][element[self.__indexOfColumnOfTheMove]] = 0

    def checkIfOneMoveCanEndTheGame(self):
        listOfAllAvailableMovesOnTheGameBoard = self.getListOfAllAvailableMovesOnTheGameBoard()
        foundMove = None
        for move in listOfAllAvailableMovesOnTheGameBoard:
            listOfAllAffectedSquares = self.makeFakeMove(move[self.__indexOfRowOfTheMove], move[self.__indexOfColumnOfTheMove])
            if len(listOfAllAffectedSquares) != 0 and self.checkIfTheGameIsOver():
                foundMove = move
            self.undoMove(listOfAllAffectedSquares)
        return foundMove

    def lookingForAllMovesThatComputerCanMadeSoHumanCantWinWithNextMove(self):
        allMovesThatComputerCanMadeSoHumanCantWinWithNextMove = self.getListOfAllAvailableMovesOnTheGameBoard()
        index = 0
        lengthOfList = len(allMovesThatComputerCanMadeSoHumanCantWinWithNextMove)
        while index < lengthOfList:
            move = allMovesThatComputerCanMadeSoHumanCantWinWithNextMove[index]
            listOfAllAffectedSquares = self.makeFakeMove(move[self.__indexOfRowOfTheMove], move[self.__indexOfColumnOfTheMove])
            humanCanWin = self.checkIfOneMoveCanEndTheGame()
            if humanCanWin is not None:
                allMovesThatComputerCanMadeSoHumanCantWinWithNextMove.remove(move)
                lengthOfList -= 1
            else:
                index += 1
            self.undoMove(listOfAllAffectedSquares)
        return allMovesThatComputerCanMadeSoHumanCantWinWithNextMove

