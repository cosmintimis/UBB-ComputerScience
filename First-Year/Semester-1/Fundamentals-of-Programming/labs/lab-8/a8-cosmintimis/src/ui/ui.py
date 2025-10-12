from src.repository.repositoryException import RepositoryException
from src.services.bookRentalException import BookRentalException
from datetime import datetime


class UserInterface:
    def __init__(self, bookService, clientService, rentalService):
        self.__bookService = bookService
        self.__clientService = clientService
        self.__rentalService = rentalService
        self.__clientService.generateRandomClientsAndStoreThemToRepository(10)
        self.__bookService.generateRandomBooksAndStoreThemToRepository(10)
        self.__rentalService.generateRandomRentalsAndStoreThemToRepository(5)
        self.__allUserCommands = {
            "add book": self.addBook,
            "list books": self.listBooks,
            "add client": self.addClient,
            "list clients": self.listClients,
            "remove book": self.removeBook,
            "remove client": self.removeClient,
            "update book": self.updateBook,
            "update client": self.updateClient,
            "list rentals": self.listRentals,
            "rent book": self.rentBook,
            "return book": self.returnBook,
            "search for clients": self.searchForCertainClients,
            "search for books": self.searchForCertainBooks,
            "most rented books": self.displayMostRentedBooks,
            "most active clients": self.displayListOfMostActiveClientsByNumberOfBookRentalDaysTheyHave,
            "most rented authors": self.displayListOfMostRentedAuthors
        }

    def addBook(self):
        bookId = input("Please enter an id for your book: ")
        bookTitle = input("Please enter a title for your book: ")
        bookAuthor = input("Please enter an author for your book: ")
        self.__bookService.createBookAndStoreItToRepository(str(bookId), bookTitle, bookAuthor)
        print("Successfully!")

    def removeBook(self):
        bookToDeleteId = input("Please enter an id for the book you want to delete: ")
        self.__bookService.deleteBookWithCertainIdFromRepository(bookToDeleteId)
        print("Successfully!")

    def updateBook(self):
        bookId = input("Please enter an id for the book you want to update: ")
        newBookTitle = input("Please enter the new title for your book: ")
        newBookAuthor = input("Please enter the new author for your book: ")
        self.__bookService.updateTitleAndAuthorForAnExistingBook(str(bookId), newBookTitle, newBookAuthor)
        print("Successfully!")

    def listBooks(self):
        listOfAllBooks = self.__bookService.getAllBooksFromRepository()
        if len(listOfAllBooks) == 0:
            print("There's no books!")
        else:
            for book in listOfAllBooks:
                print(str(book))

    def searchForCertainBooks(self):
        bookIdForm = str(input("Please enter how book's id supposed to be: "))
        bookTitleForm = str(input("Please enter how book's title supposed to be: "))
        bookAuthorForm = str(input("Please enter how book's author supposed to be: "))
        for book in self.__bookService.getAllBooksThatHaveSpecificIdTitleAndAuthor(bookIdForm.lower(), bookTitleForm.lower(), bookAuthorForm.lower()):
            print(book)
        if len(self.__bookService.getAllBooksThatHaveSpecificIdTitleAndAuthor(bookIdForm.lower(), bookTitleForm.lower(), bookAuthorForm.lower())) == 0:
            print("Don't exist such books!")


    def displayMostRentedBooks(self):
        listOfMostRentedBooksSortedInDescendingOrder = self.__rentalService.getListOfMostRentedBooksSortedInDescendingOrder()
        for book in listOfMostRentedBooksSortedInDescendingOrder:
            print(str(book))
        if len(listOfMostRentedBooksSortedInDescendingOrder) == 0:
            print("No data to display!")


    def addClient(self):
        clientId = input("Please enter an id for your client: ")
        clientName = input("Please enter a name for your client: ")
        self.__clientService.createClientAndStoreItToRepository(str(clientId), clientName)
        print("Successfully!")

    def removeClient(self):
        clientToDeleteId = input("Please enter an id for the client you want to delete: ")
        self.__clientService.deleteClientWithCertainIdFromRepository(clientToDeleteId)
        print("Successfully!")

    def updateClient(self):
        clientId = input("Please enter an id for the client you want to update: ")
        newClientName = input("Please enter the new name for your client: ")
        self.__clientService.updateNameForAnExistingClient(str(clientId), newClientName)
        print("Successfully!")

    def listClients(self):
        listOfAllClients = self.__clientService.getAllClientsFromRepository()
        if len(listOfAllClients) == 0:
            print("There's no clients!")
        else:
            for client in listOfAllClients:
                print(str(client))

    def searchForCertainClients(self):
        clientIdForm = str(input("Please enter how client's id supposed to be: "))
        clientNameForm = str(input("Please enter how client's name supposed to be: "))
        for client in self.__clientService.getAllClientsThatHaveSpecificNameAndId(clientIdForm.lower(), clientNameForm.lower()):
            print(client)
        if len(self.__clientService.getAllClientsThatHaveSpecificNameAndId(clientIdForm.lower(), clientNameForm.lower())) == 0:
            print("Don't exist such clients!")

    def displayListOfMostActiveClientsByNumberOfBookRentalDaysTheyHave(self):
        listOfMostActiveClientsByNumberOfBookRentalDaysTheyHave = self.__rentalService.getListOfMostActiveClientsByNumberOfBookRentalsTheyHaveSortedInDescendingOrder()
        for client in listOfMostActiveClientsByNumberOfBookRentalDaysTheyHave:
            print(str(client))
        if len(listOfMostActiveClientsByNumberOfBookRentalDaysTheyHave) == 0:
            print("No data to display!")


    def listRentals(self):
        listOfAllRentals = self.__rentalService.getAllRentalsFromRepository()
        if len(listOfAllRentals) == 0:
            print("There's no rentals!")
        else:
            for rental in listOfAllRentals:
                print(str(rental))

    def rentBook(self):
        rentalId = input("Please enter an id for that rental: ")
        clientId = input("Please enter the id of the client that want to rent: ")
        bookId = input("Please enter the id of the book that the client want to rent: ")
        rentedDate = input("Please enter the starting date of rent: ")
        returnedDate = input("Please enter the date when the book is returned: ")
        try:
            rentedDate = datetime.strptime(rentedDate, '%Y-%m-%d')
            returnedDate = datetime.strptime(returnedDate, '%Y-%m-%d')
        except ValueError as errorMessage:
            print(f"try again --- {errorMessage}")
        self.__rentalService.createRentalAndStoreItToRepository(str(rentalId), str(bookId), str(clientId), rentedDate,
                                                                returnedDate)
        print("Successfully!")

    def returnBook(self):
        clientId = input("Please enter the id of the client: ")
        bookId = input("Please enter the id of the book that client want to return: ")
        newReturnedDate = input("Please enter the date for that return: ")
        try:
            newReturnedDate = datetime.strptime(newReturnedDate, '%Y-%m-%d')
        except ValueError as errorMessage:
            print(f"try again --- {errorMessage}")
        self.__rentalService.updateTheReturnedDateForABook(str(clientId), str(bookId), newReturnedDate)
        print("Successfully!")


    def displayListOfMostRentedAuthors(self):
        listOfMostRentedAuthorsByNumberOfRentalsTheirBookHave = self.__rentalService.getListOfMostRentedAuthorsByNumberOfRentalsTheirBookHave()
        for author in listOfMostRentedAuthorsByNumberOfRentalsTheirBookHave:
            print(str(author))
        if len(listOfMostRentedAuthorsByNumberOfRentalsTheirBookHave) == 0:
            print("No data to display!")

    def start(self):

        while True:
            userInput = input(">>>")

            if userInput == "":
                continue
            elif userInput == "exit":
                break
            elif userInput in self.__allUserCommands:
                try:
                    self.__allUserCommands[userInput]()
                except ValueError as errorMessage:
                    print(f"try again --- {errorMessage}")
                except TypeError as errorMessage:
                    print(f"try again --- {errorMessage}")
                except RepositoryException as errorMessage:
                    print(f"try again --- {errorMessage}")
                except BookRentalException as errorMessage:
                    print(f"try again --- {errorMessage}")
            else:
                print("Invalid command!")
