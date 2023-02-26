import unittest

from domain.board import Board
from repository.board_repository import BoardRepository


class TestRepository(unittest.TestCase):
    def setUp(self):
        self.__board = Board(3)
        self.__board.set(2, 2, 1)
        self.__repo = BoardRepository(self.__board)

    def test_update_board(self):
        new_board = Board(3)
        new_board.set(0, 0, 1)
        self.__repo.update_board(new_board)
        self.assertEqual(new_board.grid, [[1, 0, 0], [0, 0, 0], [0, 0, 0]])

    def test_get_board(self):
        self.assertEqual(self.__repo.get_board().grid, [[0, 0, 0], [0, 0, 0], [0, 0, 1]])