

;;;;;;;;;;;;;;;;;;;;;;;;;
; Assembly w/ Professor P


;;;;;;;;;;;;;;
; Data Section
section .data


;;;
; CStrings


MSG_MULT_IMMEDIATE_PREFIX		db		"The result of multiplying immediates is: ***"
MSG_MULT_IMMEDIATE_PREFIX_LEN	equ		$-MSG_MULT_IMMEDIATE_PREFIX
MSG_MULT_IMMEDIATE_SUFFIX		db		"***"
MSG_MULT_IMMEDIATE_SUFFIX_LEN	equ		$-MSG_MULT_IMMEDIATE_SUFFIX


MSG_MULT_GLOBAL_PREFIX			db		"The result of multiplying globals is: ***"
MSG_MULT_GLOBAL_PREFIX_LEN		equ		$-MSG_MULT_GLOBAL_PREFIX
MSG_MULT_GLOBAL_SUFFIX			db		"***"
MSG_MULT_GLOBAL_SUFFIX_LEN		equ		$-MSG_MULT_GLOBAL_SUFFIX


MSG_DIVISION_QUOTIENT			db		"The division result (quotient) is: "
MSG_DIVISION_QUOTIENT_LEN		equ		$-MSG_DIVISION_QUOTIENT
MSG_DIVISION_REMAINDER			db		"The division remainder is: "
MSG_DIVISION_REMAINDER_LEN		equ		$-MSG_DIVISION_REMAINDER


CRLF					db		13,10
CRLF_LEN				equ		$-CRLF


;;;
; System Calls
SYS_WRITE			equ		1


;;;
; File descriptors
FD_STDOUT			equ		1


;;;
;	Return values (for whatever reason)
RETURN_VALUE		equ		7


; Integers
MY_INT_A			dq		233
MY_INT_B			dq		256


;;;;;;;;;;;;;;
; Text Section
section .text


;;;;;;;;;;;;;;;;;;;;;;
; Our external symbols
extern libPuhfessorP_printSignedInteger64
extern libPuhfessorP_printRegisters


; Our entry point
global math
math:
	
	; Load 
	call multiplyTest
	call divideTest
	
	; We're done
	mov rax, RETURN_VALUE	; Mov 7 into rax (our return code)
	ret						; Return control back to the driver

;;;;;;;;;;;;;;;
; Multiply test
; void multiplyTest();
;
; Register usage:
;	r12: Temporarily hold an immediate for multiplication
;	r13: Temporarily hold an immediate for multiplication
;	r14: Temporarily hold a global for multiplication
;	r15: Temporarily hold a global for multiplication
multiplyTest:
	
	; Prologue
	push r12
	push r13
	push r14
	push r15
	
	; Multiply immediates
	mov r12, 233	; Setup r12
	mov r13, 256	; Setup r13
	imul r12, r13	; Multiply (signed int64) r12 by r13, and put the result into r12
					; This could also be commented as r12 = r12 * r13
	
	; Prefix to the immediates result
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_MULT_IMMEDIATE_PREFIX
	mov rdx, MSG_MULT_IMMEDIATE_PREFIX_LEN
	syscall
	
	; Ask libP to print the result (immediates)
	mov rdi, r12								; First integer argument goes into rdi
	call libPuhfessorP_printSignedInteger64		; Do a call (will return like a func)
	
	; Suffix to the immediates result
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_MULT_IMMEDIATE_SUFFIX
	mov rdx, MSG_MULT_IMMEDIATE_SUFFIX_LEN
	syscall
	call crlf
	
	; Multiply global memory (slow)
	mov r14, [MY_INT_A]	; Setup r14
	mov r15, [MY_INT_B]	; Setup r15
	imul r14, r15		; r14 = r14 * r15
	
	; Extra stuff for fun
	inc qword r14		; r14++
	add r14, 5			; r14 = r14 + 5
	
	; Prefix to the globals result
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_MULT_GLOBAL_PREFIX
	mov rdx, MSG_MULT_GLOBAL_PREFIX_LEN
	syscall
	
	; Ask libP to print the result (global memory)
	mov rdi, r14								; First integer argument goes into rdi
	call libPuhfessorP_printSignedInteger64		; Do a call (will return like a func)
	
	; Suffix to the globals result
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_MULT_GLOBAL_SUFFIX
	mov rdx, MSG_MULT_GLOBAL_SUFFIX_LEN
	syscall
	call crlf
	
	; Epilogue
	pop r15
	pop r14
	pop r13
	pop r12
	
	ret


;;;;;;;;;;;;;
; Divide Test
; void divideTest();
;
; Register usage:
;	r12: Divisor we'll use
;	r14: Resulting quotient
;	r15: Resulting remainder
divideTest:
	
	; Prologue
	push r12
	push r14
	push r15
	
	mov rax, 256	; Setup rax (numerator)
	cqo				; Stretch rax (64-bits) onto the 128-bit combination of rdx:rax
					; The numerator is now setup
	
	mov r12, 233
	idiv r12		; Divide the numerator by 233
					; rax now contains the answer
					; rdx now contains the remainder
	
	; Save the result of our division elsewhere
	; rax and rdx are not callee-saved, so they are unsafe across any function call
	; Let's just use other registers, since registers are very fast
	mov r14, rax
	mov r15, rdx
	
	; Prefix to the quotient
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_DIVISION_QUOTIENT
	mov rdx, MSG_DIVISION_QUOTIENT_LEN
	syscall
	
	; Ask libP to print the quotient (answer)
	mov rdi, r14								; First integer argument goes into rdi
	call libPuhfessorP_printSignedInteger64		; Do a call (will return like a func)
	call crlf
	
	; Prefix to the remainder
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_DIVISION_REMAINDER
	mov rdx, MSG_DIVISION_REMAINDER_LEN
	syscall
	
	; Ask libP to print the remainder
	mov rdi, r15								; First integer argument goes into rdi
	call libPuhfessorP_printSignedInteger64		; Do a call (will return like a func)
	call crlf
	
	; Epilogue
	pop r15
	pop r14
	pop r12
	
	ret

;;;
; Custom function to print a CRLF
; void crlf();
crlf:

	; Prologue
	push r12
	push r13

	; Just to have a reason to preserve some callee-saved registers,
	; let's mess with the values of r12 and r13
	mov r12, 5
	mov r13, 9

	; Print the CRLF!
	mov rax, SYS_WRITE	; System call code
	mov rdi, FD_STDOUT	; Print to stdout
	mov rsi, CRLF		; Pointer to first character of string to print
	mov rdx, CRLF_LEN	; Length of the string to print
	syscall

	; Epilogue
	pop r13
	pop r12

	ret






