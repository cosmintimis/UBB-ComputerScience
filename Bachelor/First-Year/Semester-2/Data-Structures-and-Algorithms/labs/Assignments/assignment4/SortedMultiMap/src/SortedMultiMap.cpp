#include "SMMIterator.h"
#include "SortedMultiMap.h"
#include <iostream>
#include <vector>
#include <exception>
using namespace std;


SortedMultiMap::SortedMultiMap(Relation r)
{
    this->relation = r;
	this->capacity = 8;
	this->nrOfPairs = 0;
	this->loadFactor = 0.75;

	this->hashTable = new Slot[this->capacity];
	for (int i = 0; i < this->capacity; i++) {
		this->hashTable[i].deleted = false;
		this->hashTable[i].occupied = false;
	}
}

int SortedMultiMap::hashFunction(int cap, TKey key, Slot* hashT) const
{
	float c1 = 0.5;
	float c2 = 0.5;
	int i = 0;
	int hash = (int(abs(key) % cap + c1 * i + c2 * i * i)) % cap;
	while (hashT[hash].occupied == true) {
		i++;
		hash = (int(abs(key) % cap + c1 * i + c2 * i * i)) % cap;
	}
	return hash;    
}

void SortedMultiMap::add(TKey c, TValue v) {
	if(this->loadFactor < (float)(this->nrOfPairs + 1) / this->capacity) 
	{
		Slot* newHashTable = new Slot[this->capacity * 2];
		for (int i = 0; i < this->capacity * 2; i++) {
			newHashTable[i].deleted = false;
			newHashTable[i].occupied = false;
		}
		
		for (int i = 0; i < this->capacity; i++) {
			int hash = this->hashFunction(this->capacity * 2, this->hashTable[i].elem.first, newHashTable);
			newHashTable[hash].elem = this->hashTable[i].elem;
			newHashTable[hash].occupied = this->hashTable[i].occupied;
			newHashTable[hash].deleted = this->hashTable[i].deleted;
		}

		delete[] this->hashTable;
		this->hashTable = newHashTable;
		this->capacity *= 2;
	}

	int hash = this->hashFunction(this->capacity, c, this->hashTable);

	this->hashTable[hash].elem.first = c;
	this->hashTable[hash].elem.second = v;
	this->hashTable[hash].occupied = true;
	this->nrOfPairs++;

}

vector<TValue> SortedMultiMap::search(TKey c) const {
	vector<TValue> values;
	// int i = 0;
	// while (i < this->capacity) {
	// 	if (this->hashTable[i].occupied == true && this->hashTable[i].elem.first == c) {
	// 		values.push_back(this->hashTable[i].elem.second);
	// 	}
	// 	i++;
	// }

	int i = 0;
	float c1, c2;
	c1 = c2 = 0.5;
	int hash = (int(abs(c) % this->capacity + c1 * i + c2 * i * i)) % this->capacity;
	while (this->hashTable[hash].occupied == true && i < this->capacity) {
		if (this->hashTable[hash].elem.first == c) {
			values.push_back(this->hashTable[hash].elem.second);
		}
		i++;
		hash = (int(abs(c) % this->capacity + c1 * i + c2 * i * i)) % this->capacity;
	}

	return values;
}

bool SortedMultiMap::remove(TKey c, TValue v) {
	int i = 0;
	float c1, c2;
	c1 = c2 = 0.5;
	int hash = (int(abs(c) % this->capacity + c1 * i + c2 * i * i)) % this->capacity;
	while (this->hashTable[hash].occupied == true || this->hashTable[hash].deleted == true) {
		if (this->hashTable[hash].elem.first == c && this->hashTable[hash].elem.second == v) {
			this->hashTable[hash].elem = NULL_TELEM;
			this->hashTable[hash].deleted = true;
			this->hashTable[hash].occupied = false;
			this->nrOfPairs--;
			return true;
		}
		i++;
		hash = (int(abs(c) % this->capacity + c1 * i + c2 * i * i)) % this->capacity;
	}
	return false;
}


int SortedMultiMap::size() const {
	return this->nrOfPairs;
}

bool SortedMultiMap::isEmpty() const {
	return this->nrOfPairs == 0;
}

SMMIterator SortedMultiMap::iterator() const {
	return SMMIterator(*this);
}

SortedMultiMap::~SortedMultiMap() {
	delete[] this->hashTable;
}
