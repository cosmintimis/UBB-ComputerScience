bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf, myFunction               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    sir dd -1,123456, 0xabcdeff, 0xabcdeff, 0xcbcdeff, 0xdbcdeff, 0111010101b
    len equ ($-sir)/4
    sirfinal resd len
    format db "%d",10,0
    format2 db "%X",32,0
    space db 10,0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        push len
        push sirfinal
        push sir
        call myFunction
        add esp, 12
        
        
        mov esi, sirfinal + 4
        mov ecx, len - 1
        jecxz .final
        mov edx, 1
        mov ebx, sir
        
        .loop1:
            mov eax,[esi - 4]
            cmp eax, [esi]
            jae .nubun
            inc edx
            jmp .bun
            .nubun:
                cmp edx, 2
                jae .afisare
                
                jmp .skipp
                .afisare:
                    push ebx
                    push ecx
                    mov ecx, edx
                    jecxz .skip
                    .loop2:
                        pushad
                        push dword [ebx]
                        push format2
                        call [printf]
                        add esp, 8
                        popad
                        add ebx, 4
                        loop .loop2
                    pushad
                    push space
                    call [printf]
                    add esp, 4
                    popad
                    
                    .skip:
                        pop ecx
                        pop ebx
                        
                .skipp:
                lea ebx, [ebx+edx*4]                
                mov edx, 1
                
            .bun:
                add esi, 4
                loop .loop1
    
        .final:

        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
