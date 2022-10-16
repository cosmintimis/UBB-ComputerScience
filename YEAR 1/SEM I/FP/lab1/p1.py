# Solve the problem from the first set here
# 1 Generate the first prime number larger than a given natural number n.

def checkPrime(TheNumberThatWeAreVerifyingIfItsPrimeOrNot):
    if(TheNumberThatWeAreVerifyingIfItsPrimeOrNot < 2):
        return 0
    if(TheNumberThatWeAreVerifyingIfItsPrimeOrNot !=2 and TheNumberThatWeAreVerifyingIfItsPrimeOrNot % 2 == 0):
        return 0
    for i in range(3, int(TheNumberThatWeAreVerifyingIfItsPrimeOrNot ** 0.5) + 1, 2):
        if TheNumberThatWeAreVerifyingIfItsPrimeOrNot % i == 0:
            return 0
    return 1

def firstLargePrimeNumber(afterThatNumber):
    firstLargePrimeNumberFound = 0
    while firstLargePrimeNumberFound == 0:
        if checkPrime(afterThatNumber + 1):
            print("First prime number larger than the number you just entered is: " + str(afterThatNumber + 1))
            firstLargePrimeNumberFound = 1
        else:
            afterThatNumber += 1

number = int(input("Enter a natural number: "))
firstLargePrimeNumber(number)
