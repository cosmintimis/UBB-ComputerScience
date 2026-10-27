from src.domain.rental import Rental
from src.services.bookRentalException import BookRentalException
from random import choice, randint
from datetime import datetime, timedelta


class RentalService:

    def __init__(self, rentalValidator, rentalRepository, bookRepository, clientRepository):
        self.__rentalValidator = rentalValidator
        self.__rentalRepository = rentalRepository
        self.__bookRepository = bookRepository
        self.__clientRepository = clientRepository

    def createRentalAndStoreItToRepository(self, rentalId, bookId, clientId, rentedDate, returnedDate):
        newRental = Rental(rentalId, bookId, clientId, rentedDate, returnedDate)
        self.__rentalValidator.checkIfProvidedRentalInstanceIsValid(newRental)

        if self.checkIfGivenBookIsAvailableInCertainPeriod(newRental.book, newRental.rentedDate,
                                                           newRental.returnedDate) is False:
            raise BookRentalException("This Book is not available during that time!")

        self.__rentalRepository.storeObjectToRepository(newRental)

        return newRental

    def checkIfGivenBookIsAvailableInCertainPeriod(self, givenBook, startDate, endDate):

        allRentalsForProvidedBook = self.getListOfRentalsPerformedByProvidedClientForProvidedBook(None, givenBook)
        for rental in allRentalsForProvidedBook:
            if startDate > rental.returnedDate or endDate < rental.rentedDate:
                continue
            return False
        return True

    def getListOfRentalsPerformedByProvidedClientForProvidedBook(self, providedClient, providedBook):
        """
        providedClient - The client performing the rental. None means all clients
        providedBook - The rented book. None means all books
        """
        listOfRentalsPerformedByProvidedClientForProvidedBook = []
        for rental in self.__rentalRepository.getAllObjectsFromRepository():
            if providedClient is not None and rental.client != providedClient:
                continue
            if providedBook is not None and rental.book != providedBook:
                continue
            listOfRentalsPerformedByProvidedClientForProvidedBook.append(rental)
        return listOfRentalsPerformedByProvidedClientForProvidedBook

    def getListOfMostRentedBooksSortedInDescendingOrder(self):
        listOfMostRentedBooksSortedInDescendingOrder = self.__bookRepository.getAllObjectsFromRepository()
        numberOfRentalsForEachBook = [0] * len(listOfMostRentedBooksSortedInDescendingOrder)
        index = 0
        for book in listOfMostRentedBooksSortedInDescendingOrder:
            numberOfRentalsForEachBook[index] = len(
                self.getListOfRentalsPerformedByProvidedClientForProvidedBook(None, book.id))
            index += 1
        for index1 in range(0, len(listOfMostRentedBooksSortedInDescendingOrder) - 1):
            for index2 in range(index1, len(listOfMostRentedBooksSortedInDescendingOrder)):
                if numberOfRentalsForEachBook[index1] < numberOfRentalsForEachBook[index2]:
                    numberOfRentalsForEachBook[index1], numberOfRentalsForEachBook[index2] = numberOfRentalsForEachBook[
                        index2], numberOfRentalsForEachBook[index1]
                    listOfMostRentedBooksSortedInDescendingOrder[index1], listOfMostRentedBooksSortedInDescendingOrder[
                        index2] = listOfMostRentedBooksSortedInDescendingOrder[index2], \
                    listOfMostRentedBooksSortedInDescendingOrder[index1]
        return listOfMostRentedBooksSortedInDescendingOrder

    def getListOfMostActiveClientsByNumberOfBookRentalsTheyHaveSortedInDescendingOrder(self):
        listOfMostActiveClientsByNumberOfBookRentalsTheyHaveSortedInDescendingOrder = self.__clientRepository.getAllObjectsFromRepository()
        totalNumberOfBookRentalsForEachClient = [0] * len(
            listOfMostActiveClientsByNumberOfBookRentalsTheyHaveSortedInDescendingOrder)
        index = 0
        for client in listOfMostActiveClientsByNumberOfBookRentalsTheyHaveSortedInDescendingOrder:
            for rental in self.getListOfRentalsPerformedByProvidedClientForProvidedBook(client.id, None):
                totalNumberOfBookRentalsForEachClient[index] += len(rental)
            index += 1

        for index1 in range(0, len(totalNumberOfBookRentalsForEachClient) - 1):
            for index2 in range(index1, len(totalNumberOfBookRentalsForEachClient)):
                if totalNumberOfBookRentalsForEachClient[index1] < totalNumberOfBookRentalsForEachClient[index2]:
                    totalNumberOfBookRentalsForEachClient[index1], totalNumberOfBookRentalsForEachClient[index2] = \
                    totalNumberOfBookRentalsForEachClient[index2], totalNumberOfBookRentalsForEachClient[index1]
                    listOfMostActiveClientsByNumberOfBookRentalsTheyHaveSortedInDescendingOrder[index1], \
                    listOfMostActiveClientsByNumberOfBookRentalsTheyHaveSortedInDescendingOrder[index2] = \
                    listOfMostActiveClientsByNumberOfBookRentalsTheyHaveSortedInDescendingOrder[index2], \
                    listOfMostActiveClientsByNumberOfBookRentalsTheyHaveSortedInDescendingOrder[index1]
        return listOfMostActiveClientsByNumberOfBookRentalsTheyHaveSortedInDescendingOrder

    def getListOfMostRentedAuthorsByNumberOfRentalsTheirBookHave(self):
        listOfMostRentedAuthorsByNumberOfRentalsTheirBookHave = self.getListOfAllCurrentAuthors()
        totalNumberOfRentalsEachAuthorBooksHave = [0] * len(listOfMostRentedAuthorsByNumberOfRentalsTheirBookHave)
        index = 0
        for author in listOfMostRentedAuthorsByNumberOfRentalsTheirBookHave:
            totalNumberOfRentalsEachAuthorBooksHave[index] += len(
                self.getListOfAllRentedBooksHavingCertainAuthor(author))
            index += 1
        for index1 in range(0, len(totalNumberOfRentalsEachAuthorBooksHave) - 1):
            for index2 in range(index1, len(totalNumberOfRentalsEachAuthorBooksHave)):
                if totalNumberOfRentalsEachAuthorBooksHave[index1] < totalNumberOfRentalsEachAuthorBooksHave[index2]:
                    totalNumberOfRentalsEachAuthorBooksHave[index1], totalNumberOfRentalsEachAuthorBooksHave[index2] = \
                    totalNumberOfRentalsEachAuthorBooksHave[index2], totalNumberOfRentalsEachAuthorBooksHave[index1]
                    listOfMostRentedAuthorsByNumberOfRentalsTheirBookHave[index1], \
                    listOfMostRentedAuthorsByNumberOfRentalsTheirBookHave[index2] = \
                    listOfMostRentedAuthorsByNumberOfRentalsTheirBookHave[index2], \
                    listOfMostRentedAuthorsByNumberOfRentalsTheirBookHave[index1]
        return listOfMostRentedAuthorsByNumberOfRentalsTheirBookHave

    def getListOfAllRentedBooksHavingCertainAuthor(self, certainAuthor):
        listOfAllRentedBooksHavingCertainAuthor = []
        for rental in self.__rentalRepository.getAllObjectsFromRepository():
            if self.__bookRepository.findObjectWithCertainId(rental.book).author == certainAuthor:
                listOfAllRentedBooksHavingCertainAuthor.append(
                    self.__bookRepository.findObjectWithCertainId(rental.book))
        return listOfAllRentedBooksHavingCertainAuthor

    def getAllRentalsFromRepository(self):
        return self.__rentalRepository.getAllObjectsFromRepository()

    def getTotalNumberOfRentals(self):
        return len(self.__rentalRepository)

    def updateTheReturnedDateForABook(self, clientId, bookId, newReturnedDate):
        checkingIfRentalExists = False
        for rental in self.__rentalRepository.getAllObjectsFromRepository():
            if rental.book == bookId and rental.client == clientId:
                checkingIfRentalExists = rental
                rental.returnedDate(newReturnedDate)
        if checkingIfRentalExists:
            checkingIfRentalExists.returnedDate = newReturnedDate
        else:
            raise BookRentalException("Doesn't exist such a rental!")

    def generateRandomRentalsAndStoreThemToRepository(self, howManyToGenerate):

        while howManyToGenerate:
            idOfTheLastRental = self.getTotalNumberOfRentals()
            pickARandomClient = choice(self.__clientRepository.getAllObjectsFromRepository())
            pickARandomBook = choice(self.__bookRepository.getAllObjectsFromRepository())
            pickARandomRentedDate = datetime.now() + timedelta(days=randint(1, 28))
            pickARandomReturnedDate = pickARandomRentedDate + timedelta(days=randint(1, 28))
            checkIfTheBookWeChooseIsAvailableOverThatPeriod = self.checkIfGivenBookIsAvailableInCertainPeriod(
                pickARandomBook.id, pickARandomRentedDate, pickARandomReturnedDate)
            if checkIfTheBookWeChooseIsAvailableOverThatPeriod:
                self.createRentalAndStoreItToRepository(str(idOfTheLastRental + 1), pickARandomBook.id,
                                                        pickARandomClient.id, pickARandomRentedDate,
                                                        pickARandomReturnedDate)
                howManyToGenerate -= 1

    def deleteRentalWithCertainIdFromRepository(self, rentalId):
        rentalToDelete = self.__rentalRepository.deleteObjectFromRepositoryWithCertainId(rentalId)
        return rentalToDelete

    def getListOfAllCurrentAuthors(self):
        listOfAllCurrentAuthors = []
        for book in self.__bookRepository.getAllObjectsFromRepository():
            checkIfAuthorWasAddedToList = False
            for author in listOfAllCurrentAuthors:
                if author == book.author:
                    checkIfAuthorWasAddedToList = True
            if not checkIfAuthorWasAddedToList:
                listOfAllCurrentAuthors.append(book.author)
        return listOfAllCurrentAuthors
