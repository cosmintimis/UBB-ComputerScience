class RepositoryException(Exception):
    def __init__(self, exceptionMessage):
        self.__exceptionMessage = exceptionMessage

    def getExceptionMessage(self):
        return self.__exceptionMessage

    def __str__(self):
        return self.__exceptionMessage
