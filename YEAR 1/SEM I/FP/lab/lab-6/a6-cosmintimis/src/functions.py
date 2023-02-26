#
# The program's functions are implemented here. There is no user interaction in this file, therefore no input/print statements. Functions here
# communicate via function parameters, the return statement and raising of exceptions. 
#

from datetime import datetime

def createAnFamilyExpense(day, amountOfMoney, expenseType):
    """
    Create an expense
    :param day: day of expense
    :param amountOfMoney: cost of expense
    :param expenseType: type of expense
    :return: the new family expense
    Raise ValueError if param day isn't in right interval, amountOfMoney isn't positive integer and expenseType contains
    non defined expense type
    """
    if day not in range(1, 31):
        raise ValueError(f"Day of the month must be between 1-30, got: {day}")
    if amountOfMoney is not None and amountOfMoney <= 0:
        raise ValueError(f"Amount of money must be a positive integer, got: {amountOfMoney}")
    if expenseType not in ("housekeeping", "food", "transport", "clothing", "internet", "others"):
        raise ValueError(f"Invalid expense type")
    return [day, amountOfMoney, expenseType]

def addingNewExpenseToAllFamilyExpenses(amountOfMoney, expenseType, allFamilyExpenses, day=int(datetime.now().day)):
    """
    Adding an expense to repository of all family expenses
    :param amountOfMoney: cost of expense
    :param expenseType: type of expense
    :param allFamilyExpenses: repository of all expenses
    :param day: day of expense
    """
    newFamilyExpense = createAnFamilyExpense(day, amountOfMoney, expenseType)
    allFamilyExpenses.append(newFamilyExpense)

    return allFamilyExpenses

def testAddingNewExpenseToAllFamilyExpenses():
    testFamilyExpensesList = []

    assert addingNewExpenseToAllFamilyExpenses(10, "food", testFamilyExpensesList)
    assert addingNewExpenseToAllFamilyExpenses(200, "others", testFamilyExpensesList, 30)

    try:
        addingNewExpenseToAllFamilyExpenses(None, None, testFamilyExpensesList)
        assert False
    except ValueError:
        assert True

    try:
        addingNewExpenseToAllFamilyExpenses('aa', 'bb', testFamilyExpensesList, 33)
        assert False
    except ValueError:
        assert True

    try:
        addingNewExpenseToAllFamilyExpenses(' ', ' ', testFamilyExpensesList, -30)
        assert False
    except ValueError:
        assert True

    try:
        addingNewExpenseToAllFamilyExpenses(-4, "internet", testFamilyExpensesList, 5)
        assert False
    except ValueError:
        assert True

    try:
        addingNewExpenseToAllFamilyExpenses(4, "housekeeping", testFamilyExpensesList, -5)
        assert False
    except ValueError:
        assert True


def getAllFamilyExpensesHavingSameExpenseType(allFamilyExpenses, expenseType):
    """
    Obtain the list of all family expenses having same expense type
    :param allFamilyExpenses: repository of all family expenses
    :param expenseType: type of expense
    :return: the list of all family expenses having same expense type
    """
    allFamilyExpensesWithSameExpenseType = []
    if expenseType not in ("housekeeping", "food", "transport", "clothing", "internet", "others"):
        raise ValueError(f"Invalid expense type")
    for expense in allFamilyExpenses:
        if expense[2] == expenseType:
            allFamilyExpensesWithSameExpenseType.append(expense)
    return allFamilyExpensesWithSameExpenseType

