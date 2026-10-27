#include "MultiMap.h"
#include "MultiMapIterator.h"
#include <exception>
#include <iostream>

using namespace std;


MultiMap::MultiMap() {

	this->capacity = 10;
	this->elements = new DLLANode[this->capacity];
	
	for(int i = 0; i < this->capacity; i++)
		this->elements[i].next = i + 1;

	this->elements[this->capacity - 1].next = -1;

	this->head = -1;
	this->tail = -1;
	this->firstEmpty = 0;
	this->nrElements = 0;
}

/// Theta(capacity)


void MultiMap::add(TKey c, TValue v) {
	
	if(this->firstEmpty == -1)
	{
		DLLANode* newElements = new DLLANode[this->capacity * 2];
		for(int i = 0; i < this->capacity; i++)
			newElements[i] = this->elements[i];
		this->capacity *= 2;

		this->firstEmpty = this->capacity / 2;
		for(int i = this->capacity / 2 - 1; i < this->capacity; i++)
			newElements[i].next = i + 1;
		newElements[this->capacity - 1].next = -1;

		delete[] this->elements;
		this->elements = newElements;
	}

	int position = this->firstEmpty;
	this->firstEmpty = this->elements[position].next;

	this->elements[position].info.first = c;
	this->elements[position].info.second = v;

	this->elements[position].next = -1;
	this->elements[position].previous = this->tail;

	if(this->head == -1)
	{
		this->head = position;
		this->tail = position;
	}
	else
	{
		this->elements[this->tail].next = position;
		this->tail = position; 
	}

	this->nrElements++;

}

/// Best case: Theta(1), Worst case: Theta(nrElements), Total complexity: O(nrElements)

bool MultiMap::remove(TKey c, TValue v) {
	
	int current = this->head;

	while(current != -1 && (this->elements[current].info.first != c || this->elements[current].info.second != v))
		current = this->elements[current].next;

	if(current == -1)
		return false;

	if(this->elements[current].previous == -1)
		this->head = this->elements[current].next;
	else
		this->elements[this->elements[current].previous].next = this->elements[current].next;

	if(this->elements[current].next == -1)
		this->tail = this->elements[current].previous;
	else
		this->elements[this->elements[current].next].previous = this->elements[current].previous;

	this->elements[current].next = this->firstEmpty;
	this->firstEmpty = current;

	this->nrElements--;

	return true;
}

/// Best case: Theta(1), Worst case: Theta(nrElements), Total complexity: O(nrElements)

vector<TValue> MultiMap::search(TKey c) const {
	vector<TValue> allValuesOfGivenKey;

	int current = this->head;

	while(current != -1)
	{
		if(this->elements[current].info.first == c)
			allValuesOfGivenKey.push_back(this->elements[current].info.second);
		current = this->elements[current].next;
	}

	return allValuesOfGivenKey;
}

/// Theta(nrElements)


int MultiMap::size() const {
	return this->nrElements;
}

/// Theta(1)


bool MultiMap::isEmpty() const {
	return this->nrElements == 0;
}

/// Theta(1)

MultiMapIterator MultiMap::iterator() const {
	return MultiMapIterator(*this);
}


MultiMap::~MultiMap() {
	delete[] this->elements;
}

/// Theta(nrElements)

