bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, simetry, printf, scanf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import scanf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    msg db "Enter numbers in base 16(0-stop)",10,0
    number dd 0
    format db "%X",0
    format2 db "%X", 32, 0
    sir resd 1000
    contor dd 0
    
    ;; FF2004FF, 8A2112A8, BE10087D, 0FF11FF0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        push msg
        call [printf]
        add esp, 4
        
        mov edi, sir
        
        .loop1:
            push number
            push format
            call [scanf]
            add esp, 8
            
            cmp dword [number], 0
            je .out
            
            mov al, byte [number + 3]
            shl ax, 8
            mov al, byte [number]
            
            push ax
            call simetry
            add esp, 2
            
            cmp eax, 0
            je .skip
            
            mov al, byte [number + 2]
            shl ax, 8
            mov al, byte [number + 1]
            
            push ax
            call simetry
            add esp, 2
            cmp eax, 0
            je .skip
            
            
            mov eax, [number]
            stosd
            inc dword [contor]
            
            .skip:
            
          
            
            loop .loop1
            
        .out:
        
        mov ecx, [contor]
        jecxz .end
        
        mov edi, sir
        .loop2:
            pushad
            push dword [edi]
            push format2
            call [printf]
            add esp, 8
            popad
            add edi, 4
            loop .loop2
            
        
        
        
        
        .end:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
