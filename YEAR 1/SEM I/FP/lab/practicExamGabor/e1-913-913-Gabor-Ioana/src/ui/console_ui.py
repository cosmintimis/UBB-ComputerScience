import re

from service.game_service import GameService


class ConsoleUI:
    def __init__(self, game_service: GameService):
        self.__game_service = game_service
        self.__commands = {
            "^place [a-z]* [0-9]*,[0-9]*$": self.__place_pattern,
            "^tick$": self.__simulate,
            "^tick [0-9]*$": self.__simulate,
            "^save [0-9a-zA-Z\.]*": self.__save_configuration,
            "^load [\.0-9a-zA-Z/]*": self.__load_configuration,
        }

    def __print_board(self):
        print(self.__game_service.get_board())

    def __place_pattern(self, command):
        tokens = command.split(" ")
        name = tokens[1]
        coordinates = tokens[2].split(",")
        x = coordinates[0]
        y = coordinates[1]
        try:
            self.__game_service.add_pattern_to_board(name, x, y)
        except Exception as e:
            print(e)

    def __simulate(self, command):
        tokens = command.split(" ")
        if len(tokens) == 1:
            n = 1
        else:
            n = tokens[1]
        self.__game_service.simulate(n)

    def __find_function(self, command):
        for expression in self.__commands:
            if re.match(expression, command):
                return self.__commands[expression]
        return None

    def __save_configuration(self, command):
        tokens = command.split(" ")
        try:
            self.__game_service.save(tokens[1])
        except Exception as e:
            print(e)

    def __load_configuration(self, command):
        tokens = command.split(" ")
        try:
            self.__game_service.load(tokens[1])
        except Exception as e:
            print(e)

    @staticmethod
    def __parse_command(command: str):
        command.lower()
        command.strip()
        return command

    def run(self):
        while True:
            self.__print_board()
            command = input("Please enter your command: \n")
            command = ConsoleUI.__parse_command(command)
            if command == "exit":
                break
            function = self.__find_function(command)
            if function is None:
                print("invalid command")
            else:
                function(command)
