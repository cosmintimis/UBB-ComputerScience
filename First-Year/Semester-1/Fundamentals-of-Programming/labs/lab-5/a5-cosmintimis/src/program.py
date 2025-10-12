#
# Write the implementation for A5 in this file
#

"""
Implement a menu-driven console application that provides the following functionalities:

1. Read a list of complex numbers from the console.
2. Display the entire list of numbers on the console.
3. Length and elements of the longest subarray of numbers having the same modulus.
4. The length and elements of the longest increasing subsequence, when considering each number's real part.
0. Exit the application.
"""
import random


#
# Write below this comment 
# Functions to deal with complex numbers -- list representation
# -> There should be no print or input statements in this section 
# -> Each function should do one thing only
# -> Functions communicate using input parameters and their return values
#

def createComplexNumber(realPart: int, ImaginaryPart: int):
    return [realPart, ImaginaryPart]

def getRealPartOfComplexNumber(complexNumber: list):
    return complexNumber[0]


def getImaginaryPartOfComplexNumber(complexNumber: list):
    return complexNumber[1]


def getModulusOfComplexNumber(complexNumber: list):
    return (getRealPartOfComplexNumber(complexNumber) ** 2 + getImaginaryPartOfComplexNumber(complexNumber) ** 2) ** (1 / 2)


#
# Write below this comment 
# Functions to deal with complex numbers -- dict representation
# -> There should be no print or input statements in this section 
# -> Each function should do one thing only
# -> Functions communicate using input parameters and their return values
#

"""def createComplexNumber(realPart: int, ImaginaryPart: int):
    return {"realPart": realPart, "imaginaryPart": ImaginaryPart}

def getRealPartOfComplexNumber(complexNumber: dict):
    return complexNumber["realPart"]


def getImaginaryPartOfComplexNumber(complexNumber: dict):
    return complexNumber["imaginaryPart"]


def getModulusOfComplexNumber(complexNumber: dict):
    return (getRealPartOfComplexNumber(complexNumber) ** 2 + getImaginaryPartOfComplexNumber(complexNumber) ** 2) ** (1 / 2)"""


#
# Write below this comment 
# Functions that deal with subarray/subsequence properties
# -> There should be no print or input statements in this section 
# -> Each function should do one thing only
# -> Functions communicate using input parameters and their return values
#

def generateComplexNumbers(howManyNumbersToGenerate: int, complexNumbersList: list):
    while howManyNumbersToGenerate > 0:
        realPart = random.randint(-4, 5)
        imaginaryPart = random.randint(-4, 5)
        complexNumbersList.append(createComplexNumber(realPart, imaginaryPart))
        howManyNumbersToGenerate -= 1

def convertComplexNumberToString(complexNumber):
    realPart = getRealPartOfComplexNumber(complexNumber)
    imaginaryPart = getImaginaryPartOfComplexNumber(complexNumber)

    if imaginaryPart == 1:
        if realPart == 0:
            return "i"
        else:
            return str(realPart) + "+" + "i"
    if imaginaryPart == -1:
        if realPart == 0:
            return "-i"
        else:
            return str(realPart) + "-i"
    if imaginaryPart == 0:
        return str(realPart)
    if realPart == 0:
        return str(imaginaryPart) + "i"
    if imaginaryPart > 0:
        return str(realPart) + "+" + str(imaginaryPart) + "i"
    if imaginaryPart < 0:
        return str(realPart) + str(imaginaryPart) + "i"


def lookingForLongestSubarrayOfComplexNumbersHavingSameModulus(complexNumbersList: list):
    complexNumbersModulusList = []
    subarrayWeAreLookingFor = []
    for complexNumber in complexNumbersList:
        complexNumbersModulusList.append(getModulusOfComplexNumber(complexNumber))
    startingPositionOfSubarray = 0
    lengthOfCurrentSubarray = lengthOfLongestSubarray = 1
    for currentPosition in range(len(complexNumbersModulusList) - 1):
        if complexNumbersModulusList[currentPosition] == complexNumbersModulusList[currentPosition + 1]:
            if lengthOfCurrentSubarray == 1:
                startingPositionOfSubarray = currentPosition
            lengthOfCurrentSubarray += 1
        else:
            if lengthOfLongestSubarray < lengthOfCurrentSubarray:
                lengthOfLongestSubarray = lengthOfCurrentSubarray
            lengthOfCurrentSubarray = 1
    if lengthOfLongestSubarray < lengthOfCurrentSubarray:
        lengthOfLongestSubarray = lengthOfCurrentSubarray
    endingPositionOfSubarray = startingPositionOfSubarray + lengthOfLongestSubarray
    for index in range(startingPositionOfSubarray, endingPositionOfSubarray):
        subarrayWeAreLookingFor.append(complexNumbersList[index])
    return subarrayWeAreLookingFor

