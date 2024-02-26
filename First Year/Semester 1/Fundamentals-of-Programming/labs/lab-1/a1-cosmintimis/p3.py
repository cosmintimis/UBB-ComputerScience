# Solve the problem from the third set here
# 12 Determine the age of a person, in number of days. Take into account leap years, as well as the date of birth and current date (year, month, day).
# Do not use Python's inbuilt date/time functions.
def displayAgeInDays(birthDate = [int(birthDate) for birthDate in input("Enter a date of birth (year,month,day): ").split(',')]):
    def isLeapYear(year):
        numberOfDaysInEachMonth[1] = 28
        if year % 4 == 0 and year % 100 != 0:
            numberOfDaysInEachMonth[1] = 29
        elif year % 400 == 0:
            numberOfDaysInEachMonth[1] = 29
    currentDate = [2023, 1, 23]
    numberOfDaysInEachMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    ageInNumberOfDays = 0

    if (birthDate[0] > currentDate[0] or (birthDate[0] == currentDate[0] and birthDate[1] > currentDate[1]) or
            (birthDate[0] == currentDate[0] and birthDate[1] == currentDate[1] and birthDate[2] > currentDate[2])):
        print("Enter a valid birth date !!")
        return 0

    if birthDate[0] < currentDate[0]:
        isLeapYear(birthDate[0])
        ageInNumberOfDays += numberOfDaysInEachMonth[birthDate[1] - 1] - birthDate[2] + 1
        birthDate[1] += 1
        birthDate[2] = 1
        while birthDate[0] < currentDate[0]:
            isLeapYear(birthDate[0])
            while birthDate[1] <= 12:
                ageInNumberOfDays += numberOfDaysInEachMonth[birthDate[1] - 1]
                birthDate[1] += 1
            birthDate[0] += 1
            birthDate[1] = 1

    if birthDate[1] < currentDate[1]:
        isLeapYear(birthDate[0])
        ageInNumberOfDays += numberOfDaysInEachMonth[birthDate[1] - 1] - birthDate[2] + 1
        birthDate[1] += 1
        birthDate[2] = 1
        while birthDate[1] < currentDate[1]:
            ageInNumberOfDays += numberOfDaysInEachMonth[birthDate[1] - 1]
            birthDate[1] += 1

    if birthDate[2] <= currentDate[2]:
        ageInNumberOfDays += currentDate[2] - birthDate[2] + 1
    print("The person's age in days is: " + str(ageInNumberOfDays))


displayAgeInDays()


