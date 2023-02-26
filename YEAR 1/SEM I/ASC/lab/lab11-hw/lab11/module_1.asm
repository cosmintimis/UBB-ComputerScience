bits 32 ; assembling for the 32 bits architecture
global convertNumberInBase10ToBase16

; declare external functions needed by our program
extern exit, printf
import exit msvcrt.dll
import printf msvcrt.dll
;data
segment data use32 class=data
    x resb 8
    res resd 1

;code
segment code use32 class=code
convertNumberInBase10ToBase16:
    
    push ebp
    mov ebp, esp
    
    mov ebx, 16
    mov edi, x
    mov ecx, 0
    
    .loop1:          ; obtain all digits of the number in base 16
        cmp eax, 0
        je .done
        mov edx, 0
        div ebx
        mov [edi], dl
        inc edi
        inc ecx
        jmp .loop1
    
    .done:
        dec edi
        
    jecxz .end
            
    mov ebx, 1
    mov esi, x
    xor edx, edx
    cld
         
    .loop4:          ; construct the number in base 16 and store it in res
        xor eax,eax
        lodsb
        mul ebx
        shl ebx, 4
        add [res], eax
        loop .loop4
                
    
    .end:
    
    mov eax, [res]
    mov dword [res], 0 ; clear res
    
    mov esp, ebp
    pop ebp
    ret