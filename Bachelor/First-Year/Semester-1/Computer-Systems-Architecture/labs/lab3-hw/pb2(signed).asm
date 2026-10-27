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
    a db -50
    b dw 200
    c dd 300
    d dq 1000
    printformat db '%x%x', 10, 0 
    ; d-(a+b+c)-(a+a) = 650 // 28A
    ; 1000 - 450 + 100

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov al, [a]
        cbw
        cwde ; EAX = a
        mov ebx, 0
        mov bx, word [b]; EBX = b
        add eax, ebx
        mov ebx, dword [c]
        add eax, ebx ; eax = a + b + c
        mov ebx, eax ; ebx = a + b + c
        
        mov al, byte [a]
        cbw
        add ax, ax
        cwde ; eax = a + a
        
        add ebx, eax ; ebx = (a+b+c) + (a+a)
        xchg ebx, eax
        cdq; edx:eax = (a+b+c) + (a+a)
       
        
        mov ebx, dword [d]
        mov ecx, dword [d+4] ; ecx:ebx = d
        
        sub ebx, eax
        sbb ecx, edx; edx:eax = d - [(a+b+c) + (a+a)] = d - (a+b+c) - (a+a)
        
        ;push ebx
        ;push ecx
        ;push printformat
        ;call [printf]
        ;add esp, 12
        
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
