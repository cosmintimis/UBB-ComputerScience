#pragma once
#include "userEventsList.h"

class FileUserEventsList : public UserEventsList
{
    protected:
        std::string filename; 
    public:
        FileUserEventsList(const std::string& f) : filename{f} {}
        virtual ~FileUserEventsList() {}
        virtual void writeToFile() = 0;
	    virtual void displayUserEventsList() = 0;
       
};