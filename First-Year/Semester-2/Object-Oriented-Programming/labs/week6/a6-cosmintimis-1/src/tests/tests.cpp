#include "tests.h"

Test::Test()
{
}

Test::~Test()
{
}

void Test::testAddEvent()
{
    Event defaultEvent;
    std::cout<<defaultEvent<< "Test print default event passed!" << std::endl;
    std::tm dateAndTime = std::tm();
    this->service.setDateAndTime(1,1,2023,20, dateAndTime);
    std::string title = "test", description = "test", link = "test";
    int numberOfPeople = 1;
    Event test(title, description, dateAndTime, numberOfPeople, link);
    assert(this->service.addEventService(title, description, dateAndTime, numberOfPeople, link) == 0);
    assert(test == this->service.getEvent(0));
    std::string newTitle = "newTitle";
    test.updateTitle(newTitle);
    if(test == this->service.getEvent(0))
        assert(false);
    else
        assert(true);
    assert(this->service.addEventService(title, description, dateAndTime, numberOfPeople, link) == 2);
    assert(this->service.getEvent(0).getTitle() == title);
    assert(this->service.getEvent(0).getDescription() == description);
    assert(this->service.getEvent(0).getLink() == link);
    assert(this->service.getEvent(0).getNumberOfPeople() == numberOfPeople);
    assert(this->service.getEvent(0).getDateAndTime().tm_mday == dateAndTime.tm_mday);
    title = "";
    assert(this->service.addEventService(title, description, dateAndTime, numberOfPeople, link) == 1);
    title = "test";
    description = "";
    assert(this->service.addEventService(title, description, dateAndTime, numberOfPeople, link) == 1);
    description = "test";
    link = "";
    assert(this->service.addEventService(title, description, dateAndTime, numberOfPeople, link) == 1);
    link = "test";
    numberOfPeople = -1;
    assert(this->service.addEventService(title, description, dateAndTime, numberOfPeople, link) == 1);
    numberOfPeople = 1;
    dateAndTime.tm_year = -5000;
    assert(this->service.addEventService(title, description, dateAndTime, numberOfPeople, link) == 1);
    dateAndTime.tm_year = 2023 - 1900;

    

    std::cout<<"Test add event passed!"<<std::endl;
               
}

void Test::testDeleteEvent()
{
    std::string title = "test";
    int numberOfPeople = 1;

    assert(this->service.deleteEventService(title, numberOfPeople) == 1);
    title = "test2";
    numberOfPeople = 2;
    assert(this->service.deleteEventService(title, numberOfPeople) == 0);

    std::cout << "Test delete event passed!" << std::endl;
}

void Test::testUpdateEvent()
{
    std::string title = "test2";
    int numberOfPeople = 1000;

    std::string newTitle = "test", newDescription = "test2", newLink = "test2";
    int newNumberOfPeople = 1;
    std::tm newDateAndTime = std::tm();

    assert(this->service.updateAnEvent(newTitle, newDescription, newDateAndTime, newNumberOfPeople, newLink, title, numberOfPeople) == 3);

    title = "test";
    numberOfPeople = 1;

    assert(this->service.updateAnEvent(newTitle, newDescription, newDateAndTime, newNumberOfPeople, newLink, title, numberOfPeople) == 2);

    this->service.setDateAndTime(1, 1, 2023, 20, newDateAndTime);


    assert(this->service.updateAnEvent(newTitle, newDescription, newDateAndTime, newNumberOfPeople, newLink, title, numberOfPeople) == 1);

    newTitle = "test2";
    newNumberOfPeople = 2;

    assert(this->service.updateAnEvent(newTitle, newDescription, newDateAndTime, newNumberOfPeople, newLink, title, numberOfPeople) == 0);

    std::cout << "Test update event passed!" << std::endl;

}

void Test::testGetAllEvents()
{
    assert( (int) this->service.getAllEvents().size() ==  (int) this->service.numberOfEvents());
}

void Test::testAddTenEventsToRepository()
{
    this->service.addTenEventsToRepository();
    assert(this->service.numberOfEvents() == 10);
}

void Test::testGetEventsForAGivenMonthOrderedChronologically()
{
    std::vector<Event> eventsForAGivenMonthOrderedChronologically;
    this->service.getEventsForAGivenMonthOrderedChronologically(5, eventsForAGivenMonthOrderedChronologically);
    assert(eventsForAGivenMonthOrderedChronologically.size() == 2);

    Event first = eventsForAGivenMonthOrderedChronologically[0];
    Event second = eventsForAGivenMonthOrderedChronologically[1];
    assert(this->service.compareTwoDates(first.getDateAndTime(), second.getDateAndTime()) == false);
    assert(this->service.compareTwoDates(second.getDateAndTime(), first.getDateAndTime()) == true);

    std::vector<Event> eventsForAGivenMonthOrderedChronologically2;
    this->service.getEventsForAGivenMonthOrderedChronologically(4, eventsForAGivenMonthOrderedChronologically2);
    assert(eventsForAGivenMonthOrderedChronologically2.size() == 4);

}

void Test::testAddEventToUserList()
{
    std::tm dateAndTime = std::tm();
    this->service.setDateAndTime(1,1,2023,20, dateAndTime);
    std::string title = "test", description = "test", link = "test";
    int numberOfPeople = 1;
    this->service.addEventService(title, description, dateAndTime, numberOfPeople, link);
    assert(this->service.addEventToUserList(title, numberOfPeople) == 0);
    numberOfPeople = 2;
    assert(this->service.addEventToUserList(title, numberOfPeople) == 1);
    assert((int)this->service.getUserList().size() == 1);

}

void Test::testDeleteEventFromUserList()
{
    std::string title = "test2";
    int numberOfPeople = 2;
    assert(this->service.deleteEventFromUserList(title, numberOfPeople) == 1);
    title = "test";
    numberOfPeople = 2;
    assert(this->service.deleteEventFromUserList(title, numberOfPeople) == 0);


}

void Test::testAll()
{
    
    this->testAddEvent();
    this->testUpdateEvent();
    this->testDeleteEvent();
    this->testGetAllEvents();
    this->testAddTenEventsToRepository();
    this->testGetEventsForAGivenMonthOrderedChronologically();
    this->testAddEventToUserList();
    this->testDeleteEventFromUserList();
}
