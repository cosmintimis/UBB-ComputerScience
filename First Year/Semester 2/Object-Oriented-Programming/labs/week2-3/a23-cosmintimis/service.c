#include "service.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

Service *createService(Repository *repository)
{
    Service *newService = malloc(sizeof(Service));
    newService->repository = repository;
    return newService;
}

void destroyService(Service *service)
{
    destroyRepository(service->repository);
    free(service);
}

int checkIfAnOfferAlreadyExists(Service *service, char *offerDestination, date offerDepartureDate)
{
    /// return -1 if provided offer doesn't exist, otherwise return index of provided offer
    for (int i = 0; i < getSize(service->repository); i++)
    {
        Offer *currentOffer = getOfferByIndex(service->repository, i);
        if (strcmp(currentOffer->destination, offerDestination) == 0 && currentOffer->departureDate.day == offerDepartureDate.day &&
            currentOffer->departureDate.month == offerDepartureDate.month && currentOffer->departureDate.year == offerDepartureDate.year)
            return i;
    }
    return -1;
}

int addOfferService(Service *service, char *type, char *destination, date departureDate, int price)
{
    /// return 0 if new offer is added
    /// return 1 if offer we want to add already exists
    /// return 2 if offer we want to add isn't valid

    int offerIsValid, offerAlreadyExists;
    offerIsValid = checkIfAnOfferIsValid(type, destination, departureDate, price);
    offerAlreadyExists = checkIfAnOfferAlreadyExists(service, destination, departureDate);

    if (!offerIsValid)
        return 2;
    if (offerAlreadyExists != -1)
        return 1;

    
    Offer *newOffer = createOffer(type, destination, departureDate, price);
    resetListsOfOffersUsingForRedo(service->repository);
    saveCopyOfCurrentListOfOffers(service->repository);
    addOffer(service->repository, newOffer);
    return 0;
}

int deleteAnOffer(Service *service, char *offerDestination, date offerDepartureDate)
{
    /// return 0 if provided offer doesn't exist
    /// return 1 if provided offer was deleted

    int indexOfProvidedOffer = checkIfAnOfferAlreadyExists(service, offerDestination, offerDepartureDate);

    if (indexOfProvidedOffer == -1)
        return 0;

    resetListsOfOffersUsingForRedo(service->repository);
    saveCopyOfCurrentListOfOffers(service->repository);
    deleteOffer(service->repository, indexOfProvidedOffer);
    return 1;
}

void getAllOffersWhoseDestinationsContainAGivenString(Service *service, char *givenString, Offer *arrayOfAllOffersWhoseDestinationsContainAGivenString, int *numberOfAllOffersWhoseDestinationsContainAGivenString)
{
    /// if the given string is empty all destinations are considered

    int numberOfOffers = getSize(service->repository);
    *numberOfAllOffersWhoseDestinationsContainAGivenString = -1;
    if (strcmp(givenString, "") == 0)
    {
        for (int i = 0; i < numberOfOffers; i++)
            arrayOfAllOffersWhoseDestinationsContainAGivenString[++*numberOfAllOffersWhoseDestinationsContainAGivenString] = *getOfferByIndex(service->repository, i);
    }
    else
    {
        for (int i = 0; i < numberOfOffers; i++)
        {
            if (strstr((*getOfferByIndex(service->repository, i)).destination, givenString) != NULL)
                arrayOfAllOffersWhoseDestinationsContainAGivenString[++*numberOfAllOffersWhoseDestinationsContainAGivenString] = *getOfferByIndex(service->repository, i);
        }
    }

    Offer temp;
    for (int i = 0; i <= *numberOfAllOffersWhoseDestinationsContainAGivenString - 1; i++)
    {
        for (int j = i + 1; j <= *numberOfAllOffersWhoseDestinationsContainAGivenString; j++)
            if (arrayOfAllOffersWhoseDestinationsContainAGivenString[i].price > arrayOfAllOffersWhoseDestinationsContainAGivenString[j].price)
            {
                temp = arrayOfAllOffersWhoseDestinationsContainAGivenString[i];
                arrayOfAllOffersWhoseDestinationsContainAGivenString[i] = arrayOfAllOffersWhoseDestinationsContainAGivenString[j];
                arrayOfAllOffersWhoseDestinationsContainAGivenString[j] = temp;
            }
    }
}

