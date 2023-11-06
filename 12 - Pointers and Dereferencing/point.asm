

;;;;;;;;;;;;;;;;;;;;;;;;;
; Assembly w/ Professor P


;;;;;;;;;;;;;;
; Data Section
section .data


;;;
; CStrings

MSG_BEGIN					db		"Now inside the point module",0
MSG_RECEIVED_CSTRING		db		"Now printing the received cstring: ",0

MSG_STRING_INSIDE_ASM		db		"This string is owned by the assembly module",0


CRLF						db		13,10,0


;;	Numbers
LONG_INSIDE_ASM				dq		12345
FLOAT_INSIDE_ASM			dq		1.2345


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

extern heyDriverPrintThis


; Our entry point
;	void point(char * printMe, long * changeMe);
;
;	Register usage:
;		r12: Pointer to the first character of the cstring to print
;		r13: Pointer to the long to modify
global point
point:
	
	;	Prologue
	push r12
	push r13
	push r13	; Stack alignment again.
	
	;	Save our arguments
	mov r12, rdi
	mov r13, rsi
	
	;	Welcome
	mov rdi, MSG_BEGIN
	call printNullTerminatedString
	call crlf
	
	;	Print the received cstring!
	mov rdi, MSG_RECEIVED_CSTRING
	call printNullTerminatedString
	;
	mov rdi, r12
	call printNullTerminatedString
	call crlf
	
	;	Now modify the incoming long
	inc qword [r13]
	
	;	Ask the driver to print our own stufffffff
	mov rdi, MSG_STRING_INSIDE_ASM
	mov rsi, LONG_INSIDE_ASM
	mov rdx, FLOAT_INSIDE_ASM
	call heyDriverPrintThis
	
	;	Epilogue
	pop r13
	pop r13
	pop r12
	
	; We're done
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




