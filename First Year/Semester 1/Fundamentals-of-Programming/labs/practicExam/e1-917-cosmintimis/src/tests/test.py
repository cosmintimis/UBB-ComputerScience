import unittest

from src.game.game import Game


class Tests(unittest.TestCase):

    def testCheckIfHumanPlayerWon(self):
        newGame = Game("testInput.txt")
        newGame.shuffleSentence = newGame.randomWordOrSentence
        if newGame.checkIfPlayerWon():
            assert True

    def testCountingLetters(self):
        newGame = Game("testInput.txt")
        assert newGame.countingLettersOfAGivenSentence("scramble") == 8

    def testShuffleAGivenSentenceOrWord(self):
        newGame = Game("testInput.txt")
        sentence = "Work hard dream big"
        newSentence = newGame.randomlyShuffleWordOrSentenceGiven(sentence)
        if sentence is not newSentence:
            assert True


    def testSwapCommand(self):
        newGame = Game("testInput.txt")
        newSentence = newGame.swapLettersOfTwoWord(0, 1, 0, 2)
        if newGame.randomWordOrSentence is not newSentence:
            assert True


    def testUndoCommand(self):
        newGame = Game("testInput.txt")
        newGame.swapLettersOfTwoWord(0, 1, 0, 2)
        newGame.undoTheLastSwapPerformedByUser()
        if newGame.randomWordOrSentence is newGame.shuffleSentence:
            assert True