def getAllFamilyExpensesHavingSameTypeWithCostSmallerOrEqualsOrBiggerThanCertainValue(allFamilyExpenses, expenseType, smallerOrEqualsOrBigger, certainValue):
    """
    Obtain the list of all family expenses having same type smaller/equals/bigger than certain value
    :param allFamilyExpenses: repository of all family expenses
    :param expenseType: type of expense
    :param smallerOrEqualsOrBigger: smaller or equals or bigger sign
    :param certainValue: value to compare
    :return: the list of all family expenses having same type with cost smaller/equals/bigger than certain value
    """
    allFamilyExpensesHavingSameTypeSmallerOrEqualsOrBiggerThanCertainValue = []
    if expenseType not in ("housekeeping", "food", "transport", "clothing", "internet", "others"):
        raise ValueError("Invalid expense type")
    if smallerOrEqualsOrBigger not in ('<', '=', '>'):
        raise ValueError("Invalid property!(only <,=,>)")

    if smallerOrEqualsOrBigger == '<':
        for expense in allFamilyExpenses:
            if expense[2] == expenseType and expense[1] < certainValue:
                allFamilyExpensesHavingSameTypeSmallerOrEqualsOrBiggerThanCertainValue.append(expense)
    elif smallerOrEqualsOrBigger == '=':
        for expense in allFamilyExpenses:
            if expense[2] == expenseType and expense[1] == certainValue:
                allFamilyExpensesHavingSameTypeSmallerOrEqualsOrBiggerThanCertainValue.append(expense)
    elif smallerOrEqualsOrBigger == '>':
        for expense in allFamilyExpenses:
            if expense[2] == expenseType and expense[1] > certainValue:
                allFamilyExpensesHavingSameTypeSmallerOrEqualsOrBiggerThanCertainValue.append(expense)

    return allFamilyExpensesHavingSameTypeSmallerOrEqualsOrBiggerThanCertainValue


def removeAllFamilyExpensesFromACertainDay(allFamilyExpenses, day):
    """
    Delete all family expenses from a certain day
    :param allFamilyExpenses: repository of all family expenses
    :param day: day of month
    :return: new list without all family expenses from certain day
    """
    if day not in range(1, 31):
        raise ValueError(f"Day of the month must be between 1-30, got: {day}")
    index = 0
    while index < len(allFamilyExpenses):
        if allFamilyExpenses[index][0] == day:
            allFamilyExpenses.pop(index)
        else:
            index += 1
    return allFamilyExpenses

def removeAllFamilyExpensesHavingCertainExpenseType(allFamilyExpenses, expenseType):
    """
    Delete all family expenses having certain expense type
    :param allFamilyExpenses: repository of all family expenses
    :param expenseType: type of expense
    :return: new list without all family expenses that have certain expense type
    """
    if expenseType not in ("housekeeping", "food", "transport", "clothing", "internet", "others"):
        raise ValueError(f"Invalid expense type")
    index = 0
    while index < len(allFamilyExpenses):
        if allFamilyExpenses[index][2] == expenseType:
            allFamilyExpenses.pop(index)
        else:
            index += 1
    return allFamilyExpenses


def removeAllFamilyExpensesBetweenTwoGivenDays(allFamilyExpenses, startDay, endDay):
    """
    Delete all family expenses between two days
    :param allFamilyExpenses: repository of all family expenses
    :param startDay: day of month
    :param endDay: day of month
    :return: new list without all family expenses that was made between those two days
    """
    if startDay not in range(1, 31):
        raise ValueError(f"Day of the month must be between 1-30, got: {startDay}")
    if endDay not in range(1, 31):
        raise ValueError(f"Day of the month must be between 1-30, got: {endDay}")
    if startDay > endDay:
        raise ValueError(f"Invalid parameters")
    for day in range(startDay, endDay + 1):
        allFamilyExpenses = removeAllFamilyExpensesFromACertainDay(allFamilyExpenses, day)
    return allFamilyExpenses


