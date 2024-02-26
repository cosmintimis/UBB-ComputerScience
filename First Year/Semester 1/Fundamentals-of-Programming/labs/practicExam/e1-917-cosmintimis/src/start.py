from src.game.game import Game
from src.ui.ui import UserInterface

if __name__ == "__main__":
    game = Game("input.txt")
    userInterface = UserInterface(game)
    userInterface.run()