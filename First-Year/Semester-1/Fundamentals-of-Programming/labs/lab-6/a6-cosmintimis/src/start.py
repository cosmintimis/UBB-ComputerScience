#
# This module is used to invoke the program's UI and start it. It should not contain a lot of code.
#
from ui import start
from functions import testAllRemoveCommands, testAddingNewExpenseToAllFamilyExpenses

def main():
    testAddingNewExpenseToAllFamilyExpenses()
    testAllRemoveCommands()
    start()


main()
