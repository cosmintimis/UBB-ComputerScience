#include "SMMIterator.h"
#include "SortedMultiMap.h"
#include <iostream>
SMMIterator::SMMIterator(const SortedMultiMap& d) : map(d){
	
	for(int i = 0; i < this->map.capacity; i++)
		if(this->map.hashTable[i].occupied == true && this->map.hashTable[i].deleted == false)
			this->arrayOfPairs.push_back(this->map.hashTable[i].elem);
	
	
	// std::sort(this->arrayOfPairs.begin(), this->arrayOfPairs.end(), [this](const TElem& a, const TElem& b) {
    // return this->map.relation(a.first, b.first); });

	for(int i = 0; i < this->arrayOfPairs.size() - 1; i++)
		for(int j = i + 1; j < this->arrayOfPairs.size(); j++)
			if(this->map.relation(this->arrayOfPairs[i].first, this->arrayOfPairs[j].first) == false)
				swap(this->arrayOfPairs[i], this->arrayOfPairs[j]);

	this->currentPairIndex = 0;
}

void SMMIterator::first(){
	this->currentPairIndex = 0;
}

void SMMIterator::next(){
	if(this->valid())
		this->currentPairIndex++;
	else 
		throw exception();
		
}

bool SMMIterator::valid() const{
	return this->currentPairIndex < this->arrayOfPairs.size();
}

TElem SMMIterator::getCurrent() const{
	if(this->valid())
		return this->arrayOfPairs[this->currentPairIndex];
	else 
		throw exception();
}
