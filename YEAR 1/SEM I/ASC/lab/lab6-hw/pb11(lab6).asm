bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    A dd 12345678h, 11223344h
    len equ ($ - A) / 4
    B1 resb len
    B2 resb len
    ;Given an array A of doublewords, build two arrays of bytes:  
    ; - array B1 contains as elements the higher part of the higher words from A
    ; - array B2 contains as elements the lower part of the lower words from A

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ecx, len
        mov esi, A
        mov edi, B1
        mov edx, B2
        
        jecxz end
        
        my_loop:
            mov al, [esi]
            mov [edx], al
            add esi, 3
            mov ah, [esi]
            mov [edi], ah
            inc esi
            inc edx
            inc edi
       
        loop my_loop
        
        end:
            ; exit(0)
            push    dword 0      ; push the parameter for exit onto the stack
            call    [exit]       ; call exit to terminate the program
