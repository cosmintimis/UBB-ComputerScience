#pragma once
#include "service.h"

typedef struct 
{
    Service* service;
}Ui;

Ui* createUi(Service*);

void destroyUi(Ui*);

void startMenu(Ui*);

void printMenu();
