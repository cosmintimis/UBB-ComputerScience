#include "service.h"

void Service::addEventService(std::string &title, std::string &description, std::tm &dateAndTime, int &numberOfPeople, std::string &link)
{
    Event newEvent = Event(title, description, dateAndTime, numberOfPeople, link);

    this->eventValidator.validate(newEvent);

    if(searchForEvent(title, numberOfPeople) != -1)
        throw RepositoryException("The event already exists! \n");
    
    this->repository.addEvent(newEvent);
  
}

void Service::deleteEventService(std::string title, int numberOfPeople)
{
    int index = searchForEvent(title, numberOfPeople);

    if(index != -1)
        this->repository.deleteEvent(index);
    else
        throw RepositoryException("The event doesn't exist! \n");
}

int Service::searchForEvent(std::string& title, int& numberOfPeople)
{
    auto iterator = std::find_if(this->getAllEvents().begin(), this->getAllEvents().end(), [&title, &numberOfPeople](Event& event) { return event.getTitle() == title && event.getNumberOfPeople() == numberOfPeople; });
    
    if(iterator == this->getAllEvents().end())
        return -1;

    return std::distance(this->getAllEvents().begin(), iterator);
}

Event& Service::getEvent(int index)
{
    return getAllEvents()[index];
}

std::vector<Event>& Service::getAllEvents()
{
    return this->repository.getAll();
}

int Service::numberOfEvents()
{
    return this->repository.getSize();
}

void Service::updateAnEvent(std::string & newTitle, std::string & newDescription, std::tm & newDateAndTime, int& newNumberOfPeople, std::string & newLink, std::string & titleOfEventToUpdate, int& numberOfPeopleOfEventToUpdate)
{
    int indexOfProvidedEvent = searchForEvent(titleOfEventToUpdate, numberOfPeopleOfEventToUpdate);

    if (indexOfProvidedEvent == -1)
        throw RepositoryException("The event you want to update doesn't exist! \n");

    Event updatedEvent = Event(newTitle, newDescription, newDateAndTime, newNumberOfPeople, newLink);
    this->eventValidator.validate(updatedEvent);

    int checkIfUpdatedOfferIsUnique = searchForEvent(newTitle, newNumberOfPeople);

    if (checkIfUpdatedOfferIsUnique != -1)
        throw RepositoryException("The updated event already exists! \n");

   
    Event& eventToUpdate = this->getEvent(indexOfProvidedEvent);
    eventToUpdate.updateTitle(newTitle);
    eventToUpdate.updateDescription(newDescription);
    eventToUpdate.updateDateAndTime(newDateAndTime);
    eventToUpdate.updateNumberOfPeople(newNumberOfPeople);
    eventToUpdate.updateLink(newLink);

    this->repository.updateFile();

}

void Service::setDateAndTime(int day, int month, int year, int hour, std::tm& dateAndTime)
{
    dateAndTime.tm_min = 0;
    dateAndTime.tm_hour = hour;
    dateAndTime.tm_year = year - 1900;
    dateAndTime.tm_mon = month - 1;
    dateAndTime.tm_mday = day;
}

bool Service::compareTwoDates(std::tm firstDateAndTime, std::tm secondDateAndTime)
{
    /// return true if firstDateAndTime > secondDateAndTime, false otherwise

     if(firstDateAndTime.tm_year > secondDateAndTime.tm_year)
        return true;
    else if(firstDateAndTime.tm_year == secondDateAndTime.tm_year)
    {
        if(firstDateAndTime.tm_mon > secondDateAndTime.tm_mon)
            return true;
        else if(firstDateAndTime.tm_mon == secondDateAndTime.tm_mon)
        {
            if(firstDateAndTime.tm_mday > secondDateAndTime.tm_mday)
                return true;
            else if(firstDateAndTime.tm_mday == secondDateAndTime.tm_mday)
            {
                if(firstDateAndTime.tm_hour > secondDateAndTime.tm_hour)
                    return true;
            }
        }
    }
    return false;

}

void Service::getEventsForAGivenMonthOrderedChronologically(int month, std::vector<Event> &eventsForAGivenMonthOrderedChronologically)
{
    /// return all events for a given month, ordered by date and time, month is an integer between 1 and 12, if month is zero return all events
    std::vector<Event> allEvents = this->getAllEvents();
    if (month == 0)
    {
        for (auto event : allEvents)
            eventsForAGivenMonthOrderedChronologically.push_back(event);
    }
    else
    {
        eventsForAGivenMonthOrderedChronologically.resize(std::count_if(allEvents.begin(), allEvents.end(), [month](Event event)
                                                                        { return event.getDateAndTime().tm_mon == month - 1; }));
        std::copy_if(allEvents.begin(), allEvents.end(), eventsForAGivenMonthOrderedChronologically.begin(), [month](Event event)
                     { return event.getDateAndTime().tm_mon == month - 1; });
    }

    auto compareDates = [this](Event &firstEvent, Event &secondEvent)
    { return !compareTwoDates(firstEvent.getDateAndTime(), secondEvent.getDateAndTime()); };

    std::sort(eventsForAGivenMonthOrderedChronologically.begin(), eventsForAGivenMonthOrderedChronologically.end(), compareDates);
}

void Service::addEventToUserList(std::string& eventTitle, int& numberOfPeople)
{

    auto iterator = std::find_if(this->getUserList().begin(), this->getUserList().end(), [&eventTitle, &numberOfPeople](Event& event) { return event.getTitle() == eventTitle && event.getNumberOfPeople() == numberOfPeople; });

    if(iterator != this->getUserList().end())
        throw RepositoryException("The event is already in the user list! \n");
    
    int indexOfProvidedEvent = searchForEvent(eventTitle, numberOfPeople);

    Event& eventToAdd = this->getEvent(indexOfProvidedEvent);

    int newNumberOfPeople = eventToAdd.getNumberOfPeople() + 1;
    eventToAdd.updateNumberOfPeople(newNumberOfPeople);
    
    this->userEventsList->addEventToUserList(eventToAdd);
    this->userEventsList->writeToFile();
}

void Service::deleteEventFromUserList(std::string &eventTitle, int &numberOfPeople)
{

    auto iterator = std::find_if(this->getUserList().begin(), this->getUserList().end(), [&eventTitle, &numberOfPeople](Event& event) { return event.getTitle() == eventTitle && event.getNumberOfPeople() == numberOfPeople; });

    if(iterator != this->getUserList().end())
    {
        /// update the number of people for the event in the main list
        int indexOfProvidedEvent = searchForEvent(eventTitle, numberOfPeople);
        int newNumberOfPeople = this->getEvent(indexOfProvidedEvent).getNumberOfPeople() - 1;
        this->getEvent(indexOfProvidedEvent).updateNumberOfPeople(newNumberOfPeople);

        /// delete the event from the user list
        int indexToDelete = std::distance(this->getUserList().begin(), iterator);
        this->userEventsList->deleteEventFromUserList(indexToDelete);
        this->userEventsList->writeToFile();
    }
    else
        throw RepositoryException("The event is not in the user list! \n");
}

std::vector<Event> &Service::getUserList()
{
    return this->userEventsList->getUserList();
}

void Service::displayUserEventsList()
{
    this->userEventsList->displayUserEventsList();
}
