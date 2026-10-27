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
    std::tm dateAndTime = std::tm();
    this->service.setDateAndTime(1, 1, 2023, 20, dateAndTime);
    std::string title = "test", description = "test", link = "www.test";
    int numberOfPeople = 1;
    Event test(title, description, dateAndTime, numberOfPeople, link);

    try
    {
        this->service.addEventService(title, description, dateAndTime, numberOfPeople, link);
        assert(true);
    }
    catch (...)
    {
        if (this->service.searchForEvent(title, numberOfPeople) == -1)
            assert(false);
        else
            assert(true);
    }

    int size = this->service.numberOfEvents() - 1;

    assert(test == this->service.getEvent(size));
    std::string newTitle = "newTitle";
    test.updateTitle(newTitle);
    if (test == this->service.getEvent(size))
        assert(false);
    else
        assert(true);

    try
    {
        this->service.addEventService(title, description, dateAndTime, numberOfPeople, link);
        assert(false);
    }
    catch (...)
    {
        assert(true);
    }

    assert(this->service.getEvent(size).getTitle() == title);
    assert(this->service.getEvent(size).getDescription() == description);
    assert(this->service.getEvent(size).getLink() == link);
    assert(this->service.getEvent(size).getNumberOfPeople() == numberOfPeople);
    assert(this->service.getEvent(size).getDateAndTime().tm_mday == dateAndTime.tm_mday);
    title = "";

    try
    {
        this->service.addEventService(title, description, dateAndTime, numberOfPeople, link);
        assert(false);
    }
    catch (...)
    {
        assert(true);
    }

    title = "test";
    description = "";

    try
    {
        this->service.addEventService(title, description, dateAndTime, numberOfPeople, link);
        assert(false);
    }
    catch (...)
    {
        assert(true);
    }

    description = "test";
    link = "";

    try
    {
        this->service.addEventService(title, description, dateAndTime, numberOfPeople, link);
        assert(false);
    }
    catch (...)
    {
        assert(true);
    }

    link = "test";
    numberOfPeople = -1;

    try
    {
        this->service.addEventService(title, description, dateAndTime, numberOfPeople, link);
        assert(false);
    }
    catch (...)
    {
        assert(true);
    }
    numberOfPeople = 1;
    dateAndTime.tm_year = -5000;

    try
    {
        this->service.addEventService(title, description, dateAndTime, numberOfPeople, link);
        assert(false);
    }
    catch (...)
    {
        assert(true);
    }
    dateAndTime.tm_year = 2023 - 1900;

    std::cout << "Test add event passed!" << std::endl;
}

void Test::testDeleteEvent()
{
    std::string title = "test";
    int numberOfPeople = 1;

    try
    {
        this->service.deleteEventService(title, numberOfPeople);
        assert(true);
    }
    catch (...)
    {
        assert(false);
    }

    title = "test2";
    numberOfPeople = 2;

    try
    {
        this->service.deleteEventService(title, numberOfPeople);
        assert(false);
    }
    catch (...)
    {
        assert(true);
    }

    std::cout << "Test delete event passed!" << std::endl;
}

void Test::testUpdateEvent()
{
    std::string title = "test2";
    int numberOfPeople = 1000;

    std::string newTitle = "test", newDescription = "test2", newLink = "test2";
    int newNumberOfPeople = 1;
    std::tm newDateAndTime = std::tm();

    try
    {
        this->service.updateAnEvent(newTitle, newDescription, newDateAndTime, newNumberOfPeople, newLink, title, numberOfPeople);
        assert(false);
    }
    catch (...)
    {
        assert(true);
    }

    title = "test";
    numberOfPeople = 1;

    try
    {
        this->service.updateAnEvent(newTitle, newDescription, newDateAndTime, newNumberOfPeople, newLink, title, numberOfPeople);
        assert(false);
    }
    catch (...)
    {
        assert(true);
    }

    this->service.setDateAndTime(1, 1, 2023, 20, newDateAndTime);

    try
    {
        this->service.updateAnEvent(newTitle, newDescription, newDateAndTime, newNumberOfPeople, newLink, title, numberOfPeople);
        assert(false);
    }
    catch (...)
    {
        assert(true);
    }

    newTitle = "test2";
    newNumberOfPeople = 2;

    try
    {
        this->service.updateAnEvent(newTitle, newDescription, newDateAndTime, newNumberOfPeople, newLink, title, numberOfPeople);
        assert(false);
    }
    catch (...)
    {
        assert(true);
    }

    std::cout << "Test update event passed!" << std::endl;
}

void Test::testGetAllEvents()
{
    assert((int)this->service.getAllEvents().size() == (int)this->service.numberOfEvents());
}

void Test::testAll()
{

    this->testAddEvent();
    this->testUpdateEvent();
    this->testDeleteEvent();
    this->testGetAllEvents();
}
