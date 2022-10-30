bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start     

; declare external functions needed by our program
extern exit, printf         ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import printf msvcrt.dll

; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a dd 2000
    b db -2
    c db 121
    x dq -2000
    printformat db '%x%x', 10, 0 
    ; (a+b)/(2-b*b+b/c)-x = 1001 // 3e9
    ; 

; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        mov al, byte [b]
        imul al
        mov bl, 2
        mov bh, 0
        sub bx, ax ; BX = 2 - b*b
        mov al, byte [b]
        cbw
        mov cl, byte [c]
        idiv cl; AL = b / c , AH = b % c
        cbw
        add ax, bx
        cwde ; EAX = (2-b*b+b/c)
        mov ebx, eax
        
        
        mov al, byte [b]
        cbw
        cwde; EAX = b
        mov ecx, dword [a]
        add eax, ecx;  
        cdq ; EDX:EAX = a + b
        
        idiv ebx ; EAX = (a + b) / (2-b*b+b/c)
        cdq; EDX:EAX = (a + b) / (2-b*b+b/c)
        
        mov ebx, dword [x]
        mov ecx, dword [x+4]
        
        sub eax, ebx
        sbb edx, ecx; EDX:EAX = (a + b) / (2-b*b+b/c) - x
        
        ;push eax
        ;push edx
        ;push printformat
        ;call [printf]
        ;add esp, 12
        
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
