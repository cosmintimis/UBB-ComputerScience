"""
Generate all subsequences of length 2n+1, formed only by 0, -1 or 1,
 such that a1 = 0, ..., a2n+1= 0 and |ai+1 - ai| = 1 or 2, for any 1 ≤ i ≤ 2n.
"""
import timeit


def checkIfTheConstraintsAreRespectedAtCurrentPosition(candidateSolution, lengthOfSubsequence, currentPosition):
    if currentPosition == 0:
        if candidateSolution[0] != 0:
            return False
    else:
        if abs(candidateSolution[currentPosition] - candidateSolution[currentPosition - 1]) not in (1, 2):
            return False
    if currentPosition == lengthOfSubsequence - 1:
        if candidateSolution[currentPosition] != 0:
            return False

    return True


def generateAllSubSequencesWithGivenPropertyRecursive(candidateSolution, lengthOfSubsequence, startingPosition):
    """
        Property: subsequences formed only by 0, -1 or 1,
            such that a1 = 0, ..., a2n+1= 0 and |ai+1 - ai| = 1 or 2, for any 1 ≤ i ≤ 2n.
    """
    for tryValue in range(-1, 2):
        candidateSolution[startingPosition] = tryValue
        if checkIfTheConstraintsAreRespectedAtCurrentPosition(candidateSolution, lengthOfSubsequence, startingPosition):
            if startingPosition == lengthOfSubsequence - 1:
                print("Solution: ", *candidateSolution)
            else:
                generateAllSubSequencesWithGivenPropertyRecursive(candidateSolution, lengthOfSubsequence, startingPosition + 1)

def generateAllSubSequencesWithGivenPropertySimulatingRecursion(candidateSolution, lengthOfSubsequence, startingPosition):
    """
        Property: subsequences formed only by 0, -1 or 1,
            such that a1 = 0, ..., a2n+1= 0 and |ai+1 - ai| = 1 or 2, for any 1 ≤ i ≤ 2n.
    """
    stack = [(candidateSolution, startingPosition)]
    while len(stack) > 0:
        partiallySolution, currentPosition = stack.pop()
        copyOfPartiallySolution = partiallySolution.copy()
        for tryValue in range(1, -2, -1):
            copyOfPartiallySolution[currentPosition] = tryValue
            if checkIfTheConstraintsAreRespectedAtCurrentPosition(copyOfPartiallySolution, lengthOfSubsequence, currentPosition):
                if currentPosition == lengthOfSubsequence - 1:
                    print("Solution: ", *partiallySolution)
                else:
                    partiallySolution = copyOfPartiallySolution.copy()
                    stack.append((partiallySolution, currentPosition + 1))
def start():
    while True:
        print("Property: Subsequences formed only by 0, -1 or 1, such that a1 = 0, ..., a2n+1= 0 and "
              "|ai+1 - ai| = 1 or 2, for any 1 ≤ i ≤ 2n.")
        print("1.Generate all subsequences of length (2n+1) with given property using backtracking first implementation")
        print("2.Generate all subsequences of length (2n+1) with given property using backtracking second implementation")
        print("0.Exit")

        option = input(">")

        if option == "1":
            lengthOfSubsequence = int(input("Enter the length of the subsequence(n): "))
            lengthOfSubsequence = 2 * lengthOfSubsequence + 1
            candidateSolution = [0] * lengthOfSubsequence
            startTimer = timeit.default_timer()
            generateAllSubSequencesWithGivenPropertyRecursive(candidateSolution, lengthOfSubsequence, 0)
            stopTimer = timeit.default_timer()
            print("The runtime is: " + str(stopTimer - startTimer))
        elif option == "2":
            lengthOfSubsequence = int(input("Enter the length of the subsequence(n): "))
            lengthOfSubsequence = 2 * lengthOfSubsequence + 1
            candidateSolution = [0] * lengthOfSubsequence
            startTimer = timeit.default_timer()
            generateAllSubSequencesWithGivenPropertySimulatingRecursion(candidateSolution, lengthOfSubsequence, 0)
            stopTimer = timeit.default_timer()
            print("The runtime is: " + str(stopTimer - startTimer))
        elif option == "0":
            return
        else:
            print("Bad input")


start()

