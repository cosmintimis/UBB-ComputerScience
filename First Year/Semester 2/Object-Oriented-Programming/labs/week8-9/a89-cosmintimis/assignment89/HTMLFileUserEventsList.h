#pragma once

#include "fileUserEventsList.h"

class HTMLFileUserEventsList : public FileUserEventsList
{
    public:
        HTMLFileUserEventsList(const std::string& f) : FileUserEventsList{f} {}
        ~HTMLFileUserEventsList() {}
        void writeToFile() override;
        void displayUserEventsList() override;
};