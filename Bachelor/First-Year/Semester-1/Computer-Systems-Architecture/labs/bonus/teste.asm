bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll                         ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
   
    a db 0
    b dd e
    e db 2
    
  

; our code starts here
segment code use32 class=code
    start:
        ; ... 
        
       
        
        
        
        
        
        ;Dinnou:
        ;Mov eax, 89

        ; Jmp Maideparte ; JMP is not restricted to any “distance”
        ; Resd 1000h; The distance between LOOP and the label Dinnou is > 127 bytes so it is not a short jump !
        ; Maideparte:
        ; Mov ebx, 17

        ;jnz Dinnou
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
