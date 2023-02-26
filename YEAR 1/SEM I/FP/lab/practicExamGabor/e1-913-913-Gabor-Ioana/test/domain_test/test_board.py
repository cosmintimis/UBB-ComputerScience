import unittest

from src.domain.board import Board


class TestBoard(unittest.TestCase):
    def setUp(self):
        self.__board = Board(3)
        self.__board.set(2, 2, 1)

    def test_get_ok(self):
        self.assertEqual(self.__board.get(2, 2), 1)

    def test_set_ok(self):
        self.__board.set(0, 0, 1)
        self.assertEqual(self.__board.grid, [[1, 0, 0], [0, 0, 0], [0, 0, 1]])

    def test_get_raises_error(self):
        self.assertRaises(ValueError, self.__board.get, 421, 421)

    def test_set_raises_error(self):
        self.assertRaises(ValueError, self.__board.set, 421, 421, 3)