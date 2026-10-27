#pragma once
#include "../service/service.h"
#include <climits>

class Ui
{
    private:
        Service service;

    public:
    Ui();
    ~Ui();
    void startMenu();
    void administratorMenu();
    void userMenu();
    void start();
    void flushStdin();
    void readEventFromKeyboard(std::string &, std::string &, std::tm &, int &, std::string &);
    void secondUserMenu();
    

};