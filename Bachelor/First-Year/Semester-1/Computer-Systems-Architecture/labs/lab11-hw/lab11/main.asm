bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf, convertNumberInBase10ToBase16, convertNumberInBase2ToBase10; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    format db "%X",10,0
    format2 db "%s", 0
    msg1 db "Enter numbers in base 2 ($ to stop): ",10, 0
    msg2 db "Number: %s is in base 16: ", 0
    n resb 33
    
    ;Multiple numbers in base 2 are read from the keyboard. Display these numbers in the base 16.
; our code starts here
segment code use32 class=code
    start:
    
        push msg1
        push format2
        call [printf]
        add esp,8
    
        .loop1:
        
            push n
            push format2
            call [scanf]
            add esp,8
            
            cmp [n], byte '$'
            je .end
            
            push n
            push msg2
            call [printf]
            add esp, 8
         
            push n
            call convertNumberInBase2ToBase10
            add esp, 4
           
            call convertNumberInBase10ToBase16
            
            push eax
            push format
            call [printf]
            add esp, 8

            mov ecx, 33 ; clear n
            mov esi, n
            cld
            .loop4:
                mov byte [esi], 0
                inc esi
                loop .loop4
            
            jmp .loop1
        
            
        .end:
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
