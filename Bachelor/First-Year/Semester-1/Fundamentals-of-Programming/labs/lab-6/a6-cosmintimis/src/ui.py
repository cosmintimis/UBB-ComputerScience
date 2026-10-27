#
# This is the program's UI module. The user interface and all interaction with the user (print and input statements) are found here
#

from functions import *


def printMenu():
    print("1.Add a new expense: add <sum> <category> or insert <day> <sum> <category>")
    print("2.Modify expenses: remove <day> or remove <start day> to <end day> or remove <category>")
    print("3.Display expenses with different properties: list <category> [ < | = | > ] <value>")
    print("4.Filter expenses: filter <category> [ < | = | > ] <value>")
    print("5.Undo: undo")
    print("0.Exit: exit")


def readUserCommand():
    userInput = input(">")
    indexOfFirstSpace = userInput.find(" ")
    if indexOfFirstSpace == -1:
        return userInput, None
    userCommand = userInput[:indexOfFirstSpace]
    userCommandParameters = userInput[(indexOfFirstSpace + 1):]

    return userCommand, userCommandParameters


def displayFamilyExpenses(familyExpenses):
    if len(familyExpenses) == 0:
        print("Empty list!")
    for expense in familyExpenses:
        print(f"Day: {expense[0]}, Amount of money: {expense[1]}, Expense type: {expense[2]}")


