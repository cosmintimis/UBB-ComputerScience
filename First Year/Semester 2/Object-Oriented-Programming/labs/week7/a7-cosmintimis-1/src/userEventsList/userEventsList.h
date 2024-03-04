#pragma once

#include "../domain/event.h"

class UserEventsList
{
    protected:
        std::vector<Event> listOfUserEvents;
    public:
        void addEventToUserList(Event);
        void deleteEventFromUserList(int);
        std::vector<Event>& getUserList();

};