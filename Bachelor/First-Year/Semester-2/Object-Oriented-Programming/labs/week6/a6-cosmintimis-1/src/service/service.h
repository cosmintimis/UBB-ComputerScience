#pragma once 
#include "../repository/repository.h"
#include "../domain/eventValidator.h"
#include <algorithm>

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
    std::vector<Event>& getAllEvents(); 
    int numberOfEvents();
    int updateAnEvent(std::string&, std::string&, std::tm&, int&, std::string&, std::string&, int&);
    void addTenEventsToRepository();
    void setDateAndTime(int, int, int, int, std::tm&);
    static bool compareTwoDates(std::tm, std::tm);
    void getEventsForAGivenMonthOrderedChronologically(int, std::vector<Event>&);
    int addEventToUserList(std::string&, int&);
    int deleteEventFromUserList(std::string&, int&);
    std::vector<Event>& getUserList();


};