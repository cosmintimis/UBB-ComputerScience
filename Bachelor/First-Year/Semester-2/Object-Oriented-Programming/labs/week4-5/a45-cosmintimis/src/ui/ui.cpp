#include "ui.h"

Ui::Ui()
{
}

Ui::~Ui()
{
}

void Ui::startMenu()
{
    std::cout << "1. Administator mode" << std::endl;
    std::cout << "2. User mode" << std::endl;
    std::cout << "0. Exit" << std::endl;
    std::cout << "Select mode: ";
}

void Ui::administratorMenu()
{
    std::cout << "1. Add new event" << std::endl;
    std::cout << "2. Delete existing event" << std::endl;
    std::cout << "3. Update existing event" << std::endl;
    std::cout << "4. Display all events" << std::endl;
    std::cout << "5. Back" << std::endl;
    std::cout << "Your option: ";
}

void Ui::userMenu()
{
    std::cout << "1. See the events in the database for a given month, one by one" << std::endl;
    std::cout << "2. Delete an event from your list" << std::endl;
    std::cout << "3. Display your list of events" << std::endl;
    std::cout << "4. Back" << std::endl;
    std::cout << "Your option: ";
}

void Ui::flushStdin()
{
    std::cin.clear();
    std::cin.ignore(INT_MAX, '\n');
}

void Ui::readEventFromKeyboard(std::string &title, std::string &description, std::tm &dateAndTime, int &numberOfPeople, std::string &link)
{
    int day = 0, month = 0, year = 0, hour = 0;
    std::cout << std::endl
              << "Title:";
    flushStdin();
    std::getline(std::cin, title);
    std::cout << "Description:";
    std::getline(std::cin, description);
    std::cout << "Date (dd/mm/yyyy):" << std::endl;
    std::cout << "\tDay: ";
    std::cin >> day;
    flushStdin();
    std::cout << "\tMonth: ";
    std::cin >> month;
    flushStdin();
    std::cout << "\tYear: ";
    std::cin >> year;
    flushStdin();
    std::cout << "\tHour: ";
    std::cin >> hour;
    flushStdin();
    std::cout << "Number of people: ";
    std::cin >> numberOfPeople;
    flushStdin();
    std::cout << "Link:";
    std::getline(std::cin, link);

    dateAndTime.tm_mday = day;
    dateAndTime.tm_mon = month - 1;
    dateAndTime.tm_year = year - 1900;
    dateAndTime.tm_hour = hour;
}

void Ui::secondUserMenu()
{
    std::cout << "1. Add current event to your list" << std::endl;
    std::cout << "2. Next" << std::endl;
    std::cout << "3. Stop" << std::endl;
    std::cout << "Your option: ";
}

