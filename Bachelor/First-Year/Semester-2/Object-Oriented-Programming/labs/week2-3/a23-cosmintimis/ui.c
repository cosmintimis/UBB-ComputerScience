#include "ui.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

Ui *createUi(Service *service)
{
    Ui *newUi = malloc(sizeof(newUi));
    newUi->service = service;
    return newUi;
}

void destroyUi(Ui *ui)
{
    destroyService(ui->service);
    free(ui);
}

void printMenu()
{
    printf("1. Add an offer\n");
    printf("2. Delete an offer\n");
    printf("3. Update an offer\n");
    printf("4. Display all offers whose destinations contain a given string in ascending order by price(Empty string means all destinations!)\n");
    printf("5. Display all offers of a given type, having their departure after a given date.\n");
    printf("6. Undo\n");
    printf("7. Redo\n");
    printf("0. Exit\n");
}

void flushStdinBuffer()
{
    int c;
    while ((c = getchar()) != '\n' && c != EOF);
}

void startMenu(Ui *ui)
{
    addTenRandomOffersToRepository(ui->service);
   /// ui->service->repository->listsOfOffersUsingForUndo[0] = makeCopyOfDynamicArray(ui->service->repository->currentListOfAllOffers);
    int userOption;
    do
    {
        userOption = -1;
        printMenu();
        scanf("%d", &userOption);
        flushStdinBuffer();

        switch (userOption)
        {
        case 1:
        {
            char type[20]= "";
            char destination[100] = "";
            date departureDate;
            departureDate.day = -1;
            departureDate.month = -1;
            departureDate.year = -1;
            int price = -1;

            printf("Enter type(seaside/mountain/city break): ");
            scanf("%19[^\n]", type);
            flushStdinBuffer();

            printf("Enter destination(max 99char): ");
            scanf("%99[^\n]", destination);
            flushStdinBuffer();

            printf("Enter departure date:\n");
            printf("\tYear: ");
            scanf("%d", &departureDate.year);
            flushStdinBuffer();
            printf("\tMonth: ");
            scanf("%d", &departureDate.month);
            flushStdinBuffer();
            printf("\tDay: ");
            scanf("%d", &departureDate.day);
            flushStdinBuffer();
            printf("Enter price: ");
            scanf("%d", &price);
            flushStdinBuffer();

            int statusOfAddOffer = addOfferService(ui->service, type, destination, departureDate, price);

            if (statusOfAddOffer == 0)
                printf("Successfully!\n");
            else if (statusOfAddOffer == 1)
                printf("Provided offer already exists!\n");
            else
                printf("Invalid input! --- try again ---\n");

            break;
        }
        case 2:
        {
            char destination[100] = "";
            date departureDate;
            departureDate.day = -1;
            departureDate.month = -1;
            departureDate.year = -1;

            printf("To delete an offer enter the destination and departure date of it: \n");
            printf("\tDestination(max 99char): ");
            scanf("%99[^\n]", destination);
            flushStdinBuffer();

            printf("\tDeparture date:\n");
            printf("\t\tYear: ");
            scanf("%d", &departureDate.year);
            flushStdinBuffer();
            printf("\t\tMonth: ");
            scanf("%d", &departureDate.month);
            flushStdinBuffer();
            printf("\t\tDay: ");
            scanf("%d", &departureDate.day);
            flushStdinBuffer();

            int statusOfDeleteAnOffer = deleteAnOffer(ui->service, destination, departureDate);

            if(statusOfDeleteAnOffer == 0)
                printf("Provided offer doesn't exist!\n");
            else
                printf("Successfully!\n");
         
            break;
        }

        case 3:
        {

            char destination[100] = "";
            date departureDate;
            char newType[20]="";
            char newDestination[100] = "";
            date newDepartureDate;
            newDepartureDate.day = -1;
            newDepartureDate.month = -1;
            newDepartureDate.year = -1;
            int newPrice = -1;
            printf("Enter the destination and departure date of the offer you want to update: \n");
            printf("\tDestination(max 99char): ");
            scanf("%99[^\n]", destination);
            flushStdinBuffer();

            printf("\tDeparture date:\n");
            printf("\t\tYear: ");
            scanf("%d", &departureDate.year);
            flushStdinBuffer();
            printf("\t\tMonth: ");
            scanf("%d", &departureDate.month);
            flushStdinBuffer();
            printf("\t\tDay: ");
            scanf("%d", &departureDate.day);
            flushStdinBuffer();

            printf("Enter new type(seaside/mountain/city break): ");
            scanf("%19[^\n]", newType);
            flushStdinBuffer();

            printf("Enter new destination(max 99char): ");
            scanf("%99[^\n]", newDestination);
            flushStdinBuffer();

            printf("Enter new departure date:\n");
            printf("\tYear: ");
            scanf("%d", &newDepartureDate.year);
            flushStdinBuffer();
            printf("\tMonth: ");
            scanf("%d", &newDepartureDate.month);
            flushStdinBuffer();
            printf("\tDay: ");
            scanf("%d", &newDepartureDate.day);
            flushStdinBuffer();
            printf("Enter new price: ");
            scanf("%d", &newPrice);
            flushStdinBuffer();

            int statusOfUpdateAnOffer = updateAnOffer(ui->service, destination, departureDate, newType, newDestination, newDepartureDate, newPrice);

            switch(statusOfUpdateAnOffer)
            {
                case 0:
                    printf("Successfully!\n");
                    break;
                case 1:
                    printf("Updated offer already exists!\n");
                    break;
                case 2:
                    printf("Invalid input! --- try again ---\n");
                    break;
                case 3:
                    printf("There's no offer with destination and departure date you entered!\n");
                    break;
            }

            break;
        }
        case 4:
        {
            int numberOfAllOffersWhoseDestinationsContainAGivenString = -1;
            Offer* arrayOfAllOffersWhoseDestinationsContainAGivenString = malloc(getSize(ui->service->repository) * sizeof(Offer));
            char givenString[100] = "";
            printf("Enter the string:(max 99char): ");
            scanf("%99[^\n]", givenString);
            flushStdinBuffer();

            getAllOffersWhoseDestinationsContainAGivenString(ui->service, givenString, arrayOfAllOffersWhoseDestinationsContainAGivenString, &numberOfAllOffersWhoseDestinationsContainAGivenString);

            if(numberOfAllOffersWhoseDestinationsContainAGivenString == -1)
                printf("There's no offers!\n");
            else
            {   
                char stringFormOfAnOffer[200]; 
                for(int i = 0; i <= numberOfAllOffersWhoseDestinationsContainAGivenString; i++)
                {
                    convertOfferToString(&arrayOfAllOffersWhoseDestinationsContainAGivenString[i], stringFormOfAnOffer);
                    printf("%s\n", stringFormOfAnOffer);
                }
            }
            free(arrayOfAllOffersWhoseDestinationsContainAGivenString);
            break;
        }
        case 5:
        {
            date givenDepartureDate;
            givenDepartureDate.day = -1;
            givenDepartureDate.month = -1;
            givenDepartureDate.year = -1; 
            char givenType[20] = "";
            printf("Type: ");
            scanf("%19[^\n]", givenType);
            flushStdinBuffer();

            printf("Departure date:\n");
            printf("\tYear: ");
            scanf("%d", &givenDepartureDate.year);
            flushStdinBuffer();
            printf("\tMonth: ");
            scanf("%d", &givenDepartureDate.month);
            flushStdinBuffer();
            printf("\tDay: ");
            scanf("%d", &givenDepartureDate.day);
            flushStdinBuffer();

            if(checkIfOfferTypeIsValid(givenType) && checkIfOfferDepartureDateIsValid(givenDepartureDate))
            {
                
                Offer* arrayOfAllOffersHavingSameTypeAndAfterASpecificDate = malloc(getSize(ui->service->repository) * sizeof(Offer));
                int lenghtOfArray;
                getAllOffersHavingSameTypeAndAfterASpecificDate(ui->service, givenType, givenDepartureDate, arrayOfAllOffersHavingSameTypeAndAfterASpecificDate, &lenghtOfArray);

                if(lenghtOfArray == 0)
                     printf("There's no such offers!\n");
                else
                {
                    char stringFormOfAnOffer[200]; 
                    for(int i = 0; i < lenghtOfArray; i++)
                    {
                        convertOfferToString(&arrayOfAllOffersHavingSameTypeAndAfterASpecificDate[i], stringFormOfAnOffer);
                        printf("%s\n", stringFormOfAnOffer);
                    }

                }
                free(arrayOfAllOffersHavingSameTypeAndAfterASpecificDate);
            }
            else
                 printf("Invalid input! --- try again ---\n");
            break;
            
        }
        case 6:
        {
            if(undoLastOperation(ui->service))
                printf("No available undo!\n");
            else
                printf("Successfully!\n");
            break;
        }
        case 7:
        {
            if(redoLastUndo(ui->service))
                printf("No available redo!\n");
            else
                printf("Successfully!\n");
            break;
        }
        case 0:
            break;

        default:
            printf("Invalid command!\n");
            break;
        }

    } while (userOption != 0);
}
