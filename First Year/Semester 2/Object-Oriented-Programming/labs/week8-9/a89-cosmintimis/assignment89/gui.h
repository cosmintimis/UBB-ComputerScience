#pragma once

#include "service.h"
#include "eventValidator.h"
#include "CSVFileUserEventsList.h"
#include "HTMLFileUserEventsList.h"
#include <QtWidgets/QApplication>
#include <QtWidgets/QLabel>
#include <QtWidgets/QPushButton>
#include <QtWidgets/qboxlayout.h>
#include <QtWidgets/qlineedit.h>
#include <QtWidgets/qformlayout.h>
#include <QtWidgets/qlistwidget.h>
#include <QFont>
#include <qdebug.h>
#include <qmessagebox.h>

using namespace std;

class GUI : public QWidget
{
public:
	GUI() 
	{ 

		run();
        initConnect();
    }
    ~GUI() {}

private:

    Repository repo{"./events.txt"};
    Service* service;
    Event selectedEvent,selectedEvent2;
	
	QListWidget* listWithData = new QListWidget{}; 
	QPushButton* exitButton = new QPushButton{ "&Exit" }; 
	QPushButton* addButton = new QPushButton{ "&Add" };
	QPushButton* deleteButton = new QPushButton{ "&Delete" };
	QPushButton* updateButton = new QPushButton{ "&Update" };
	QLineEdit* titleTextBox = new QLineEdit{};
    QLineEdit* descriptionTextBox = new QLineEdit{};
    QLineEdit* dateAndTimeTextBox = new QLineEdit{};
    QLineEdit* numberOfPeopleTextBox = new QLineEdit{};
	QLineEdit* linkTextBox = new QLineEdit{};
    QWidget* userSelectedFileType = new QWidget;
    QWidget* userMainWindow = new QWidget;
    QPushButton* HTMLButton = new QPushButton{ "&HTML" };
    QPushButton* CSVButton = new QPushButton{ "&CSV" };
    QLabel* infoUser = new QLabel{"Please choose the type of the file:"};
    QLabel* currentEvent = new QLabel{""};
    QPushButton* sortBtn = new QPushButton{ "&Sort by month" };
    QLineEdit* getMonth = new QLineEdit;
    QPushButton* nextBtn = new QPushButton{ "&Next" };
    QPushButton* addBtn = new QPushButton{ "&Add" };
    QListWidget* userData = new QListWidget{};
    std::vector<Event> sortEvents;
    int indexOfUserCurrentEvent = -1;
    QLineEdit* titleTextBox2 = new QLineEdit{};
    QLineEdit* descriptionTextBox2 = new QLineEdit{};
    QLineEdit* dateAndTimeTextBox2 = new QLineEdit{};
    QLineEdit* numberOfPeopleTextBox2 = new QLineEdit{};
    QLineEdit* linkTextBox2 = new QLineEdit{};
    QPushButton* deleteBtn = new QPushButton{ "&Delete" };
    QPushButton* displayBtn = new QPushButton{ "&Display user list(file)" };