void Ui::start()
{
    int option;
    std::cout << "Welcome!" << std::endl;
    this->service.addTenEventsToRepository();
    do
    {
        option = -1;
        startMenu();
        std::cin >> option;
        if (std::cin.fail())
        {
            flushStdin();
            option = -1;
        }

        switch (option)
        {
        case 1:
        {
            do
            {
                option = -1;
                administratorMenu();
                std::cin >> option;
                if (std::cin.fail())
                {
                    flushStdin();
                    option = -1;
                }
                std::string title = "", description = "", link = "";
                int numberOfPeople = -1;
                std::tm dateAndTime = {0};
                switch (option)
                {
                case 1:
                {
                    std::cout << "Provide title, description, date and time, number of people and link to add new event: ";
                    readEventFromKeyboard(title, description, dateAndTime, numberOfPeople, link);

                    int statusOfAddEvent = this->service.addEventService(title, description, dateAndTime, numberOfPeople, link);

                    if (statusOfAddEvent == 0)
                        std::cout << "Succesfully!" << std::endl;
                    else if (statusOfAddEvent == 1)
                        std::cout << "Invalid input! --- try again ---!" << std::endl;
                    else
                        std::cout << "Provided event already exists!" << std::endl;
                    break;
                }
                case 2:
                {
                    std::cout << std::endl
                              << "To delete an event enter the title and the number of people who are going:";
                    std::cout << std::endl
                              << "Title:";
                    flushStdin();
                    std::getline(std::cin, title);
                    std::cout << "Number of people: ";
                    std::cin >> numberOfPeople;
                    flushStdin();

                    int statusOfDeleteEvent = this->service.deleteEventService(title, numberOfPeople);

                    if (statusOfDeleteEvent == 0)
                        std::cout << "Succesfully!" << std::endl;
                    else if (statusOfDeleteEvent == 1)
                        std::cout << "Provided event doesn't exist!" << std::endl;

                    break;
                }
                case 3:
                {
                    std::string newTitle = "", newDescription = "", newLink = "";
                    int newNumberOfPeople = -1;
                    std::tm newDateAndTime = {0};
                    std::cout << std::endl
                              << "To update an event enter the title and the number of people who are going:";
                    std::cout << std::endl
                              << "Title:";
                    flushStdin();
                    std::getline(std::cin, title);
                    std::cout << "Number of people: ";
                    std::cin >> numberOfPeople;

                    std::cout << "Provide new title, new description, new date and time, new number of people and new link: ";
                    readEventFromKeyboard(newTitle, newDescription, newDateAndTime, newNumberOfPeople, newLink);

                    int statusOfUpdateEvent = this->service.updateAnEvent(newTitle, newDescription, newDateAndTime, newNumberOfPeople, newLink, title, numberOfPeople);

                    if (statusOfUpdateEvent == 0)
                        std::cout << "Succesfully!" << std::endl;
                    else if (statusOfUpdateEvent == 1)
                        std::cout << "Updated event already exists!" << std::endl;
                    else if (statusOfUpdateEvent == 2)
                        std::cout << "Invalid input! --- try again ---!" << std::endl;
                    else
                        std::cout << "There's no event with that title and number of people!" << std::endl;

                    break;
                }
                case 4:
                {
                    int numberOfEvents = this->service.numberOfEvents();
                    for (int i = 0; i < numberOfEvents; i++)
                    {
                        std::cout << this->service.getEvent(i) << std::endl;
                    }
                    if (numberOfEvents == 0)
                        std::cout << "There's no events!" << std::endl;
                    break;
                }

                case 5:
                    break;

                default:
                    std::cout << "Invalid command!" << std::endl;
                    break;
                }
            } while (option != 5);

            break;
        }
        case 2:

            do
            {
                option = -1;
                userMenu();
                std::cin >> option;
                if (std::cin.fail())
                {
                    flushStdin();
                    option = -1;
                }
                switch (option)
                {
                case 1:
                {
                    int valueOfMonth;
                    std::string month = "";
                    std::cout << "Enter the month(empty means all): ";
                    flushStdin();
                    std::getline(std::cin, month);

                    if (month.length() == 0)
                        valueOfMonth = 0;
                    else
                    {
                        try
                        {
                            valueOfMonth = std::stoi(month);
                        }
                        catch (...)
                        {
                            std::cout << "try again!" << std::endl;
                            break;
                        }
                    }

                    DynamicVector<Event> eventsForAGivenMonthOrderedChronologically;
                    this->service.getEventsForAGivenMonthOrderedChronologically(valueOfMonth, eventsForAGivenMonthOrderedChronologically);

                    if(eventsForAGivenMonthOrderedChronologically.getSize() == 0)
                    {
                        std::cout << "There's no events for that month!" << std::endl;
                        break;
                    }

                    int index = 0, stop = -1, option = 2;
                    do
                    {

                        if(option == 2)
                        {
                            std::cout << eventsForAGivenMonthOrderedChronologically.getElemByIndex(index) << std::endl;

                            std::string link = eventsForAGivenMonthOrderedChronologically.getElemByIndex(index).getLink();
                            std::string command = "open " + link + " >/dev/null 2>&1 &";
                            system(command.c_str());
                        }

                        this->secondUserMenu();
                        std::cin >> option;
                        if (std::cin.fail())
                        {
                            flushStdin();
                            option = -1;
                        }

                        switch (option)
                        {
                        case 1:
                        {
                        
                            std::string titleOfCurrentEvent = eventsForAGivenMonthOrderedChronologically.getElemByIndex(index).getTitle();
                            int numberOfPeopleOfCurrentEvent = eventsForAGivenMonthOrderedChronologically.getElemByIndex(index).getNumberOfPeople();
                            int statusOfAddEventToUserList = this->service.addEventToUserList(titleOfCurrentEvent, numberOfPeopleOfCurrentEvent);
                            if (statusOfAddEventToUserList == 0)
                            {
                                std::cout << "Succesfully!" << std::endl;
                                numberOfPeopleOfCurrentEvent += 1;
                                eventsForAGivenMonthOrderedChronologically.getElemByIndex(index).updateNumberOfPeople(numberOfPeopleOfCurrentEvent);
                            }
                            else if (statusOfAddEventToUserList == 1)
                                std::cout << "Already added!" << std::endl;
                            break;
                        }
                        case 2:
                            if (index == eventsForAGivenMonthOrderedChronologically.getSize() - 1)
                                index = 0;
                            else
                                index++;
                            break;
                        case 3:
                            stop = 1;
                            break;
                        default:
                            std::cout << "Invalid command!" << std::endl;
                            break;
                        }

                    } while (stop == -1);
                    break;
                }
                case 2:
                {
                    std::string title;
                    int numberOfPeople;
                    std::cout << std::endl
                              << "To delete an event from your list enter the title and the number of people who are going:";
                    std::cout << std::endl
                              << "Title:";
                    flushStdin();
                    std::getline(std::cin, title);
                    std::cout << "Number of people: ";
                    std::cin >> numberOfPeople;
                    flushStdin();

                    int statusOfDeleteEventFromUserList = this->service.deleteEventFromUserList(title, numberOfPeople);

                    if (statusOfDeleteEventFromUserList == 0)
                        std::cout << "Succesfully!" << std::endl; 
                    else if (statusOfDeleteEventFromUserList == 1)
                        std::cout << "Provided event doesn't exist! --- try again" << std::endl;

                    break;
                }
                case 3:
                {
                    int lengthOfUserList = this->service.getUserList().getSize();
                    DynamicVector<Event> userEvents = this->service.getUserList();
                    for (int i = 0; i < lengthOfUserList; i++)
                    {
                        std::cout << userEvents.getElemByIndex(i) << std::endl;
                    }
                    if (lengthOfUserList == 0)
                        std::cout << "There's no events!" << std::endl;

                    break;
                }
                case 4:
                    break;
                default:
                    std::cout << "Invalid command!" << std::endl;
                    break;
                }
            } while (option != 4);
            break;
        case 0:
            break;
        default:
            std::cout << "Invalid command!" << std::endl;
            break;
        }
    } while (option != 0);
}
