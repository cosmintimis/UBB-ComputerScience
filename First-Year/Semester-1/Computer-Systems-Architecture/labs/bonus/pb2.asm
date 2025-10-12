bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, scanf, fopen, fclose, fprintf, printf, gets               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import scanf msvcrt.dll  
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll      ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
import gets msvcrt.dll                         ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    msg1 db "Enter the file name: ", 0
    msg2 db "Enter the text: ", 10, 0
    fileName resb 30
    format1 db "%s", 0
    format2 db ` %[^\n]`, 0
    mode db "w", 0
    fileDescriptor dd -1
    text resb 120
    
    

; our code starts here
segment code use32 class=code
    start:
        ; ...
        push msg1
        call [printf]
        add esp, 4
        
        push fileName
        push format1
        call [scanf]
        add esp, 8
        
        push mode
        push fileName
        call [fopen]
        add esp, 8
        
        cmp eax, 0
        je .end
        
        mov [fileDescriptor], eax
        
        push msg2
        call [printf]
        add esp, 4
        
        push text
        push format2
        call [scanf]
        add esp, 8
        
        push text
        push format1
        push dword [fileDescriptor]
        call [fprintf]
        add esp, 12
        
 
        .end:
        
        
        
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
