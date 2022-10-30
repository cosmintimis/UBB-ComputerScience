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
    a db 1
    b dw 32768
    c dd 1
    d dq 8589934592
    printformat db '%x%x', 10, 0 
    ;(d-c)+(b-a)-(b+b+b) = 8589869054 // 1fffefffe

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov eax, dword [d]
        mov edx, dword [d+4]
        mov ebx, dword [c]
        mov ecx, 0 ; ECX:EBC <- c
        sub eax, ebx
        sbb edx, ecx ; EDX:EAX = d - c

        mov bl, byte [a]
        mov cx, word [b]
        mov bh, 0
        sub cx,bx ; CX = b - a
        
        xchg cx,bx
        mov ecx, 0
        xchg cx,bx
        mov ebx, 0
        add eax, ecx
        adc edx, ebx ; EDX:EAX = (d - c) + (b - a)
        
        mov ebx, 0
        mov bx, word[b]
        mov ecx, 0
        sub eax, ebx
        sbb edx, ecx
        sub eax, ebx
        sbb edx, ecx
        sub eax, ebx
        sbb edx, ecx ; EDX:EAX = (d-c)+(b-a)-(b+b+b)
        
        ;push eax
        ;push edx
        ;push printformat
        ;call [printf]
        ;add esp, 12
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
