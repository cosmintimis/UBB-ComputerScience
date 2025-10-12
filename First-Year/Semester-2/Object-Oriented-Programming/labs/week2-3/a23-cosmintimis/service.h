#pragma once
#include "repository.h"
#include "offerValidator.h"

typedef struct{

    Repository* repository;

}Service;

Service* createService(Repository*);

void destroyService(Service*);

int addOfferService(Service*, char*, char*, date, int);

int checkIfAnOfferAlreadyExists(Service*, char*, date);

int deleteAnOffer(Service*, char*, date);

void getAllOffersWhoseDestinationsContainAGivenString(Service*, char*,Offer*,int*);

int updateAnOffer(Service*,char*, date, char*, char*, date, int);

void getAllOffersHavingSameTypeAndAfterASpecificDate(Service*, char*, date, Offer*, int*);

int compareTwoDates(date, date);

void addTenRandomOffersToRepository(Service*);

date createDate(int, int, int);

int undoLastOperation(Service*);

int redoLastUndo(Service*);