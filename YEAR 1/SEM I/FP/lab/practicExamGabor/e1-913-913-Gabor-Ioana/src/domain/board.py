import texttable

from exceptions.board_exception import BoardException


class Board:
    def __init__(self, size):
        self.__size = size
        self.__grid = []
        for i in range(self.__size):
            self.__grid.append([])
            for j in range(self.__size):
                self.__grid[-1].append(0)

    @property
    def grid(self):
        return self.__grid

    @property
    def size(self):
        return self.__size

    def __str__(self):
        table_obj = texttable.Texttable()
        for i in range(self.__size):
            table_line = []
            for j in range(self.__size):
                if self.__grid[i][j] == 0:
                    table_line.append("")
                else:
                    table_line.append("x")
            table_obj.add_row(table_line)
        return table_obj.draw()

    def add_pattern_to_board(self, pattern, x: int, y: int):
        coordinates = pattern.coordinates
        for coord in coordinates:
            x_placed: int = x + coord[0]
            y_placed: int = y + coord[1]
            if x_placed >= self.__size or y_placed >= self.__size:
                raise BoardException("live cell from a pattern cannot be outside the board")
            if self.__grid[x_placed][y_placed] == 1:
                raise BoardException("live cell from a pattern cannot overlap other live cell")
        for coord in coordinates:
            x_placed: int = x + coord[0]
            y_placed: int = y + coord[1]
            self.__grid[x_placed][y_placed] = 1

    def set(self, i, j, value):
        """Sets the (i,j) cell with value v

        :param i: int
        :param j: int
        :param value: 0 or 1
        :return:
        Raises value error if i or j is not in range or if value is not 0 or 1.
        """
        if i < 0 or i > self.__size:
            raise ValueError("x is not in range")

        if j < 0 or j > self.__size:
            raise ValueError("y is not in range")

        if value != 0 and value != 1:
            raise ValueError("value is not in range")
        self.__grid[i][j] = value

    def get(self, i, j):
        """Gets the (i,j) cell

        :param i: int
        :param j: int
        :return: the value of the cell int
        Raises value error if i or j is not in range.
        """
        if i < 0 or i > self.__size:
            raise ValueError("x is not in range")

        if j < 0 or j > self.__size:
            raise ValueError("y is not in range")

        return self.__grid[i][j]
