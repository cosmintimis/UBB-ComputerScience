

class Book:
    def __init__(self, id, title, author):
        self.__id = id
        self.__title = title
        self.__author = author

    @property
    def id(self):
        return self.__id

    @id.setter
    def id(self, newId):
        self.__id = newId

    @property
    def title(self):
        return self.__title

    @title.setter
    def title(self, newTitle):
        self.__title = newTitle

    @property
    def author(self):
        return self.__author

    @author.setter
    def author(self, newAuthor):
        self.__author = newAuthor

    def __str__(self):
        return "Book id: " + str(self.id) + " --- Title: " + str(self.title) + " --- Author: " + str(self.author)

    def __repr__(self):
        return str(self)

    def __eq__(self, randomBook):
        if not isinstance(randomBook, Book):
            return False
        return self.id == randomBook.id


class BookValidator:
    def __init__(self):
        pass

    @staticmethod
    def checkIfProvidedBookInstanceIsValid(providedBook):
        if not isinstance(providedBook, Book):
            raise TypeError("Can only validate Book objects!")
        if len(str(providedBook.id)) == 0:
            raise ValueError("A Book must have an id!")
        if len(providedBook.title) == 0:
            raise ValueError("A Book must have an title!")
        if len(providedBook.author) == 0:
            raise ValueError("A Book must have an author!")
        return True



