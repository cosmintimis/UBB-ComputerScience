from src.game.gameException import GameException


class UserInterface:
    def __init__(self, game):
        self.game = game
        self.__userScore = self.game.countingLettersOfAGivenSentence(self.game.shuffleSentence)
        self.__numberOfUserSwaps = 0

    def run(self):
        sentenceToPrint = ""
        sentenceToPrint += self.game.shuffleSentence
        score = f" [score is: {self.__userScore}]"
        sentenceToPrint += score
        print(sentenceToPrint)

        while self.__userScore > 0:
            if self.game.checkIfPlayerWon():
                print(f"Victory! --- Your score is: {self.__userScore}" )
                break
            userInput = input(">>>")
            userInput = userInput.split(" ")
            # print(userInput)
            # print(len(userInput))
            if len(userInput) == 1 and userInput[0] == "undo":
                if self.__numberOfUserSwaps > 0:
                    self.game.undoTheLastSwapPerformedByUser()
                else:
                    print("Cannot undo! --- Make first a swap")
                    continue
            elif len(userInput) != 6:
                print("Invalid command")
                continue
            elif userInput[0] == "swap" and userInput[3] == "-":
                try:
                    firstWordIndex = int(userInput[1])
                    firstLetterIndex = int(userInput[2])
                    secondWordIndex = int(userInput[4])
                    secondLetterIndex = int(userInput[5])
                    self.game.swapLettersOfTwoWord(firstWordIndex, firstLetterIndex, secondWordIndex, secondLetterIndex)
                    self.__userScore -= 1
                    self.__numberOfUserSwaps += 1
                except ValueError as errorMessage:
                    print("try again --- " + str(errorMessage))
                    continue
                except GameException as errorMessage:
                    print("try again --- " + str(errorMessage))
                    continue
            else:
                print("Invalid command")
                continue
            sentenceToPrint = ""
            sentenceToPrint += self.game.shuffleSentence
            score = f" [score is: {self.__userScore}]"
            sentenceToPrint += score
            print(sentenceToPrint)
        if self.__userScore == 0:
            print("Defeat!")



