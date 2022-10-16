import random
import time


# Generate natural numbers

def generateNaturalNumbers(count):
    naturalNumbersList = []
    for index in range(count):
        naturalNumbersList.append(random.randint(1, 99))
    return naturalNumbersList


# 1 Stupid Sort

def permutationSort(numberList, printAtStep):  # BogoSort
    currentStep = 0
    while not isSorted(numberList):
        if currentStep % printAtStep == 0:
            print(f"{currentStep}: {numberList}")
        random.shuffle(numberList)
        currentStep = currentStep + 1
        time.sleep(0.1)

    return numberList


def isSorted(numberList):
    sizeOfNumberList = len(numberList)
    for index in range(sizeOfNumberList - 1):
        if numberList[index] > numberList[index + 1]:
            return False
    return True


# 2 Stupid Sort

def gnomeSort(numberList, printAtStep):
    currentStep = 0
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
        currentStep = currentStep + 1
        if currentStep % printAtStep == 0:
            print(f"{currentStep}: {numberList}")
        time.sleep(0.1)

    return numberList


def verifyIfInputIsNaturalNumber(CustomMessageForUser):
    numberExpectedFromUser = input(f"{CustomMessageForUser}")
    while not numberExpectedFromUser.isdigit() or int(numberExpectedFromUser) <= 0:
        print("Enter a valid value!")
        numberExpectedFromUser = input(">")
    return int(numberExpectedFromUser)


def start():
    naturalNumbersList = []
    while True:
        print("1. Generate a list of n random natural numbers(1-99)")
        print("2. Sort the list using the \"Permutation Sort\" algorithm")
        print("3. Sort the list using the \"Gnome Sort\" algorithm")
        print("0. Exit")

        option = input(">")

        if option == "1":
            count = verifyIfInputIsNaturalNumber("How many numbers to generate? ")
            naturalNumbersList = generateNaturalNumbers(count)
            print(f"Your list is: {naturalNumbersList}")
        elif option == "2":
            printAtStep = verifyIfInputIsNaturalNumber(
                "Please enter the step which is use for display the partially sorted list: (>0) ")
            sortedList = naturalNumbersList.copy()
            sortedList = permutationSort(sortedList, printAtStep)
            print(f"The list is now sorted: {sortedList}")
        elif option == "3":
            printAtStep = verifyIfInputIsNaturalNumber(
                "Please enter the step which is use for display the partially sorted list: (>0) ")
            sortedList = naturalNumbersList.copy()
            sortedList = gnomeSort(sortedList, printAtStep)
            print(f"The list is now sorted: {sortedList}")
        elif option == "0":
            return
        else:
            print("Bad input")


start()
