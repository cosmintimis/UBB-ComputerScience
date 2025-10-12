#include "userEventsList.h"

void UserEventsList::addEventToUserList(Event event)
{
    this->listOfUserEvents.push_back(event);
}

void UserEventsList::deleteEventFromUserList(int index)
{
    this->listOfUserEvents.erase(this->listOfUserEvents.begin() + index);
}

std::vector<Event>& UserEventsList::getUserList()
{
    return this->listOfUserEvents;
}