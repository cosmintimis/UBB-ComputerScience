#include <exception>
#include "BagIterator.h"
#include "Bag.h"

using namespace std;


BagIterator::BagIterator(const Bag& c): bag(c)
{
	this->indexOfCurrentElement = 0;
	this->currentFrequencyOfCurrentElement = 1;
}

// theta(1)

void BagIterator::first() {
	this->indexOfCurrentElement = 0;
	this->currentFrequencyOfCurrentElement = 1;
}

// theta(1)

void BagIterator::next() {
	if(!valid())
		throw exception();
	else
	{
		if(this->currentFrequencyOfCurrentElement < this->bag.arrayOfPairs[this->indexOfCurrentElement].second)
			this->currentFrequencyOfCurrentElement += 1;
		else
		{
			this->indexOfCurrentElement += 1;
			this->currentFrequencyOfCurrentElement = 1;
		}
	}
}

// theta(1)

bool BagIterator::valid() const {
	if(this->indexOfCurrentElement == this->bag.nrPairs)
		return false;
	return true;
}

// theta(1)

TElem BagIterator::getCurrent() const
{
	if(valid())
		return this->bag.arrayOfPairs[this->indexOfCurrentElement].first;
	else
		throw exception();
}

// theta(1)