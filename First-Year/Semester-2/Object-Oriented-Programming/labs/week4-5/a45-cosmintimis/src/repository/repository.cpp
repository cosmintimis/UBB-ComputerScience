#include "repository.h"

Repository::Repository()
{
}

Repository::~Repository()
{
}

void Repository::addEvent(Event event)
{
    this->listOfEvents.addElemToVector(event);
}

void Repository::deleteEvent(int index)
{
    this->listOfEvents.deleteElemFromVector(index);
}


DynamicVector<Event>& Repository::getAll()
{
    return this->listOfEvents;
}

int Repository::getSize()
{
    return this->listOfEvents.getSize();
}

void Repository::addEventToUserList(int index)
{
    this->listOfUserEvents.addElemToVector(this->listOfEvents.getElemByIndex(index));
}

void Repository::deleteEventFromUserList(int index)
{
    this->listOfUserEvents.deleteElemFromVector(index);
}

DynamicVector<Event> &Repository::getUserList()
{
    return this->listOfUserEvents;
}
