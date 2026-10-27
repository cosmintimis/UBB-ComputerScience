from graphError import GraphError
from random import randint, choice


class DirectedGraphDictionaryRepresentation:
    def __init__(self):
        self.__dictionaryIn = {}
        self.__dictionaryOut = {}
        self.__dictionaryCost = {}

    @property
    def getNumberOfVertices(self):
        return len(self.__dictionaryIn)

    @property
    def getNumberOfEdges(self):
        return len(self.__dictionaryCost)

    @property
    def getDictionaryIn(self):
        return self.__dictionaryIn

    @property
    def getDictionaryOut(self):
        return self.__dictionaryOut

    @property
    def getDictionaryCost(self):
        return self.__dictionaryCost

    def checkIfTheGraphHasGivenVertex(self, givenVertex):
        if givenVertex in self.__dictionaryIn and givenVertex in self.__dictionaryOut:
            return True
        return False

    def checkIfTheGraphHasGivenEdge(self, sourceVertex, targetVertex):
        if not self.checkIfTheGraphHasGivenVertex(sourceVertex):
            raise GraphError("Source vertex doesn't exist in current graph!")
        if not self.checkIfTheGraphHasGivenVertex(targetVertex):
            raise GraphError("Target vertex doesn't exist in current graph!")

        if not sourceVertex in self.__dictionaryIn[targetVertex] and not targetVertex in self.__dictionaryOut[
            sourceVertex]:
            return False
        return True

    def addNewVertex(self, vertexToBeAdded):
        if self.checkIfTheGraphHasGivenVertex(vertexToBeAdded):
            raise GraphError("Vertex already exists!")
        self.__dictionaryIn[vertexToBeAdded] = []
        self.__dictionaryOut[vertexToBeAdded] = []
        return True

    def addNewEdge(self, sourceVertex, targetVertex, costOfEdge):
        if not self.checkIfTheGraphHasGivenVertex(sourceVertex):
            raise GraphError("Source vertex doesn't exist in current graph!")
        if not self.checkIfTheGraphHasGivenVertex(targetVertex):
            raise GraphError("Target vertex doesn't exist in current graph!")

        if sourceVertex in self.__dictionaryIn[targetVertex] or targetVertex in self.__dictionaryOut[sourceVertex]:
            raise GraphError("The edge already exists!")
        self.__dictionaryIn[targetVertex].append(sourceVertex)
        self.__dictionaryOut[sourceVertex].append(targetVertex)
        self.__dictionaryCost[(sourceVertex, targetVertex)] = costOfEdge
        return True

    def parseSetOfVertices(self):
        for vertex in self.__dictionaryIn:
            yield vertex

    def parseSetOfOutboundEdgesOfAVertex(self, givenVertex):
        if not self.checkIfTheGraphHasGivenVertex(givenVertex):
            raise GraphError("Given vertex doesn't exist in current graph!")
        for targetVertex in self.__dictionaryOut[givenVertex]:
            yield targetVertex

    def parseSetOfInboundEdgesOfAVertex(self, givenVertex):
        if not self.checkIfTheGraphHasGivenVertex(givenVertex):
            raise GraphError("Given vertex doesn't exist in current graph!")
        for sourceVertex in self.__dictionaryIn[givenVertex]:
            yield sourceVertex

    def getInDegreeOfGivenVertex(self, givenVertex):
        if not self.checkIfTheGraphHasGivenVertex(givenVertex):
            raise GraphError("Given vertex doesn't exist in current graph!")
        inDegree = len(self.__dictionaryIn[givenVertex])
        return inDegree

    def getOutDegreeOfGivenVertex(self, givenVertex):
        if not self.checkIfTheGraphHasGivenVertex(givenVertex):
            raise GraphError("Given vertex doesn't exist in current graph!")
        outDegree = len(self.__dictionaryOut[givenVertex])
        return outDegree

    def getCostOfGivenEdge(self, sourceVertex, targetVertex):
        if not self.checkIfTheGraphHasGivenEdge(sourceVertex, targetVertex):
            raise GraphError("Provided edge doesn't exist in current graph!")
        return self.__dictionaryCost[(sourceVertex, targetVertex)]

    def updateTheCostOfGivenEdge(self, sourceVertex, targetVertex, newCostOfTheEdge):
        if not self.checkIfTheGraphHasGivenEdge(sourceVertex, targetVertex):
            raise GraphError("Provided edge doesn't exist in current graph!")
        self.__dictionaryCost[(sourceVertex, targetVertex)] = newCostOfTheEdge

    def removeAnEdge(self, sourceVertex, targetVertex):
        if not self.checkIfTheGraphHasGivenEdge(sourceVertex, targetVertex):
            raise GraphError("Provided edge doesn't exist in current graph!")
        self.__dictionaryCost.pop((sourceVertex, targetVertex))
        self.__dictionaryIn[targetVertex].remove(sourceVertex)
        self.__dictionaryOut[sourceVertex].remove(targetVertex)

    def removeVertex(self, givenVertex):
        if not self.checkIfTheGraphHasGivenVertex(givenVertex):
            raise GraphError("Given vertex doesn't exist in current graph!")
        for predecessor in list(self.__dictionaryIn[givenVertex]):
            self.removeAnEdge(predecessor, givenVertex)
        for successor in list(self.__dictionaryOut[givenVertex]):
            self.removeAnEdge(givenVertex, successor)
        self.__dictionaryIn.pop(givenVertex)
        self.__dictionaryOut.pop(givenVertex)


