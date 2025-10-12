bits 32 ; assembling for the 32 bits architecture
global convertNumberInBase2ToBase10

; declare external functions needed by our program
extern exit
import exit msvcrt.dll
;data
segment data use32 class=data
    
;code
segment code use32 class=code
convertNumberInBase2ToBase10:
    
    push ebp
    mov ebp, esp
    
    mov esi, [esp + 8]
    add esi, 32
    std
    mov ecx, 33
    .lengthOfString:
        lodsb
        dec ecx
        cmp al, '0'
        je .out
        cmp al, '1'
        je .out
        jmp .lengthOfString
    .out:
        inc esi
        inc ecx
      
    mov eax, 1
    mov edx, 0
        
    jecxz .end
                    
    .loop2:        
        push eax
        xor eax,eax
        lodsb
        sub al, '0'
        cmp al, 0
        je .skip1
        pop eax
        add edx, eax
                
        jmp .skip2
        .skip1:
            pop eax
        .skip2:
            shl eax, 1
                
        loop .loop2
 
        mov eax, edx
    .end:
    
    mov esp, ebp
    pop ebp
    ret