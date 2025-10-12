#include "dynamicVector.h"

template <typename TElem>
DynamicVector<TElem>::DynamicVector(int capacity)
{
    size = 0;
    this->capacity = capacity;
    data = new TElem[capacity];
}

template <typename TElem>
DynamicVector<TElem>::~DynamicVector()
{
    delete[] this->data;
}

template <typename TElem>
int DynamicVector<TElem>::getSize() const
{
    return size;
}

template <typename TElem>
TElem& DynamicVector<TElem>::getElemByIndex(int index)
{
   return this->data[index];
}

template <typename TElem>
void DynamicVector<TElem>::addElemToVector(TElem item)
{
    if (this->size == this->capacity)
        increaseCapacity();
    this->data[this->size] = item;
    this->size++;

}
template <typename TElem>
void DynamicVector<TElem>::deleteElemFromVector(int index)
{
    for (int i = index; i < this->size - 1; ++i)
        this->data[i] = this->data[i + 1];
    this->size--;
}
template <typename TElem>
DynamicVector<TElem>::DynamicVector(const DynamicVector & dynamicVector)
{
    size = dynamicVector.size;
    capacity = dynamicVector.capacity;
    data = new TElem[capacity];
    // memcpy(data, dynamicVector.data, sizeof(TElem) * size);
    for(int i=0; i < size; i++)
        data[i] = dynamicVector.data[i];
}

template <typename TElem>
DynamicVector<TElem> &DynamicVector<TElem>::operator=(const DynamicVector<TElem> & dynamicVector)
{
    // TODO: insert return statement here
    if(&dynamicVector == this)
        return *this;
    // DynamicVector temp(dynamicVector);
    // return temp;
    size = dynamicVector.size;
    capacity = dynamicVector.capacity;
    delete[] this->data;
    data = new TElem[capacity];
    for(int i=0; i < size; i++)
        data[i] = dynamicVector.data[i];

    return *this;
    
}

template <typename TElem>
void DynamicVector<TElem>::swapTwoElements(int indexOfFirstElement, int indexOfSecondElement)
{
    TElem temp = this->data[indexOfFirstElement];
    this->data[indexOfFirstElement] = this->data[indexOfSecondElement];
    this->data[indexOfSecondElement] = temp;
}

template <typename TElem>
void DynamicVector<TElem>::increaseCapacity()
{
    this->capacity *= 2;
    TElem * arr = new TElem[capacity];
    for(int i=0;i<size;i++)
        arr[i] = this->data[i];
    delete[] this->data;
    this->data = arr;
}

template class DynamicVector<int>;
template class DynamicVector<Event>;
