bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll                       ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    
    s db 1, 5, 3, 8, 2, 9
    len equ $ - s
    d1 resb len
    d2 resb len
    ; ...
    ; A byte string S is given. Obtain the string D1 which contains all the even numbers of S and the string D2 which contains all the odd numbers of S.
    ;S: 1, 5, 3, 8, 2, 9
    ;D1: 8, 2
    ;D2: 1, 5, 3, 9

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ecx, len
        mov esi, s
        mov edi, d1
        mov edx, d2
        
        jecxz skip
        
        my_loop:
            mov al, [esi]
            inc esi
            test al, 1
            jz is_even
            mov [edx], al ; odd
            inc edx
            jmp skip_is_even
            is_even:
                mov [edi], al
                inc edi
            
            skip_is_even:
        
        loop my_loop
        
        
        skip:
        ; exit(0)
        push    dword 0     
        call    [exit]      
