bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start, len      

; declare external functions needed by our program
extern exit, myfunction, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll                         ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    sir dd 1234A678h, 12345678h, 1AC3B47Dh, 0hFEDC9876
    len db ($-sir)/4
    sir2 resb ($-sir)/4 + 1
    format db "%d",10, 0
    format2 db "%s", 10 ,0
    summ dd -1

; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        push sir2
        push sir
        call myfunction
        add esp, 8
        
        mov [summ], eax
        
        pushad
        push sir2
        push format2
        call [printf]
        add esp, 8
        popad
        
        pushad
        push dword [summ]
        push format
        call [printf]
        add esp, 8
        popad
        
       
        
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
