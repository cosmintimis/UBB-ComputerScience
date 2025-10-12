bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, scanf, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import scanf msvcrt.dll                         ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll                           ; Read three numbers a, m and n (a: word, 0 <= m, n <= 15, m > n) from the keyboard. Isolate the bits m-n of a and display the integer represented by those bits in base 16
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a resw 1
    m resb 1
    n resb 1
    format db "%hd%hd%hd", 0
    format2 db "%hd", 0
    format3 db "%hx", 0
    ;11111111 10101100
    ;00000000 01111000
    ;          n  m
; our code starts here
segment code use32 class=code
    start:
        ; ...
     
        push n
        push m
        push a
        push format
        call [scanf]
        add esp, 16
        
        mov ax, [a]
        mov cl, 16
        sub cl, [n]
        sub cl, 1
        
        shl ax, cl
        
        add cl, [m]
        shr ax, cl
        
        push ax
        push format3
        call [printf]
        add esp,6 
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
