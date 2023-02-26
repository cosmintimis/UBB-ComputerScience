import pickle

from exceptions.board_exception import BoardException
from exceptions.repository_exceptions import RepositoryException
from src.domain.board import Board


class BoardRepository:
    def __init__(self, board: Board):
        self.__board = board

    def save_to_file(self, file_name):
        try:
            fi = open(file_name, "wb")
            pickle.dump(self.__board, fi)
        except Exception:
            raise RepositoryException("an error has happened while saving the configuration")

    def load_from_file(self, file_name):
        try:
            fi = open(file_name, "rb")
            board = pickle.load(fi)
        except Exception:
            raise RepositoryException("an error has happened while loading")
        self.update_board(board)

    def get_board(self):
        return self.__board

    def add_pattern_to_board(self, pattern, x, y):
        try:
            self.__board.add_pattern_to_board(pattern, x, y)
        except BoardException as be:
            raise RepositoryException(be)

    def update_board(self, board):
        self.__board = board
