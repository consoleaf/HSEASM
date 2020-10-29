;------------------------------------------
; void iprint(Integer number)
; Integer printing function (itoa)
iprint:
    push    eax             ; preserve eax on the stack to be restored after function runs
    push    ecx             ; preserve ecx on the stack to be restored after function runs
    push    edx             ; preserve edx on the stack to be restored after function runs
    push    esi             ; preserve esi on the stack to be restored after function runs
    mov     ecx, 0          ; counter of how many bytes we need to print in the end

divideLoop:
    inc     ecx             ; count each byte to print - number of characters
    mov     edx, 0          ; empty edx
    mov     esi, 10         ; mov 10 into esi
    idiv    esi             ; divide eax by esi
    add     edx, 48         ; convert edx to it's ascii representation - edx holds the remainder after a divide instruction
    push    edx             ; push edx (string representation of an intger) onto the stack
    cmp     eax, 0          ; can the integer be divided anymore?
    jnz     divideLoop      ; jump if not zero to the label divideLoop

printLoop:
    dec     ecx             ; count down each byte that we put on the stack
    mov     eax, esp        ; mov the stack pointer into eax for printing
    call    sprint          ; call our string print function
    pop     eax             ; remove last character from the stack to move esp forward
    cmp     ecx, 0          ; have we printed all bytes we pushed onto the stack?
    jnz     printLoop       ; jump is not zero to the label printLoop

    pop     esi             ; restore esi from the value we pushed onto the stack at the start
    pop     edx             ; restore edx from the value we pushed onto the stack at the start
    pop     ecx             ; restore ecx from the value we pushed onto the stack at the start
    pop     eax             ; restore eax from the value we pushed onto the stack at the start
    ret


;------------------------------------------
; void iprintLF(Integer number)
; Integer printing function with linefeed (itoa)
iprintLF:
    call    iprint          ; call our integer printing function

    push    eax             ; push eax onto the stack to preserve it while we use the eax register in this function
    mov     eax, 0Ah        ; move 0Ah into eax - 0Ah is the ascii character for a linefeed
    push    eax             ; push the linefeed onto the stack so we can get the address
    mov     eax, esp        ; move the address of the current stack pointer into eax for sprint
    call    sprint          ; call our sprint function
    pop     eax             ; remove our linefeed character from the stack
    pop     eax             ; restore the original value of eax before our function was called
    ret


;------------------------------------------
; void iprint_err(Integer number)
; Integer printing function (itoa) to STDERR instead of STDOUT
iprint_err:
    push    eax             ; preserve eax on the stack to be restored after function runs
    push    ecx             ; preserve ecx on the stack to be restored after function runs
    push    edx             ; preserve edx on the stack to be restored after function runs
    push    esi             ; preserve esi on the stack to be restored after function runs
    mov     ecx, 0          ; counter of how many bytes we need to print in the end

divideLoop_err:
    inc     ecx             ; count each byte to print - number of characters
    mov     edx, 0          ; empty edx
    mov     esi, 10         ; mov 10 into esi
    idiv    esi             ; divide eax by esi
    add     edx, 48         ; convert edx to it's ascii representation - edx holds the remainder after a divide instruction
    push    edx             ; push edx (string representation of an intger) onto the stack
    cmp     eax, 0          ; can the integer be divided anymore?
    jnz     divideLoop_err  ; jump if not zero to the label divideLoop

printLoop_err:
    dec     ecx             ; count down each byte that we put on the stack
    mov     eax, esp        ; mov the stack pointer into eax for printing
    call    sprint_err      ; call our string print function
    pop     eax             ; remove last character from the stack to move esp forward
    cmp     ecx, 0          ; have we printed all bytes we pushed onto the stack?
    jnz     printLoop_err   ; jump is not zero to the label printLoop

    pop     esi             ; restore esi from the value we pushed onto the stack at the start
    pop     edx             ; restore edx from the value we pushed onto the stack at the start
    pop     ecx             ; restore ecx from the value we pushed onto the stack at the start
    pop     eax             ; restore eax from the value we pushed onto the stack at the start
    ret

