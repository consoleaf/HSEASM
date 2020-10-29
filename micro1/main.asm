    SECTION .rodata

    format      db  "Found f(%d) = ", 0h
    format2     db  "%d.", 0xA, 0h
    limit       dd  1000000000

    SECTION .data

    _n2         dd  0
    _n1         dd  0
    _n          dd  1
    n           dd  -2

    SECTION .text

    global _start
    extern printf
    extern exit

_start:

while:
    mov eax, dword[_n1]         ; _n2 = _n1
    mov dword[_n2], eax

    mov eax, dword[_n]          ; _n1 = _n
    mov dword[_n1], eax

    mov eax, dword[_n2]         ; _n = _n2 - _n1
    sub eax, dword[_n1]
    mov dword[_n], eax

    dec dword[n]                ; n--

    mov eax, dword[_n]

    cmp eax, 0
    jge skipAbs
    neg eax

skipAbs:
    cmp eax, dword[limit]       ; if (_n < limit)
    jl while                    ;   goto while

    mov esi, dword[n]           ; arg2 = n
    inc esi                     ; arg2++

    mov rdi, format             ; arg1 = format
    xor rax, rax
    call printf                 ; printf(format, n - 1)

    mov rdi, format2            ; arg1 = format2
    mov rsi, [_n1]              ; arg2 = _n1
    xor rax, rax
    call printf                 ; printf(format2, _n1)

    xor edi, edi                ; arg1 = 0
    call exit                   ; exit(0)
