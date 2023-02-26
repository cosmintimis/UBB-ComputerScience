bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fwrite, fprintf, printf              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fclose msvcrt.dll 
import fprintf msvcrt.dll
import fwrite msvcrt.dll    
import printf msvcrt.dll                         ;A file name and a hexadecimal number (on 16 bits) are given. Create a file with the given name and write each nibble composing the hexadecimal number on a different line to file. 23
                          

                          
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    number dw 0ABCDh
    fileName db "date.txt", 0
    modd db "w", 0
    fd dd -1
    d resb 4
    format1 db "%X", 10, 0

; our code starts here
segment code use32 class=code
    start:
        ; ...
        push modd
        push fileName
        call [fopen]
        add esp, 8
        
        cmp eax, 0
        je .end
        
        mov [fd], eax
        
        
        mov ax, [number]
        mov ebx, 0
        mov bl, 00001111b
        mov ecx, 4
        mov esi, d
        
        .loop:
            and bl, al
            mov [esi], bl
            inc esi
            mov edx, ebx
            pushad
            push edx
            push format1
            push dword [fd]
            call [fprintf]
            add esp, 12
            popad
            shr ax, 4
            mov bl, 00001111b
            loop .loop
        

        
        push dword [fd]
        call [fclose]
        add esp, 4
    
    
        .end:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