;------------------------------------------
; void iprintLF_err(Integer number)
; Integer printing function with linefeed (itoa) to STDERR
iprintLF_err:
    call    iprint_err      ; call our integer printing function

    push    eax             ; push eax onto the stack to preserve it while we use the eax register in this function
    mov     eax, 0Ah        ; move 0Ah into eax - 0Ah is the ascii character for a linefeed
    push    eax             ; push the linefeed onto the stack so we can get the address
    mov     eax, esp        ; move the address of the current stack pointer into eax for sprint
    call    sprint_err          ; call our sprint function
    pop     eax             ; remove our linefeed character from the stack
    pop     eax             ; restore the original value of eax before our function was called
    ret

;------------------------------------------
; int slen(String message)
; String length calculation function
slen:
    push    ebx
    mov     ebx, eax

nextchar:
    cmp     byte [eax], 0
    jz      finished
    inc     eax
    jmp     nextchar

finished:
    sub     eax, ebx
    pop     ebx
    ret

;------------------------------------------
; void sprint(String message)
; String printing function
sprint:
    push    edx
    push    ecx
    push    ebx
    push    eax
    call    slen

    mov     edx, eax
    pop     eax

    mov     ecx, eax
    mov     ebx, 1              ; STDOUT
    mov     eax, 4
    int     80h

    pop     ebx
    pop     ecx
    pop     edx
    ret


;------------------------------------------
; void sprintLF(String message)
; String printing with line feed function
sprintLF:
    call    sprint

    push    eax
    mov     eax, 0AH
    push    eax
    mov     eax, esp
    call    sprint
    pop     eax
    pop     eax
    ret

;------------------------------------------
; void sprint_err(String message)
; String printing function (to STDERR)
sprint_err:
    push    edx
    push    ecx
    push    ebx
    push    eax
    call    slen

    mov     edx, eax
    pop     eax

    mov     ecx, eax
    mov     ebx, 2              ; STDERR
    mov     eax, 4
    int     80h

    pop     ebx
    pop     ecx
    pop     edx
    ret


;------------------------------------------
; void sprintLF(String message)
; String printing with line feed function (to STDERR)
sprintLF_err:
    call    sprint_err

    push    eax
    mov     eax, 0AH
    push    eax
    mov     eax, esp
    call    sprint_err
    pop     eax
    pop     eax
    ret


;------------------------------------------
; void exit()
; Exit program and restore resources
quit:
    mov     ebx, 0
    mov     eax, 1
    int     80h
    ret


;------------------------------------------
; int atoi(Integer number)
; Ascii to integer function (atoi)
atoi:
    push    ebx             ; preserve ebx on the stack to be restored after function runs
    push    ecx             ; preserve ecx on the stack to be restored after function runs
    push    edx             ; preserve edx on the stack to be restored after function runs
    push    esi             ; preserve esi on the stack to be restored after function runs
    mov     esi, eax        ; move pointer in eax into esi (our number to convert)
    mov     eax, 0          ; initialise eax with decimal value 0
    mov     ecx, 0          ; initialise ecx with decimal value 0

.multiplyLoop:
    xor     ebx, ebx        ; resets both lower and uppper bytes of ebx to be 0
    mov     bl, [esi+ecx]   ; move a single byte into ebx register's lower half
    cmp     bl, 48          ; compare ebx register's lower half value against ascii value 48 (char value 0)
    jl      .finished       ; jump if less than to label finished
    cmp     bl, 57          ; compare ebx register's lower half value against ascii value 57 (char value 9)
    jg      .finished       ; jump if greater than to label finished

    sub     bl, 48          ; convert ebx register's lower half to decimal representation of ascii value
    add     eax, ebx        ; add ebx to our interger value in eax
    mov     ebx, 10         ; move decimal value 10 into ebx
    mul     ebx             ; multiply eax by ebx to get place value
    inc     ecx             ; increment ecx (our counter register)
    jmp     .multiplyLoop   ; continue multiply loop

.finished:
    cmp     ecx, 0          ; compare ecx register's value against decimal 0 (our counter register)
    je      .restore        ; jump if equal to 0 (no integer arguments were passed to atoi)
    mov     ebx, 10         ; move decimal value 10 into ebx
    div     ebx             ; divide eax by value in ebx (in this case 10)

