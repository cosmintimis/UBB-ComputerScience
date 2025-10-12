#include "eventValidator.h"

EventException::EventException(std::vector<std::string> errors)
{
    this->errors = errors;
}

std::vector<std::string> EventException::getErrors() const
{
    return this->errors;
}

void EventValidator::validate(Event event)
{
    std::vector<std::string> errors;
    if (event.getTitle().size() < 3)
        errors.push_back("The title name cannot be less than 3 characters!\n");

    if (event.getDescription().size() < 3)
        errors.push_back("The description cannot be less than 3 characters!\n");

    std::tm date = event.getDateAndTime();
    if (date.tm_year < -1900)
        errors.push_back("The year cannot be less than 0!\n");
    if (date.tm_mon < 0 || date.tm_mon > 11)
        errors.push_back("The month must be between 1 and 12!\n");
    if (date.tm_mday < 1 || date.tm_mday > 31)
        errors.push_back("The day must be between 1 and 31!\n");
    if (date.tm_hour < 0 || date.tm_hour > 23)
        errors.push_back("The hour must be between 0 and 23!\n");
    if (event.getNumberOfPeople() < 0)
        errors.push_back("The number of people cannot be less than 0!\n");
    size_t posWww = event.getLink().find("www");
    size_t posHttp = event.getLink().find("http");
    if (posWww != 0 && posHttp != 0)
        errors.push_back("The youtube source must start with one of the following strings: \"www\" or \"http\" !\n");
    if (errors.size() > 0)
        throw EventException(errors);
}
