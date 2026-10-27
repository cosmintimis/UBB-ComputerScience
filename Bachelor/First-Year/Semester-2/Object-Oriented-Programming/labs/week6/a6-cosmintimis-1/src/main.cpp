#include "ui/ui.h"
#include "tests/tests.h"

void run()
{
    Ui ui;
    ui.start();
}

void tests()
{
    Test test;
    test.testAll();
}

int main()
{
    tests();
    run();

    return 0;
}