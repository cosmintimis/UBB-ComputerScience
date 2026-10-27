#include "repository.h"

Repository::Repository()
{
}

Repository::~Repository()
{
}

void Repository::addEvent(Event event)
{
    this->listOfEvents.push_back(event);
}

void Repository::deleteEvent(int index)
{
    this->listOfEvents.erase(this->listOfEvents.begin() + index);
}


std::vector<Event>& Repository::getAll()
{
    return this->listOfEvents;
}

int Repository::getSize()
{
    return this->listOfEvents.size();
}

void Repository::addEventToUserList(int index)
{
    this->listOfUserEvents.push_back(this->listOfEvents[index]);
}

void Repository::deleteEventFromUserList(int index)
{
    this->listOfUserEvents.erase(this->listOfUserEvents.begin() + index);
}

std::vector<Event>& Repository::getUserList()
{
    return this->listOfUserEvents;
}
