#include "MultiMapIterator.h"
#include "MultiMap.h"


MultiMapIterator::MultiMapIterator(const MultiMap& c): col(c) {
	this->current = col.head;
}

/// Theta(1)

TElem MultiMapIterator::getCurrent() const{
	if(valid())
		return col.elements[this->current].info;
	throw exception();
}

/// Theta(1)

bool MultiMapIterator::valid() const {
	return this->current != -1;

}

/// Theta(1)

void MultiMapIterator::next() {
	if(valid())
		this->current = col.elements[this->current].next;
	else
		throw exception();
}

/// Theta(1)

void MultiMapIterator::first() {
	this->current = col.head;
}

/// Theta(1)

