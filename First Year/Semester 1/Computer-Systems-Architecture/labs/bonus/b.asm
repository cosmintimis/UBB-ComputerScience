bits 32

global myfunction

extern printf, len
import printf msvcrt.dll

segment data use32 class=data
    ;vedem
    testt db "da", 0
    table db '4321'
    format db "%x",10, 0
    format2 db "%s", 10 ,0
    max db 0
    number db 0
    sum dd 0
    
segment code use32 class=code
    myfunction:
        push ebp
        mov ebp, esp
        
        mov esi, [ebp + 8]
        mov edi, [ebp + 12]
        
        mov ecx, [len]
        
        .loop1:
            push ecx
            mov ecx, 4
            .loop2:
                mov al, [esi+ecx-1]
                cmp al, [max]
                ja .newmax
                
                jmp .skip
                .newmax:
                    mov byte [max], al
                    mov ebx, table
                    mov al, cl
                    sub al, 1
                    xlat
                    mov byte [number], al
                .skip:
                
                loop .loop2
            
            
            
            mov al, [number]
            stosb
            
            mov al, [max]
            movsx eax, al
            
            add [sum], eax
            
                
            pop ecx
            mov byte [max], 0 
            mov byte [number], 0
            add esi, 4
            loop .loop1
            
            
        mov byte [edi], 0
        
        
        mov eax, [sum]
        
        mov esp, ebp
        pop ebp
        
        ret
        
        