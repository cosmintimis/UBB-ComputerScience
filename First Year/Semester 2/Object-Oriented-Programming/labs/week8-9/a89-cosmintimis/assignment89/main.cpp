#include <QApplication>
#include "gui.h"
#include <QDebug>
int main(int argc, char *argv[])
{

    QApplication a(argc, argv);
    GUI gui;
    return a.exec();
}
