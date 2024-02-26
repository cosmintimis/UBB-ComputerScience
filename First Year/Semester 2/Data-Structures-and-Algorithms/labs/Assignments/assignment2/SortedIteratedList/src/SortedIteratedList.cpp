#include "ListIterator.h"
#include "SortedIteratedList.h"
#include <iostream>
using namespace std;
#include <exception>

SortedIteratedList::SortedIteratedList(Relation r) {
	this->relation = r;
	this->head = nullptr;
	this->length = 0;
}

/// Theta(1)


int SortedIteratedList::size() const {
	
	return this->length;
}

/// Theta(1)

bool SortedIteratedList::isEmpty() const {
	return this->length == 0;
}

/// Theta(n)

ListIterator SortedIteratedList::first() const {
	return ListIterator(*this);
}

/// Theta(1)

TComp SortedIteratedList::getElement(ListIterator poz) const {
	if (poz.valid()) {
		return poz.currentElement->info;
	}
	else {
		throw exception();
	}
}

/// Theta(1)
	

TComp SortedIteratedList::remove(ListIterator& poz) {
	if (poz.valid()) {

		PNode current = this->head;
		PNode previous = nullptr;
		while (current != poz.currentElement) {
			previous = current;
			current = current->next;
		}

		if (previous == nullptr) {
			this->head = current->next;
		}
		else {
			previous->next = current->next;
		}

		TComp info = current->info;
		delete current;
		this->length--;
		poz.currentElement = previous ? previous->next : this->head;
		return info;
	}
	else {
		throw exception();
	}
}

/// Best Case : Theta(1), Worst Case : Theta(length), Total Complexity : O(length)

ListIterator SortedIteratedList::search(TComp e) const{
	ListIterator iterator = this->first();
	while (iterator.valid() && iterator.getCurrent() != e) {
		iterator.next();
	}
	return iterator;
}

/// Best case: Theta(1) - the element is the first one, Worst case: Theta(length) - the element is the last one, Total Complexity: O(length)

void SortedIteratedList::add(TComp e) {
	PNode newNode = new SLLNode(e);

	if (this->head == nullptr || this->relation(e, this->head->info))
	{
		newNode->next = this->head;
		this->head = newNode;
	}
	else
	{
		PNode current = this->head;
		while (current->next != nullptr && this->relation(current->next->info, e))
		{
			current = current->next;
		}
		newNode->next = current->next;
		current->next = newNode;
	}

	this->length++;
}

/// Best Case : Theta(1), Worst Case : Theta(length), Total Complexity: O(length)

SortedIteratedList::~SortedIteratedList() {
	PNode current = this->head;
	while (current != nullptr) {
		PNode next = current->next;
		delete current;
		current = next;
	}
	this->head = nullptr;
}

/// Theta(length)
