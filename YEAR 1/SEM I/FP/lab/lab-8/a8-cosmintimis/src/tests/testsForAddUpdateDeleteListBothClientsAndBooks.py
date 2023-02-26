import unittest

from src.domain.book import BookValidator, Book
from src.domain.client import ClientValidator, Client
from src.domain.rental import RentalValidator, Rental
from src.repository.repository import Repository
from src.services.bookService import BookService
from src.services.clientService import ClientService
from src.services.rentalService import RentalService


class TestsForAddUpdateDeleteListBothClientsAndBooks(unittest.TestCase):

    bookValidator = BookValidator()
    clientValidator = ClientValidator()
    rentalValidator = RentalValidator()
    bookRepository = Repository()
    clientRepository = Repository()
    rentalRepository = Repository()
    rentalService = RentalService(rentalValidator, rentalRepository, bookRepository, clientRepository)
    bookService = BookService(bookValidator, bookRepository, rentalService)
    clientService = ClientService(clientValidator, clientRepository, rentalService)

    def testsForAddClientsAndBooksFunctionality(self):
        self.bookService.createBookAndStoreItToRepository('1', "Ion", "Liviu Rebreanu")
        self.bookService.createBookAndStoreItToRepository('2', "White Fang", "Jack London")
        self.bookService.createBookAndStoreItToRepository('3', "Sans Famille", "Hector Malot")

        self.assertIn(self.bookRepository.findObjectWithCertainId('1'), self.bookService.getAllBooksFromRepository())
        self.assertIn(self.bookRepository.findObjectWithCertainId('2'), self.bookService.getAllBooksFromRepository())
        self.assertIn(self.bookRepository.findObjectWithCertainId('3'), self.bookService.getAllBooksFromRepository())

        self.clientService.createClientAndStoreItToRepository('1', "Cosmin Timis")
        self.clientService.createClientAndStoreItToRepository('2', "Sebastian Hojda")
        self.clientService.createClientAndStoreItToRepository('3', "Robert Pitic")

        self.assertIn(self.clientRepository.findObjectWithCertainId('1'),
                      self.clientService.getAllClientsFromRepository())
        self.assertIn(self.clientRepository.findObjectWithCertainId('2'),
                      self.clientService.getAllClientsFromRepository())
        self.assertIn(self.clientRepository.findObjectWithCertainId('3'),
                      self.clientService.getAllClientsFromRepository())

    def testsForUpdateClientsAndBooksFunctionality(self):
        self.bookService.updateTitleAndAuthorForAnExistingBook('1', "White Fang", "Jack Landon")

        self.assertEqual(self.bookRepository.findObjectWithCertainId('1').title, "White Fang")
        self.assertEqual(self.bookRepository.findObjectWithCertainId('1').author, "Jack Landon")

        self.clientService.updateNameForAnExistingClient('3', "Davide Roman")
        self.assertEqual(self.clientRepository.findObjectWithCertainId('3').name, "Davide Roman")


    def testsForDeleteClientsAndBooks(self):
        book2 = self.bookRepository.findObjectWithCertainId('2')
        self.bookService.deleteBookWithCertainIdFromRepository('2')

        self.assertNotIn(book2, self.bookService.getAllBooksFromRepository())

        client1 = self.clientRepository.findObjectWithCertainId('1')
        self.clientService.deleteClientWithCertainIdFromRepository('1')

        self.assertNotIn(client1, self.clientService.getAllClientsFromRepository())