.restore:
    pop     esi             ; restore esi from the value we pushed onto the stack at the start
    pop     edx             ; restore edx from the value we pushed onto the stack at the start
    pop     ecx             ; restore ecx from the value we pushed onto the stack at the start
    pop     ebx             ; restore ebx from the value we pushed onto the stack at the start
    ret

;----------------------------
; int readInt()
;
; Displays a prompt and reads a number from STDIN
;
; After execution, eax contains the number
readInt:
    ;; Push used registers
    push edx
    push ecx
    push ebx

    mov eax, inputMsg
    call sprint

    ;; Read the number
    mov edx, 255                ; number of bytes to read
    mov ecx, sinput             ; buffer
    mov ebx, 0                  ; STDIN
    mov eax, 3                  ; SYS_READ (kernel opcode 3)
    int 80h                     ; Call kernel

    ;; sinput now has the input data

    mov eax, sinput
    call atoi

    pop ebx
    pop ecx
    pop edx
    ret


;---------------------------------------
; void readIntArray(array, len)
; ebx pointing to array
; eax = len
readIntArray:
    push edx
    push ecx

    mov ecx, eax                ; Move eax (len) to ecx

loopStep:
    call readInt                ; read a value into eax

    mov [ebx], eax              ; Save the value

    ;; NOTE: Used previously for debug purposes
    ;; mov eax, outputMsg
    ;; call sprint_err

    ;; mov eax, [ebx]
    ;; call iprintLF_err

    add ebx, 8                  ; Move pointer

    loop loopStep

finish:
    pop ecx
    pop edx
    mov eax, 0

    ret

;------------------------------
; void printIntArray(array, length)
;
; A function, printing an array into STDOUT
;
; ebx points to array
; ecx contains a number of elements
printIntArray:
    push ecx
    mov ecx, eax
loopStep1:
    mov eax, [ebx]
    call iprint

    mov eax, space
    call sprint

    add ebx, 8

    loop loopStep1

finishPrint:
    mov eax, space
    call sprintLF

    pop ecx
    ret

;-----------------------------
; void copyArray(array1, array2, length)
;
; A function, copying array1 into array2
;
; eax - array 1
; ebx - array 2
; ecx - length
copyArray:
    push eax
    push ebx
    push ecx

    cmp ecx, 0                  ; If there are no elements to copy, just stop
    jz finishCopy

copyStep:
    ;; [eax] -> edx -> [ebx]
    mov edx, [eax]
    mov [ebx], edx

    add eax, 8
    add ebx, 8

    loop copyStep               ; Iterate over ecx

finishCopy:
    pop ecx
    pop ebx
    pop eax

    ret

; -----------------------------------
; void reverseArray(array, length)
;
; A function reversing the order of elements in an array
;
; ebx = pointer to the array
; ecx = length
reverseArray:
    push ecx                    ; Preserve ecx in stack
    push ebx                    ; Preserve ebx in stack
    push eax                    ; Preserve eax in stack
    push esi                    ; Preserve esi in stack

    mov esi, ebx
    lea edi,[esi+ecx*8-8]

    cmp esi, edi                ; if (esi >= edi)
    jnb reverseDone             ;   return;

loopStepReverse:
    ;; NOTE: Has been used for debugging purposes.
    ;; mov eax, [esi]
    ;; call iprint_err
    ;; mov eax, space
    ;; call sprint_err
    ;; mov eax, [edi]
    ;; call iprintLF_err

    mov eax,[esi]               ; eax = *esi;
    mov ebx,[edi]               ; ebx = *edi;
    mov [edi],eax               ; *edi = eax;
    mov [esi],ebx               ; *esi = ebx;

    add esi,8                   ; esi++
    sub edi,8                   ; edi--

    cmp esi,edi                 ; if (esi < edi)            ; if (esi >= edi)
    jb loopStepReverse          ;   goto loopStepReverse    ;   break;

reverseDone:
    pop esi                     ; Restore esi from stack
    pop eax                     ; Restore eax from stack
    pop ebx                     ; Restore ebx from stack
    pop ecx                     ; Restore ecx from stack

    ret                         ; return;
