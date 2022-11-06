bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll    ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    printformat db "%b", 0, 10
    A db 00110100b
    ;    76543210
    B dw 0010101111000100b
    ;    5432109876543210
    C resb 1
     ;Given the byte A and the word B, compute the byte C as follows:
        ;-the bits 0-3 are the same as the bits 2-5 of A
        ;-the bits 4-7 are the same as the bits 6-9 of B.

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov al, byte [A]
        shr al, 2
        and al, 00001111b ; last 4 bits of al are the bits 2-5 of A
        mov bx, word [B]
        shr bx, 6
        shl bx, 4 ; 4-7 bits of bx are the bits 6-9 of B
        or al, bl
        mov byte [C], al
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
