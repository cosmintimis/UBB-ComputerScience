from src.domain.book import BookValidator
from src.domain.client import ClientValidator
from src.domain.rental import RentalValidator
from src.repository.repository import Repository
from src.services.bookService import BookService
from src.services.clientService import ClientService
from src.services.rentalService import RentalService
from src.ui.ui import UserInterface

if __name__ == "__main__":
    bookValidator = BookValidator()
    clientValidator = ClientValidator()
    rentalValidator = RentalValidator()
    bookRepository = Repository()
    clientRepository = Repository()
    rentalRepository = Repository()
    rentalService = RentalService(rentalValidator, rentalRepository, bookRepository, clientRepository)
    bookService = BookService(bookValidator, bookRepository, rentalService)
    clientService = ClientService(clientValidator, clientRepository, rentalService)
    userInterface = UserInterface(bookService, clientService, rentalService)
    userInterface.start()
