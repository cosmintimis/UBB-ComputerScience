#pragma once
#include "dynamicVector.h"

class Repository
{
    private:
        DynamicVector<Event> listOfEvents;
        DynamicVector<Event> listOfUserEvents;

    public:
    Repository();
    ~Repository();
    void addEvent(Event);
    void deleteEvent(int);
    DynamicVector<Event>& getAll();
    int getSize(); 
    void addEventToUserList(int);
    void deleteEventFromUserList(int);
    DynamicVector<Event>& getUserList();


};