bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    n dd 0
    format1 db "%x", 0
    message1 db "Your number in base 10 is: %u", 0
    message2 db "Enter your number in base 16: ", 0
    ; Read a number in base 16 from the keyboard and display the value of that number in base 10
    ; Example: Read: 1D; display: 29
; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        push dword message2
        call [printf]
        add esp, 4
        
        push dword n
        push dword format1
        call [scanf]
        add esp, 8
        
        push dword [n]
        push dword message1
        call [printf]
        add esp, 8
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
