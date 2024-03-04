#pragma once
#include "service.h"

typedef struct 
{
    Repository* testRepository;
    Service* testService;
}Tests;


Tests* createTests();

void destroyTests(Tests*);

void testAddOffer(Tests*);

void testDeleteOffer(Tests*);

void testUpdateOffer(Tests*);

void testUndo(Tests*);

void testRedo(Tests*);

void testGetAllOffersWhoseDestinationsContainAGivenString(Tests*);

void testGetAllOffersHavingSameTypeAndAfterASpecificDate(Tests*);

void testAll(Tests*);