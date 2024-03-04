#include <stdio.h>
#include <stdlib.h>


void createPascalTriangle(int dimensionOfPascalTriangle, long long pascalTriangle[][100])
{
    for(int i = 0; i < dimensionOfPascalTriangle;i++)
    {
        pascalTriangle[i][i] = 1;
        pascalTriangle[i][0] = 1;
    }

     for(int i = 2; i < dimensionOfPascalTriangle;i++)
        for(int j = 1; j < i; j++)
            pascalTriangle[i][j] = pascalTriangle[i-1][j-1] + pascalTriangle[i-1][j];
}

void printPascalTriangle(int dimensionOfPascalTriangle, long long pascalTriangle[][100])
{
    for(int i = 0; i < dimensionOfPascalTriangle;i++)
        {
            for(int j = 0; j <= i; j++)
                printf("%lld ", pascalTriangle[i][j]);
            
            printf("\n");
        }
}

void displayMenu()
{
    printf("1. Read a vector of numbers from console.\n");
    printf("2. Print the pascal triangle.\n");
    printf("3. Given a vector of numbers, find the longest contiguous subsequence of prime numbers.\n");
    printf("0. Exit\n");
}

int checkIfGivenNumberIsPrime(int givenNumber)
{
    if(givenNumber < 2)
        return 0;
    if(givenNumber != 2 && givenNumber % 2 == 0)
        return 0;
    for(int divisor = 3; divisor * divisor <= givenNumber; divisor += 2)
        if(givenNumber % divisor == 0)
            return 0;
    return 1;
}

int findLongestContiguousSubsequenceOfPrimeNumbers(int arrayOfNumbers[], int lengthOfArray, int outputArray[])
{
    int index = 0, maximumLength = - 1, startingIndexOfSubsequence = -1, currentLength = 0, startingIndexOfLongestSubsequence;
    while(index < lengthOfArray)
    {
        if(checkIfGivenNumberIsPrime(arrayOfNumbers[index]) == 1)
        {
            
            if(startingIndexOfSubsequence == -1)
            {
                startingIndexOfSubsequence = index;
                currentLength = 1;
            }
            else
                currentLength++;
            
        }
        else
        {
            if(currentLength > maximumLength)
            {
            
                maximumLength = currentLength;
                startingIndexOfLongestSubsequence = startingIndexOfSubsequence;
            }
            startingIndexOfSubsequence = -1;
            currentLength = 0;
        }
        index++;

    }

    if(currentLength > maximumLength)
    {   
        maximumLength = currentLength;
        startingIndexOfLongestSubsequence = startingIndexOfSubsequence;
    }
    
    if(maximumLength != -1)
    {
        int index = -1;
        for(int i = startingIndexOfLongestSubsequence; i < startingIndexOfLongestSubsequence + maximumLength; i++)
            outputArray[++index] = arrayOfNumbers[i];
    }
    return maximumLength;
}

int main()
{
    int userOption, arrayOfNumbers[100], lengthOfArray = 0, dimensionOfPascalTriangle;
    long long pascalTriangle[100][100];
    char c;
    do
    {
        userOption = -1;
        displayMenu();
        scanf("%d", &userOption);
        while((c = getchar()) != '\n' && c != EOF);

        switch (userOption)
        {
        case 1:
            {
                int goodInput, countGoodEntries = 0;
                printf("Enter the length of the array: ");
                goodInput = scanf("%d", &lengthOfArray);
                while((c = getchar()) != '\n' && c != EOF);
                while(goodInput == 0)
                {
                    printf("Invalid input!\n");
                    goodInput = scanf("%d", &lengthOfArray);
                    while((c = getchar()) != '\n' && c != EOF);

                }
                printf("Enter %d numbers: ", lengthOfArray);
                while(countGoodEntries < lengthOfArray)
                {
                    goodInput = scanf("%d", &arrayOfNumbers[countGoodEntries]);
                    while((c = getchar()) != '\n' && c != EOF);
                    while(goodInput == 0)
                    {
                        printf("Invalid input!\n");
                        goodInput = scanf("%d", &arrayOfNumbers[countGoodEntries]);
                        while((c = getchar()) != '\n' && c != EOF);

                    }
                    countGoodEntries++;
                }
                printf("\nYour array is: ");
                for(int i = 0 ; i < lengthOfArray; i++)
                    printf("%d ", arrayOfNumbers[i]);
                printf("\n");

                break;
            }
        case 2:
            {
                int goodInput;
                printf("Enter the dimension for the pascal triangle: ");
                goodInput = scanf("%d", &dimensionOfPascalTriangle);
                while((c = getchar()) != '\n' && c != EOF);
                while(goodInput == 0)
                {
                    printf("Invalid input!\n");
                    goodInput = scanf("%d", &dimensionOfPascalTriangle);
                    while((c = getchar()) != '\n' && c != EOF);
                }
                createPascalTriangle(dimensionOfPascalTriangle, pascalTriangle);
                printPascalTriangle(dimensionOfPascalTriangle, pascalTriangle);
            break;
            }
        case 3:
            {
                int longestContiguousSubsequenceOfPrimeNumbers[99], lengthOfLongestContiguousSubsequence;
                if(lengthOfArray == 0)
                {
                    int defaultArrayOfNumbers[] = {1, 3, 5, 2, 6, 7, 13, 4, 9, 10}, defaultLengthOfArray = 10;
                    lengthOfLongestContiguousSubsequence = findLongestContiguousSubsequenceOfPrimeNumbers(defaultArrayOfNumbers, defaultLengthOfArray, longestContiguousSubsequenceOfPrimeNumbers);
                    if(lengthOfLongestContiguousSubsequence > 0)
                    {
                        printf("Longest contiguous subsequence of prime numbers is: ");
                        for(int i = 0; i  < lengthOfLongestContiguousSubsequence; i++)
                            printf("%d ", longestContiguousSubsequenceOfPrimeNumbers[i]);
                        printf("\n");
                    }
                    else
                        printf("There's no such subsequence!\n");
                }
                else
                {
                    lengthOfLongestContiguousSubsequence = findLongestContiguousSubsequenceOfPrimeNumbers(arrayOfNumbers, lengthOfArray, longestContiguousSubsequenceOfPrimeNumbers);
                    if(lengthOfLongestContiguousSubsequence > 0)
                    {
                        printf("Longest contiguous subsequence of prime numbers is: ");
                        for(int i = 0; i  < lengthOfLongestContiguousSubsequence; i++)
                            printf("%d ", longestContiguousSubsequenceOfPrimeNumbers[i]);
                        printf("\n");
                    }
                    else
                        printf("There's no such subsequence!\n");

                }
                
            break;
            }
        
        case 0:
            break;

        default:
            printf("Invalid command!\n");
            break;
        }
        
    }while(userOption != 0);
    
    return 0;
}