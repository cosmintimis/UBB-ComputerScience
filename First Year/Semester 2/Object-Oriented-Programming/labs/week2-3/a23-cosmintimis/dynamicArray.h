#pragma once
#include "offer.h"

typedef Offer TElem;

typedef void(*destroyer)(Offer*);

typedef struct 
{
    int capacity;
    int size;
    TElem** data;
    destroyer destroyElement;
    
}DynamicArray;

DynamicArray* createDynamicArray(int, int, destroyer);

void destroyDynamicArray(DynamicArray*);

TElem* getElemByIndex(DynamicArray* , int);

int deleteElemFromArray(DynamicArray*, int);

void addElemToArray(DynamicArray* , TElem*);

void increaseCapacity(DynamicArray*);

void decreaseCapacity(DynamicArray*);

DynamicArray* makeCopyOfDynamicArray(DynamicArray*);