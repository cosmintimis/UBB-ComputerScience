#include "dynamicArray.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


DynamicArray* createDynamicArray(int capacity, int size, destroyer destroyElement)
{
    DynamicArray* dynamicArray = malloc(sizeof(DynamicArray));
    dynamicArray->capacity = capacity;
    dynamicArray->size = size;
    dynamicArray->data = malloc(dynamicArray->capacity * sizeof(TElem*));
    dynamicArray->destroyElement = destroyElement;
    return dynamicArray;
}

void destroyDynamicArray(DynamicArray* dynamicArray)
{
    for(int i = 0; i < dynamicArray->size; i++)
        dynamicArray->destroyElement(dynamicArray->data[i]);
    free(dynamicArray->data);
    free(dynamicArray);

}

TElem* getElemByIndex(DynamicArray* dynamicArray, int indexOfElement)
{
    if(indexOfElement < dynamicArray->size)
        return dynamicArray->data[indexOfElement];
    return NULL;
}

int deleteElemFromArray(DynamicArray* dynamicArray, int indexOfElement)
{
    if(dynamicArray->size == dynamicArray->capacity / 4)
        decreaseCapacity(dynamicArray);

    if(indexOfElement < dynamicArray->size)
    {
        TElem* elem = dynamicArray->data[indexOfElement];
        dynamicArray->data[indexOfElement] = dynamicArray->data[dynamicArray->size - 1];
        dynamicArray->size -= 1;
        dynamicArray->destroyElement(elem);
        return 0;
    }
    return 1;
}

void addElemToArray(DynamicArray* dynamicArray, TElem* element)
{
    if(dynamicArray->size == dynamicArray->capacity)
        increaseCapacity(dynamicArray);
    
    dynamicArray->data[dynamicArray->size] = element;
    dynamicArray->size += 1;

}


void increaseCapacity(DynamicArray* dynamicArray)
{
    dynamicArray->capacity *= 2;
    dynamicArray->data = realloc(dynamicArray->data, dynamicArray->capacity * sizeof(TElem*));
}

void decreaseCapacity(DynamicArray* dynamicArray)
{
    dynamicArray->capacity /= 2;
    dynamicArray->data = realloc(dynamicArray->data, dynamicArray->capacity * sizeof(TElem*));
}

DynamicArray* makeCopyOfDynamicArray(DynamicArray* dynamicArray)
{
    DynamicArray* newDynamicArray = createDynamicArray(dynamicArray->capacity, 0, dynamicArray->destroyElement);
    for(int i = 0; i < dynamicArray->size; i++)
    {
        TElem* currentElement = getElemByIndex(dynamicArray, i);
        TElem* newElement = createOffer(currentElement->type, currentElement->destination, currentElement->departureDate, currentElement->price);
        addElemToArray(newDynamicArray, newElement);
    }
    return newDynamicArray;
}