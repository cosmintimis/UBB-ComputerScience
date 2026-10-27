#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tests.h"


Tests* createTests()
{
    Tests* newTests = malloc(sizeof(Tests));
    newTests->testRepository = createRepository();
    newTests->testService = createService(newTests->testRepository);
    addTenRandomOffersToRepository(newTests->testService);
    return newTests;
}

void destroyTests(Tests* tests)
{
    destroyService(tests->testService);
    free(tests);
}

void testAddOffer(Tests* tests)
{
    addOfferService(tests->testService, "seaside", "Mamaia", createDate(10,8,2023), 500);
    assert(getSize(tests->testRepository) == 11);
    assert(strcmp(getElemByIndex(tests->testRepository->currentListOfAllOffers, 10)->destination, "Mamaia") == 0);

}

void testDeleteOffer(Tests* tests)
{
    deleteAnOffer(tests->testService, "Mamaia", createDate(10,8,2023));
    assert(getSize(tests->testRepository) == 10);
}

void testUpdateOffer(Tests* tests)
{

    addOfferService(tests->testService, "seaside", "Mamaia", createDate(10,8,2023), 500);
    updateAnOffer(tests->testService, "Mamaia", createDate(10,8,2023), "city break", "Borsa", createDate(10,5,2023), 1000);
    assert(strcmp(getElemByIndex(tests->testRepository->currentListOfAllOffers, 10)->destination, "Borsa") == 0);
}


void testUndo(Tests* tests)
{
    addOfferService(tests->testService, "city break", "Bucuresti", createDate(11,9,2023), 1000);
    undoLastOperation(tests->testService);
    assert(checkIfAnOfferAlreadyExists(tests->testService, "Bucuresti", createDate(11,9,2023)) == -1);

}

void testRedo(Tests* tests)
{
    redoLastUndo(tests->testService);
    assert(checkIfAnOfferAlreadyExists(tests->testService, "Bucuresti", createDate(11,9,2023)) != -1);
}

void testGetAllOffersWhoseDestinationsContainAGivenString(Tests* tests)
{
    int numberOfAllOffersWhoseDestinationsContainAGivenString = -1;
    Offer* arrayOfAllOffersWhoseDestinationsContainAGivenString = malloc(getSize(tests->testRepository) * sizeof(Offer));
    getAllOffersWhoseDestinationsContainAGivenString(tests->testService, "Bucuresti", arrayOfAllOffersWhoseDestinationsContainAGivenString, &numberOfAllOffersWhoseDestinationsContainAGivenString);
    assert(numberOfAllOffersWhoseDestinationsContainAGivenString == 0);
    free(arrayOfAllOffersWhoseDestinationsContainAGivenString);
}

void testGetAllOffersHavingSameTypeAndAfterASpecificDate(Tests* tests)
{
    Offer* arrayOfAllOffersHavingSameTypeAndAfterASpecificDate = malloc(getSize(tests->testRepository) * sizeof(Offer));
    int lenghtOfArray = -1;
    getAllOffersHavingSameTypeAndAfterASpecificDate(tests->testService, "city break", createDate(30,12,2022), arrayOfAllOffersHavingSameTypeAndAfterASpecificDate, &lenghtOfArray);
    assert(lenghtOfArray == 4);
    free(arrayOfAllOffersHavingSameTypeAndAfterASpecificDate);

}

void testAll(Tests* tests)
{
    testAddOffer(tests);
    testDeleteOffer(tests);
    testUpdateOffer(tests);
    testUndo(tests);
    testRedo(tests);
    testGetAllOffersWhoseDestinationsContainAGivenString(tests);
    testGetAllOffersHavingSameTypeAndAfterASpecificDate(tests);
    printf("Successfully!\n");
}