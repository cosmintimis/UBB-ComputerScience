bits 32

global simetry


segment data use32 class=data


segment code use32 class=code
    simetry:
        push ebp
        mov ebp, esp
        
        mov ax, [ebp + 8]
        mov bl, 0
        mov ecx, 8
        .loop1:
            shr ax, 1
            rcl bl, 1
            loop .loop1
        cmp al, bl
        je .good
        
        jmp .skip
        .good:
        mov eax, 1
        jmp .end
        
        .skip:
        mov eax, 0
        
        .end:
        mov esp, ebp
        pop ebp
        ret