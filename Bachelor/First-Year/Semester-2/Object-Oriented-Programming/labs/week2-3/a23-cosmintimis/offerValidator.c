#include "offerValidator.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>

int checkIfAnOfferIsValid(char* type, char* destination, date departureDate, int price)
{
    if(checkIfOfferDepartureDateIsValid(departureDate) && checkIfOfferPriceIsValid(price) && checkIfOfferTypeIsValid(type) && checkIfOfferDestinationIsValid(destination))
        return 1;
    return 0;
}

int checkIfOfferPriceIsValid(int price)
{
    if(price < 0 || price > INT_MAX)
        return 0;
    return 1;
}

int checkIfOfferDepartureDateIsValid(date departureDate)
{
    int daysOfEveryMonthFromAYear[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

    if((departureDate.year % 4 == 0) && ((departureDate.year % 400 == 0) || (departureDate.year % 100 != 0)))
        daysOfEveryMonthFromAYear[1] = 29;
    
    if(departureDate.year <= 0 || departureDate.month < 1 || departureDate.month > 12)
        return 0;

    if(departureDate.day < 1 || departureDate.day > daysOfEveryMonthFromAYear[departureDate.month - 1])
        return 0;
    
    return 1;
}

int checkIfOfferDestinationIsValid(char* destination)
{
    if(strcmp(destination, "") == 0)
        return 0;
    return 1;
}

int checkIfOfferTypeIsValid(char* type)
{
    if (strcmp(type, "city break") == 0)
		return 1;
	
	if (strcmp(type, "seaside") == 0) 
		return 1;
	
	if (strcmp(type, "mountain") == 0) 
		return 1;
	
	return 0;
}