#pragma once
#include "../domain/event.h"

class Repository
{
    private:
        std::vector<Event> data;
        std::string filename;
        void readFromFile();
        void writeToFile();

    public:
        Repository(const std::string& ); 
        ~Repository();
        void addEvent(Event);
        void deleteEvent(int);
        void updateFile();
        std::vector<Event>& getAll();
        int getSize(); 

};