def start():
    allFamilyExpenses = [[1, 100, "food"], [25, 50, "internet"], [5, 300, "transport"], [2, 500, "others"],
                         [12, 250, "clothing"], [9, 300, "housekeeping"], [19, 200, "food"], [14, 50, "transport"],
                         [28, 100, "others"], [21, 250, "clothing"]]

    olderVersionsOfAllFamilyExpensesUsingForUndoCommand = []
    numberOfCommandsExecutedByUser = -1

    while True:
        printMenu()

        userCommand, userCommandParameters = readUserCommand()

        if userCommand == "add":
            if userCommandParameters is None:
                print("Invalid command!")
                continue
            userCommandParameters = userCommandParameters.split(" ")
            if len(userCommandParameters) != 2:
                print("Invalid number of parameters!")
                continue
            copyOfAllFamilyExpenses = allFamilyExpenses.copy()
            try:
                allFamilyExpenses = addingNewExpenseToAllFamilyExpenses(int(userCommandParameters[0]),
                                                                        userCommandParameters[1],
                                                                        allFamilyExpenses)
                print("Successfully!")
                numberOfCommandsExecutedByUser += 1
                olderVersionsOfAllFamilyExpensesUsingForUndoCommand.append([])
                olderVersionsOfAllFamilyExpensesUsingForUndoCommand[
                    numberOfCommandsExecutedByUser] = copyOfAllFamilyExpenses.copy()

            except ValueError as ve:
                print("try again -- " + str(ve))
        elif userCommand == "insert":
            if userCommandParameters is None:
                print("Invalid command!")
                continue
            userCommandParameters = userCommandParameters.split(" ")
            if len(userCommandParameters) != 3:
                print("Invalid number of parameters!")
                continue
            copyOfAllFamilyExpenses = allFamilyExpenses.copy()
            try:
                allFamilyExpenses = addingNewExpenseToAllFamilyExpenses(int(userCommandParameters[1]),
                                                                        userCommandParameters[2],
                                                                        allFamilyExpenses,
                                                                        int(userCommandParameters[0]))
                print("Successfully!")
                numberOfCommandsExecutedByUser += 1
                olderVersionsOfAllFamilyExpensesUsingForUndoCommand.append([])
                olderVersionsOfAllFamilyExpensesUsingForUndoCommand[
                    numberOfCommandsExecutedByUser] = copyOfAllFamilyExpenses
            except ValueError as ve:
                print("try again -- " + str(ve))
        elif userCommand == "list":
            if userCommandParameters is None:
                displayFamilyExpenses(allFamilyExpenses)
            else:
                userCommandParameters = userCommandParameters.split(" ")
                if len(userCommandParameters) == 1:
                    try:
                        displayFamilyExpenses(
                            getAllFamilyExpensesHavingSameExpenseType(allFamilyExpenses, userCommandParameters[0]))
                    except ValueError as ve:
                        print("try again -- " + str(ve))
                elif len(userCommandParameters) == 3:
                    try:
                        displayFamilyExpenses(
                            getAllFamilyExpensesHavingSameTypeWithCostSmallerOrEqualsOrBiggerThanCertainValue(
                                allFamilyExpenses, userCommandParameters[0], userCommandParameters[1],
                                int(userCommandParameters[2])))
                    except ValueError as ve:
                        print("try again -- " + str(ve))
                else:
                    print("Invalid command parameters!")
        elif userCommand == "remove":
            if userCommandParameters is None:
                print("Invalid command!")
                continue
            userCommandParameters = userCommandParameters.split(" ")
            if len(userCommandParameters) == 1:
                copyOfAllFamilyExpenses = allFamilyExpenses.copy()
                if userCommandParameters[0].isdigit():
                    try:
                        allFamilyExpenses = removeAllFamilyExpensesFromACertainDay(allFamilyExpenses,
                                                                                   int(userCommandParameters[0]))
                        print("Successfully!")
                        numberOfCommandsExecutedByUser += 1
                        olderVersionsOfAllFamilyExpensesUsingForUndoCommand.append([])
                        olderVersionsOfAllFamilyExpensesUsingForUndoCommand[
                            numberOfCommandsExecutedByUser] = copyOfAllFamilyExpenses
                    except ValueError as ve:
                        print("try again -- " + str(ve))
                else:
                    try:
                        allFamilyExpenses = removeAllFamilyExpensesHavingCertainExpenseType(allFamilyExpenses,
                                                                                            userCommandParameters[0])
                        print("Successfully!")
                        numberOfCommandsExecutedByUser += 1
                        olderVersionsOfAllFamilyExpensesUsingForUndoCommand.append([])
                        olderVersionsOfAllFamilyExpensesUsingForUndoCommand[
                            numberOfCommandsExecutedByUser] = copyOfAllFamilyExpenses
                    except ValueError as ve:
                        print("try again -- " + str(ve))
            elif len(userCommandParameters) == 3:
                if userCommandParameters[1] == "to":
                    copyOfAllFamilyExpenses = allFamilyExpenses.copy()
                    try:
                        allFamilyExpenses = removeAllFamilyExpensesBetweenTwoGivenDays(allFamilyExpenses,
                                                                                       int(userCommandParameters[0]),
                                                                                       int(userCommandParameters[2]))
                        print("Successfully!")
                        numberOfCommandsExecutedByUser += 1
                        olderVersionsOfAllFamilyExpensesUsingForUndoCommand.append([])
                        olderVersionsOfAllFamilyExpensesUsingForUndoCommand[
                            numberOfCommandsExecutedByUser] = copyOfAllFamilyExpenses
                    except ValueError as ve:
                        print("try again -- " + str(ve))
                else:
                    print("Invalid command parameters!")
            else:
                print("Invalid command parameters!")

        elif userCommand == "filter":
            if userCommandParameters is None:
                print("Invalid command!")
                continue
            userCommandParameters = userCommandParameters.split(" ")
            if len(userCommandParameters) == 1:
                copyOfAllFamilyExpenses = allFamilyExpenses.copy()
                try:
                    allFamilyExpenses = keepOnlyExpensesHavingCertainType(allFamilyExpenses, userCommandParameters[0])
                    print("Successfully!")
                    numberOfCommandsExecutedByUser += 1
                    olderVersionsOfAllFamilyExpensesUsingForUndoCommand.append([])
                    olderVersionsOfAllFamilyExpensesUsingForUndoCommand[
                        numberOfCommandsExecutedByUser] = copyOfAllFamilyExpenses
                except ValueError as ve:
                    print("try again -- " + str(ve))
                pass
            elif len(userCommandParameters) == 3:
                copyOfAllFamilyExpenses = allFamilyExpenses.copy()
                try:
                    allFamilyExpenses = keepOnlyExpensesHavingCertainTypeWithCostSmallerOrEqualsOrBiggerThanCertainValue(
                        allFamilyExpenses, userCommandParameters[0], userCommandParameters[1],
                        int(userCommandParameters[2]))
                    print("Successfully!")
                    numberOfCommandsExecutedByUser += 1
                    olderVersionsOfAllFamilyExpensesUsingForUndoCommand.append([])
                    olderVersionsOfAllFamilyExpensesUsingForUndoCommand[
                        numberOfCommandsExecutedByUser] = copyOfAllFamilyExpenses
                except ValueError as ve:
                    print("try again -- " + str(ve))
            else:
                print("Invalid command parameters!")
        elif userCommand == "undo":
            if numberOfCommandsExecutedByUser != -1:
                allFamilyExpenses = olderVersionsOfAllFamilyExpensesUsingForUndoCommand[numberOfCommandsExecutedByUser]
                numberOfCommandsExecutedByUser -= 1
                print("Successfully!")
            else:
                print("No undo(s) left")
        elif userCommand == "exit":
            return
        else:
            print("Invalid command!")
