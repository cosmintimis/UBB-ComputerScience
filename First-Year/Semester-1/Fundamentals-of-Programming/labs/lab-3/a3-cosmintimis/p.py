import timeit
import random
from texttable import *
#import itertools as itr


def generateNaturalNumbersList(count):
    naturalNumbersList = []
    for index in range(count):
        naturalNumbersList.append(random.randint(1, 9999))
    return naturalNumbersList


def permutationSort(numberList):  # BogoSort
    lengthOfList = len(numberList)
    while not isSorted(numberList):
        for index in range(0, lengthOfList - 1):
            randomIndex = random.randint(0, lengthOfList - 1)
            numberList[index], numberList[randomIndex] = numberList[randomIndex], numberList[index]
    return numberList


def isSorted(numberList):
    sizeOfNumberList = len(numberList)
    for index in range(sizeOfNumberList - 1):
        if numberList[index] > numberList[index + 1]:
            return False
    return True


def gnomeSort(numberList):
    index = 0
    sizeOfNumberList = len(numberList)
    while index < sizeOfNumberList:
        if index == 0:
            index = index + 1
        elif numberList[index] >= numberList[index - 1]:
            index = index + 1
        else:
            numberList[index], numberList[index - 1] = numberList[index - 1], numberList[index]
            index = index - 1
    return numberList


def verifyIfInputIsNaturalNumber(customMessageForUser):
    numberExpectedFromUser = input(f"{customMessageForUser}")
    while not numberExpectedFromUser.isdigit() or int(numberExpectedFromUser) <= 0:
        print("Enter a valid value!")
        numberExpectedFromUser = input(">")
    return int(numberExpectedFromUser)


def generateXRandomList(x, size):
    listOfLists = []
    for index in range(0, x):
        listOfLists.append(generateNaturalNumbersList(size))
        size *= 2
    return listOfLists


def generateData(numberOfLists, size, case):
    inputLists = generateXRandomList(numberOfLists, size)
    match case:
        case "BestCase":
            for index in range(0, numberOfLists):
                gnomeSort(inputLists[index])
        case "WorstCase":
            for index in range(0, numberOfLists):
                gnomeSort(inputLists[index])
                inputLists[index].reverse()
    return inputLists


def runTimeOfSortAlgorithm(sortAlgorithm, data):
    runTime = []
    numberOfLists = len(data)
    for index in range(0, numberOfLists):
        start = timeit.default_timer()
        sortAlgorithm(data[index])
        end = timeit.default_timer()
        runTime.append(end - start)
    return runTime


def displayRunTimeOfSortAlgorithm(function, data):
    size = len(data[0])
    sizeOfLists = [size]
    for index in range(1, len(data)):
        size = len(data[index])
        sizeOfLists.append(size)
    table = Texttable()
    table.set_precision(20)
    table.set_max_width(500)
    table.add_row(['Function/size'] + sizeOfLists)
    runTime = runTimeOfSortAlgorithm(function, data)
    table.add_row([function.__name__] + runTime)
    print(table.draw())


def customDataForPermutationSort(case):
    data = generateData(3, 2, case)
    newList = generateNaturalNumbersList(10)
    match case:
        case "BestCase":
            newList.sort()
        case "WorstCase":
            newList.sort()
            newList.reverse()
    data.append(newList)
    return data


def consoleApp():
    naturalNumbersList = []
    sortFunctions = [permutationSort, gnomeSort]
    while True:
        print("1. Generate a list of n random natural numbers")
        print("2. Sort the list using the \"Permutation Sort\" algorithm")
        print("3. Sort the list using the \"Gnome Sort\" algorithm")
        print("4. Runtime of the implemented algorithms in Best Case")
        print("5. Runtime of the implemented algorithms in Average Case")
        print("6. Runtime of the implemented algorithms in Worst Case")
        print("0. Exit")

        option = input(">")

        if option == "1":
            count = verifyIfInputIsNaturalNumber("How many numbers to generate? ")
            naturalNumbersList = generateNaturalNumbersList(count)
            print(f"Your list is: {naturalNumbersList}")
        elif option == "2":
            sortedList = naturalNumbersList.copy()
            sortedList = permutationSort(sortedList)
            print(f"The list is now sorted: {sortedList}")
        elif option == "3":
            sortedList = naturalNumbersList.copy()
            sortedList = gnomeSort(sortedList)
            print(f"The list is now sorted: {sortedList}")
        elif option == "4":
            print("BestCase:")
            data = generateData(5, 200, 'BestCase')
            displayRunTimeOfSortAlgorithm(sortFunctions[1], data)
            data = customDataForPermutationSort('BestCase')
            displayRunTimeOfSortAlgorithm(sortFunctions[0], data)
            displayRunTimeOfSortAlgorithm(sortFunctions[1], data)
        elif option == "5":
            print("AverageCase:")
            data = generateData(5, 200, 'AverageCase')
            displayRunTimeOfSortAlgorithm(sortFunctions[1], data)
            data = customDataForPermutationSort('AverageCase')
            displayRunTimeOfSortAlgorithm(sortFunctions[0], data)
            displayRunTimeOfSortAlgorithm(sortFunctions[1], data)
        elif option == "6":
            print("WorstCase:")
            data = generateData(5, 200, 'WorstCase')
            displayRunTimeOfSortAlgorithm(sortFunctions[1], data)
            data = customDataForPermutationSort('WorstCase')
            displayRunTimeOfSortAlgorithm(sortFunctions[0], data)
            displayRunTimeOfSortAlgorithm(sortFunctions[1], data)
        elif option == "0":
            return
        else:
            print("Bad input")


consoleApp()
