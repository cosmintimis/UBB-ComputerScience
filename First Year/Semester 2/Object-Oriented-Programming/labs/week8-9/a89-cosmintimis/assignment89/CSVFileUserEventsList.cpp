#include "CSVFileUserEventsList.h"
#include <fstream>
#include "repositoryException.h"
#include <cstdlib>
#include <QCoreApplication>
#include <QProcess>
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
//    std::string command = "libreoffice --calc " + this->filename;
//    system(command.c_str());
    QStringList arguments;
    arguments << QString::fromStdString(this->filename);

    QProcess::startDetached("notepad.exe", arguments);
}
