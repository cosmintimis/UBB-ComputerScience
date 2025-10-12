#include "offer.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

Offer* createOffer(char* type, char* destination, date departureDate, int price)
{
    Offer* newOffer = malloc(sizeof(Offer));
    newOffer->type = malloc((strlen(type)+1) * sizeof(char));
    strcpy(newOffer->type, type);
    newOffer->destination = malloc((strlen(destination)+1) * sizeof(char));
    strcpy(newOffer->destination, destination);
    newOffer->departureDate = departureDate;
    newOffer->price = price;
    return newOffer;
}

void destroyOffer(Offer* offer)
{
    free(offer->destination);
    free(offer->type);
    free(offer);
}

char* getType(Offer* offer)
{
    return offer->type;
}

char* getDestination(Offer* offer)
{
    return offer->destination;
}

date getDepartureDate(Offer* offer)
{
    return offer->departureDate;
}

int getPrice(Offer* offer)
{
    return offer->price;
}

void updateType(Offer* offer, char* newType)
{
    offer->type = realloc(offer->type, (strlen(newType) + 1) * sizeof(char));
    strcpy(offer->type, newType);
}

void updateDestination(Offer* offer, char* newDestination)
{
    offer->destination = realloc(offer->destination, (strlen(newDestination) + 1) * sizeof(char));
    strcpy(offer->destination, newDestination);
}

void updateDepartureDate(Offer* offer, date newDepartureDate)
{
    offer->departureDate = newDepartureDate;
}

void updatePrice(Offer* offer, int newPrice)
{
    offer->price = newPrice;
}

void convertOfferToString(Offer* offer,char* stringFormOfAnOffer)
{
	sprintf(stringFormOfAnOffer, "Type: %s -- Destination: %s -- DepartureDate: %d/%d/%d -- Price: %d", offer->type, offer->destination, offer->departureDate.day, offer->departureDate.month, offer->departureDate.year, offer->price);
}