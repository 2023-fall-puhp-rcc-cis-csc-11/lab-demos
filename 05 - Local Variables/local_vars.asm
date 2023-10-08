
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;	Assembly w Professor Peralta


;;;;;;;;;;;;;;;;
;	Data Section
section .data


;	Messages
MSG_INTRO			db		"Hello! I am Cecil Hipplington-Shoreditch. The assembly module has started."
MSG_INTRO_LEN		equ		$-MSG_INTRO

CRLF				db		13,10
CRLF_LEN			equ		$-CRLF

;	Defines
NUM_INTEGERS		equ		50
INTEGER_SIZE		equ		8
INTEGER_START_VALUE	equ		7


;	Syscall codes
SYS_WRITE			equ		1


;	File descriptors
FD_STDIN			equ		0
FD_STDOUT			equ		1
FD_STDERR			equ		2


;;;;;;;;;;;;;;;;
;	Text Section
section .text

extern libPuhfessorP_printSignedInteger64


;;;;;;;;;;;;;;;;;;;;;;
;	void local_vars();
global local_vars
local_vars:
	
	call welcome
	
	call demo
	
	ret

;;;;;;;;;;;;;;;;;;;
;;	void welcome();
welcome:
	
	;;	Print our welcome message
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_INTRO
	mov rdx, MSG_INTRO_LEN
	syscall
	call crlf
	
	ret


;;;;;;;;;;;;;;;;
;	void demo();
;	
;	Register usage:
;		r12: Pointer to first local integer
;		r13: Pointer to last local integer
;		r14: Running pointer to current integer
;		r15: Temporary initialization value
demo:
	
	;	Prologue
	push rbp
	push r12
	push r13
	push r14
	push r15
	
	;	Remember where the stack pointer started
	;	We'll store its value in the base pointer,
	;	For an easy way to remember.
	mov rbp, rsp
	
	;	Now that we remember where the stack started,
	;		we can manipulate it directly.
	;	By moving the stack pointer a bit, we can make room
	;		for local variables. This is how C++ makes locals!
	;	Note that the stack grows "downward in memory", meaning
	;		that if we wanted to create a quadword local variable,
	;		we would *subtract* 8 from the stack, to make it point
	;		8 memory locations (aka 8 bytes) lower in memory.
	
								;	First, we need to know how many bytes to make room for on the stack.
								;	We'll use r10 to hold our computation.
	mov r10, NUM_INTEGERS		;	Start with the number of integers we want.
	
	imul r10, INTEGER_SIZE		;	Since we want quadwords, we multiply the number by INTEGER_SIZE (8).
								;	This effectively says "make room for NUM_INTEGER quadwords on the stack
								;		by making room for (NUM_INTEGERS * INTEGER_SIZE) bytes on the stack."
								;	We could also have made room on the stack for other data sizes this way.
								;	For example, if we wanted words, we'd only multiply by 2.
								
	sub rsp, r10				;	Now that we know exactly how many bytes to reserve on the stack,
								;	we simply adjust the stack register by that amount.
	
	;	At this point in execution, we now have room on the stack for NUM_INTEGER quadwords.
	;	For simplicity, we'll say the "first" integer is now at the "top" of the stack.
	;	Using that approach, we can then say the next integer is at a higher memory location,
	;		and can iterate over each integer simply by increasing the memory location by INTEGER_SIZE.
	
	;	Now let's remember the first and last integers in our new local array
	mov r12, rsp											;	First integer
	lea r13, [r12 + ((NUM_INTEGERS - 1) * INTEGER_SIZE)]	;	Last integer
	
	;	Let's loop through our local array of integers, initializing them with some value
	
demo_initLoop_init:					;	Before while()
	
	mov r14, r12					;	Start the loop at the first integer
	mov r15, INTEGER_START_VALUE	;	Setup the first initialization value

demo_initLoop_top:					;	while()
	
	cmp r14, r13					;	If we're beyond the last integer, we're done
	jg demo_initLoop_done			;	Break the loop if r14 > r13
	
	;	Begin loop body {
	
	mov	[r14], r15					;	Set the integer
	inc	r15							;	Increase the initialization value
	
	;	End loop body }
	
demo_initLoop_bottom:
	
	add r14, INTEGER_SIZE	;	Advance to the next integer and jump back to the top of the loop
	jmp demo_initLoop_top
	
demo_initLoop_done:
	
	;	Nothing needed
	
demo_printLoop_init:
	
	mov r14, r12			;	Start the loop at the first integer
	
demo_printLoop_top:
	
	cmp r14, r13			; If we're beyond the last integer, we're done
	jg demo_printLoop_done
	
	;	Begin body {
	
	mov rdi, [r14]								;	Ask libP to print the current integer for us
	call libPuhfessorP_printSignedInteger64
	call crlf
	
	;	End body }
	
demo_printLoop_bottom:
	
	add r14, INTEGER_SIZE	;	Advance to the next integer and jump back to the top of the loop
	jmp demo_printLoop_top
	
demo_printLoop_done:
	
	; Epilogue
	mov rsp, rbp		;	Restore the stack pointer! (kill the local variables)
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	
	ret


;;;;;;;;;;;;;;;;
;;	void crlf();
crlf:
	
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, CRLF
	mov rdx, CRLF_LEN
	syscall
	
	ret







