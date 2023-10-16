

;;;;;;;;;;;;;;;;;;;;;;;;;
; Assembly w/ Professor P


;;;;;;;;;;;;;;
; Data Section
section .data


;;;
; CStrings

MSG_JUMP_INTRO					db		"Begin jump test"
MSG_JUMP_INTRO_LEN				equ		$-MSG_JUMP_INTRO
MSG_JUMP_SHOULDNT_HAPPEN		db		"This message should not appear!"
MSG_JUMP_SHOULDNT_HAPPEN_LEN	equ		$-MSG_JUMP_SHOULDNT_HAPPEN
MSG_JUMP_EXIT					db		"End jump test"
MSG_JUMP_EXIT_LEN				equ		$-MSG_JUMP_EXIT

MSG_BRANCH_INTRO				db		"Begin branching test"
MSG_BRANCH_INTRO_LEN			equ		$-MSG_BRANCH_INTRO
MSG_BRANCH_PROMPT				db		"Please enter an integer: "
MSG_BRANCH_PROMPT_LEN			equ		$-MSG_BRANCH_PROMPT
MSG_BRANCH_GREATER_ZERO			db		"Your number was greater than 0!"
MSG_BRANCH_GREATER_ZERO_LEN		equ		$-MSG_BRANCH_GREATER_ZERO
MSG_BRANCH_LESS_TEN				db		"Your number was less than 10!"
MSG_BRANCH_LESS_TEN_LEN			equ		$-MSG_BRANCH_LESS_TEN
MSG_BRANCH_EQUAL_FIVE			db		"Your number was equal to 5!"
MSG_BRANCH_EQUAL_FIVE_LEN		equ		$-MSG_BRANCH_EQUAL_FIVE
MSG_BRANCH_EXIT					db		"End branching test"
MSG_BRANCH_EXIT_LEN				equ		$-MSG_BRANCH_EXIT


CRLF						db		13,10
CRLF_LEN					equ		$-CRLF


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
extern libPuhfessorP_inputSignedInteger64


; Our entry point
global cool
cool:
	
	; Load 
	call jumpTest
	call branchTest
	
	; We're done
	ret

;;;;;;;;;;;;;;;
; Jump test
; void jumpTest();
jumpTest:
	
	; Prologue
	; meh
	
	; Intro message
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_JUMP_INTRO
	mov rdx, MSG_JUMP_INTRO_LEN
	syscall
	call crlf
	
	; Jump past the following message
	jmp jumpTest_exiting
	
	; This should never be printed
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_JUMP_SHOULDNT_HAPPEN
	mov rdx, MSG_JUMP_SHOULDNT_HAPPEN_LEN
	syscall
	call crlf
	
jumpTest_exiting:

	; Exit message
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_JUMP_EXIT
	mov rdx, MSG_JUMP_EXIT_LEN
	syscall
	call crlf
	
	; Epilogue
	; meh
	
	ret


;;;;;;;;;;;;;;;;;;;;
; void branchTest();
; Test out basic comparison and branching instructions
;
; Register usage:
;	r12: The user's number
branchTest:
	
	; Prologue
	push r12
	
	; Intro
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_BRANCH_INTRO
	mov rdx, MSG_BRANCH_INTRO_LEN
	syscall
	call crlf
	
	; Ask for a number
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_BRANCH_PROMPT
	mov rdx, MSG_BRANCH_PROMPT_LEN
	syscall
	;
	call libPuhfessorP_inputSignedInteger64
	mov r12, rax
	
	; Is the number greater than 0?
	cmp r12, 0							; Populate rFlags with info about the comparison
	jle branchTest_afterGreaterTest		; Jump to branchTest_afterGreaterTest if r12 <= 0
	
	; Say their number was greater than zero
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_BRANCH_GREATER_ZERO
	mov rdx, MSG_BRANCH_GREATER_ZERO_LEN
	syscall
	call crlf

branchTest_afterGreaterTest:
	
	; Is the number less than than 10?
	cmp r12, 10
	jge branchTest_afterLessTest
	
	; Say their number was less than ten
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_BRANCH_LESS_TEN
	mov rdx, MSG_BRANCH_LESS_TEN_LEN
	syscall
	call crlf

branchTest_afterLessTest:
	
	; Is the number equal to 5?
	cmp r12, 5
	jne branchTest_afterEqualTest
	
	; Say their number was equal to 5
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_BRANCH_EQUAL_FIVE
	mov rdx, MSG_BRANCH_EQUAL_FIVE_LEN
	syscall
	call crlf
	
branchTest_afterEqualTest:
	
	; Say goodbye
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_BRANCH_EXIT
	mov rdx, MSG_BRANCH_EXIT_LEN
	syscall
	call crlf
	
	; Epilogue
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






