class userInterface:
    def __init__(self, complexNumberService):
        self.__complexNumberService = complexNumberService

    def start(self):

        numberOfOperationsMadeByUser = 0
        while True:
            print("1. Add a complex number")
            print("2. Display the list of complex numbers")
            print("3. Filter the list so that it contains only numbers between \"start\" and \"end\"")
            print("4. Undo")
            print("0. Exit")

            option = input('>')

            if option == '1':
                print("Please enter the real part: ")
                realPart = input('>')
                print("Please enter the imaginary part: ")
                imaginaryPart = input('>')
                try:
                    realPart = float(realPart)
                    imaginaryPart = float(imaginaryPart)
                    if realPart == int(realPart):
                        realPart = int(realPart)
                    if imaginaryPart == int(imaginaryPart):
                        imaginaryPart = int(imaginaryPart)
                    self.__complexNumberService.saveCurrentListOfAllComplexNumbers()
                    self.__complexNumberService.addComplexNumberToRepository(realPart, imaginaryPart)
                except ValueError as errorMessage:
                    print("try again -- " + str(errorMessage))
                else:
                    numberOfOperationsMadeByUser += 1
                    print("Successfully!")
            elif option == '2':
                listOfAllComplexNumbers = self.__complexNumberService.getAllComplexNumbers()
                for number in listOfAllComplexNumbers:
                    print(number)
            elif option == '3':
                print("Please enter the value of \"start\": ")
                startValue = input('>')
                print("Please enter the value of \"end\": ")
                endValue = input('>')
                try:
                    startValue = int(startValue)
                    endValue = int(endValue)
                    if startValue < 0 or endValue < 0:
                        print("Invalid input!(<0)")
                        continue
                    if startValue > endValue:
                        print("End must be greater or equal to start!")
                        continue
                    listOfAllComplexNumbers = self.__complexNumberService.getAllComplexNumbers()
                    if endValue > len(listOfAllComplexNumbers) - 1:
                        print("Value of \"end\" is longer than the length of the list!")
                        continue
                    self.__complexNumberService.saveCurrentListOfAllComplexNumbers()
                    self.__complexNumberService.filterRepositoryOfComplexNumbersSuchThatItContainsOnlyNumbersBetweenIndicesStartAndEnd(startValue, endValue)
                except ValueError as errorMessage:
                    print("try again -- " + str(errorMessage))
                else:
                    numberOfOperationsMadeByUser += 1
                    print("Successfully!")
            elif option == '4':
                if numberOfOperationsMadeByUser > 0:
                    self.__complexNumberService.undoTheLastOperationPerformedByUser()
                    numberOfOperationsMadeByUser -= 1
                    print("Successfully!")
                else:
                    print("Perform an operation in order to undo!(No undoes left)")
            elif option == '0':
                return
            elif option == "":
                continue
            else:
                print("Invalid command!")

