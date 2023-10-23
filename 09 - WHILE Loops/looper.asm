

;;;;;;;;;;;;;;;;;;;;;;;;;
; Assembly w/ Professor P


;;;;;;;;;;;;;;
; Data Section
section .data


;;;
; CStrings

MSG_WHILE_BEGIN				db		"Begin the while test"
MSG_WHILE_BEGIN_LEN			equ		$-MSG_WHILE_BEGIN
MSG_WHILE_PROMPT			db		"Please enter a number, or 99 to quit: "
MSG_WHILE_PROMPT_LEN		equ		$-MSG_WHILE_PROMPT
MSG_WHILE_ECHO				db		"You entered: "
MSG_WHILE_ECHO_LEN			equ		$-MSG_WHILE_ECHO
MSG_WHILE_END				db		"End the while test"
MSG_WHILE_END_LEN			equ		$-MSG_WHILE_END

MSG_FOR_BEGIN				db		"Begin the for test"
MSG_FOR_BEGIN_LEN			equ		$-MSG_FOR_BEGIN
MSG_FOR_PROMPT				db		"Please enter a number: "
MSG_FOR_PROMPT_LEN			equ		$-MSG_FOR_PROMPT
MSG_FOR_CURRENT_NUMBER		db		"---> "
MSG_FOR_CURRENT_NUMBER_LEN	equ		$-MSG_FOR_CURRENT_NUMBER
MSG_FOR_END					db		"End the for test"
MSG_FOR_END_LEN				equ		$-MSG_FOR_END

NULL_TERMINATED_STRING		db		"Hello, this is an example of a null-terminated string!",0

CRLF						db		13,10,0	; Another example of a null-terminated string


;;;
; System Calls
SYS_WRITE					equ		1


;;;
; File descriptors
FD_STDOUT					equ		1


;;;;;;;;;;;;;;
; Text Section
section .text


;;;;;;;;;;;;;;;;;;;;;;
; Our external symbols
extern libPuhfessorP_printSignedInteger64
extern libPuhfessorP_inputSignedInteger64


; Our entry point
global looper
looper:
	
	; Load 
	call whileTest
	call forTest
	
	mov rdi, NULL_TERMINATED_STRING
	call printNullTerminatedString
	call crlf
	
	; We're done
	ret

;;;;;;;;;;;;;;;
; While test
; void whileTest();
;
; Register usage:
;	r12: User's input
whileTest:
	
	; Prologue
	push r12
	
	; Intro message
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_WHILE_BEGIN
	mov rdx, MSG_WHILE_BEGIN_LEN
	syscall
	call crlf
	
whileTest_init:
	
	mov r12, 0		; Make sure r12 isn't 99 at the start
	
whileTest_top:
	
	; Are we done?
	cmp r12, 99			; while (           )
	jne whileTest_body	;         r12 != 99
	jmp whileTest_done

whileTest_body:			; {
	
	; Prompt the user for input
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_WHILE_PROMPT
	mov rdx, MSG_WHILE_PROMPT_LEN
	syscall
	call libPuhfessorP_inputSignedInteger64
	mov r12, rax
	
	; Echo the user's input back to them
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_WHILE_ECHO
	mov rdx, MSG_WHILE_ECHO_LEN
	syscall
	mov rdi, r12
	call libPuhfessorP_printSignedInteger64
	call crlf

whileTest_body_bottom:
	
	jmp whileTest_top
						; }
	
whileTest_done:
	
	; Exit message
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_WHILE_END
	mov rdx, MSG_WHILE_END_LEN
	syscall
	call crlf
	
	; Epilogue
	pop r12
	
	ret


;;;;;;;;;;;;;;;;;;;;
; void forTest();
; Basic for loop
;
; Register usage:
;	r12: The user's number
;	r13: Current counter variable
forTest:
	
	; Prologue
	push r12
	push r13
	
	; Intro
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_FOR_BEGIN
	mov rdx, MSG_FOR_BEGIN_LEN
	syscall
	call crlf
	
	; Ask for a number
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_FOR_PROMPT
	mov rdx, MSG_FOR_PROMPT_LEN
	syscall
	;
	call libPuhfessorP_inputSignedInteger64
	mov r12, rax
	
					; About to unroll: for (r13 = 0; r13 < r12; r13++)
					; for (                           )
forTest_loopInit:
	mov r13, 0		;       r13 = 0;
forTest_loopTop:
	cmp r13, r12	;                r13 < r12;
	jl forTest_loopBody
	jmp forTest_loopDone

forTest_loopBody:
	
	; {
	
	; Print the current number
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_FOR_CURRENT_NUMBER
	mov rdx, MSG_FOR_CURRENT_NUMBER_LEN
	syscall
	mov rdi, r13
	call libPuhfessorP_printSignedInteger64
	call crlf
	
	; Increase r13, which is the last part of for (r13 = 0; r13 < r12; r13++)
	inc r13				; r13++
	jmp forTest_loopTop
	
	; }

forTest_loopDone:
	
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_FOR_END
	mov rdx, MSG_FOR_END_LEN
	syscall
	call crlf
	
	; Epilogue
	pop r13
	pop r12
	
	ret

;;;
; Custom function to print a CRLF
; void crlf();
crlf:
	
	mov rdi, CRLF
	call printNullTerminatedString
	
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void printNullTerminatedString(char* p);
; Prints a null terminated string, pointed to by p
; Register usage:
;	r12: Running pointer
;
printNullTerminatedString:
	
	; Prologue
	push r12
	
printNullTerminatedString_loopInit:
	
	;	Grab incoming args
	mov r12, rdi
	
printNullTerminatedString_loopTop:

printNullTerminatedString_loopTop_eval:
	
	;	while ( (*r12) != 0 )
	cmp byte [r12], 0
	jne printNullTerminatedString_loopTop_eval_true
	jmp printNullTerminatedString_loopTop_eval_false
	
printNullTerminatedString_loopTop_eval_true:
	
	;	{
	
	; Print the character pointed to by r12
	mov rax, SYS_WRITE	; System call code
	mov rdi, FD_STDOUT	; Print to stdout
	mov rsi, r12		; Pointer to first character of string to print
	mov rdx, 1			; Length of the string to print
	syscall
	
	; Advance the running pointer
	inc r12
	
	;	}
	
	jmp printNullTerminatedString_loopTop
	
printNullTerminatedString_loopTop_eval_false:
	
	nop
	
printNullTerminatedString_done:	
	
	; Epilogue
	pop r12
	
	ret




