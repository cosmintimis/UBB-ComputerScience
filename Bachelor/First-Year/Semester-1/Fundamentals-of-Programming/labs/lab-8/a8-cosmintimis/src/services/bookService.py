from src.domain.book import Book
from random import choice


class BookService:
    def __init__(self, bookValidator, bookRepository, rentalService):
        self.__bookValidator = bookValidator
        self.__bookRepository = bookRepository
        self.__rentalService = rentalService

    def createBookAndStoreItToRepository(self, bookId, bookTitle, bookAuthor):
        newBook = Book(bookId, bookTitle, bookAuthor)
        self.__bookValidator.checkIfProvidedBookInstanceIsValid(newBook)
        self.__bookRepository.storeObjectToRepository(newBook)
        return newBook

    def deleteBookWithCertainIdFromRepository(self, bookId):
        bookToDelete = self.__bookRepository.deleteObjectFromRepositoryWithCertainId(bookId)

        allRentalsForProvidedBook = self.__rentalService.getListOfRentalsPerformedByProvidedClientForProvidedBook(None,
                                                                                                                  bookId)
        for rental in allRentalsForProvidedBook:
            self.__rentalService.deleteRentalWithCertainIdFromRepository(rental.id)

        return bookToDelete

    def getTotalNumberOfBooks(self):
        return len(self.__bookRepository)

    def getAllBooksFromRepository(self):
        return self.__bookRepository.getAllObjectsFromRepository()

    def getAllBooksThatHaveSpecificIdTitleAndAuthor(self, bookIdForm, bookTitleForm, bookAuthorForm):
        listOfAllBooksThatHaveSpecificIdTitleAndAuthor = []
        for book in self.__bookRepository.getAllObjectsFromRepository():
            if bookIdForm in book.id.lower() and bookTitleForm in book.title.lower() and bookAuthorForm in book.author.lower():
                listOfAllBooksThatHaveSpecificIdTitleAndAuthor.append(book)
        return listOfAllBooksThatHaveSpecificIdTitleAndAuthor

    def generateRandomBooksAndStoreThemToRepository(self, howManyToGenerate):
        listOfRandomTitlesForBooks = ["The Burden of the Galaxy", "The Mortal Bell", "Roses and Flame",
                                      "Unleash the Dragon", "Cry of Blood",
                                      "The Haunted Painting", "Fatal Gun", "Force of Gravity", "Mysterious Cyborg",
                                      "The Other Animals",
                                      "The Judgement", "The Angel And The Star", "Dragon Invasion",
                                      "Ninja Cats Rescue Mission", "Bad Surprise",
                                      "Tales of the Heart", "The Strange Key", "Nothing In This World",
                                      "Horse With No Rider"]
        listOfRandomNamesForAuthors = ["MADISON CLARKE", "JANE HINES", "PAUL SALAZAR", "SCARLETT HARVEY",
                                       "HALBERD WEAVER", "DRAKE HOLDEN", "HADWIN WATSON", "DEVON ROBSON",
                                       "WYNNE WATERS", "KYM MENDOZA", "DON SPENCER", "MANFRED FROST"
                                       ]
        
        while howManyToGenerate:
            idOfLastBookFromRepository = self.getTotalNumberOfBooks()
            randomBookTitle = choice(listOfRandomTitlesForBooks)
            randomBookAuthor = choice(listOfRandomNamesForAuthors)
            self.createBookAndStoreItToRepository(str(idOfLastBookFromRepository + 1), randomBookTitle, randomBookAuthor)
            howManyToGenerate -= 1


    def updateTitleAndAuthorForAnExistingBook(self, bookId, newTitle, newAuthor):
        newBook = Book(bookId, newTitle, newAuthor)
        self.__bookRepository.replaceAnExistingObjectWithNewProvidedObjectHavingSameId(newBook)
