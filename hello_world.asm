; Assembly code in nasm for x86_64 
; run - `nasm -felf64 hello_world.asm && ld hello_world.o -o hello_world && ./hello_world`

section .rodata                 ;<- Read Only Data segment 
                                ;   In rodata segment we store static constants
                                
    text db "Hello World!", 0xA ;<- Store initialized variable in .rodata 
                                ;   Similar to C language code `char *text = "Hello World!";`
                                ;   0xA at the end is simply the '\n' character
                                ;   You can find in ASCII as Line Feed (LF)
 
    len equ $ - text            ;<- Count length of the text
                                ;   It scored as compile time constant 0xd in DISASSEMBLE section
                                ;   401014:	ba 0d 00 00 00 mov edx,0xd
                                ;   $ - current address and substracting where text label begins

section .text                   ;<- .text (code) section where our source code turns into opcode instructions
    global _start               ;<- It is used for ld (linker) to define starting point

_start:
    mov rax, 1                  ;<- system call 1 for write
    mov rdi, 1                  ;<- file descriptor 1 = STDOUT
    mov rsi, text               ;<- load to register source index address of text label
    mov rdx, len                ;<- store length of the text
    syscall                     ;<- invoke the kernel to write system call

exit:
    mov rax, 60                 ;<- system call 60 for exit
    mov rdi, 0                  ;<- set rdi register to 0
    syscall                     ;<- invoke the kernel to exit system call


; DISASSEMBLE 
; ------------------------------------------------------
; `objdump -D -Mintel hello_world`
        ;hello_world:     file format elf64-x86-64

        ;Disassembly of section .text:

        ;0000000000401000 <_start>:
        ;  401000:	b8 01 00 00 00       	mov    eax,0x1
        ;  401005:	bf 01 00 00 00       	mov    edi,0x1
        ;  40100a:	48 be 00 20 40 00 00 	movabs rsi,0x402000
        ;  401011:	00 00 00
        ;  401014:	ba 0d 00 00 00       	mov    edx,0xd
        ;  401019:	0f 05                	syscall

        ;000000000040101b <exit>:
        ;  40101b:	b8 3c 00 00 00       	mov    eax,0x3c
        ;  401020:	bf 00 00 00 00       	mov    edi,0x0
        ;  401025:	0f 05                	syscall

        ;Disassembly of section .rodata:

        ;0000000000402000 <text>:      ;note: I changed random opcodes to text values 
        ;  402000:	48              H
        ;  402001:	65 6c           el
        ;  402003:	6c              l
        ;  402004:	6f              o
        ;  402005:	20 57 6f         Wo
        ;  402008:	72 6c           rl
        ;  40200a:	64 21 0a        d! 0xA

; Resources:
;   - https://cs.lmu.edu/~ray/notes/x86assembly
;   - https://en.wikipedia.org/wiki/Data_segment
;   - https://www.nasm.us/xdoc/2.16.03/nasmdoc.pdf
;   - https://filippo.io/linux-syscall-table/
