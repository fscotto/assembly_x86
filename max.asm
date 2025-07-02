; A simple program that print in output
; the max between two numbers.
; 
; Author: Fabio Scotto di Santolo
; Date:   02/07/2025

global _start

section .text
_start:
    mov eax, [a]        ; load a value in eax register
    mov ebx, [b]        ; load b value in ebx register
    cmp eax, ebx        ; compare a and b values
    jg  greater
    jle less_or_equal

less_or_equal:          ; print b is greater or equal than b
    mov eax, 0x04       ; write syscall
    mov ebx, 1          ; STDOUT file descriptor
    mov ecx, msg1
    mov edx, len1
    int 0x80            ; trigger syscall
    jmp end

greater:                ; print a is greater than b
    mov eax, 0x04       ; write syscall
    mov ebx, 1          ; STDOUT file descriptor
    mov ecx, msg2
    mov edx, len2
    int 0x80            ; trigger syscall
    jmp end

end:
    ; call syscall exit
    mov eax, 0x1
    xor ebx, ebx        ; reset register to 0
    int 0x80            ; trigger syscall

section .data
    a: dd 10
    b: dd 40
    msg1: db "A is less or equal than B", 0xA
    len1: equ $ - msg1
    msg2: db "A is greater than B", 0xA
    len2: equ $ - msg2

