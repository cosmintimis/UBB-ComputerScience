from src.repository.repositoryException import RepositoryException


class Repository:
    def __init__(self):
        self.__listOfStoredObjects = []

    def storeObjectToRepository(self, randomObject):
        if self.findObjectWithCertainId(randomObject.id) is not None:
            raise RepositoryException("Element having id=" + str(randomObject.id) + " already stored!")
        self.__listOfStoredObjects.append(randomObject)

    def replaceAnExistingObjectWithNewProvidedObjectHavingSameId(self, randomObject):

        checkIfExistsAnObjectWithSameIdAsProvidedObject = self.findObjectWithCertainId(randomObject.id)
        if checkIfExistsAnObjectWithSameIdAsProvidedObject is None:
            raise RepositoryException("Element not found!")
        if type(randomObject) != type(checkIfExistsAnObjectWithSameIdAsProvidedObject):
            raise RepositoryException("Can't replace objects with different types!")
        indexOfObjectWeWantToReplace = self.__listOfStoredObjects.index(checkIfExistsAnObjectWithSameIdAsProvidedObject)
        self.__listOfStoredObjects.remove(checkIfExistsAnObjectWithSameIdAsProvidedObject)
        self.__listOfStoredObjects.insert(indexOfObjectWeWantToReplace, randomObject)

    def findObjectWithCertainId(self, objectId):
        for object in self.__listOfStoredObjects:
            if objectId == object.id:
                return object
        return None

    def deleteObjectFromRepositoryWithCertainId(self, objectId):
        objectToDelete = self.findObjectWithCertainId(objectId)
        if objectToDelete is None:
            raise RepositoryException("Element not in repository!")
        self.__listOfStoredObjects.remove(objectToDelete)
        return objectToDelete

    def getAllObjectsFromRepository(self):
        return self.__listOfStoredObjects

    def __len__(self):
        return len(self.__listOfStoredObjects)

    def __str__(self):
        stringFormatForRepository = ""
        for object in self.__listOfStoredObjects:
            stringFormatForRepository += str(object)
            stringFormatForRepository += "\n"
        return stringFormatForRepository
