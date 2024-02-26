from datetime import datetime


class Rental:
    def __init__(self, id, bookId, clientId, rentedDate, returnedDate):
        self.__id = id
        self.__bookId = bookId
        self.__clientId = clientId
        self.__rentedDate = rentedDate
        self.__returnedDate = returnedDate

    @property
    def id(self):
        return self.__id

    @id.setter
    def id(self, newId):
        self.__id = newId

    @property
    def client(self):
        return self.__clientId

    @client.setter
    def client(self, newClientId):
        self.__clientId = newClientId

    @property
    def book(self):
        return self.__bookId

    @book.setter
    def book(self, newBookId):
        self.__bookId = newBookId

    @property
    def rentedDate(self):
        return self.__rentedDate

    @rentedDate.setter
    def rentedDate(self, newRentedDate):
        self.__rentedDate = newRentedDate

    @property
    def returnedDate(self):
        return self.__returnedDate

    @returnedDate.setter
    def returnedDate(self, newReturnedDate):
        self.__returnedDate = newReturnedDate

    def __len__(self):
        return (self.returnedDate - self.rentedDate).days + 1

    def __repr__(self):
        return str(self)

    def __eq__(self, randomRental):
        if isinstance(randomRental, Rental) is False:
            return False
        return self.id == randomRental.id

    def __str__(self):
        return "Rental Id:" + str(self.id) + " --- Client Id:" + str(self.client) + " --- Book Id:" + str(
            self.book) + "\nPeriod: " + self.rentedDate.strftime("%Y-%m-%d") + " to " + self.returnedDate.strftime(
            "%Y-%m-%d")


class RentalValidator:
    def __init__(self):
        pass

    @staticmethod
    def checkIfProvidedRentalInstanceIsValid(providedRental):
        if not isinstance(providedRental, Rental):
            raise TypeError("Can only validate Rental objects!")
        if len(str(providedRental.id)) == 0:
            raise ValueError("A Rental must have an id!")
        todayDate = datetime.now()
        if providedRental.rentedDate < todayDate:
            raise ValueError("Rental starts in past!")
        if len(providedRental) < 1:
            raise ValueError("Rental must be at least 1 day!")
        return True
