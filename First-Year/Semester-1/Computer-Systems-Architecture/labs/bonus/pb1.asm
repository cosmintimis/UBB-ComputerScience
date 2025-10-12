bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, fwrite, fprintf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import fopen msvcrt.dll   
import fclose msvcrt.dll ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fwrite msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fread msvcrt.dll
import fprintf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    file_name1 db "data.txt", 0
    file_name2 db "data2.txt", 0       ; filename to be created
    access_mode1 db "r", 0
    access_mode2 db "w", 0
    format db "%s", 0
                                ; w - creates an empty file for writing
    file1_descriptor dd -1
    file2_descriptor dd -1    ; variable to hold the file descriptor
    buf resb 100

; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        push access_mode1
        push file_name1
        call [fopen]
        add esp, 8
        
        cmp eax, 0
        je .end
        
        mov [file1_descriptor], eax
        
        
        push access_mode2
        push file_name2
        call [fopen]
        add esp, 8
        
        cmp eax, 0
        je .closeReadFile
        
        mov [file2_descriptor], eax
        
        .loop
            push dword [file1_descriptor]
            push 100
            push 1
            push buf
            call [fread]
            add esp, 16
            
            mov ecx, eax
            jecxz .closeFiles
            
            mov esi, buf
            
            .parse:
                pushad
                cmp byte [esi], '0'
                jb .skip
                cmp byte [esi], '9'
                ja .skip
               
                cmp byte [esi], '9'
                je .bine
                    
                jmp .skip2
                .bine:
                mov byte [esi], '0'
                jmp .skip
                .skip2:
                add byte [esi], 1
                    
                .skip:
                    
                
                
                ;push dword [file2_descriptor]
                ;push 1
                ;push 1
                ;push esi
                ;call [fwrite]
                ;add esp, 16
    
                popad
                inc esi
                loop .parse
                pushad
                push buf
                push format
                push dword [file2_descriptor]
                call [fprintf]
                add esp, 12
                popad
            jmp .loop
            
        
        
        
        
        .closeFiles:
            push dword [file1_descriptor]
            call [fclose]
            add esp, 4
            
            push dword [file2_descriptor]
            call [fclose]
            add esp, 4
            
        
        
        
        
        
        jmp .end
        .closeReadFile:
            push dword [file1_descriptor]
            call [fclose]
            add esp, 4
            
        .end:
            
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
