"""
Given the set of positive integers S and the natural number k, display one of the subsets of S which sum to k.
 For example, if S = { 2, 3, 5, 7, 8 } and k = 14, subset { 2, 5, 7 } sums to 14
"""

def createPowerSet(givenSet):
    powerSetOfGivenSet = [[]]
    for elementOfGivenSet in givenSet:
        partiallyPowerSet = []
        for subSet in powerSetOfGivenSet:
            copyOfSubSet = subSet.copy()
            copyOfSubSet.append(elementOfGivenSet)
            partiallyPowerSet.append(copyOfSubSet)
        powerSetOfGivenSet.extend(partiallyPowerSet)
    return powerSetOfGivenSet


def searchForSubSetOfGivenSetWhoseElementsSumToCertainValueNonOptimizedVersion(givenSet, certainValue):
    powerSetOfGivenSet = createPowerSet(givenSet)
    subSetWeAreLookingFor = []

    for subSet in powerSetOfGivenSet:
        sumOfSubSetElements = 0
        for subSetElement in subSet:
            sumOfSubSetElements += subSetElement
        if sumOfSubSetElements == certainValue:
            subSetWeAreLookingFor = subSet.copy()

    if len(subSetWeAreLookingFor) > 0:
        print(f"One subset with given property is: {subSetWeAreLookingFor}")
    else:
        print("There's no such subset")

def searchForSubSetOfGivenSetWhoseElementsSumToCertainValueOptimizedVersion(givenSet, certainValue):
    lengthOfGivenSet = len(givenSet)

    """
    Create a 2D array where every a[i][j] will be 1(True) if with the first i elements of given
        set we can obtain sum j otherwise 0(False)
    """

    allSumsThatWeCanObtainWithGivenSetElements = [[0 for _ in range(certainValue + 1)] for _ in range(lengthOfGivenSet + 1)]

    # fill the first row except the first element with 0(False) because without any values we can't get any sum>0

    for i in range(1, certainValue + 1):
        allSumsThatWeCanObtainWithGivenSetElements[0][i] = 0

    # fill first column with 1(True) because sum 0 can be obtained always

    for i in range(lengthOfGivenSet + 1):
        allSumsThatWeCanObtainWithGivenSetElements[i][0] = 1;

    # fill rest of the allSumsThatWeCanObtainWithGivenSetElements

    for i in range(1, lengthOfGivenSet + 1):
        for j in range(1, certainValue + 1):
            if givenSet[i - 1] > j:
                allSumsThatWeCanObtainWithGivenSetElements[i][j] = allSumsThatWeCanObtainWithGivenSetElements[i-1][j]
            else:
                allSumsThatWeCanObtainWithGivenSetElements[i][j] = allSumsThatWeCanObtainWithGivenSetElements[i-1][j] or\
                                                                   allSumsThatWeCanObtainWithGivenSetElements[i - 1][j - givenSet[i-1]]

    if allSumsThatWeCanObtainWithGivenSetElements[lengthOfGivenSet][certainValue] == 0:
        print("There's no such subset")
    else:
        subSetWeAreLookingFor = []
        i = lengthOfGivenSet
        targetSum = certainValue
        while i > 0 and targetSum > 0:
            if allSumsThatWeCanObtainWithGivenSetElements[i - 1][targetSum]:
                i -= 1
            elif allSumsThatWeCanObtainWithGivenSetElements[i-1][targetSum - givenSet[i - 1]]:
                if givenSet[i - 1] > 0:
                    subSetWeAreLookingFor.append(givenSet[i-1])
                targetSum -= givenSet[i - 1]
                i -= 1
        print(f"One subset with given property is: {subSetWeAreLookingFor}")
        print()
        for s in allSumsThatWeCanObtainWithGivenSetElements:
            print(*s)

def start():
    givenSet = [2, 3, 5, 7, 8]
    givenTarget = 14
    searchForSubSetOfGivenSetWhoseElementsSumToCertainValueNonOptimizedVersion(givenSet, givenTarget)
    print()
    searchForSubSetOfGivenSetWhoseElementsSumToCertainValueOptimizedVersion(givenSet, givenTarget)


start()