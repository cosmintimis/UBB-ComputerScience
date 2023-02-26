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
    b db 1
    c db 121
    x dq 1000
    printformat db '%x%x', 10, 0 
    ; (a+b)/(2-b*b+b/c)-x = 1001 // 3E9
    ; 

; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        mov al, byte [b]
        mul al
        mov bl, 2
        mov bh, 0
        sub bx, ax ; BX = 2 - b*b
        mov al, byte [b]
        mov ah, 0
        mov cl, byte [c]
        div cl; AL = b / c , AH = b % c
        mov ah, 0
        add bx, ax
        mov cx, bx
        mov ebx, 0
        mov bx, cx ; ebx = (2-b*b+b/c)
      
        mov eax, dword [a]
        mov ecx, 0
        mov cl, byte [b]
        mov edx, 0
        add eax, ecx
        adc edx, 0 ; EDX:EAX = a + b
        
        div ebx ; EAX = (a + b) / (2-b*b+b/c)
        mov edx, 0 ; 
        
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
