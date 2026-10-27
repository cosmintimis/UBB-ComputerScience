#include "../service/service.h"
#include <assert.h>

class Test
{
    private:
        Repository repository;
        Service service;
    public:
        Test();
        ~Test();
        void testAddEvent();
        void testDeleteEvent();
        void testUpdateEvent();
        void testGetAllEvents();
        void testAddTenEventsToRepository();
        void testGetEventsForAGivenMonthOrderedChronologically();
        void testAddEventToUserList();
        void testDeleteEventFromUserList();
        void testAll();
};