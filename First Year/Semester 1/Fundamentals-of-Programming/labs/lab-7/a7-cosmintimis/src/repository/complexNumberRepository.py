import json
import pickle

from src.domain.complexNumber import complexNumber


class complexNumberRepositoryMemory:
    def __init__(self):
        self.__listOfAllComplexNumbers = []

    def addingNewComplexNumberToRepository(self, newComplexNumber: complexNumber):
        self.__listOfAllComplexNumbers.append(newComplexNumber)

    def getAllComplexNumbers(self):
        return self.__listOfAllComplexNumbers

    def deleteComplexNumberFromCertainPosition(self, position):
        self.__listOfAllComplexNumbers.pop(position)

    def updateListOfAllComplexNumbers(self, newListOfComplexNumbers):
        self.__listOfAllComplexNumbers = newListOfComplexNumbers

    def __len__(self):
        return len(self.__listOfAllComplexNumbers)


class complexNumberRepositoryTextFile(complexNumberRepositoryMemory):

    def __init__(self, fileName="..\\src\\repository\\complexNumbers.txt"):
        super(complexNumberRepositoryTextFile, self).__init__()
        self.__fileName = fileName
        self.__loadComplexNumbersFromTextFile()

    def __loadComplexNumbersFromTextFile(self):
        allLinesFromTextFile = []
        try:
            fileToReadFrom = open(self.__fileName, "rt")
            allLinesFromTextFile = fileToReadFrom.readlines()
            fileToReadFrom.close()
        except IOError:
            pass

        for line in allLinesFromTextFile:
            number = ""
            if line[0] in ('+', '-'):
                signOfNumber = line[0]
                for char in line[1:]:
                    if char in ('+', '-'):
                        realPart = signOfNumber + number
                        signOfNumber = char
                        number = ""
                    else:
                        if char != 'i':
                            number += char
            else:
                signOfNumber = '+'
                for char in line:
                    if char in ('+', '-'):
                        realPart = signOfNumber + number
                        signOfNumber = char
                        number = ""
                    else:
                        if char != 'i':
                            number += char

            imaginaryPart = signOfNumber + number
            realPart = float(realPart)
            imaginaryPart = float(imaginaryPart)
            if realPart == int(realPart):
                realPart = int(realPart)
            if imaginaryPart == int(imaginaryPart):
                imaginaryPart = int(imaginaryPart)
            newComplexNumber = complexNumber(realPart, imaginaryPart)
            super().addingNewComplexNumberToRepository(newComplexNumber)

    def __saveComplexNumbersToTextFile(self):

        fileToWriteIn = open(self.__fileName, "wt")
        for imaginaryNumber in self.getAllComplexNumbers():
            fileToWriteIn.write(str(imaginaryNumber) + "\n")
        fileToWriteIn.close()

    def addingNewComplexNumberToRepository(self, newComplexNumber: complexNumber):
        super().addingNewComplexNumberToRepository(newComplexNumber)
        self.__saveComplexNumbersToTextFile()

    def deleteComplexNumberFromCertainPosition(self, position):
        super().deleteComplexNumberFromCertainPosition(position)
        self.__saveComplexNumbersToTextFile()

    def updateListOfAllComplexNumbers(self, newListOfComplexNumbers):
        super().updateListOfAllComplexNumbers(newListOfComplexNumbers)
        self.__saveComplexNumbersToTextFile()


class complexNumberRepositoryBinaryFile(complexNumberRepositoryMemory):

    def __init__(self, fileName="..\\src\\repository\\complexNumbers.bin"):
        super(complexNumberRepositoryBinaryFile, self).__init__()
        self.__fileName = fileName
        self.__loadComplexNumbersFromBinaryFile()

    def addingNewComplexNumberToRepository(self, newComplexNumber: complexNumber):
        super().addingNewComplexNumberToRepository(newComplexNumber)
        self.__saveComplexNumbersToBinaryFile()

    def __loadComplexNumbersFromBinaryFile(self):
        fileToWriteIn = open(self.__fileName, "rb")
        reconstitutedObjects = pickle.load(fileToWriteIn)
        for element in reconstitutedObjects:
            super().addingNewComplexNumberToRepository(element)
        fileToWriteIn.close()


    def __saveComplexNumbersToBinaryFile(self):
        fileToWriteIn = open(self.__fileName, "wb")
        pickle.dump(self.getAllComplexNumbers(), fileToWriteIn)
        fileToWriteIn.close()

    def deleteComplexNumberFromCertainPosition(self, position):
        super().deleteComplexNumberFromCertainPosition(position)
        self.__saveComplexNumbersToBinaryFile()

    def updateListOfAllComplexNumbers(self, newListOfComplexNumbers):
        super().updateListOfAllComplexNumbers(newListOfComplexNumbers)
        self.__saveComplexNumbersToBinaryFile()


class complexNumberRepositoryJsonFile(complexNumberRepositoryMemory):

    def __init__(self, fileName="..\\src\\repository\\complexNumbers.json"):
        super(complexNumberRepositoryJsonFile, self).__init__()
        self.__fileName = fileName
        self.__loadComplexNumbersFromJsonFile()

    def addingNewComplexNumberToRepository(self, newComplexNumber: complexNumber):
        super().addingNewComplexNumberToRepository(newComplexNumber)
        self.__saveComplexNumbersToJsonFile()

    def __loadComplexNumbersFromJsonFile(self):
        fileToWriteIn = open(self.__fileName, "r")
        jsonComplexNumberStringList = json.load(fileToWriteIn)
        for complexNumberString in jsonComplexNumberStringList:
            complexNumberDictionary = json.loads(complexNumberString)
            newComplexNumber = complexNumber(complexNumberDictionary["_complexNumber__realPart"], complexNumberDictionary["_complexNumber__imaginaryPart"])
            super().addingNewComplexNumberToRepository(newComplexNumber)
        fileToWriteIn.close()

    def __saveComplexNumbersToJsonFile(self):
        fileToWriteIn = open(self.__fileName, "w")
        json.dump(list(map(lambda obj: obj.convertObjectToJson(), self.getAllComplexNumbers())), fileToWriteIn)
        fileToWriteIn.close()

    def deleteComplexNumberFromCertainPosition(self, position):
        super().deleteComplexNumberFromCertainPosition(position)
        self.__saveComplexNumbersToJsonFile()

    def updateListOfAllComplexNumbers(self, newListOfComplexNumbers):
        super().updateListOfAllComplexNumbers(newListOfComplexNumbers)
        self.__saveComplexNumbersToJsonFile()
