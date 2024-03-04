#pragma once

#include "event.h"
#include <QDesktopServices>
#include <QUrl>

class UserEventsList
{
    protected:
        std::vector<Event> listOfUserEvents;
    public:
        void addEventToUserList(Event);
        void deleteEventFromUserList(int);
        std::vector<Event>& getUserList();

};
