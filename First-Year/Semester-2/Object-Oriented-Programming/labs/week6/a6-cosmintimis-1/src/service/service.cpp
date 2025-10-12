#include "service.h"


Service::Service()
{
}

Service::~Service()
{
}

int Service::addEventService(std::string &title, std::string &description, std::tm &dateAndTime, int &numberOfPeople, std::string &link)
{
    if(checkIfAnEventIsValid(title, description, dateAndTime, numberOfPeople, link))
        return 1;
    if(searchForEvent(title, numberOfPeople) != -1)
        return 2;
    Event newEvent = Event(title, description, dateAndTime, numberOfPeople, link);
    this->repository.addEvent(newEvent);
    return 0;
}

int Service::deleteEventService(std::string title, int numberOfPeople)
{
    int index = searchForEvent(title, numberOfPeople);

    if(index != -1)
    {
        this->repository.deleteEvent(index);
        return 0;
    }
    
    return 1;
}

int Service::searchForEvent(std::string& title, int& numberOfPeople)
{

    // int index = -1;
    // for(int i = 0; i < numberOfEvents(); i++)
    // {
    //     Event currentEvent = this->getEvent(i);
    //     if(currentEvent.getTitle() == title && currentEvent.getNumberOfPeople() == numberOfPeople)
    //         index = i;
    // }

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

int Service::updateAnEvent(std::string & newTitle, std::string & newDescription, std::tm & newDateAndTime, int& newNumberOfPeople, std::string & newLink, std::string & titleOfEventToUpdate, int& numberOfPeopleOfEventToUpdate)
{



    /// return 0 if the update was made
    /// return 1 if the updated offer already exists
    /// return 2 if the updated offer isn't valid
    /// return 3 if the offer user want to update doesn't exist


    int indexOfProvidedEvent = searchForEvent(titleOfEventToUpdate, numberOfPeopleOfEventToUpdate);

    if (indexOfProvidedEvent == -1)
        return 3;

    int checkIfUpdatedOfferIsValid = checkIfAnEventIsValid(newTitle, newDescription, newDateAndTime, newNumberOfPeople, newLink);

    if (checkIfUpdatedOfferIsValid)
        return 2;

    int checkIfUpdatedOfferIsUnique = searchForEvent(newTitle, newNumberOfPeople);

    if (checkIfUpdatedOfferIsUnique != -1)
        return 1;

    Event& eventToUpdate = this->getEvent(indexOfProvidedEvent);

    eventToUpdate.updateTitle(newTitle);
    eventToUpdate.updateDescription(newDescription);
    eventToUpdate.updateDateAndTime(newDateAndTime);
    eventToUpdate.updateNumberOfPeople(newNumberOfPeople);
    eventToUpdate.updateLink(newLink);

    return 0;
}



void Service::addTenEventsToRepository()
{


    std::tm dateAndTime;
    setDateAndTime(8, 4, 2023, 20, dateAndTime);
    Event newEvent1(std::string("Heart Society ❌ TUJAMO"), std::string("Join us on a journey that rivals the one of a festival! Experience through mind and body, the music that will change partying as you know it!"), dateAndTime, 100, std::string("https://www.facebook.com/events/1014477312857367"));
    this->repository.addEvent(newEvent1);

    setDateAndTime(31,3, 2023, 22, dateAndTime);
    Event newEvent2(std::string("Girls Night Party"), std::string("#LondonPub #LondonPeople #Memories #ClujNightLife #partytime #celebrate #fridaynight "), dateAndTime, 50, std::string("https://www.facebook.com/events/3492630354281905"));
    this->repository.addEvent(newEvent2);

    setDateAndTime(30, 2, 2023, 22, dateAndTime);
    Event newEvent3(std::string("SECRET GARDEN PARTY"), std::string("We bring you the party, and you bring your dance moves. Nice people, good vibes and perfect music are waiting for you on this night."), dateAndTime, 70, std::string("https://www.facebook.com/events/628752539065673"));
    this->repository.addEvent(newEvent3);

    setDateAndTime(14, 1, 2023, 21, dateAndTime);
    Event newEvent4(std::string("Neon party @ After Eight"), std::string("O petrecere spectaculoasă, unde imaginația depășește limitele realului, iar tu poți fi parte din magia serii. ✨"), dateAndTime, 90, std::string("https://www.facebook.com/events/147589328244573"));
    this->repository.addEvent(newEvent4);

    setDateAndTime(6, 4, 2023, 22, dateAndTime);
    Event newEvent5(std::string("CAROUSEL PARTY @ After Eight"), std::string("PUBLICUL DEȚINE CONTROLUL! La fiecare 30 de minute se votează următorul gen muzical, LIVE direct de pe telefoanele voastre, accesând un link."), dateAndTime, 120, std::string("https://www.facebook.com/events/1607131766454185"));
    this->repository.addEvent(newEvent5);

    setDateAndTime(2, 4, 2023, 22, dateAndTime);
    Event newEvent6(std::string("Marea studențeală @ After Eight"), std::string("Un sfârșit de săptămână nu se petrece în cămin, lucrând la proiecte, ci în club, lucrând la portofoliul de shot-uri băute unul după celălalt!"), dateAndTime, 190, std::string("https://www.facebook.com/events/241754678288198"));
    this->repository.addEvent(newEvent6);

    setDateAndTime(8, 4, 2023, 19, dateAndTime);
    Event newEvent7(std::string("Zdob si Zdub"), std::string("Zdob si Zdub canta pe 8 aprilie la /FORM Space din Cluj-Napoca. Trupa va lansa si un nou single intitulat \"Floarea Soarelui\""), dateAndTime, 110, std::string("https://www.facebook.com/events/1158388484873366"));
    this->repository.addEvent(newEvent7);

    setDateAndTime(11, 5, 2023, 20, dateAndTime);
    Event newEvent8(std::string("Rava at /FORM Space"), std::string("Straight outta \"Giulești\", right up in your face in Space."), dateAndTime, 135, std::string("https://www.facebook.com/events/5636273346426924"));
    this->repository.addEvent(newEvent8);

    setDateAndTime(18, 5, 2023, 23, dateAndTime);
    Event newEvent9(std::string("Zilele Clujului 2023"), std::string("Zilele Clujului 2023 vor avea loc în perioada 18-21 mai. Stați pe-aproape, revenim cu vești!"), dateAndTime, 50000, std::string("https://www.facebook.com/events/1140497883290634"));
    this->repository.addEvent(newEvent9);

    setDateAndTime(17, 2, 2023, 21, dateAndTime);
    Event newEvent10(std::string("Heart Society Valentines ❌ Andia ❤️‍🔥"), std::string("Homemaker or heartbreaker, there is no reason to not enjoy the magic Valentine's Day party by Heart Society🔥"), dateAndTime, 200, std::string("https://www.facebook.com/events/5808930322534509"));
    this->repository.addEvent(newEvent10);

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

    // for(int i = 0; i < (int) eventsForAGivenMonthOrderedChronologically.size() - 1; i++)
    // {
    //     for(int j = i + 1; j < (int) eventsForAGivenMonthOrderedChronologically.size(); j++)
    //     {
    //         if(compareTwoDates(eventsForAGivenMonthOrderedChronologically[i].getDateAndTime(), eventsForAGivenMonthOrderedChronologically[j].getDateAndTime()))
    //             std::iter_swap(eventsForAGivenMonthOrderedChronologically.begin() + i, eventsForAGivenMonthOrderedChronologically.begin() + j);
    //     }
    // }

    auto compareDates = [this](Event &firstEvent, Event &secondEvent)
    { return !compareTwoDates(firstEvent.getDateAndTime(), secondEvent.getDateAndTime()); };

    std::sort(eventsForAGivenMonthOrderedChronologically.begin(), eventsForAGivenMonthOrderedChronologically.end(), compareDates);
}

int Service::addEventToUserList(std::string& eventTitle, int& numberOfPeople)
{
    /// return 0 if the event was added to the user list, 1 if the event was already in the user list

    // for(int i = 0; i < (int) this->repository.getUserList().size(); i++)
    // {
    //     Event currentEvent = this->repository.getUserList()[i];
    //     if(currentEvent.getTitle() == eventTitle && currentEvent.getNumberOfPeople() == numberOfPeople)
    //         return 1;
    // }

    auto iterator = std::find_if(this->getUserList().begin(), this->getUserList().end(), [&eventTitle, &numberOfPeople](Event& event) { return event.getTitle() == eventTitle && event.getNumberOfPeople() == numberOfPeople; });

    if(iterator != this->getUserList().end())
        return 1;
    
    int indexOfProvidedEvent = searchForEvent(eventTitle, numberOfPeople);

    int newNumberOfPeople = this->getEvent(indexOfProvidedEvent).getNumberOfPeople() + 1;
    this->getEvent(indexOfProvidedEvent).updateNumberOfPeople(newNumberOfPeople);
    
    this->repository.addEventToUserList(indexOfProvidedEvent);

    return 0;

}

int Service::deleteEventFromUserList(std::string &eventTitle, int &numberOfPeople)
{
    /// return 0 if the event was deleted from the user list, 1 if the event was not in the user list

    // for (int i = 0; i < (int) this->repository.getUserList().size(); i++)
    // {
    //     Event currentEvent = this->repository.getUserList()[i];
    //     if (currentEvent.getTitle() == eventTitle && currentEvent.getNumberOfPeople() == numberOfPeople)
    //     {
    //         int indexOfProvidedEvent = searchForEvent(eventTitle, numberOfPeople);

    //         int newNumberOfPeople = this->getEvent(indexOfProvidedEvent).getNumberOfPeople() - 1;
    //         this->getEvent(indexOfProvidedEvent).updateNumberOfPeople(newNumberOfPeople);
    //         this->repository.deleteEventFromUserList(i);
    //         return 0;
    //     }
    // }
    // return 1;


    auto iterator = std::find_if(this->getUserList().begin(), this->getUserList().end(), [&eventTitle, &numberOfPeople](Event& event) { return event.getTitle() == eventTitle && event.getNumberOfPeople() == numberOfPeople; });

    if(iterator != this->getUserList().end())
    {
        int indexOfProvidedEvent = searchForEvent(eventTitle, numberOfPeople);
        int newNumberOfPeople = this->getEvent(indexOfProvidedEvent).getNumberOfPeople() - 1;
        this->getEvent(indexOfProvidedEvent).updateNumberOfPeople(newNumberOfPeople);
        this->repository.deleteEventFromUserList(iterator - this->getUserList().begin());
        return 0;
    }
    return 1;
}

std::vector<Event> &Service::getUserList()
{
    return this->repository.getUserList();
}

