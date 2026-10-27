from texttable import Texttable

class Board:
    def __init__(self, heightOfBoard, widthOfBoard):
        self.__indexOfFirstRow = 0
        self.__indexOfFirstColumn = 0
        self.__heightOfBoard = heightOfBoard
        self.__widthOfBoard = widthOfBoard
        self.__board = [[0] * (widthOfBoard + 1) for _ in range(heightOfBoard + 1)]
        self.__board[self.__indexOfFirstRow][self.__indexOfFirstColumn] = '/'
        for index in range(1, heightOfBoard + 1):
            self.__board[index][self.__indexOfFirstColumn] = index
        for index in range(1, widthOfBoard + 1):
            self.__board[self.__indexOfFirstRow][index] = index

    @property
    def heightOfBoard(self):
        return self.__heightOfBoard

    @property
    def widthOfBoard(self):
        return self.__widthOfBoard

    @property
    def board(self):
        return self.__board

    def __str__(self):
        tableFormOfTheGameBoard = Texttable(max_width=1000)

        for index in range(self.__heightOfBoard + 1):
            rowOfTheGameBoardToDisplay = self.__board[index].copy()
            for index2 in range(1, self.__widthOfBoard + 1):
                if rowOfTheGameBoardToDisplay[index2] == 0:
                    rowOfTheGameBoardToDisplay[index2] = ' '
            tableFormOfTheGameBoard.add_row(rowOfTheGameBoardToDisplay)
        return tableFormOfTheGameBoard.draw()

