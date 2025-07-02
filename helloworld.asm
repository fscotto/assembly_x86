;; This is a simple Hello World assembly x86
;;
;; Author:  Fabio Scotto di Santolo
;; Date:    02/07/2025

global _start

section .text:
_start:
    ; write text in stdout
    mov eax, 0x04       ; syscall write
    mov ebx, 1          ; stdout
    mov ecx, message
    mov edx, message_length
    int 0x80

    ; call exit syscall
    mov eax, 0x01      ; syscall exit
    mov ebx, 0x00      ; exit code
    int 0x80

section .data:
    message: db "Hello World!", 0xA
    message_length equ $-message

