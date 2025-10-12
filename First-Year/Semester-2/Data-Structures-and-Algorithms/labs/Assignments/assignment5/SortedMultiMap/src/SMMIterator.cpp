#include "SMMIterator.h"
#include "SortedMultiMap.h"
#include <iostream>
SMMIterator::SMMIterator(const SortedMultiMap& d) : map(d){

	int node = this->map.root;
	while(node != -1)
	{
		this->stack.push(this->map.pairs[node]);
		node = this->map.pairs[node].left;
	}

	if (!this->stack.empty())
		this->currentNode = &(this->stack.top());
	else
		this->currentNode = nullptr;
	
	currentElement = 0;
	
}

void SMMIterator::first(){

	while(!this->stack.empty())
		this->stack.pop();
	int node = this->map.root;
	while(node != -1)
	{
		this->stack.push(this->map.pairs[node]);
		node = this->map.pairs[node].left;
	}

	if (!this->stack.empty())
		this->currentNode = &(this->stack.top());
	else
		this->currentNode = nullptr;
	currentElement = 0;
}

void SMMIterator::next(){
	if(!valid())
			throw std::exception();

	int index;
	for(int i = 0 ; i < map.capacity; i++)
	{
		if(currentNode->information.first == map.pairs[i].information.first)
		{
			index = i;
			break;
		}
	}

	if(currentElement < map.lengths[index] - 1)
	{
		currentElement++;
		return;
	}
	else
	{
		currentElement = 0;
		this->stack.pop();

		if(currentNode->right == -1)
		{
			if (!this->stack.empty())
				this->currentNode = &(this->stack.top());
			else
				this->currentNode = nullptr;
			return;
		}
		else
		{
			int node = currentNode->right;
			while(node != -1)
			{
				this->stack.push(this->map.pairs[node]);
				node = this->map.pairs[node].left;
			}
			if (!this->stack.empty())
				this->currentNode = &(this->stack.top());
			else
				this->currentNode = nullptr;
			return;
		}	
	}
	
	
	
}

bool SMMIterator::valid() const{

	return this->currentNode != nullptr;

}

TElem SMMIterator::getCurrent() const{
	if(valid())
	{
		TElem elem;
		elem.first = this->currentNode->information.first;
		elem.second = this->currentNode->information.second[currentElement];
		return elem;
	}
	else
		throw std::exception();
}


