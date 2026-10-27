#pragma once

#include "fileUserEventsList.h"

class CSVFileUserEventsList : public FileUserEventsList
{
    public:
        CSVFileUserEventsList(const std::string& f) : FileUserEventsList{f} {}
        ~CSVFileUserEventsList() {}
        void writeToFile() override;
        void displayUserEventsList() override;
};