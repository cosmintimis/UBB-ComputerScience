from src.domain.client import Client
from random import choice


class ClientService:
    def __init__(self, clientValidator, clientRepository, rentalService):
        self.__clientValidator = clientValidator
        self.__clientRepository = clientRepository
        self.__rentalService = rentalService

    def createClientAndStoreItToRepository(self, clientId, clientName):
        newClient = Client(clientId, clientName)
        self.__clientValidator.checkIfProvidedClientInstanceIsValid(newClient)
        self.__clientRepository.storeObjectToRepository(newClient)
        return newClient

    def deleteClientWithCertainIdFromRepository(self, clientId):

        clientToDelete = self.__clientRepository.deleteObjectFromRepositoryWithCertainId(clientId)

        allRentalsOfProvidedClient = self.__rentalService.getListOfRentalsPerformedByProvidedClientForProvidedBook(clientId, None)
        for rental in allRentalsOfProvidedClient:
            self.__rentalService.deleteRentalWithCertainIdFromRepository(rental.id)

        return clientToDelete

    def getAllClientsFromRepository(self):
        return self.__clientRepository.getAllObjectsFromRepository()

    def getTotalNumberOfClients(self):
        return len(self.__clientRepository)

    def updateNameForAnExistingClient(self, clientId, newName):
        newClient = Client(clientId, newName)
        self.__clientRepository.replaceAnExistingObjectWithNewProvidedObjectHavingSameId(newClient)

    def getAllClientsThatHaveSpecificNameAndId(self, clientIdForm, clientNameForm):
        listOfAllClientsThatHaveSpecificNameAndId = []
        for client in self.__clientRepository.getAllObjectsFromRepository():
            if clientIdForm in client.id.lower() and clientNameForm in client.name.lower():
                listOfAllClientsThatHaveSpecificNameAndId.append(client)
        return listOfAllClientsThatHaveSpecificNameAndId

    def generateRandomClientsAndStoreThemToRepository(self, howManyToGenerate):
        listOfRandomFirstNamesForClients = ["Andrei", "Alexandru", "Cosmin", "Roxana", "Bianca", "Marian", "Robert", "Nicolae", "Alexandra", "Nicoleta"]
        listOfRandomLastNamesForClients = ["Timis", "Mihali", "Stetcu", "Horj", "Hojda", "Roman", "Petri", "Dragomir"]

        while howManyToGenerate:
            randomFullNameForClient = choice(listOfRandomFirstNamesForClients) + " " + choice(listOfRandomLastNamesForClients)
            idOfLastClientFromRepository = self.getTotalNumberOfClients()
            self.createClientAndStoreItToRepository(str(idOfLastClientFromRepository + 1), randomFullNameForClient)
            howManyToGenerate -= 1
