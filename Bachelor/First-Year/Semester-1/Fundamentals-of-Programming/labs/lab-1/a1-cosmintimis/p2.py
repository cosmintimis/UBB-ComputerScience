# Solve the problem from the second set here
# 6: Determine a calendar date (as year, month, day) starting from two integer numbers representing the year and the day number inside that year
# (e.g. day number 32 is February 1st). Take into account leap years. Do not use Python's inbuilt date/time functions.


def isLeapYear(year):
    if year % 4 == 0 and year % 100 != 0:
        return 1
    elif year % 400 == 0:
        return 1
    return 0


def convertDayNumberIntoCalendarDate(year = int(input("Enter a number for year: ")), dayNumber = int(input("Enter a day number from that year: "))):
    numberOfDaysInEachMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    if isLeapYear(year):
        numberOfDaysInEachMonth[1] = 29
    monthNumber = 0
    while dayNumber - numberOfDaysInEachMonth[monthNumber] > 0:
        dayNumber = dayNumber - numberOfDaysInEachMonth[monthNumber]
        monthNumber = monthNumber + 1
    print("The calendar date is: ", end='')
    print(year, monthNumber + 1, dayNumber, sep='/')


convertDayNumberIntoCalendarDate()

