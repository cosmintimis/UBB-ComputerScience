"""
->Create an app for an airport that uses a menu-driven console-based user interface
->Each flight has a code, duration(minutes), departure city, destination city
-> add a flight, raise an error if one fild(code,departure city, destination city) has a length less than 3 char or
the duration is less than 20m
->modify the duration of given flight
->for a given destination, all flights are rerouted
->show all flights with a given departure city, sorting increasing their duration
"""

from functions import *


def displayFlights(flightsRepository):
    for flight in flightsRepository:
        print(f"Code: {flight[0]} - Duration: {flight[1]} minutes - Departure city: {flight[2]} - Destination city: {flight[3]}")


def startApp():
    flightsRepository = [[111, 30, "Cluj", "Paris"], [222, 25, "Cluj", "Milano"],
                         [333, 45, "Cluj", "Barcelona"], [444, 70, "Bucuresti", "Atena"], [555, 20, "Cluj", "Targu-Mures"]]

    while True:
        print("1. Add a flight(code, duration(minutes), departure city, destination city)")
        print("2. Modify the duration of given flight")
        print("3. For a given destination, all flights are rerouted")
        print("4. Show all flights with a given departure city, sorting increasing their duration")
        print("0. Exit")

        option = input('>')

        if option == '1':
            print("Please enter the code of the flight: ")
            codeOfFlight = input('>')
            print("Please enter the duration of the flight: ")
            durationOfFlight = input('>')
            print("Please enter the departure city of the flight: ")
            departureCityOfFlight = input('>')
            print("Please enter the destination city of the flight: ")
            destinationCityOfFlight = input('>')
            try:
                newFlight = createNewFlight(codeOfFlight, durationOfFlight, departureCityOfFlight,
                                            destinationCityOfFlight)
            except ValueError as errorMessage:
                print("try again -- " + str(errorMessage))
            else:
                flightsRepository.append(newFlight)
                print("Successfully!")
        elif option == '2':
            print("Please enter the code of the flight:")
            codeOfFlight = input('>')
            print("Please enter the new duration of flight:")
            newDuration = input('>')
            try:
                updateDurationOfAnExistingFlight(flightsRepository, codeOfFlight, newDuration)
            except ValueError as errorMessage:
                print("try again -- " + str(errorMessage))
            else:
                print("Successfully!")
        elif option == '3':
            print("Please enter the initial destination:")
            initialDestination = input('>')
            print("Please enter the new destination: ")
            newDestination = input('>')
            try:
                setNewDestinationForAllFlightsWithGivenDestination(flightsRepository, newDestination, initialDestination)
            except ValueError as errorMessage:
                print("try again -- " + str(errorMessage))
            else:
                print("Successfully!")
        elif option == '4':
            print("Please enter the departure city: ")
            departureCity = input('>')
            listOfSortedFlightsWithSameDepartureCity = sortFlightsWithSameDepartureCityIncreasingByTheirDuration(flightsRepository, departureCity)
            if len(listOfSortedFlightsWithSameDepartureCity) != 0:
                displayFlights(listOfSortedFlightsWithSameDepartureCity)
            else:
                print("There's no flights with this departure city!")
        elif option == '5':
            displayFlights(flightsRepository)
        elif option == '0':
            return
        else:
            print("Invalid command!")