    void initConnect()
    {

        QObject::connect(displayBtn, &QPushButton::clicked, [&]() {
            service->displayUserEventsList();
        });

        QObject::connect(deleteBtn, &QPushButton::clicked, [&]() {

            try
            {
                auto title = selectedEvent2.getTitle();
                auto numberOfPeople = selectedEvent2.getNumberOfPeople();
                this->service->deleteEventFromUserList(title, numberOfPeople);
                for(auto i = 0 ; i < sortEvents.size(); i++)
                    if(sortEvents[i].getTitle() == title && sortEvents[i].getNumberOfPeople() == numberOfPeople)
                    {
                        numberOfPeople -= 1;
                        sortEvents[i].updateNumberOfPeople(numberOfPeople);
                    }
                currentEvent->setText(QString::fromStdString(sortEvents[indexOfUserCurrentEvent].toString()));
                loadData();

            }
            catch (exception& )
            {
                QMessageBox::critical(this, "Error", "Item not in list");

            }

            loadData();
        });

        QObject::connect(addBtn, &QPushButton::clicked, [&]() {
            if(indexOfUserCurrentEvent != -1)
            {
                auto eventTitle = sortEvents[indexOfUserCurrentEvent].getTitle();
                auto numberOfPeople = sortEvents[indexOfUserCurrentEvent].getNumberOfPeople();
                try{
                    service->addEventToUserList(eventTitle, numberOfPeople);
                    numberOfPeople++;
                    sortEvents[indexOfUserCurrentEvent].updateNumberOfPeople(numberOfPeople);
                    currentEvent->setText(QString::fromStdString(sortEvents[indexOfUserCurrentEvent].toString()));
                    loadData();
                }
                catch (RepositoryException&)
                {
                    QMessageBox::critical(this, "Error", "Event already added");
                }

            }
        });

        QObject::connect(sortBtn, &QPushButton::clicked, [&]() {
            sortEvents.clear();
            auto month = getMonth->text().toInt();
            service->getEventsForAGivenMonthOrderedChronologically(month, sortEvents);
            if(sortEvents.size() > 0)
            {
                currentEvent->setText(QString::fromStdString(sortEvents[0].toString()));
                indexOfUserCurrentEvent = 0;
                sortEvents[0].openLink();
            }
            else
            {
                indexOfUserCurrentEvent = -1;
            }
        });

        QObject::connect(nextBtn, &QPushButton::clicked, [&]() {

            if(indexOfUserCurrentEvent != -1)
            {
                indexOfUserCurrentEvent += 1;
                if(indexOfUserCurrentEvent >= sortEvents.size())
                    indexOfUserCurrentEvent = 0;
                currentEvent->setText(QString::fromStdString(sortEvents[indexOfUserCurrentEvent].toString()));
                sortEvents[indexOfUserCurrentEvent].openLink();
            }
        });


        QObject::connect(HTMLButton, &QPushButton::clicked, [&]() {
            FileUserEventsList* p = new HTMLFileUserEventsList{"./userEvents.html"};
            service = new Service{repo, p};
            loadData();
            userSelectedFileType->close();
            show();
            userMainWindow->show();
        });

        QObject::connect(CSVButton, &QPushButton::clicked, [&]() {
            FileUserEventsList* p = new CSVFileUserEventsList{"./userEvents.csv"};
            service = new Service{repo, p};
            loadData();
            userSelectedFileType->close();
            show();
            userMainWindow->show();
        });

		QObject::connect(exitButton, &QPushButton::clicked, [&]() {
			close();
			});
		QObject::connect(addButton, &QPushButton::clicked, [&]() {
			auto name = titleTextBox->text();
            auto description = descriptionTextBox->text();
            auto duration = dateAndTimeTextBox->text();
            auto numberOfPeople = numberOfPeopleTextBox->text();
			auto link = linkTextBox->text();
			
			try
			{
                std::string format = "%d/%m/%Y %H:%M";
                std::tm dateTime = this->service->convertStringToTm(duration.toStdString(), format);
                this->service->addEventService(name.toStdString(), description.toStdString(), dateTime, stoi(numberOfPeople.toStdString()), link.toStdString());
			}
			catch (exception&)
			{
                QMessageBox::critical(this, "Error", "Event already in list");
			}
            catch (EventException&)
			{
				QMessageBox::critical(this, "Error", "Please introduce valid input");
			}

			loadData(); 
			});

		QObject::connect(deleteButton, &QPushButton::clicked, [&]() {

			try
			{
                this->service->deleteEventService(selectedEvent.getTitle(), selectedEvent.getNumberOfPeople());

			}
			catch (exception& )
			{
				QMessageBox::critical(this, "Error", "Item not in list");

			}

			loadData(); 
			});

		QObject::connect(updateButton, &QPushButton::clicked, [&]() {
			auto title = titleTextBox->text(); 
            auto description = descriptionTextBox->text();
            auto duration = dateAndTimeTextBox->text();
            auto numberOfPeople = numberOfPeopleTextBox->text();
			auto link = linkTextBox->text(); 

			try
			{
                std::string format = "%d/%m/%Y %H:%M";
                std::tm dateTime = this->service->convertStringToTm(duration.toStdString(), format);
                this->service->updateAnEvent(title.toStdString(), description.toStdString(), dateTime, stoi(numberOfPeople.toStdString()), link.toStdString(), selectedEvent.getTitle(), selectedEvent.getNumberOfPeople());

			}
            catch (EventException&)
			{
				QMessageBox::critical(this, "Error", "Please introduce valid input");
			}
            catch(...)
            {
                QMessageBox::critical(this, "Error", "Please introduce valid input");
            }

			loadData(); 
			});

		QObject::connect(listWithData, &QListWidget::itemSelectionChanged, [&]() {
			auto selected = listWithData->selectedItems();
			if (selected.isEmpty())
			{
				titleTextBox->setText("");
                descriptionTextBox->setText("");
                dateAndTimeTextBox->setText("");
                numberOfPeopleTextBox->setText("");
				linkTextBox->setText("");

                selectedEvent = Event{};

				return;
			}
			else
			{
                auto item = selected.at(0);
                auto parts = item->text().split(" | ");
                titleTextBox->setText(parts.at(0));
                titleTextBox->setCursorPosition(0);
                descriptionTextBox->setText(parts.at(1));
                descriptionTextBox->setCursorPosition(0);

                // Convert string to std::tm
                std::tm dateAndTime = {};
                std::istringstream iss(parts.at(2).toStdString());
                iss >> std::get_time(&dateAndTime, "%d/%m/%Y %H:%M");
                dateAndTimeTextBox->setText(parts.at(2));

                int numberOfPeople = parts.at(3).toInt();
                numberOfPeopleTextBox->setText(QString::number(numberOfPeople));

                linkTextBox->setText(parts.at(4));
                linkTextBox->setCursorPosition(0);

                selectedEvent = Event{
                    parts.at(0).toStdString(),
                        parts.at(1).toStdString(),
                        dateAndTime,
                        numberOfPeople,
                        parts.at(4).toStdString()
                };
            }

        });

        QObject::connect(userData, &QListWidget::itemSelectionChanged, [&]() {
            auto selected = userData->selectedItems();
            if (selected.isEmpty())
            {
                titleTextBox2->setText("");
                descriptionTextBox2->setText("");
                dateAndTimeTextBox2->setText("");
                numberOfPeopleTextBox2->setText("");
                linkTextBox2->setText("");

                selectedEvent2 = Event{};

                return;
            }
            else
            {
                auto item = selected.at(0);
                auto parts = item->text().split(" | ");
                titleTextBox2->setText(parts.at(0));
                titleTextBox2->setCursorPosition(0);
                descriptionTextBox2->setText(parts.at(1));
                descriptionTextBox2->setCursorPosition(0);

                // Convert string to std::tm
                std::tm dateAndTime = {};
                std::istringstream iss(parts.at(2).toStdString());
                iss >> std::get_time(&dateAndTime, "%d/%m/%Y %H:%M");
                dateAndTimeTextBox2->setText(parts.at(2));

                int numberOfPeople = parts.at(3).toInt();
                numberOfPeopleTextBox2->setText(QString::number(numberOfPeople));

                linkTextBox2->setText(parts.at(4));
                linkTextBox2->setCursorPosition(0);

                selectedEvent2 = Event{
                    parts.at(0).toStdString(),
                    parts.at(1).toStdString(),
                    dateAndTime,
                    numberOfPeople,
                    parts.at(4).toStdString()
                };
            }

        });

    }

