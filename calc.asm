; A simple calculator program that do simple operation (+, -, *, /)
; 
; Author: Fabio Scotto di Santolo
; Date:   03/07/2025

global _start

section .text
_start:
    ; Prompt for first number:
    mov eax, 0x04               ; write syscall 
    mov ebx, 1                  ; STDOUT file descriptor
    mov ecx, nprompt
    mov edx, len1
    int 0x80                    ; trigger write syscall
    mov eax, 0x03               ; read syscall
    mov ebx, 0                  ; STDIN file descriptor
    mov ecx, buffer1
    mov edx, 32 
    int 0x80                    ; trigger read syscall
    mov edi, buffer1            ; save buffer address
    mov esi, eax                ; save length 

    ; Prompt for second number:
    mov eax, 0x04               ; write syscall 
    mov ebx, 1                  ; STDOUT file descriptor
    mov ecx, nprompt
    mov edx, len1
    int 0x80                    ; trigger write syscall
    mov eax, 0x03               ; read syscall
    mov ebx, 0                  ; STDIN file descriptor
    mov ecx, buffer2
    mov edx, 32 
    int 0x80                    ; trigger read syscall

    ; Convert second number
    mov ecx, buffer2            ; save buffer address
    mov ebx, eax                ; save length
    call ascii_to_int
    push eax                    ; save converted second number in the stack

    ; Convert first number
    mov ecx, edi                ; ECX = address
    mov ebx, esi                ; EBX = length
    call ascii_to_int           ; EAX = first number
    push eax                    ; save converted first number in the stack

    ; Prompt for operand:
    mov eax, 0x04               ; write syscall 
    mov ebx, 1                  ; STDOUT file descriptor
    mov ecx, oprompt
    mov edx, len2
    int 0x80                    ; trigger write syscall
    mov eax, 0x03               ; read syscall
    mov ebx, 0                  ; STDIN file descriptor
    mov ecx, buffer3
    mov edx, 1
    int 0x80                    ; trigger read syscall

    ; Check operand
    mov eax, [buffer3]          ; move in EAX operand
    cmp eax, 0x2B               ; compare with +
    je .add
    cmp eax, 0x2D               ; compare with -
    je .sub
    cmp eax, 0x2A               ; compare with *
    je .mul
    cmp eax, 0x2F               ; compare with /
    je .div
    jmp end                     ; safety jmp to end

.add:
    pop eax
    pop ebx
    add eax, ebx
    jmp result

.sub:
    pop eax
    pop ebx
    sub eax, ebx
    jmp result
    
.mul:
    pop eax
    pop ebx
    imul eax, ebx
    jmp result  

.div:
    pop eax
    pop ebx
    xor edx, edx
    idiv ebx
    jmp result
    
result:
    ; Print operation result
    mov ebx, eax
    mov eax, msg
    call concat_string_num      ; concat result with final message
   
    mov eax, 0x04               ; write syscall 
    mov ebx, 1                  ; STDOUT file descriptor
    int 0x80                    ; trigger syscall
    jmp end

end:
    ; call syscall exit
    mov eax, 0x1
    xor ebx, ebx                ; reset register to 0
    int 0x80                    ; trigger syscall

; --- ASCII to Integer Conversion Routine ---
ascii_to_int:
    push ebx
    push ecx
    push edx
    push esi

    xor eax, eax
    xor edx, edx
    mov esi, ecx
    mov ecx, ebx

convert_loop:
    cmp byte [esi], 0xA         ; newline?
    je convert_done
    cmp byte [esi], 0xD         ; carriage return?
    je convert_done

    mov ebx, 10
    mul ebx                     ; EAX *= 10

    movzx ebx, byte [esi]
    sub ebx, '0'
    add eax, ebx                ; EAX += digit

    inc esi
    loop convert_loop

convert_done:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

; ----------------------------------------------------------------
; concat_string_num
; Concatenates a null-terminated string in EAX with a number in EBX.
; Result:
;   ECX = pointer to result string (concat_buf)
;   EDX = length of result string (excluding null terminator)
; Clobbers:
;   EAX, EBX, ESI, EDI, EDX, AL, ECX
; ----------------------------------------------------------------
concat_string_num:
    push eax
    push ebx
    push esi
    push edi

    ; Copy string from [EAX] to concat_buf
    mov esi, eax
    mov edi, concat_buf
.copy_str:
    lodsb
    stosb
    test al, al
    jnz .copy_str
    dec edi                     ; go back to overwrite null terminator

    ; Convert EBX (number) to ASCII in num_buf (reversed order)
    mov eax, ebx                ; number to convert
    mov esi, num_buf + 11       ; write from the end
    mov byte [esi], 0           ; null terminator
.convert_digit:
    dec esi
    xor edx, edx
    mov ebx, 10
    div ebx                     ; EAX = EAX / 10, EDX = remainder
    add dl, '0'
    mov [esi], dl
    test eax, eax
    jnz .convert_digit

    ; Copy number string from [ESI] to buffer (at current EDI)
    mov ecx, num_buf + 12
    sub ecx, esi                ; ECX = number string length
    rep movsb
    
    ; Add newline at end
    mov byte [edi], 0xA
    inc edi

    ; Null terminator
    mov byte [edi], 0

    ; Output: ECX = buffer, EDX = length
    mov ecx, concat_buf
    mov edi, concat_buf
    xor edx, edx
.calc_len:
    cmp byte [edi + edx], 0
    je .done
    inc edx
    jmp .calc_len

.done:
    pop edi
    pop esi
    pop ebx
    pop eax
    ret

section .data
    nprompt: db "insert a number: "
    len1: equ $ - nprompt

    oprompt: db "insert a operand (+, -, * or /): "
    len2: equ $ - oprompt

    msg: db "Result is ", 0
    msglen: equ $ - msg

section .bss
    buffer1: resb 32
    buffer2: resb 32
    buffer3: resb 1
    concat_buf: resb 256
    num_buf: resb 12

