#pragma once

typedef struct
{
    int year;
    int month;
    int day;
}date;

typedef struct
{
    char* type;
    char* destination;
    date departureDate;
    int price;
}Offer;

Offer* createOffer(char* type, char* destination, date departureDate, int price);

void destroyOffer(Offer*);

char* getType(Offer*);

char* getDestination(Offer*);

date getDepartureDate(Offer*);

int getPrice(Offer*);

void updateType(Offer*, char*);

void updateDestination(Offer*, char*);

void updateDepartureDate(Offer*, date);

void updatePrice(Offer*, int);

void convertOfferToString(Offer*, char*);
