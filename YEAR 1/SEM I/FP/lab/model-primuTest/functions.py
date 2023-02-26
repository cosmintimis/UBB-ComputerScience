def createNewFlight(code, duration, departureCity, destinationCity):
    if not duration.isdigit():
        raise ValueError("Duration must be integer!")
    if len(code) <= 1 or len(departureCity) <= 1 or len(destinationCity) <= 1:
        raise ValueError("The fields code, departure city, destination city must have at least 3 char length!")
    if int(duration) < 20:
        raise ValueError("The duration is less than 20m!")
    return [code, int(duration), departureCity, destinationCity]


def sortFlightsWithSameDepartureCityIncreasingByTheirDuration(flightsRepository, departureCity):
    listOfFlightsWithSameDepartureCity = []
    for flight in flightsRepository:
        if flight[2] == departureCity:
            listOfFlightsWithSameDepartureCity.append(flight)

    for i in range(0, len(listOfFlightsWithSameDepartureCity) - 1):
        for j in range(i, len(listOfFlightsWithSameDepartureCity)):
            if listOfFlightsWithSameDepartureCity[i][1] > listOfFlightsWithSameDepartureCity[j][1]:
                listOfFlightsWithSameDepartureCity[i], listOfFlightsWithSameDepartureCity[j] = \
                    listOfFlightsWithSameDepartureCity[j], listOfFlightsWithSameDepartureCity[i]

    return listOfFlightsWithSameDepartureCity


def updateDurationOfAnExistingFlight(flightsRepository, codeOfFlight, newDuration):
    if not newDuration.isdigit():
        raise ValueError("Duration must be integer!")
    if int(newDuration) < 20:
        raise ValueError("The duration is less than 20m!")
    verifyIfTheFlightWithThatCodeExist = False
    for flight in flightsRepository:
        if flight[0] == codeOfFlight:
            verifyIfTheFlightWithThatCodeExist = True
            flight[1] = newDuration
    if not verifyIfTheFlightWithThatCodeExist:
        raise ValueError("There's no flight with this code!")
    return flightsRepository


def setNewDestinationForAllFlightsWithGivenDestination(flightsRepository, newDestination, givenDestination):
    if len(newDestination) <= 1:
        raise ValueError("Destination city must have at least 3 char length!")
    for flight in flightsRepository:
        if flight[3] == givenDestination:
            flight[3] = newDestination
    return flightsRepository
