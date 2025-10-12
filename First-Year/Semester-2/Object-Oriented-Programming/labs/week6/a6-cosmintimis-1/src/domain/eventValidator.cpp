#include "eventValidator.h"

int checkIfAnEventIsValid(std::string &title, std::string &description, std::tm &dateAndTime, int &numberOfPeople, std::string &link)
{
    if (title.length() == 0)
        return 1;
    if (description.length() == 0)
        return 1;
    if (dateAndTime.tm_year < -1900 || dateAndTime.tm_mday < 1 || dateAndTime.tm_mon < 0 || dateAndTime.tm_hour < 0)
        return 1;
    if (numberOfPeople < 0)
        return 1;
    if(link.length() == 0)
        return 1;

    return 0;
}