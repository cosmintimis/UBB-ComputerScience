bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, printf, gets, fprintf, fwrite              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll                        ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fread msvcrt.dll 
import fclose msvcrt.dll
import printf msvcrt.dll
import gets msvcrt.dll 
import fprintf msvcrt.dll
import fwrite msvcrt.dll                            ;A text file is given. Read the content of the file, determine the lowercase letter with the highest frequency and display the letter along with its frequency on the screen. The name of text file is defined in the data segment.
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    modd db "r", 0
    fileName db "d.txt", 0
    fd dd -1
    table db 'abcdefghijklmnopqrstuvwxyz'
    max db 0
    charmax db 0
    format1 db "%s", 0
    string resb 100
    d times 26 db 0
    format db "%d",10, 0
    format2 db "%c: %d", 0
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
        
        
        push dword [fd]
        push 100
        push 1
        push string
        call [fread]
        add esp, 16
        mov ecx, eax
        mov esi, string
        mov edi, table
        mov edx, d
        
        .loop:
            push ecx
            mov ecx, 26
            .loop2:
                mov al, byte [edi + ecx - 1]
                cmp byte [esi], al
                je .found
                loop .loop2
            jmp .skip
            .found:
                add byte [edx + ecx - 1], 1
                mov al, byte [edx + ecx - 1]
                cmp al, [max]
                ja .newmax
                
                .newmax:
                    mov [max], al
                    mov al, byte [edi + ecx - 1]
                    mov [charmax], al
            .skip:
            pop ecx
            inc esi
            loop .loop

           
        ;xor ebx, ebx
       ; mov bl, [max]

        mov ebx, 0FFFFFFFFh << 33
       
         
        
        mov al, [charmax]
        
        push ebx
        push eax
        push format2
        call [printf]
        add esp, 8
        
            
        
        push dword [fd]
        call [fclose]
        add esp, 4
        
        
        .end:
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
