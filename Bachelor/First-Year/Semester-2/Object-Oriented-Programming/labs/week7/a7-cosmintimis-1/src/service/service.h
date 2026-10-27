#pragma once 
#include "../repository/repository.h"
#include "../domain/eventValidator.h"
#include "../repository/repositoryException.h"
#include "../userEventsList/fileUserEventsList.h"

class Service
{
    private:
        Repository repository;
        FileUserEventsList* userEventsList;
        EventValidator eventValidator;
    
    public:
    Service(const Repository& repo, FileUserEventsList* userData): repository{repo}, userEventsList{userData} {}
    void addEventService(std::string&, std::string&, std::tm&, int&, std::string&);
    void deleteEventService(std::string, int);
    void updateAnEvent(std::string&, std::string&, std::tm&, int&, std::string&, std::string&, int&);
    int searchForEvent(std::string&, int&);
    Event& getEvent(int);
    std::vector<Event>& getAllEvents(); 
    int numberOfEvents();
    void setDateAndTime(int, int, int, int, std::tm&);
    static bool compareTwoDates(std::tm, std::tm);
    void getEventsForAGivenMonthOrderedChronologically(int, std::vector<Event>&);
    void addEventToUserList(std::string&, int&);
    void deleteEventFromUserList(std::string&, int&);
    std::vector<Event>& getUserList();
    void displayUserEventsList();


};