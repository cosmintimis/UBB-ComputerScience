#include <stdio.h>

int convertNumberInBase2ToBase16(char(*)[33]);

int x[8];
int res;


int main()
{
    char n[33];
     
    printf("Enter numbers in base 2 ($ to stop): \n");
    
    while(1)
    {
        scanf("%s", &n);
        if(n[0] == '$')
            break;
        
        printf("Number: %s is in base 16: %X \n", n, convertNumberInBase2ToBase16(&n));
        
        for(int i=0; i < 33; i++)
            n[i] = 0;
        for(int i=0; i < 8; i++)
            x[i] = 0;
        res = 0;
          
    }
    
    
    
    return 0;
}
