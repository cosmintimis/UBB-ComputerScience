#include "event.h"

Event::Event()
{
    title = "";
    description = "";
    dateAndTime = std::tm();
    numberOfPeople = 0;
    link = "";
}

Event::Event(const std::string& title,const std::string& description,const std::tm& dateAndTime, const int& numberOfPeople ,const std::string& link)
{
    this->title = title;
    this->description = description;
    this->dateAndTime = dateAndTime;
    this->numberOfPeople = numberOfPeople;
    this->link = link;
}

Event::Event(const Event & event)
{
    title = event.title;
    description = event.description;
    dateAndTime = event.dateAndTime;
    numberOfPeople = event.numberOfPeople;
    link = event.link;
}




Event::~Event()
{
}

std::string Event::getTitle()
{
    return this->title;
}

std::string Event::getDescription()
{
    return this->description;
}

std::tm Event::getDateAndTime()
{
    return this->dateAndTime;
}

int Event::getNumberOfPeople()
{
    return this->numberOfPeople;
}

std::string Event::getLink()
{
    return this->link;
}

void Event::updateDescription(std::string &description)
{
   this->description = description;
    
}

void Event::updateDateAndTime(std::tm &dateAndTime)
{
    this->dateAndTime = dateAndTime;
}

void Event::updateNumberOfPeople(int &numberOfPeople)
{
    this->numberOfPeople = numberOfPeople;
}

void Event::updateLink(std::string &link)
{
    this->link = link;
}

void Event::updateTitle(std::string &title)
{
    this->title = title;
    
}

std::ostream &operator<<(std::ostream &os, const Event &event)
{
    std::string asterisks(30, '*');
    os << asterisks << std::endl;
    os << "Title: " << event.title << std::endl;
    os << "Description: " << event.description << std::endl;
    os << "Date and time: " << std::put_time(&event.dateAndTime, "%d-%m-%Y %H:%M") << std::endl;
    os << "Number of people: " << event.numberOfPeople << std::endl;
    os << "Link: " << event.link << std::endl;
    os << asterisks << std::endl;
    return os;
}

bool operator==(const Event &e1, const Event &e2)
{
    if(e1.title == e2.title && e1.numberOfPeople == e2.numberOfPeople )
        return true;
    return false;
}
