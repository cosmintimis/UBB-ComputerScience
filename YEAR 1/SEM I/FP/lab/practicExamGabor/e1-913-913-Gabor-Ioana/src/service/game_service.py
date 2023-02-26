import copy

from domain.board import Board
from exceptions.repository_exceptions import RepositoryException
from exceptions.service_exceptions import ServiceException
from repository.board_repository import BoardRepository
from repository.pattern_repository import PatternRepository


class GameService:
    def __init__(self, board_repository: BoardRepository, pattern_repository: PatternRepository):
        self.__board_repository = board_repository
        self.__pattern_repository = pattern_repository

    def get_board(self):
        return self.__board_repository.get_board()

    def add_pattern_to_board(self, pattern_name, x, y):
        try:
            x = int(x)
        except Exception:
            raise ServiceException("invalid x")

        try:
            y = int(y)
        except Exception:
            raise ServiceException("invalid y")

        try:
            pattern = self.__pattern_repository.get_pattern(pattern_name)
        except RepositoryException as re:
            raise ServiceException(re)
        try:
            self.__board_repository.add_pattern_to_board(pattern, x, y)
        except RepositoryException as re:
            raise ServiceException(re)

    @staticmethod
    def simulate_once(board: Board):
        """Runs the simulation one time on the board and returns the new board

        :param board: old board
        :return: new board
        """
        new_board = Board(board.size)
        neighbours = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (-1, 1), (1, -1), (-1, -1)]
        for i in range(board.size):
            for j in range(board.size):
                alive = 0
                for d in neighbours:
                    x_neigh = i + d[0]
                    y_neigh = j + d[1]
                    if 0 <= x_neigh < board.size and 0 <= y_neigh < board.size:
                        if board.get(x_neigh, y_neigh) == 1:
                            alive += 1
                if board.get(i, j) == 1:
                    if alive == 2 or alive == 3:
                        new_board.set(i, j, 1)
                    else:
                        new_board.set(i, j, 0)
                else:
                    if alive == 3:
                        new_board.set(i, j, 1)
                    else:
                        new_board.set(i, j, 0)
        return new_board

    def simulate(self, n: str):
        """Runs the simulation n times and updates the board accordingly

        :param n: string
        :return:
        """
        try:
            n = int(n)
        except Exception:
            raise ServiceException("invalid n")
        new_board = copy.deepcopy(self.__board_repository.get_board())
        while n > 0:
            n -= 1
            new_board = GameService.simulate_once(new_board)
        self.__board_repository.update_board(new_board)

    def save(self, filename):
        try:
            self.__board_repository.save_to_file(filename)
        except Exception as e:
            raise ServiceException(e)

    def load(self, filename):
        try:
            self.__board_repository.load_from_file(filename)
        except Exception as e:
            raise ServiceException(e)