def lookingForLongestIncreasingSubsequenceConsideringOnlyRealPartsOfComplexNumbers(complexNumbersList: list):
    subarrayWeAreLookingFor = []
    realPartsOfComplexNumbers = []
    lengthOfComplexNumbersList = len(complexNumbersList)
    for index in range(lengthOfComplexNumbersList):
        realPartsOfComplexNumbers.append(getRealPartOfComplexNumber(complexNumbersList[index]))
    # array[i] represent length of the longest increasing subsequence that ends in the element at index i
    lengthOfLongestSubsequenceConsideringOnlyNumbersUpToCurrentIndex = [1] * lengthOfComplexNumbersList
    arrayThatContainThePathForLongestIncreasingSubsequence = [-1] * lengthOfComplexNumbersList
    for i in range(lengthOfComplexNumbersList):
        for j in range(i):
            if realPartsOfComplexNumbers[j] < realPartsOfComplexNumbers[i] and lengthOfLongestSubsequenceConsideringOnlyNumbersUpToCurrentIndex[i] < \
                    lengthOfLongestSubsequenceConsideringOnlyNumbersUpToCurrentIndex[j] + 1:
                lengthOfLongestSubsequenceConsideringOnlyNumbersUpToCurrentIndex[i] = lengthOfLongestSubsequenceConsideringOnlyNumbersUpToCurrentIndex[j] + 1
                arrayThatContainThePathForLongestIncreasingSubsequence[i] = j

    lengthOfLongestIncreasingSubsequence = lengthOfLongestSubsequenceConsideringOnlyNumbersUpToCurrentIndex[0]
    indexOfLastElementOfLongestIncreasingSubsequence = 0

    for index in range(1, lengthOfComplexNumbersList):
        if lengthOfLongestSubsequenceConsideringOnlyNumbersUpToCurrentIndex[index] > lengthOfLongestIncreasingSubsequence:
            lengthOfLongestIncreasingSubsequence = lengthOfLongestSubsequenceConsideringOnlyNumbersUpToCurrentIndex[index]
            indexOfLastElementOfLongestIncreasingSubsequence = index

    while indexOfLastElementOfLongestIncreasingSubsequence != -1:
        subarrayWeAreLookingFor.append(realPartsOfComplexNumbers[indexOfLastElementOfLongestIncreasingSubsequence])
        indexOfLastElementOfLongestIncreasingSubsequence = arrayThatContainThePathForLongestIncreasingSubsequence[indexOfLastElementOfLongestIncreasingSubsequence]
    subarrayWeAreLookingFor.reverse()

    return subarrayWeAreLookingFor

#
# Write below this comment 
# UI section
# Write all functions that have input or print statements here
# Ideally, this section should not contain any calculations relevant to program functionalities
#


def printAllComplexNumbers(complexNumbersList: list):
    for complexNumber in complexNumbersList:
        print(convertComplexNumberToString(complexNumber))

def readComplexNumberFromConsole():
    while True:
        realPart = input("Enter the real part(int): ")
        if not realPart:
            print("Bad input!")
            continue
        elif realPart[0] in ('+', '-') and not realPart[1:].isdigit():
            print("Bad input!")
            continue
        elif realPart[0] in ('+', '-') and realPart[1:].isdigit():
            break
        elif not realPart.isdigit():
            print("Bad input!")
            continue
        break
    while True:
        imaginaryPart = input("Enter the imaginary part(int): ")
        if not imaginaryPart:
            print("Bad input!")
            continue
        elif imaginaryPart[0] in ('+', '-') and not imaginaryPart[1:].isdigit():
            print("Bad input!")
            continue
        elif imaginaryPart[0] in ('+', '-') and imaginaryPart[1:].isdigit():
            break
        elif not imaginaryPart.isdigit():
            print("Bad input!")
            continue
        break
    return int(realPart), int(imaginaryPart)

def start():
    complexNumbersList = []
    generateComplexNumbers(10, complexNumbersList)
    while True:
        print("1. Read a list of complex numbers from the console.")
        print("2. Display the entire list of numbers on the console.")
        print("3. Length and elements of a longest subarray of numbers having the same modulus.")
        print("4. The length and elements of a longest increasing subsequence, when considering each number's real part")
        print("0. Exit")

        option = input(">")

        if option == '1':
            while True:
                print("Enter a complex number: ")
                realPart, imaginaryPart = readComplexNumberFromConsole()
                complexNumbersList.append(createComplexNumber(realPart, imaginaryPart))
                print("The number was added successfully!")
                print("Press 1 to adding another number or anything else to stop")
                option = input(">")
                if option == '1':
                    continue
                else:
                    break
        elif option == '2':
            printAllComplexNumbers(complexNumbersList)
        elif option == '3':
            subarrayFound = lookingForLongestSubarrayOfComplexNumbersHavingSameModulus(complexNumbersList)
            print(f"The length of the longest subarray having same modulus is: {len(subarrayFound)}")
            print(*subarrayFound)
        elif option == '4':
            subarrayFound = lookingForLongestIncreasingSubsequenceConsideringOnlyRealPartsOfComplexNumbers(complexNumbersList)
            print(f"The length of the longest increasing subsequence, when considering each number's real part is: {len(subarrayFound)}")
            print(*subarrayFound)
        elif option == '0':
            return
        else:
            print("Bad input!")


if __name__ == "__main__":
    start()
