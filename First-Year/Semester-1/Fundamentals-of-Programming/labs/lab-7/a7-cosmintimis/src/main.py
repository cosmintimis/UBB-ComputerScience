from services.complexNumberService import complexNumberService
from src.repository.complexNumberRepository import complexNumberRepositoryMemory, complexNumberRepositoryTextFile, complexNumberRepositoryBinaryFile, complexNumberRepositoryJsonFile
from ui.ui import userInterface
from jproperties import Properties
from src.tests.testsForAddNewComplexNumberFunctionality import testAddingNewComplexNumberToRepository

if __name__ == '__main__':
    testAddingNewComplexNumberToRepository()
    configuration = Properties()
    with open('settings.properties', 'rb') as readProperties:
        configuration.load(readProperties)
    selectedComplexNumberRepository = configuration.get("complexNumberRepository").data
    complexNumberRepository = locals()[selectedComplexNumberRepository]()
    complexNumberService = complexNumberService(complexNumberRepository)
    userInterface = userInterface(complexNumberService)
    userInterface.start()
