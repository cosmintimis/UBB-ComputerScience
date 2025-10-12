bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, scanf, fprintf, fopen, fclose, printf              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import fprintf msvcrt.dll
import scanf msvcrt.dll 
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll   ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    file_name db "data.txt", 0   ; filename to be created
    access_mode db "w", 0       ; file access mode:
                                ; w - creates an empty file for writing
    file_descriptor dd -1       ; variable to hold the file descriptor
    
    format1 db "%s", 10, 0
    format2 db "%s", 0
    input db "", 0
    
    ; A file name is given (defined in the data segment). Create a file with the given name,
    ;then read words from the keyboard and write those words in the file, 
    ;until character '$' is read from the keyboard.
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        push dword access_mode     
        push dword file_name
        call [fopen]
        add esp, 8
        
        mov [file_descriptor], eax
        
        cmp eax, 0
        je end
        
        
        mov bl, "$"
        
        my_loop:
        
            push dword input
            push dword format2
            call [scanf]
            add esp, 8
            
           
            cmp bl, [input]
            je skip
              
            push dword input
            push dword format1
            push dword [file_descriptor]
            call [fprintf]
            add esp, 12
                 
            jmp my_loop
            
        
        skip:
        
            push dword [file_descriptor]
            call [fclose]
            add esp, 4
            
            end:
                ; exit(0)
                push    dword 0      ; push the parameter for exit onto the stack
                call    [exit]       ; call exit to terminate the program
