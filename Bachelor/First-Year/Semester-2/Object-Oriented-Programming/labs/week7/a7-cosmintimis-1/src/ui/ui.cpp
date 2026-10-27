#include "ui.h"

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

void Ui::displayEvent(Event& event)
{
    std::string asteriks(50, '*');
    std::cout << asteriks << std::endl;
    std::cout << "Title: " << event.getTitle() << std::endl;
    std::cout << "Description: " << event.getDescription() << std::endl;
    std::tm dateAndTime = event.getDateAndTime();
    std::cout << "Date and time: " << std::put_time(&dateAndTime, "%d/%m/%Y %H:%M") << std::endl;
    std::cout << "Number of people: " << event.getNumberOfPeople() << std::endl;
    std::cout << "Link: " << event.getLink() << std::endl;
    std::cout << asteriks << std::endl
              << std::endl;
}

void Ui::start()
{
    int option;
    std::cout << "Welcome!" << std::endl;
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

                    try
                    {

                        this->service.addEventService(title, description, dateAndTime, numberOfPeople, link);
                        std::cout << "Succesfully!" << std::endl;
                    }
                    catch (RepositoryException &e)
                    {
                        std::cout << e.what();
                    }
                    catch (EventException &e)
                    {
                        for (auto &msg : e.getErrors())
                            std::cout << msg;
                    }

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

                    try
                    {

                        this->service.deleteEventService(title, numberOfPeople);
                        std::cout << "Succesfully!" << std::endl;
                    }
                    catch (RepositoryException &e)
                    {
                        std::cout << e.what();
                    }

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

                    try
                    {

                        this->service.updateAnEvent(newTitle, newDescription, newDateAndTime, newNumberOfPeople, newLink, title, numberOfPeople);
                        std::cout << "Succesfully!" << std::endl;
                    }
                    catch (RepositoryException &e)
                    {
                        std::cout << e.what();
                    }
                    catch (EventException &e)
                    {
                        for (auto &msg : e.getErrors())
                            std::cout << msg;
                    }

                    break;
                }
                case 4:
                {
                    for (auto event : this->service.getAllEvents())
                    {
                        this->displayEvent(event);
                    }
                    if ((int)this->service.getAllEvents().size() == 0)
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

                    std::vector<Event> eventsForAGivenMonthOrderedChronologically;
                    this->service.getEventsForAGivenMonthOrderedChronologically(valueOfMonth, eventsForAGivenMonthOrderedChronologically);

                    if ((int)eventsForAGivenMonthOrderedChronologically.size() == 0)
                    {
                        std::cout << "There's no events for that month!" << std::endl;
                        break;
                    }

                    int index = 0, stop = -1, option = 2;
                    do
                    {

                        if (option == 2)
                        {
                            this->displayEvent(eventsForAGivenMonthOrderedChronologically[index]);
                            eventsForAGivenMonthOrderedChronologically[index].openLink();
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

                            std::string titleOfCurrentEvent = eventsForAGivenMonthOrderedChronologically[index].getTitle();
                            int numberOfPeopleOfCurrentEvent = eventsForAGivenMonthOrderedChronologically[index].getNumberOfPeople();

                            try
                            {

                                this->service.addEventToUserList(titleOfCurrentEvent, numberOfPeopleOfCurrentEvent);
                                numberOfPeopleOfCurrentEvent += 1;
                                eventsForAGivenMonthOrderedChronologically[index].updateNumberOfPeople(numberOfPeopleOfCurrentEvent);
                                std::cout << "Succesfully!" << std::endl;
                            }
                            catch (RepositoryException &e)
                            {
                                std::cout << e.what();
                            }
                            catch (FileException &e)
                            {
                                std::cout << e.what();
                            }
                            break;
                        }
                        case 2:
                            if (index == (int)eventsForAGivenMonthOrderedChronologically.size() - 1)
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

                    try
                    {

                        this->service.deleteEventFromUserList(title, numberOfPeople);

                        std::cout << "Succesfully!" << std::endl;
                    }
                    catch (RepositoryException &e)
                    {
                        std::cout << e.what();
                    }
                    catch (FileException &e)
                    {
                        std::cout << e.what();
                    }

                    break;
                }
                case 3:
                {
                    int lengthOfUserList = (int)this->service.getUserList().size();
                    if (lengthOfUserList == 0)
                        std::cout << "There's no events!" << std::endl;
                    else  
                        this->service.displayUserEventsList();
                    


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
