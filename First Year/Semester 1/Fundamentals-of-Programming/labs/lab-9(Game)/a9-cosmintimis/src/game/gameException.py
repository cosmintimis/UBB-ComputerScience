class GameException(Exception):
    def __init__(self, errorMessage):
        self.__errorMessage = errorMessage

    def __str__(self):
        return self.__errorMessage