	void loadData()
	{
        listWithData->clear();
        userData->clear();
        vector<Event> events = service->getAllEvents();

        for (auto t : events)
			listWithData->addItem(QString::fromStdString(t.toString()));

        vector<Event> userEvents = service->getUserList();

        for (auto t : userEvents)
            userData->addItem(QString::fromStdString(t.toString()));

	}

	void run()
	{
        userSelectedFileType->setMaximumHeight(100);
        userSelectedFileType->show();
        QHBoxLayout* userOptionLayout = new QHBoxLayout;
        QVBoxLayout* userSelectedFileMainLayout = new QVBoxLayout;
        userSelectedFileType->setLayout(userSelectedFileMainLayout);
        HTMLButton->setMinimumSize(QSize(40,80));
        CSVButton->setMinimumSize(QSize(40, 80));
        userOptionLayout->addWidget(HTMLButton);
        userOptionLayout->addWidget(CSVButton);
        infoUser->setFont(QFont("arial", 48));
        userSelectedFileMainLayout->addWidget(infoUser);
        userSelectedFileMainLayout->addLayout(userOptionLayout, Qt::AlignCenter);
        listWithData->setSizeAdjustPolicy(QListWidget::AdjustToContents);


        QHBoxLayout* userWindowMainLayout = new QHBoxLayout;
        QVBoxLayout* userWindowLayout = new QVBoxLayout;

        userWindowLayout->addWidget(currentEvent);
        userWindowLayout->addWidget(getMonth);
        userWindowLayout->addWidget(sortBtn);
        userWindowLayout->addWidget(nextBtn);
        userWindowLayout->addWidget(addBtn);
        userWindowLayout->addWidget(userData);

        userWindowMainLayout->addLayout(userWindowLayout);
        userMainWindow->setLayout(userWindowMainLayout);

        QVBoxLayout* userWindowLayout2 = new QVBoxLayout;

        auto lyForm2 = new QFormLayout{};
        lyForm2->addRow("Name", titleTextBox2);
        lyForm2->addRow("Description", descriptionTextBox2);
        lyForm2->addRow("Duration", dateAndTimeTextBox2);
        lyForm2->addRow("NumberOfPeople", numberOfPeopleTextBox2);
        lyForm2->addRow("Link", linkTextBox2);

        userWindowLayout2->addLayout(lyForm2);
        userWindowLayout2->addWidget(deleteBtn);
        userWindowLayout2->addWidget(displayBtn);
        userWindowMainLayout->addLayout(userWindowLayout2);



        QHBoxLayout* lyMain = new QHBoxLayout{};
		setLayout(lyMain);


		lyMain->addWidget(listWithData); 
		 
		auto leftLy = new QVBoxLayout{}; 

		auto lyForm = new QFormLayout{};
		lyForm->addRow("Name", titleTextBox);
        lyForm->addRow("Description", descriptionTextBox);
        lyForm->addRow("Duration", dateAndTimeTextBox);
        lyForm->addRow("NumberOfPeople", numberOfPeopleTextBox);
		lyForm->addRow("Link", linkTextBox);

		leftLy->addLayout(lyForm);


		auto lyBtn = new QHBoxLayout{};
		lyBtn->addWidget(addButton);
		lyBtn->addWidget(deleteButton);
		lyBtn->addWidget(updateButton);	
		lyBtn->addWidget(exitButton); 

		leftLy->addLayout(lyBtn);

		lyMain->addLayout(leftLy);

	}

};
