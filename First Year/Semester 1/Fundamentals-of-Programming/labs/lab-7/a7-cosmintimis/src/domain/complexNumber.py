import json


class complexNumber:

    def __init__(self, realPart, imaginaryPart):
        self.__realPart = realPart
        self.__imaginaryPart = imaginaryPart

    @property
    def realPart(self):
        return self.__realPart

    @realPart.setter
    def realPart(self, new_value):
        self.__realPart = new_value

    @property
    def imaginaryPart(self):
        return self.__imaginaryPart

    @imaginaryPart.setter
    def imaginaryPart(self, new_value):
        self.__imaginaryPart = new_value

    def convertObjectToJson(self):
        return json.dumps(self, default=lambda obj: obj.__dict__)

    def __repr__(self):
        return str(self)

    def __eq__(self, randomComplexNumber):
        if self.realPart == randomComplexNumber.realPart and self.imaginaryPart == randomComplexNumber.imaginaryPart:
            return True
        return False

    def __str__(self):
        if self.imaginaryPart == 0:
            return f"{self.realPart}"
        if self.realPart == 0:
            return f"{self.imaginaryPart}i"
        if self.imaginaryPart > 0:
            return f"{self.realPart}+{self.imaginaryPart}i"
        if self.imaginaryPart < 0:
            return f"{self.realPart}{self.imaginaryPart}i"
