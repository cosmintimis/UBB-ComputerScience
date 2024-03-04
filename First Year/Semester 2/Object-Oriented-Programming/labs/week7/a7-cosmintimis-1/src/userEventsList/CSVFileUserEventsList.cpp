#include "CSVFileUserEventsList.h"
#include <fstream>
#include "../repository/repositoryException.h"
#include <cstdlib>
void CSVFileUserEventsList::writeToFile()
{
    std::ofstream file(this->filename);
	if (!file.is_open())
		throw FileException("The file could not be opened!");

	for (auto s : this->listOfUserEvents)
	{
		file << s;
	}
	
	file.close();

}

void CSVFileUserEventsList::displayUserEventsList()
{
    std::string command = "libreoffice --calc " + this->filename;
    system(command.c_str());
}
