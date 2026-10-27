#include "repository.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

Repository* createRepository()
{
    Repository* newRepository = malloc(sizeof(Repository));
    newRepository->listsOfOffersUsingForUndo = malloc(0 * sizeof(DynamicArray*));
    newRepository->listsOfOffersUsingForRedo = malloc(0 * sizeof(DynamicArray*));
    newRepository->currentListOfAllOffers = createDynamicArray(5, 0, destroyOffer);
    newRepository->numberOfOperationsPerformedByUser = 0;
    newRepository->numberOfAvailableRedo = 0;
    return newRepository;
}

void destroyRepository(Repository* repository)
{
    destroyDynamicArray(repository->currentListOfAllOffers);
    for(int i = 0; i < repository->numberOfOperationsPerformedByUser; i++)
        destroyDynamicArray(repository->listsOfOffersUsingForUndo[i]);
    for(int i = 0; i < repository->numberOfAvailableRedo; i++)
        destroyDynamicArray(repository->listsOfOffersUsingForRedo[i]);
    free(repository->listsOfOffersUsingForUndo);
    free(repository->listsOfOffersUsingForRedo);
    free(repository);
}

int getSize(Repository* repository)
{
    return repository->currentListOfAllOffers->size;
}

Offer** getAll(Repository* repository)
{
    return repository->currentListOfAllOffers->data;
}

Offer* getOfferByIndex(Repository* repository, int offerIndex)
{
    return getElemByIndex(repository->currentListOfAllOffers, offerIndex);
}

void addOffer(Repository* repository, Offer* offer)
{
   addElemToArray(repository->currentListOfAllOffers, offer); 
}

void deleteOffer(Repository* repository, int indexOfTheOfferWeWantToDelete)
{
   deleteElemFromArray(repository->currentListOfAllOffers, indexOfTheOfferWeWantToDelete);
}

void saveCopyOfCurrentListOfOffers(Repository* repository)
{
    
    repository->listsOfOffersUsingForUndo = realloc(repository->listsOfOffersUsingForUndo, (repository->numberOfOperationsPerformedByUser + 1) * sizeof(DynamicArray*));
    repository->listsOfOffersUsingForUndo[repository->numberOfOperationsPerformedByUser] = makeCopyOfDynamicArray(repository->currentListOfAllOffers);
    repository->numberOfOperationsPerformedByUser += 1;
}


void resetListsOfOffersUsingForRedo(Repository* repository)
{
    for(int i = 0; i < repository->numberOfAvailableRedo; i++)
        destroyDynamicArray(repository->listsOfOffersUsingForRedo[i]);
    repository->listsOfOffersUsingForRedo = realloc(repository->listsOfOffersUsingForRedo, 0 * sizeof(DynamicArray*));
    repository->numberOfAvailableRedo = 0;

}

