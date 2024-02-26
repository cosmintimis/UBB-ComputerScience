bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll                         ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
                          
                          
                          
                          ; Read one byte and one word from the keyboard. Print on the screen "YES" if the bits of the byte read are found consecutively among the bits of the word and "NO" otherwise.

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    msg1 db "YES", 0
    msg2 db "NO", 0
    msg3 db "Enter (byte)a: ", 0
    msg4 db "Enter (word)b: ", 0
    format db "%hd", 0
    format2 db "%s", 0
    a resb 1
    b resw 1

; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        push msg3
        call [printf]
        add esp, 4
        
        push a
        push format
        call [scanf]
        add esp, 8
        
        
        push msg4
        call [printf]
        add esp, 4
        
        push b
        push format
        call [scanf]
        add esp, 8
        
        mov ax, [b]
        
        mov ecx, 8
        
        .loop:
            cmp al, [a]
            je .good
            shr ax, 1
            loop .loop
            
        
        jmp .notgood
        .good:
            push msg1
            call [printf]
            add esp, 4
        jmp .end
        .notgood:
            push msg2
            call [printf]
            add esp, 4
        
        .end:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
