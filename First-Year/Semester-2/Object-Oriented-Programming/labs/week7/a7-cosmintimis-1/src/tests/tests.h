#include "../service/service.h"
#include <assert.h>
#include "../userEventsList/fileUserEventsList.h"
class Test
{
    private:
        Repository repository{"./src/tests/test.txt"};
        Service service{repository, nullptr};
    public:
        Test();
        ~Test();
        void testAddEvent();
        void testDeleteEvent();
        void testUpdateEvent();
        void testGetAllEvents();
        void testAll();
};