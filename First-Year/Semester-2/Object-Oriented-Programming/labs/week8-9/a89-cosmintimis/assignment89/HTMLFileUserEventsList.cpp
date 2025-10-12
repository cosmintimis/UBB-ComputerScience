#include "HTMLFileUserEventsList.h"
#include <fstream>
#include "repositoryException.h"
#include <cstdlib>
void HTMLFileUserEventsList::writeToFile()
{
    std::ofstream f(this->filename);
    if (!f.is_open())
		throw FileException("The file could not be opened!");
    f << "<!DOCTYPE html>\n";
    f << "<html>\n";
    f << "<head>\n";
    f << "<title>Events</title>\n";
    f << "</head>\n";
    f << "<body>\n";
    f << "<table border=\"1\">\n";
    f << "<tr>\n";
    f << "<td>Title</td>\n";
    f << "<td>Description</td>\n";
    f << "<td>Date and Time</td>\n";
    f << "<td>Number of people</td>\n";
    f << "<td>Facebook Events link</td>\n";
    f << "</tr>\n";
    for (auto event : this->listOfUserEvents)
    {
        f << "<tr>\n";
        f << "<td>" << event.getTitle() << "</td>\n";
        f << "<td>" << event.getDescription() << "</td>\n";
        std::tm dateAndTime = event.getDateAndTime();
        f << "<td>" << std::put_time(&dateAndTime, "%d/%m/%Y %H:%M") << "</td>\n";
        f << "<td>" << event.getNumberOfPeople() << "</td>\n";
        f << "<td><a href=\"" << event.getLink() << "\">Link</a></td>\n";
        f << "</tr>\n";
    }
    f << "</table>\n";
    f << "</body>\n";
    f << "</html>\n";
    f.close();
}

void HTMLFileUserEventsList::displayUserEventsList()
{
//    std::string command = "open " + this->filename + " >/dev/null 2>&1 &";
//    system(command.c_str());
//    QString c = QString::fromStdString(command);
//    system(qPrintable(c));
    QUrl url = QUrl::fromLocalFile(QString::fromStdString(this->filename));
    QDesktopServices::openUrl(QUrl(url));

}