int updateAnOffer(Service *service, char *offerDestination, date offerDepartureDate, char *newType, char *newDestination, date newDepartureDate, int newPrice)
{
    /// return 0 if the update was made
    /// return 1 if the updated offer already exists
    /// return 2 if the updated offer isn't valid
    /// return 3 if the offer user want to update doesn't exist

    int indexOfProvidedOffer = checkIfAnOfferAlreadyExists(service, offerDestination, offerDepartureDate);

    if (indexOfProvidedOffer == -1)
        return 3;

    int checkIfUpdatedOfferIsValid = checkIfAnOfferIsValid(newType, newDestination, newDepartureDate, newPrice);

    if (!checkIfUpdatedOfferIsValid)
        return 2;

    int checkIfUpdatedOfferIsUnique = checkIfAnOfferAlreadyExists(service, newDestination, newDepartureDate);

    if (checkIfUpdatedOfferIsUnique != -1)
        return 1;

    Offer *offerToUpdate = getElemByIndex(service->repository->currentListOfAllOffers, indexOfProvidedOffer);

    resetListsOfOffersUsingForRedo(service->repository);
    saveCopyOfCurrentListOfOffers(service->repository);

    updateType(offerToUpdate, newType);
    updateDestination(offerToUpdate, newDestination);
    updateDepartureDate(offerToUpdate, newDepartureDate);
    updatePrice(offerToUpdate, newPrice);

    return 0;
}

int compareTwoDates(date firstDate, date secondDate)
{
    /// return 1 if firstDate is greater than secondDate, otherwise return 0

    if (firstDate.year > secondDate.year)
        return 1;
    else
    {
        if (firstDate.year == secondDate.year)
        {
            if (firstDate.month > secondDate.month)
                return 1;
            else
            {
                if (firstDate.month == secondDate.month)
                {
                    if (firstDate.day > secondDate.day)
                        return 1;
                }
            }
        }
    }
    return 0;
}

void getAllOffersHavingSameTypeAndAfterASpecificDate(Service *service, char *givenType, date givenDepartureDate, Offer *arrayOfAllOffersHavingSameTypeAndAfterASpecificDate, int *lengthOfArray)
{
    int numberOfOffers = getSize(service->repository);
    *lengthOfArray = 0;

    for (int i = 0; i < numberOfOffers; i++)
    {
        if (strcmp((*getOfferByIndex(service->repository, i)).type, givenType) == 0 && compareTwoDates((*getOfferByIndex(service->repository, i)).departureDate, givenDepartureDate) == 1)
        {
            arrayOfAllOffersHavingSameTypeAndAfterASpecificDate[*lengthOfArray] = *getOfferByIndex(service->repository, i);
            *lengthOfArray += 1;
        }
    }
}

date createDate(int day, int month, int year)
{
    date newDate;
    newDate.year = year;
    newDate.month = month;
    newDate.day = day;
    return newDate;
}

void addTenRandomOffersToRepository(Service *service)
{
    Offer *randomOffer;
    randomOffer = createOffer("seaside", "Hope Isle", createDate(22, 9, 2014), 800);
    addOffer(service->repository, randomOffer);

    randomOffer = createOffer("seaside", "Calm Shores", createDate(15, 8, 2013), 1200);
    addOffer(service->repository, randomOffer);

    randomOffer = createOffer("seaside", "Pristine Cove", createDate(6, 6, 2012), 900);
    addOffer(service->repository, randomOffer);

    randomOffer = createOffer("seaside", "Sunny Sands", createDate(19, 8, 2015), 2000);
    addOffer(service->repository, randomOffer);

    randomOffer = createOffer("seaside", "Bliss Bay", createDate(17, 7, 2017), 1500);
    addOffer(service->repository, randomOffer);

    randomOffer = createOffer("seaside", "Peaceful Reef", createDate(29, 8, 2016), 1000);
    addOffer(service->repository, randomOffer);

    randomOffer = createOffer("city break", "Paris", createDate(16, 2, 2023), 600);
    addOffer(service->repository, randomOffer);

    randomOffer = createOffer("city break", "Madrid", createDate(22, 1, 2023), 500);
    addOffer(service->repository, randomOffer);

    randomOffer = createOffer("mountain", "Everest", createDate(3, 7, 2022), 1100);
    addOffer(service->repository, randomOffer);

    randomOffer = createOffer("mountain", "Pietrosul Rodnei", createDate(30, 8, 2022), 9999);
    addOffer(service->repository, randomOffer);
}


int undoLastOperation(Service* service)
{

    if(service->repository->numberOfOperationsPerformedByUser > 0)
    {
        service->repository->listsOfOffersUsingForRedo = realloc(service->repository->listsOfOffersUsingForRedo, (service->repository->numberOfAvailableRedo + 1) * sizeof(DynamicArray*));
        service->repository->listsOfOffersUsingForRedo[service->repository->numberOfAvailableRedo] = service->repository->currentListOfAllOffers;
        service->repository->numberOfAvailableRedo += 1;
        service->repository->currentListOfAllOffers = service->repository->listsOfOffersUsingForUndo[service->repository->numberOfOperationsPerformedByUser - 1];
        service->repository->numberOfOperationsPerformedByUser -= 1;
        return 0;
    }
    return 1;
    
}

int redoLastUndo(Service* service)
{
    if(service->repository->numberOfAvailableRedo > 0)
    {
        service->repository->numberOfOperationsPerformedByUser += 1;
        service->repository->currentListOfAllOffers = service->repository->listsOfOffersUsingForRedo[service->repository->numberOfAvailableRedo - 1];
        service->repository->numberOfAvailableRedo -= 1;

        return 0;
    }
    return 1;
}
