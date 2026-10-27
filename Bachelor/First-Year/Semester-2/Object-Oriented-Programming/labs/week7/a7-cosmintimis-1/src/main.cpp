#include "ui/ui.h"
#include "tests/tests.h"
#include "./userEventsList/CSVFileUserEventsList.h"
#include "./userEventsList/HTMLFileUserEventsList.h"

void run()
{
    try
    {
        Repository repo("./src/repository/events.txt");
        FileUserEventsList* p = nullptr;
        std::cout << "What type of file would you like to use to store the user event list (CSV/HTML)? \nYour choice:";
        std::string fileType{};
        std::cin >> fileType;
        while (fileType != "CSV" && fileType != "HTML")
        {
            std::cout << "Invalid file type! Please try again: ";
            std::cin >> fileType;
        }
       
        if (fileType == "CSV")
        {
            p = new CSVFileUserEventsList{"./src/userEventsList/events.csv"};
        }
        else
        {
            p = new HTMLFileUserEventsList{"./src/userEventsList/events.html"};
        }

        Service service(repo, p);
        Ui ui(service);
        ui.start();


        // delete p;
        // p = nullptr;
    }
    catch (FileException &)
    {
        std::cout << "Repository file could not be opened! The application will terminate. \n" << std::endl;
    }
}

void tests()
{
    Test test;
    test.testAll();
}

int main()
{
    // tests();
    run();

    return 0;
}