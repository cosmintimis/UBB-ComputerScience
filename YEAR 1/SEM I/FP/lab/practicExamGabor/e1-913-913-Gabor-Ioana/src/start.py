from domain.board import Board
from repository.board_repository import BoardRepository
from repository.pattern_repository import PatternRepository
from service.game_service import GameService
from ui.console_ui import ConsoleUI


def run():
    pattern_repository = PatternRepository("data/patterns.txt")
    board = Board(8)
    board_repository = BoardRepository(board)
    game_service = GameService(board_repository, pattern_repository)
    console_ui = ConsoleUI(game_service)
    console_ui.run()


if __name__ == "__main__":
    run()
