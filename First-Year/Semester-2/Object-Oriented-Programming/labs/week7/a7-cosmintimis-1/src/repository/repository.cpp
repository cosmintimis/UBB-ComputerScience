#include "repository.h"
#include <fstream>
#include "repositoryException.h"
Repository::Repository(const std::string& filename)
{
    this->filename = filename;
    this->readFromFile();
}

Repository::~Repository()
{
}

void Repository::addEvent(Event event)
{
    this->data.push_back(event);
    this->writeToFile();
}

void Repository::deleteEvent(int index)
{
    this->data.erase(this->data.begin() + index);
    this->writeToFile();
}

void Repository::updateFile()
{
    this->writeToFile();
}

std::vector<Event>& Repository::getAll()
{
    return this->data;
}

int Repository::getSize()
{
    return this->data.size();
}

void Repository::readFromFile()
{
    std::ifstream file(this->filename);
    if (!file.is_open())
        throw FileException("The file could not be opened!");

    Event event;
    while (file >> event)
        this->data.push_back(event);

    file.close();
}

void Repository::writeToFile()
{
    std::ofstream file(this->filename);
	if (!file.is_open())
		throw FileException("The file could not be opened!");

	for (auto s : this->data)
	{
		file << s;
	}
	
	file.close();
}

