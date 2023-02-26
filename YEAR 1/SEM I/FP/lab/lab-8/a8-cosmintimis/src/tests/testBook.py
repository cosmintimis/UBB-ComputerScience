import unittest

from src.domain.book import Book


class TestBook(unittest.TestCase):
    def testBook1(self):
        book1 = Book('1', "Ion", "Liviu Rebreanu")
        self.assertEqual(book1.id, '1')
        self.assertEqual(book1.author, "Liviu Rebreanu")
        self.assertEqual(book1.title, "Ion")

    def testBook2(self):
        book2 = Book('9099', "White Fang", "Jack London")
        self.assertEqual(book2.id, '9099')
        self.assertEqual(book2.author, "Jack London")
        self.assertEqual(book2.title, "White Fang")
