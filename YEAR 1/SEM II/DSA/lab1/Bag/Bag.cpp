#include "Bag.h"
#include "BagIterator.h"
#include <exception>
#include <iostream>
using namespace std;

Bag::Bag()
{
	this->capacity = 5;
	this->nrPairs = 0;
	this->arrayOfPairs = new TElemPair[this->capacity];
}
// theta(1)


void Bag::add(TElem elem)
{
	if(this->nrPairs == this->capacity)
	{
		this->capacity *= 2;
		TElemPair* auxArrayOfPairs = new TElemPair[this->capacity];
		for (int pair = 0; pair < this->nrPairs; pair++)
			auxArrayOfPairs[pair] = this->arrayOfPairs[pair];
		delete[] this->arrayOfPairs;
		this->arrayOfPairs = auxArrayOfPairs;
	}
	bool found = false;
	for (int pair = 0; pair < this->nrPairs; pair++)
		if (this->arrayOfPairs[pair].first == elem)
		{
			this->arrayOfPairs[pair].second += 1;
			found = true;
		}
	if(found == false)
	{
		this->arrayOfPairs[this->nrPairs].first = elem;
		this->arrayOfPairs[this->nrPairs].second = 1;
		this->nrPairs += 1;
	}
}
//Best case: Theta(1), Worst Case: Theta(nrPairs) => Total Complexity: O(nrPairs)


bool Bag::remove(TElem elem)
{
	if(this->nrPairs == this->capacity / 4 && this->nrPairs != 0)
	{
		this->capacity /= 2;
		TElemPair* auxArrayOfPairs = new TElemPair[this->capacity];
		for (int pair = 0; pair < this->nrPairs; pair++)
			auxArrayOfPairs[pair] = this->arrayOfPairs[pair];
		delete[] this->arrayOfPairs;
		this->arrayOfPairs = NULL;
		this->arrayOfPairs = auxArrayOfPairs;
	}

	for (int pair = 0; pair < this->nrPairs; pair++)
		if (this->arrayOfPairs[pair].first == elem)
		{
			if(this->arrayOfPairs[pair].second > 1)
			{
				this->arrayOfPairs[pair].second -= 1;
				return true;
			}
			else
			{
				for(int aux = pair; aux < this->nrPairs - 1; aux++)
					this->arrayOfPairs[aux] = this->arrayOfPairs[aux + 1];
				// arrayOfPairs[pair] = this->arrayOfPairs[this->nrPairs - 1];
				this->nrPairs -= 1;
				return true;
			}
		}
	return false;
}
//Best case: Theta(1), Worst Case: Theta(nrPairs) => Total Complexity: O(nrPairs)

bool Bag::search(TElem elem) const
{
	for (int pair = 0; pair < this->nrPairs; pair++)
		if (this->arrayOfPairs[pair].first == elem)
			return true;
	return false;
}
//Best case: Theta(1), Worst Case: Theta(nrPairs) => Total Complexity: O(nrPairs)

int Bag::nrOccurrences(TElem elem) const
{
	for (int pair = 0; pair < this->nrPairs; pair++)
		if (this->arrayOfPairs[pair].first == elem)
			return this->arrayOfPairs[pair].second;
	return 0;
}
//Best case: Theta(1), Worst Case: Theta(nrPairs) => Total Complexity: O(nrPairs)

int Bag::size() const
{
	int size = 0;
	for (int pair = 0; pair < this->nrPairs; pair++)
		size += this->arrayOfPairs[pair].second;
	return size;
}

//Best case: Theta(1), Worst Case: Theta(nrPairs) => Total Complexity: O(nrPairs)

bool Bag::isEmpty() const
{
	if(this->nrPairs == 0)
		return true;
	return false;
}

// theta(1)

BagIterator Bag::iterator() const
{
	return BagIterator(*this);
}
// theta(1)

Bag::~Bag()
{
	delete[] this->arrayOfPairs;
}
//Best case: Theta(1), Worst Case: Theta(nrPairs) => Total Complexity: O(nrPairs)

