bits 32 ; assembling for the 32 bits architecture
global _convertNumberInBase2ToBase16
extern _x
extern _res

; declare external functions needed by our program

;data
segment data use32 class=data
    
;code
segment code use32 class=code
_convertNumberInBase2ToBase16:

    push ebp
    mov ebp, esp
    
    mov esi, [esp + 8] ; Transform number in base 2 (string form) to its value in base 10
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
                    
    .loop1:      
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
                
        loop .loop1
 
    mov eax, edx
    
    mov ebx, 16
    mov edi, _x
    mov ecx, 0
    
    .loop2:          ; obtain all digits of the number in base 16
        cmp eax, 0
        je .done
        mov edx, 0
        div ebx
        mov [edi], dl
        inc edi
        inc ecx
        jmp .loop2
    
    .done:
        dec edi
        
    jecxz .end
            
    mov ebx, 1
    mov esi, _x
    xor edx, edx
    cld
         
    .loop3:          ; construct the number in base 16 and store it in res
        xor eax,eax
        lodsb
        mul ebx
        shl ebx, 4
        add [_res], eax
        loop .loop3
                
    .end:
    
    mov eax, [_res]
    
    mov esp, ebp
    pop ebp
    ret