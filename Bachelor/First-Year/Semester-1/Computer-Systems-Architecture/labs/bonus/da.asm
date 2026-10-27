bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
import exit msvcrt.dll
import printf msvcrt.dll
extern exit, printf               

    ;; subiectu IV (Arhiva asc - EXAM ex2.jpg)
                       
                       
segment data use32 class=data
    format db "%d",10, 0
    format2 db "%s",32, 0
    sir dq 1110111b, 100000000h, 0ABCD0002E7FCh, 5
    len equ ($-sir)/8
    rez resd len
    len2 dd 0
    numberBase2 times 33 db 0
    numberBase2bun times 33 db 0
    

; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        mov ecx, len
        jecxz .endd
        
        jmp .tesuneu
        .endd:
            jmp .end
        .tesuneu:
        mov esi, sir
        mov edi, rez
        
        .loop:
            mov edx, 0
            mov ebx, [esi]
            push ecx
            mov ecx, 32
            xor eax, eax
            .loop2:
                test ebx, 1
                jnz .one
                
                
                jmp .reset
                .one:
                   inc eax
                   cmp eax, 3
                   jne .skip
                   inc edx
                
                .reset:
                    xor eax, eax  
                .skip:
                
                shr ebx, 1
                loop .loop2
            pop ecx
  
            cmp edx, 2
            jae .good2
            
            jmp .skip2
            .good2:
               mov ebx, [esi]
               mov [edi], ebx
               add edi, 4
               add dword [len2], 1
            .skip2:
            add esi, 8
            loop .loop
            
            mov ecx, [len2]
            jecxz .end
            
            mov esi, rez
            
            .loop3:
                mov ebx, 2
                mov edi, numberBase2
                mov eax, [esi]
                xor edx, edx
                push ecx
                
                mov ecx, 0
                
                .loop4:
                    div ebx
                    cmp dl, 1
                    jne .putzero
                    mov [edi], byte '1'
                    jmp .tesuneu2
                    .putzero:
                        mov [edi], byte '0'
                    .tesuneu2:
                    inc edi
                    inc ecx
                    xor edx, edx
                    cmp eax, 0
                    jnz .loop4
                   
                dec edi
                push esi
                mov esi, numberBase2bun
                .loop5:
                    mov bl, [edi]
                    mov [esi], bl
                    dec edi
                    inc esi
                    loop .loop5
                 
                pop esi                 
                pop ecx

                pushad
                push numberBase2bun
                push format2
                call [printf]
                add esp, 8
                popad
                    
                add esi, 4
                
                loop .loop3
        
        .end:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