def readGraphFromTextFile(textFileName):
    fileToReadFrom = open(textFileName, "rt")
    allLinesFromTextFile = fileToReadFrom.readlines()
    fileToReadFrom.close()
    newGraph = DirectedGraphDictionaryRepresentation()
    numberOfVertices = -1
    for index in range(len(allLinesFromTextFile)):
        line = allLinesFromTextFile[index].strip()
        line = line.split(' ')
        if len(line) == 3:
            sourceVertex = int(line[0])
            targetVertex = int(line[1])
            costOfEdge = int(line[2])
            if not newGraph.checkIfTheGraphHasGivenVertex(sourceVertex):
                newGraph.addNewVertex(sourceVertex)
            if not newGraph.checkIfTheGraphHasGivenVertex(targetVertex):
                newGraph.addNewVertex(targetVertex)
            newGraph.addNewEdge(sourceVertex, targetVertex, costOfEdge)
        elif len(line) == 1:
            isolatedVertex = int(line[0])
            if not newGraph.checkIfTheGraphHasGivenVertex(isolatedVertex):
                newGraph.addNewVertex(isolatedVertex)
        elif len(line) == 2:
            numberOfVertices = int(line[0])
            numberOfEdges = int(line[1])

    if numberOfVertices != -1:
        vertex = 0
        while newGraph.getNumberOfVertices < numberOfVertices:
            if not newGraph.checkIfTheGraphHasGivenVertex(vertex):
                newGraph.addNewVertex(vertex)
            vertex += 1

    return newGraph

def writeGraphToTextFile(textFileName, graph):
    fileToWriteIn = open(textFileName, "w")
    firstLine = str(graph.getNumberOfVertices) + ' ' + str(graph.getNumberOfEdges) + '\n'
    fileToWriteIn.write(firstLine)
    for key in graph.getDictionaryCost.keys():
        nextLine = str(key[0]) + ' ' + str(key[1]) + ' ' + str(graph.getDictionaryCost[key]) + '\n'
        fileToWriteIn.write(nextLine)
    for vertex in graph.getDictionaryIn.keys():
        if graph.getInDegreeOfGivenVertex(vertex) == 0 and graph.getOutDegreeOfGivenVertex(vertex) == 0:
            nextLine = str(vertex) + '\n'
            fileToWriteIn.write(nextLine)
    fileToWriteIn.close()


def createRandomGraph(numberOfVertices, numberOfEdges):
    randomGraph = DirectedGraphDictionaryRepresentation()

    for vertex in range(numberOfVertices):
        randomGraph.getDictionaryIn[vertex] = []
        randomGraph.getDictionaryOut[vertex] = []

    allPossibilitiesForSourceVertex = list(range(numberOfVertices))
    while numberOfEdges > 0:
        sourceVertex = choice(allPossibilitiesForSourceVertex)
        allPossibilitiesForSourceVertex.remove(sourceVertex)
        allPossibilitiesForTargetVertex = list(range(numberOfVertices))
        while len(allPossibilitiesForTargetVertex) > 0 and numberOfEdges > 0:
            targetVertex = choice(allPossibilitiesForTargetVertex)
            allPossibilitiesForTargetVertex.remove(targetVertex)
            costOfEdge = randint(0, 999)
            randomGraph.addNewEdge(sourceVertex, targetVertex, costOfEdge)
            numberOfEdges -= 1
    return randomGraph
