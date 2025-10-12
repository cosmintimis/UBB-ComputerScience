#pragma once
#include <vector>
#include "../domain/event.h"

class Repository
{
    private:
        std::vector<Event> listOfEvents;
        std::vector<Event> listOfUserEvents;

    public:
    Repository();
    ~Repository();
    void addEvent(Event);
    void deleteEvent(int);
    std::vector<Event>& getAll();
    int getSize(); 
    void addEventToUserList(int);
    void deleteEventFromUserList(int);
    std::vector<Event>& getUserList();


};