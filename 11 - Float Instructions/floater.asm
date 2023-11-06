

;;;;;;;;;;;;;;;;;;;;;;;;;
; Assembly w/ Professor P


;;;;;;;;;;;;;;
; Data Section
section .data


;;;
; CStrings


MSG_ASK_INT					db		"Please enter an integer: ",0
MSG_ECHO_INT				db		"The integer you entered was: ",0
MSG_ASK_FLOAT				db		"Please enter a float: ",0
MSG_ECHO_MODIFIED_FLOAT		db		"The modified float is: ",0


CRLF						db		13,10,0	; Another example of a null-terminated string


;;	Floats
THE_FLOAT					dq		0.0
THE_MODIFIED_FLOAT			dq		0.0
FLOAT_MULTIPLIER			dq		3.333


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
extern libPuhfessorP_printFloat64
extern libPuhfessorP_inputFloat64


; Our entry point
global floater
floater:
	
	;
	call floatConvertTests
	call crlf
	
	;	Return the modified float back to the driver
	movsd xmm0, [THE_MODIFIED_FLOAT]
	
	; We're done
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	void floatConvertTests();
;
;	Register usage:
;		r12:	The inputted integer
floatConvertTests:
	
	;	Prologue
	push r12
	push r12		; Stack alignment
	
	;	Grab an integer from the user
	mov rdi, MSG_ASK_INT
	call printNullTerminatedString
	call libPuhfessorP_inputSignedInteger64
	mov r12, rax
	
	;	Grab a float from the user
	mov rdi, MSG_ASK_FLOAT
	call printNullTerminatedString
	call libPuhfessorP_inputFloat64
	movsd [THE_FLOAT], xmm0
	
	;	Echo the integer
	mov rdi, MSG_ECHO_INT
	call printNullTerminatedString
	mov rdi, r12
	call libPuhfessorP_printSignedInteger64
	call crlf
	
	;	Convert the integer to a float and multiply by FLOAT_MULTIPLIER (3.333)
	;	We could lose data here on the assumption that the int is only 32 bits
	cvtsi2sd xmm0, r12
	mulsd xmm0, [FLOAT_MULTIPLIER]
	movsd [THE_MODIFIED_FLOAT], xmm0			; Immediately save our float
	
	;	Tell the user about the modified float
	mov rdi, MSG_ECHO_MODIFIED_FLOAT
	call printNullTerminatedString
	movsd xmm0, [THE_MODIFIED_FLOAT]			; xmm0 may have been destroyed by this point, so load it up again!
	call libPuhfessorP_printFloat64
	call crlf
	
	;	Epilogue
	pop r12
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




