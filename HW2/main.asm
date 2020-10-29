    ;; Арыслан Якшибаев, группа БПИ196.
    ;;
    ;; Разработать программу, которая вводит одномерный массив A[N],
    ;; формирует из элементов массива A новый массив B по правилам,
    ;; указанным в таблице, и выводит его.
    ;;
    ;; Вариант: 10
    ;;
    ;; Массив B из... элементов A в обратном порядке
    ;;

%include "util.asm"

    SECTION .data

    initPrompt          db  "Введите длину массива", 0h
    arrayPrompt         db  "Введите числа массива", 0h
    inputMsg            db  ">> ", 0h
    outputMsg           db  "<< ", 0h
    space               db  " ", 0h
    firstArrayString    db  "Введённый массив: ", 0h
    newArrayString      db  "Новый массив:     ", 0h
    zeroMsg             db  "Пустой массив, нечего делать. ", 0h

    SECTION .bss

    sinput              resb    255         ; reserve space for 255 bytes
    array               resb    255         ; reserve space for 255 bytes
    newArray            resb    255         ; reserve space for 255 bytes

    SECTION .text

    global _start

_start:
    ;; Prompt for N
    mov eax, initPrompt
    call sprintLF

    ;; Read the number N
    call readInt
    push eax

    ;; if N == 0, quit
    cmp eax, 0
    jle gotZero

    ;; mov eax, outputMsg
    ;; call sprint_err
    ;; mov eax, [arrayLen]
    ;; call iprintLF_err

    ;; Prompt for array
    mov eax, arrayPrompt
    call sprintLF

    ;; Read the array from STDIN
    pop eax
    push eax
    mov ebx, array
    call readIntArray

    ;; Copy array to newArray
    mov eax, array
    mov ebx, newArray
    pop ecx
    push ecx
    call copyArray

    ;; Reverse newArray
    mov ebx, newArray
    call reverseArray

    ;; Print decorative text
    mov eax, firstArrayString
    call sprint

    ;; print initial array
    mov ebx, array
    pop eax
    push eax
    call printIntArray

    ;; Decorative text
    mov eax, newArrayString
    call sprint

    ;; Print new, reversed array
    mov ebx, newArray
    pop eax
    call printIntArray

finishProgram:
    call quit

gotZero:
    ;; Display "0 elements, nothing to do"
    mov eax, zeroMsg
    call sprintLF
    jmp finishProgram


