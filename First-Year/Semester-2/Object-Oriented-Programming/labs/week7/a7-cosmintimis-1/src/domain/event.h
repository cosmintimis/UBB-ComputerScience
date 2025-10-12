#pragma once
#include <string>
#include <ctime>
#include <iostream>
#include <iomanip>
#include <sstream>
#include <vector>
#include <algorithm>
class Event
{
    private:
    std::string title;
    std::string description;
    std::tm dateAndTime;
    int numberOfPeople;
    std::string link;
    


    public:
    Event();
    Event(const std::string& title,const std::string& description,const std::tm& dateAndTime, const int& numberOfPeople, const std::string& link);
    Event(const Event&);
    ~Event();
    std::string getTitle();
    std::string getDescription();
    std::tm getDateAndTime();
    int getNumberOfPeople();
    std::string getLink();
    void updateTitle(std::string &);
    void updateDescription(std::string &);
    void updateDateAndTime(std::tm &);
    void updateNumberOfPeople(int &);
    void updateLink(std::string &);
    void openLink();
    friend std::ostream& operator<<(std::ostream& os, const Event& e);
    friend std::istream& operator>>(std::istream& is, Event& e);
    friend bool operator==(const Event& e1, const Event& e2);
        

};