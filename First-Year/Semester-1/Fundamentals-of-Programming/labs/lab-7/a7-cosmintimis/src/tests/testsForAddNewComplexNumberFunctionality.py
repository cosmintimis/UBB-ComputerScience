from src.repository.complexNumberRepository import complexNumberRepositoryMemory
from src.services.complexNumberService import complexNumberService
from src.domain.complexNumber import complexNumber


def testAddingNewComplexNumberToRepository():
    complexNumberRepository = complexNumberRepositoryMemory()
    complexNumbersService = complexNumberService(complexNumberRepository)

    listOfAllComplexNumbers = complexNumbersService.getAllComplexNumbers()
    if len(listOfAllComplexNumbers) == 10:
        assert True
    else:
        assert False
    newComplexNumber = complexNumber(3.2, -5.3)
    complexNumbersService.addComplexNumberToRepository(3.2, -5.3)
    listOfAllComplexNumbers = complexNumbersService.getAllComplexNumbers()
    if listOfAllComplexNumbers[10] == newComplexNumber:
        assert True
    else:
        assert False


