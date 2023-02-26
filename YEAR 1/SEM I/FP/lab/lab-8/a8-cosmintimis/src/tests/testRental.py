import unittest

from src.domain.rental import Rental
from datetime import datetime, timedelta


class TestRental(unittest.TestCase):
    def testRental(self):
        rental = Rental('1', '578', '34', datetime.now().strftime("%Y-%m-%d"), (datetime.now() + timedelta(days=10)).strftime("%Y-%m-%d"))
        self.assertEqual(rental.id, '1')
        self.assertEqual(rental.book, '578')
        self.assertEqual(rental.client, '34')
        self.assertEqual(rental.rentedDate, datetime.now().strftime("%Y-%m-%d"))
        self.assertEqual(rental.returnedDate, (datetime.now() + timedelta(days=10)).strftime("%Y-%m-%d"))
