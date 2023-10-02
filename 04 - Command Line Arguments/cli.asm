
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;	Assembly w Professor Peralta


;;;;;;;;;;;;;;;;
;	Data Section
section .data


;	Messages
MSG_INTRO			db		"Hello! I am Carnegie Mondover. Welcome to my CLI demo."
MSG_INTRO_LEN		equ		$-MSG_INTRO

MSG_ARGC			db		"You have provided this many arguments: "
MSG_ARGC_LEN		equ		$-MSG_ARGC

CRLF				db		13,10
CRLF_LEN			equ		$-CRLF

;	Syscall codes
SYS_WRITE			equ		1


;	File descriptors
FD_STDIN			equ		0
FD_STDOUT			equ		1
FD_STDERR			equ		2


;;;;;;;;;;;;;;;
;	BSS Section
section .bss

;;;;;;;;;;;;;;;;
;	Text Section
section .text

extern libPuhfessorP_printSignedInteger64

;;;;;;;;;;;;;;;;;;;;;;;;
;	int main(int argc, char * argv[]);
;
;	Register usage:
;		r12: Number of CLI arguments (argc)
;		r13: argv pointer
global main
main:
	
	;	Prologue
	push r12
	push r13
	
	;;	Immediately save our incoming arguments, before they're lost
	mov r12, rdi		; rdi is our 1st incoming argument. Save it to r12
	mov r13, rsi		; rsi is our 2nd incoming argument. Save it to r13
	
	call welcome
	
	;	Print the prelude to the number of arguments found:
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_ARGC
	mov rdx, MSG_ARGC_LEN
	syscall
	
	;	Print the number of arguments found:
	mov rdi, r12
	call libPuhfessorP_printSignedInteger64
	call crlf
	
	;	Print the first two arguments (may crash the program if less are found)
	;	(but sadly we don't know conditional branching yet)
	;
	;	We'll also carelessly attempt to print 10 characters of each argument,
	;	even if there were less.
	;	This is a bad idea, but we don't yet know how to loop,
	;		which means we can't yet print a null terminated string.
	;	We'll probably see some junk data after the real arguments
	;
	;	Remember that argv is "an array of character pointers", which means
	;		each index in the array is a different pointer.
	;	Each pointer is its own null terminated string, for a particular argument (at that index).
	;	That means the first argument is inside argv[0] and the second is inside argv[1]
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, [r13]		; This is usually where we stick the char* to the string we want to print
	mov rdx, 10			; This is usually the length of the string to print
	syscall
	call crlf
	
	;	How can we advance to the next pointer?
	;	Since a pointer is simply a 64-bit memory address,
	;		we can load argv into a register and increase it by 8 (8 bytes aka 64-bits).
	;	The new value will be the second pointer at argv[1]
	
	mov r10, r13			; Let's use temp register r10 this time (no need to preserve)
	add r10, 8				; Advance to the next pointer
	
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, [r10]			; r10 now contains the pointer we want. We must dereference it to get the real pointer.
	mov rdx, 10
	syscall
	call crlf
	
	;	Epilogue
	pop r13
	pop r12
	
	;	Main wants us to return an integer (we'll use 0 for success)
	mov rax, 0
	
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


;;	Prints CRLF
crlf:
	
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, CRLF
	mov rdx, CRLF_LEN
	syscall
	
	ret







