#pragma once
#include "../domain/event.h"

template <typename TElem>
class DynamicVector
{

    private:
        int capacity;
        int size;
        TElem* data;

    public:
        DynamicVector(int capacity = 5);
        ~DynamicVector();
        DynamicVector(const DynamicVector<TElem> &);
        int getSize() const;
        TElem& getElemByIndex(int index);
        void addElemToVector(TElem);
        void deleteElemFromVector(int index);
        DynamicVector<TElem>& operator=(const DynamicVector<TElem>&);
        void swapTwoElements(int, int);
    
    private:
        void increaseCapacity();

};