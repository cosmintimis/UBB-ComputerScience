#pragma once 
#include "../repository/repository.h"
#include "../domain/eventValidator.h"

class Service
{
    private:
        Repository repository;
    
    public:
    Service();
    ~Service();
    int addEventService(std::string&, std::string&, std::tm&, int&, std::string&);
    int deleteEventService(std::string, int);
    int searchForEvent(std::string&, int&);
    Event& getEvent(int);
    DynamicVector<Event>& getAllEvents(); 
    int numberOfEvents();
    int updateAnEvent(std::string&, std::string&, std::tm&, int&, std::string&, std::string&, int&);
    void addTenEventsToRepository();
    void setDateAndTime(int, int, int, int, std::tm&);
    bool compareTwoDates(std::tm, std::tm);
    void getEventsForAGivenMonthOrderedChronologically(int, DynamicVector<Event>&);
    int addEventToUserList(std::string&, int&);
    int deleteEventFromUserList(std::string&, int&);
    DynamicVector<Event>& getUserList();


};