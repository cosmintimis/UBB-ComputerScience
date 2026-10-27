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

void Event::openLink()
{

//    std::string command = "open " + this->link + " >/dev/null 2>&1 &";
//    system(command.c_str());
    QString url = QString::fromStdString(this->link);
    QDesktopServices::openUrl(QUrl(url));
}

void Event::updateTitle(std::string &title)
{
    this->title = title;
    
}

std::string Event::toString()
{
    std::string result;

    result += this->title + " | " + this->description + " | ";

    char dt[100];
    std::strftime(dt, sizeof(dt), "%d/%m/%Y %H:%M", &(this->dateAndTime));

    result += std::string(dt) + " | " + std::to_string(this->numberOfPeople) + " | " + this->link;

    return result;
}
std::ostream &operator<<(std::ostream &os, const Event &event)
{
    os << '\"' << event.title << "\"," << '\"' <<  event.description << "\"," << std::put_time(&event.dateAndTime, "%d/%m/%Y %H:%M")  << "," << event.numberOfPeople << "," << '\"' << event.link << "\"\n"; 
    return os; 
}

std::istream &operator>>(std::istream &is, Event &e)
{
    std::string line;
    std::getline(is, line);
    std::vector<std::string> tokens;
    int i = 0;
    std::string token;
    while(i < line.size())
    {
        if(line[i] == '"')
        {
            i++;
            while(line[i] != '"' && i < line.size())
            {
                token += line[i];
                i++;
            }
            i += 2;
            tokens.push_back(token);
            token.clear();
        }
        else
        {
            while(line[i] != ',' && i < line.size())
            {
                token += line[i];
                i++;
            }
            i++;
            tokens.push_back(token);
            token.clear();
        }

       
    }
    if(tokens.size() != 5)
        return is;
    e.title = tokens[0];
    e.description = tokens[1];
    std::stringstream ss2(tokens[2]);
    ss2 >> std::get_time(&e.dateAndTime, "%d/%m/%Y %H:%M");
    e.numberOfPeople = std::stoi(tokens[3]);
    e.link = tokens[4];
    return is;
}

bool operator==(const Event &e1, const Event &e2)
{
    if(e1.title == e2.title && e1.numberOfPeople == e2.numberOfPeople )
        return true;
    return false;
}



