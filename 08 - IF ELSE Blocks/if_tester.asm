

;;;;;;;;;;;;;;;;;;;;;;;;;
; Assembly w/ Professor P


;;;;;;;;;;;;;;
; Data Section
section .data


;;;
; CStrings
MSG_ASK_INPUT				db		"Please enter an integer: "
MSG_ASK_INPUT_LEN			equ		$-MSG_ASK_INPUT

MSG_IF_BEGIN				db		"The basic IF test has begun"
MSG_IF_BEGIN_LEN			equ		$-MSG_IF_BEGIN
MSG_IF_CHECKED_NUMBER		db		"Will test against this number: "
MSG_IF_CHECKED_NUMBER_LEN	equ		$-MSG_IF_CHECKED_NUMBER
MSG_IF_END					db		"The basic IF test has ended"
MSG_IF_END_LEN				equ		$-MSG_IF_END

MSG_IF_YES_EQUAL1			db		"Your input was equal to "
MSG_IF_YES_EQUAL1_LEN		equ		$-MSG_IF_YES_EQUAL1
MSG_IF_YES_EQUAL2			db		"!"
MSG_IF_YES_EQUAL2_LEN		equ		$-MSG_IF_YES_EQUAL2

MSG_IFELSE_BEGIN			db		"Begin if/else test"
MSG_IFELSE_BEGIN_LEN		equ		$-MSG_IFELSE_BEGIN
MSG_IFELSE_EQUAL_TO_5		db		"Your input was equal to 5"
MSG_IFELSE_EQUAL_TO_5_LEN	equ		$-MSG_IFELSE_EQUAL_TO_5
MSG_IFELSE_EQUAL_TO_6		db		"Your input was equal to 6"
MSG_IFELSE_EQUAL_TO_6_LEN	equ		$-MSG_IFELSE_EQUAL_TO_6
MSG_IFELSE_LESS_THAN_10		db		"Your input was less than 10"
MSG_IFELSE_LESS_THAN_10_LEN	equ		$-MSG_IFELSE_LESS_THAN_10
MSG_IFELSE_ELSE				db		"No conditions were satisfied"
MSG_IFELSE_ELSE_LEN			equ		$-MSG_IFELSE_ELSE
MSG_IFELSE_END				db		"End if/else test"
MSG_IFELSE_END_LEN			equ		$-MSG_IFELSE_END

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
extern libPuhfessorP_printSignedInteger64


;;;;;;;;;;;;;;;;;
; Our entry point
;
; Register usage:
;	r12: the user's inputted integer
global if_tester
if_tester:
	
	; Prologue
	push r12
	
	; Ask the user for input
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_ASK_INPUT
	mov rdx, MSG_ASK_INPUT_LEN
	syscall
	call libPuhfessorP_inputSignedInteger64
	mov r12, rax
	
	; Run the basic IF tests with a few different numbers
	mov rdi, r12
	mov rsi, 5
	call ifTest
	call crlf
	;
	mov rdi, r12
	mov rsi, 6
	call ifTest
	call crlf
	;
	mov rdi, r12
	mov rsi, 7
	call ifTest
	call crlf
	
	; Run the complex IF ELSE tests
	mov rdi, r12
	call ifElseTest
	
	; Epilogue
	pop r12
	
	; We're done
	ret

;;;;;;;;;;;;;;;
; Basic IF test
; void ifTest(long input, long testAgainstMe);
;
; Register usage:
;	r12: The user's input
;	r13: The number we'll test the input against
ifTest:
	
	; Prologue
	push r12
	push r13
	
	; Grab function arguments
	mov r12, rdi
	mov r13, rsi
	
	; Print the begin message
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_IF_BEGIN
	mov rdx, MSG_IF_BEGIN_LEN
	syscall
	call crlf
	
	; Print what we'll check against
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_IF_CHECKED_NUMBER
	mov rdx, MSG_IF_CHECKED_NUMBER_LEN
	syscall
	mov rdi, r13
	call libPuhfessorP_printSignedInteger64
	call crlf
	
	; Print the special message, only if the user entered the right number
	cmp r12, r13				; if (            )
	je ifTest_IF_wasEqual		;      r12 == r13
	jmp ifTest_IF_done
	
ifTest_IF_wasEqual:				; {
	
	; Print the equality message (prefix)
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_IF_YES_EQUAL1
	mov rdx, MSG_IF_YES_EQUAL1_LEN
	syscall
	
	mov rdi, r13
	call libPuhfessorP_printSignedInteger64
	
	; Print the equality message (suffix)
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_IF_YES_EQUAL2
	mov rdx, MSG_IF_YES_EQUAL2_LEN
	syscall
	call crlf
								; }
ifTest_IF_done:
	
	; Say goodbye
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_IF_END
	mov rdx, MSG_IF_END_LEN
	syscall
	call crlf
	
	; Epilogue
	pop r13
	pop r12
	
	ret


;;;;;;;;;;;;;;;;;;;;
; void ifElseTest(long input);
;
; More thorough test of IF/ELSEIF/ELSE blocks
;
; Register usage:
;	r12: The user's input (first argument)
ifElseTest:
	
	; Prologue
	push r12
	
	; Grab the user's input (first argument)
	mov r12, rdi
	
	; Say hello
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_IFELSE_BEGIN
	mov rdx, MSG_IFELSE_BEGIN_LEN
	syscall
	call crlf

ifElseTest_ifBegin:

	; Check if the input was == 5
	cmp r12, 5					; if (          )
	je	ifElseTest_equal5		;      r12 == 5
	jmp ifElseTest_elseIfEqual6Begin

ifElseTest_equal5:				; {
	
	; Say it was equal to 5
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_IFELSE_EQUAL_TO_5
	mov rdx, MSG_IFELSE_EQUAL_TO_5_LEN
	syscall
	call crlf
	
	jmp ifElseTest_ifDone
	
								; }

ifElseTest_elseIfEqual6Begin:
	
	; Check if the input was == 6
	cmp r12, 6							; else if (          )
	je ifElseTest_elseIfEqual6True		;           r12 == 6
	jmp ifElseTest_elseIfEqualLess10Begin

ifElseTest_elseIfEqual6True:			; {
	
	; Say it was equal to 6
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_IFELSE_EQUAL_TO_6
	mov rdx, MSG_IFELSE_EQUAL_TO_6_LEN
	syscall
	call crlf
	
	jmp ifElseTest_ifDone
	
										; }

ifElseTest_elseIfEqualLess10Begin:
	
	; Check if the input was < 10
	cmp r12, 10								; else if (          )
	jl ifElseTest_elseIfEqualLess10True		;           r12 < 10
	jmp ifElseTest_else

ifElseTest_elseIfEqualLess10True:			; {
	
	; Say it was less than 10
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_IFELSE_LESS_THAN_10
	mov rdx, MSG_IFELSE_LESS_THAN_10_LEN
	syscall
	call crlf
	
	jmp ifElseTest_ifDone

											; }

ifElseTest_else:
											; else {
	; Say no conditions applied
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_IFELSE_ELSE
	mov rdx, MSG_IFELSE_ELSE_LEN
	syscall
	call crlf
	
	jmp ifElseTest_ifDone
											; }

ifElseTest_ifDone:
	
	; Say goodbye
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_IFELSE_END
	mov rdx, MSG_IFELSE_END_LEN
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






