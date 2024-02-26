class BookRentalException(Exception):
    def __init__(self, exceptionMessage):
        self.__exceptionMessage = exceptionMessage

    def __str__(self):
        return str(self.__exceptionMessage)
