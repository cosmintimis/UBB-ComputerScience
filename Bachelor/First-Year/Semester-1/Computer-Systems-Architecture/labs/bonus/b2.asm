bits 32

global myFunction

extern printf
import printf msvcrt.dll

segment data use32 class=data
    format db "%d", 0


segment code use32 class=code
    myFunction:
        push ebp
        mov ebp, esp
        
        mov esi, [ebp + 8]
        mov edi, [ebp + 12]
        mov ecx, [ebp + 16]
        
        jecxz .final
        
        cld
        .loop1:
            push ecx
            lodsd
            mov ecx, 8
            mov edx, 0
            .loop2:
                xor ebx, ebx
                mov bl,1111b
                and bl, al
                add edx, ebx
                shr eax, 4
                loop .loop2
            mov eax, edx
            stosd
            pop ecx
            loop .loop1
            
        
        ;pushad
        ;push ecx
        ;push format
        ;call [printf]
        ;add esp, 8
        ;popad
        
        
        
        
        
        
        .final:
        
        mov esp, ebp
        pop ebp
        
        ret
        
        
        
        