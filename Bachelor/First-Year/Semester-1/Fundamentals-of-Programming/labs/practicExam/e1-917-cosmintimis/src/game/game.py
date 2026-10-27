from random import choice, shuffle

from src.game.gameException import GameException


class Game:
    def __init__(self, textFileName):
        self.__textFileName = textFileName
        self.randomWordOrSentence = self.getOneRandomWordOrSentenceFromInputFile()
        self.shuffleSentence = self.randomlyShuffleWordOrSentenceGiven(self.randomWordOrSentence)
        self.oldShuffleSentenceForUndo = ""

    def getOneRandomWordOrSentenceFromInputFile(self):
        allWordsOrSentencesFromInputFile = self.loadFromTextFile()
        oneRandomWordOrSentence = choice(allWordsOrSentencesFromInputFile)
        return oneRandomWordOrSentence

    def countingLettersOfAGivenSentence(self, givenSentence):
        count = 0
        for index in givenSentence:
            if index.isalpha():
                count += 1
        return count

    def loadFromTextFile(self):
        allLinesFromFile = []
        allLinesWithoutNewLine = []
        try:
            openFile = open(self.__textFileName, "rt")
            allLinesFromFile = openFile.readlines()
            openFile.close()
        except IOError:
            pass
        for line in allLinesFromFile:
            line = line.strip("\n")
            allLinesWithoutNewLine.append(line)
        return allLinesWithoutNewLine

    def undoTheLastSwapPerformedByUser(self):
        self.shuffleSentence = self.oldShuffleSentenceForUndo

    def randomlyShuffleWordOrSentenceGiven(self, givenString):
        """
        This function randomly shuffle letters of a given string
        :param givenString: sentence/word
        :return: shuffle sentence/word
        """
        listOfLetters = []
        lettersOfAWord = []
        givenString = givenString.split(" ")

        for word in givenString:
            index = 1
            while index < len(word) - 1:
                lettersOfAWord.append(word[index:(index + 1)])
                index += 1
            listOfLetters.extend(lettersOfAWord.copy())
            lettersOfAWord.clear()
        shuffle(listOfLetters)
        index = 0
        newWord = ""
        newSentence = ""
        for word in givenString:
            newWord += word[0]
            for index2 in range(1, len(word) - 1):
                newWord += listOfLetters[index]
                index += 1
            newWord += word[len(word) - 1]
            newSentence += newWord + " "
            newWord = ""
        return newSentence

    def checkIfPlayerWon(self):
        """
        Only check if the human player won the game, he matches all letters
        :return: true/false
        """
        index = 0
        for char in self.randomWordOrSentence:
            if self.shuffleSentence[index] != char:
                return False
            index += 1
        return True


    def swapLettersOfTwoWord(self, firstWordPosition, letterOfFirstWordPosition, secondWordPosition,
                             letterOfSecondWordPosition):
        """
        This function swap the letter from a certain position in first word with a letter from a certain position in second word
        :param firstWordPosition: position in sentence of first word
        :param letterOfFirstWordPosition: position in first word of letter to be swapped
        :param secondWordPosition:  position in sentence of second word
        :param letterOfSecondWordPosition:  position in second word of letter to be swapped
        :return: new sentence with swapping given letters in given words
        """
        listOfAllWords = self.shuffleSentence.split(" ")
        numberOfWords = len(listOfAllWords)
        if firstWordPosition < 0 or firstWordPosition > numberOfWords - 1:
            raise GameException("Invalid command: Indices supplied are incorrect")

        if secondWordPosition < 0 or secondWordPosition > numberOfWords - 1:
            raise GameException("Invalid command: Indices supplied are incorrect")

        if letterOfFirstWordPosition < 1 or letterOfFirstWordPosition > len(listOfAllWords[firstWordPosition]) - 2:
            raise GameException("Invalid command: Indices supplied are incorrect")

        if letterOfSecondWordPosition < 1 or letterOfSecondWordPosition > len(listOfAllWords[secondWordPosition]) - 2:
            raise GameException("Invalid command: Indices supplied are incorrect")

        firstWord = listOfAllWords[firstWordPosition]
        secondWord = listOfAllWords[secondWordPosition]
        firstLetter = firstWord[letterOfFirstWordPosition:(letterOfFirstWordPosition + 1)]
        secondLetter = secondWord[letterOfSecondWordPosition:(letterOfSecondWordPosition + 1)]
        index = 0
        newFirstWord = ""
        for char in firstWord:
            if index == letterOfFirstWordPosition:
                newFirstWord += secondLetter
            else:
                newFirstWord += char
            index += 1
        index = 0
        newSecondWord = ""
        if firstWord == secondWord:
            secondWord = newFirstWord
        for char in secondWord:
            if index == letterOfSecondWordPosition:
                newSecondWord += firstLetter
            else:
                newSecondWord += char
            index += 1
        secondWord = listOfAllWords[secondWordPosition]
        newSentence = ""
        for word in listOfAllWords:
            if word == secondWord:
                newSentence += newSecondWord + " "
            elif word == firstWord:
                newSentence += newFirstWord + " "
            else:
                newSentence += word + " "
        self.oldShuffleSentenceForUndo = self.shuffleSentence
        self.shuffleSentence = newSentence
        return newSentence
