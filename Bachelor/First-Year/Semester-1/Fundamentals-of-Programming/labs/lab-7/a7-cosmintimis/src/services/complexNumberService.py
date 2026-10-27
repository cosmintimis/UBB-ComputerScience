from src.domain.complexNumber import complexNumber
from src.repository.complexNumberRepository import complexNumberRepositoryMemory
from random import randint


class complexNumberService:

    def __init__(self, repository):
        self.__repository = repository
        if type(repository) == type(complexNumberRepositoryMemory()):
            self.generateComplexNumbers(10)
        self.__oldVersionsOfRepositoryUsingForUndo = []

    def addComplexNumberToRepository(self, realPart, imaginaryPart):
        newComplexNumber = complexNumber(realPart, imaginaryPart)
        self.__repository.addingNewComplexNumberToRepository(newComplexNumber)

    def getAllComplexNumbers(self):
        return self.__repository.getAllComplexNumbers()

    def generateComplexNumbers(self, howManyToGenerate: int):

        for index in range(howManyToGenerate):
            realPart = randint(-100, 100)
            imaginaryPart = randint(-100, 100)
            randomComplexNumber = complexNumber(realPart, imaginaryPart)
            self.__repository.addingNewComplexNumberToRepository(randomComplexNumber)

    def filterRepositoryOfComplexNumbersSuchThatItContainsOnlyNumbersBetweenIndicesStartAndEnd(self, start, end):
        index = 0
        numberOfDeletedComplexNumbers = 0
        while index < len(self.__repository):
            if index + numberOfDeletedComplexNumbers < start or index + numberOfDeletedComplexNumbers > end:
                self.__repository.deleteComplexNumberFromCertainPosition(index)
                numberOfDeletedComplexNumbers += 1
            else:
                index += 1

    def saveCurrentListOfAllComplexNumbers(self):
        self.__oldVersionsOfRepositoryUsingForUndo.append(self.getAllComplexNumbers()[:])

    def undoTheLastOperationPerformedByUser(self):
        self.__repository.updateListOfAllComplexNumbers(self.__oldVersionsOfRepositoryUsingForUndo[-1])
        self.__oldVersionsOfRepositoryUsingForUndo.pop()