def testAllRemoveCommands():
    testFamilyExpensesList = []

    try:
        removeAllFamilyExpensesFromACertainDay(testFamilyExpensesList, -5)
        assert False
    except ValueError:
        assert True

    try:
        removeAllFamilyExpensesBetweenTwoGivenDays(testFamilyExpensesList, 15, 12)
        assert False
    except ValueError:
        assert True

    try:
        removeAllFamilyExpensesHavingCertainExpenseType(testFamilyExpensesList, "book")
        assert False
    except ValueError:
        assert True

    testFamilyExpensesList = addingNewExpenseToAllFamilyExpenses(10, "food", testFamilyExpensesList, 5)

    removeAllFamilyExpensesFromACertainDay(testFamilyExpensesList, 5)
    if len(testFamilyExpensesList) == 0:
        assert True
    else:
        assert False

    testFamilyExpensesList = addingNewExpenseToAllFamilyExpenses(200, "housekeeping", testFamilyExpensesList, 10)
    testFamilyExpensesList = addingNewExpenseToAllFamilyExpenses(200, "food", testFamilyExpensesList, 11)
    testFamilyExpensesList = addingNewExpenseToAllFamilyExpenses(500, "others", testFamilyExpensesList, 12)

    removeAllFamilyExpensesBetweenTwoGivenDays(testFamilyExpensesList, 10, 12)
    if len(testFamilyExpensesList) == 0:
        assert True
    else:
        assert False

    testFamilyExpensesList = addingNewExpenseToAllFamilyExpenses(100, "transport", testFamilyExpensesList)
    testFamilyExpensesList = addingNewExpenseToAllFamilyExpenses(200, "clothing", testFamilyExpensesList)
    testFamilyExpensesList = addingNewExpenseToAllFamilyExpenses(300, "transport", testFamilyExpensesList)

    removeAllFamilyExpensesHavingCertainExpenseType(testFamilyExpensesList, "transport")
    assert testFamilyExpensesList[0][2] == "clothing"

def keepOnlyExpensesHavingCertainType(allFamilyExpenses, expenseType):
    """
    keep only expenses from certain category
    :param allFamilyExpenses: repository of all family expenses
    :param expenseType: type of expense
    :return: new list that contains only expenses having certain type
    """

    if expenseType not in ("housekeeping", "food", "transport", "clothing", "internet", "others"):
        raise ValueError(f"Invalid expense type")

    index = 0
    while index < len(allFamilyExpenses):
        if allFamilyExpenses[index][2] != expenseType:
            allFamilyExpenses.pop(index)
        else:
            index += 1
    return allFamilyExpenses


def keepOnlyExpensesHavingCertainTypeWithCostSmallerOrEqualsOrBiggerThanCertainValue(allFamilyExpenses, expenseType, smallerOrEqualsOrBigger, certainValue):
    """
    keep only expenses from certain category being smaller/equals/bigger than certain value
    :param allFamilyExpenses: repositort of all family expenses
    :param expenseType: type of expense
    :param smallerOrEqualsOrBigger: smaller or equals or bigger sign
    :param certainValue: value to compare
    :return: new list of family expenses having same type with cost smaller/equals/bigger than certain value
    """
    allFamilyExpensesHavingSameTypeWithCostSmallerOrEqualsOrBiggerThanCertainValue = []
    if expenseType not in ("housekeeping", "food", "transport", "clothing", "internet", "others"):
        raise ValueError("Invalid expense type")
    if smallerOrEqualsOrBigger not in ('<', '=', '>'):
        raise ValueError("Invalid property!(only <,=,>)")

    if smallerOrEqualsOrBigger == '<':
        for expense in allFamilyExpenses:
            if expense[2] == expenseType and expense[1] < certainValue:
                allFamilyExpensesHavingSameTypeWithCostSmallerOrEqualsOrBiggerThanCertainValue.append(expense)
    elif smallerOrEqualsOrBigger == '=':
        for expense in allFamilyExpenses:
            if expense[2] == expenseType and expense[1] == certainValue:
                allFamilyExpensesHavingSameTypeWithCostSmallerOrEqualsOrBiggerThanCertainValue.append(expense)
    elif smallerOrEqualsOrBigger == '>':
        for expense in allFamilyExpenses:
            if expense[2] == expenseType and expense[1] > certainValue:
                allFamilyExpensesHavingSameTypeWithCostSmallerOrEqualsOrBiggerThanCertainValue.append(expense)
    return allFamilyExpensesHavingSameTypeWithCostSmallerOrEqualsOrBiggerThanCertainValue

