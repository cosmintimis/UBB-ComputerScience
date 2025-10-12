class Client:
    def __init__(self, id, name):
        self.__id = id
        self.__name = name

    @property
    def id(self):
        return self.__id

    @id.setter
    def id(self, newId):
        self.__id = newId

    @property
    def name(self):
        return self.__name

    @name.setter
    def name(self, newName):
        self.__name = newName

    def __eq__(self, randomClient):
        if isinstance(randomClient, Client) is False:
            return False
        return self.id == randomClient.id

    def __str__(self):
        return "Id=" + str(self.id) + ", Name=" + str(self.name)

    def __repr__(self):
        return str(self)


class ClientValidator:
    def __init__(self):
        pass

    @staticmethod
    def checkIfProvidedClientInstanceIsValid(providedClient):
        if not isinstance(providedClient, Client):
            raise TypeError("Can only validate Client objects!")
        if len(str(providedClient.id)) == 0:
            raise ValueError("A Client must have an id!")
        if len(providedClient.name) == 0:
            raise ValueError("A Client must have an title!")
        return True
