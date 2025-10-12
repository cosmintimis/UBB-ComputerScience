#include "ListIterator.h"
#include "SortedIteratedList.h"
#include <exception>

using namespace std;


ListIterator::ListIterator(const SortedIteratedList& list) : list(list){	
	this->currentElement = list.head;
}

/// Theta(1)

void ListIterator::first(){
	this->currentElement = list.head;
}

/// Theta(1)

void ListIterator::next(){
	
	if (this->valid()) {
		this->currentElement = this->currentElement->next;
	}
	else
	{
		throw exception();
	}
}

/// Theta(1)

bool ListIterator::valid() const{
	return this->currentElement != nullptr;
}

/// Theta(1)

TComp ListIterator::getCurrent() const{
	if (this->valid()) {
		return this->currentElement->info;
	}
	return NULL_TCOMP;
}

/// Theta(1)

