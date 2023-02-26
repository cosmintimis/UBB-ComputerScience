import unittest

from domain.board import Board
from domain.pattern import Pattern
from repository.board_repository import BoardRepository
from service.game_service import GameService


class TestSimulation(unittest.TestCase):
    def setUp(self):
        self.__board = Board(3)
        self.__blinker = Pattern("blinker", 3, [(1, 0), (1, 1), (1, 2)])
        self.__board_repository = BoardRepository(self.__board)
        self.__game_service = GameService(self.__board_repository, "")

    def test_blinker(self):
        self.__board.add_pattern_to_board(self.__blinker, 0, 0)
        self.__board_repository.update_board(self.__board)
        self.__game_service.simulate("1")
        self.assertEqual(self.__game_service.get_board().grid, [[0, 1, 0], [0, 1, 0], [0, 1, 0]])
