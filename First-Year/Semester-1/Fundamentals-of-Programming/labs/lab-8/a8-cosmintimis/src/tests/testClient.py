import unittest

from src.domain.client import Client


class TestClient(unittest.TestCase):
    def testClient1(self):
        client1 = Client('1', "Cosmin Timis")
        self.assertEqual(client1.id, '1')
        self.assertEqual(client1.name, "Cosmin Timis")

    def testClient2(self):
        client2 = Client('5632', "Alexandra Roman")
        self.assertEqual(client2.id, '5632')
        self.assertEqual(client2.name, "Alexandra Roman")
