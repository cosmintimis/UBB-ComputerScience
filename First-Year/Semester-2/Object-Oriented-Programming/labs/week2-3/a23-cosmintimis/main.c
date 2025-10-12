#include <stdio.h>
#include <stdlib.h>
#include "repository.h"
#include "service.h"
#include "ui.h"
#include "tests.h"

int main()
{
	Repository* repository = createRepository();
	Service* service = createService(repository);
	Ui* ui = createUi(service);

	// Tests* tests = createTests();
	// testAll(tests);
	// destroyTests(tests);

	startMenu(ui);
	destroyUi(ui);

	return 0;
}