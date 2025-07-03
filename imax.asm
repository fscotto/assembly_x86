; A simple program that prints the max between two numbers from stdin
; 
; Author: Fabio Scotto di Santolo
; Date:   02/07/2025

global _start

section .text
_start:
    ; Prompt for first number:
    mov eax, 0x04               ; write syscall 
    mov ebx, 1                  ; STDOUT file descriptor
    mov ecx, prompt
    mov edx, len0
    int 0x80                    ; trigger syscall

    ; Read first number
    mov eax, 0x03               ; read syscall
    mov ebx, 0                  ; STDIN file descriptor
    mov ecx, buffer1
    mov edx, 32 
    int 0x80                    ; trigger syscall

    mov edi, buffer1            ; save buffer address
    mov esi, eax                ; save length 

    ; Prompt for second number:
    mov eax, 0x04               ; write syscall 
    mov ebx, 1                  ; STDOUT file descriptor
    mov ecx, prompt
    mov edx, len0
    int 0x80                    ; trigger syscall

    ; Read second number
    mov eax, 0x03               ; read syscall
    mov ebx, 0                  ; STDIN file descriptor
    mov ecx, buffer2
    mov edx, 32 
    int 0x80                    ; trigger syscall

    ; Convert second number
    mov ecx, buffer2            ; save buffer address
    mov ebx, eax                ; save length
    call ascii_to_int
    push eax                    ; save converted second number in the stack

    ; Convert first number
    mov ecx, edi                ; ECX = address
    mov ebx, esi                ; EBX = length
    call ascii_to_int           ; EAX = first number

    ; compare numbers
    pop ebx                     ; restore converted second number from stack
    cmp eax, ebx                ; compare a and b values
    jg  greater
    jle less_or_equal

less_or_equal:                  ; print b is greater or equal than b
    mov eax, 0x04               ; write syscall
    mov ebx, 1                  ; STDOUT file descriptor
    mov ecx, msg1
    mov edx, len1
    int 0x80                    ; trigger syscall
    jmp end

greater:                        ; print a is greater than b
    mov eax, 0x04               ; write syscall
    mov ebx, 1                  ; STDOUT file descriptor
    mov ecx, msg2
    mov edx, len2
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

section .data
    prompt: db "Insert a number: "
    len0: equ $ - prompt

    msg1: db "A is less or equal than B", 0xA
    len1: equ $ - msg1

    msg2: db "A is greater than B", 0xA
    len2: equ $ - msg2

section .bss
    buffer1: resb 32            ; a buffer of 32 bytes
    buffer2: resb 32            ; a buffer of 32 bytes


