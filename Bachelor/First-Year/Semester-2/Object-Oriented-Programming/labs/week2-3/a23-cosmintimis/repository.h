#pragma once
#include "dynamicArray.h"


typedef struct 
{
    DynamicArray* currentListOfAllOffers;
    DynamicArray** listsOfOffersUsingForUndo;
    DynamicArray** listsOfOffersUsingForRedo;
    int numberOfOperationsPerformedByUser, numberOfAvailableRedo;
}Repository;

Repository* createRepository();

void destroyRepository(Repository*);

Offer** getAll(Repository*);

int getSize(Repository*);

void addOffer(Repository*, Offer*);

void deleteOffer(Repository*, int);

Offer* getOfferByIndex(Repository* , int );

void saveCopyOfCurrentListOfOffers(Repository*);

void resetListsOfOffersUsingForRedo(Repository*);