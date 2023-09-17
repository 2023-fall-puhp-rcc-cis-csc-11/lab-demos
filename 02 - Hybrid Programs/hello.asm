

;;;;;;;;;;;;;;;;;;;;;;;;;
; Assembly w/ Professor P


;;;;;;;;;;;;;;
; Data Section
section .data


;;;
; CStrings

; We could if we wanted, but not convenient
SOME_BYTES						db		123,178,239,23
SOME_QWORDS						dq		12300000000,1780000000,23900000,2300000
; We could if we wanted, but not convenient


WELCOME_MSG						db		"Hello, this is the hello module!"
WELCOME_MSG_LEN					equ		$-WELCOME_MSG

INPUT_MSG						db		"Please enter an integer: "
INPUT_MSG_LEN					equ		$-INPUT_MSG

GOODBYE_MSG						db		"Thank you for your input. Your number will be returned to the driver."
GOODBYE_MSG_LEN					equ		$-GOODBYE_MSG

CRLF							db		13,10   ; \r\n
CRLF_LEN						equ		$-CRLF

;;;
; System Calls
SYS_WRITE						equ		1


;;;
; File descriptors
FD_STDOUT						equ		1


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; BSS Section (uninitialized data)
section .bss

INPUTTED_LONG			resq	1

;;;;;;;;;;;;;;
; Text Section
section .text


;;;;;;;;;;;;;;;;;;;;;;
; Our external symbols
extern libPuhfessorP_inputSignedInteger64
;extern libPuhfessorP_printSignedInteger64


; Our hello function
global hello
hello:
	
	; Welcome message
	mov rax, SYS_WRITE					; System call code
	mov rdi, FD_STDOUT					; Print to stdout
	mov rsi, WELCOME_MSG				; Pointer to first character of string to print
	mov rdx, WELCOME_MSG_LEN			; Length of the string to print
	syscall
	call crlf
	
	; Input message
	mov rax, SYS_WRITE					; System call code
	mov rdi, FD_STDOUT					; Print to stdout
	mov rsi, INPUT_MSG					; Pointer to first character of string to print
	mov rdx, INPUT_MSG_LEN				; Length of the string to print
	syscall
	
	; Utilize libP to input an integer from the user
	; It's using the signature: long libPuhfessorP_printSignedInteger64()
	call libPuhfessorP_inputSignedInteger64
	mov [INPUTTED_LONG], rax
	
	; Say thanks
	mov rax, SYS_WRITE					; System call code
	mov rdi, FD_STDOUT					; Print to stdout
	mov rsi, GOODBYE_MSG				; Pointer to first character of string to print
	mov rdx, GOODBYE_MSG_LEN			; Length of the string to print
	syscall
	call crlf
	
	; We're done
	mov rax, [INPUTTED_LONG]			; Mov our return code into rax
	ret									; Return control back to the caller (driver)


;;;
; Custom function to print a CRLF
crlf:
	
	; Print the CRLF!
	mov rax, SYS_WRITE	; System call code
	mov rdi, FD_STDOUT	; Print to stdout
	mov rsi, CRLF		; Pointer to first character of string to print
	mov rdx, CRLF_LEN	; Length of the string to print
	syscall
	
	ret





