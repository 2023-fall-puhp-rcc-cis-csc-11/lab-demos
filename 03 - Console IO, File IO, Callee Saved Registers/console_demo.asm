
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;	Assembly w Professor Peralta


;;;;;;;;;;;;;;;;
;	Data Section
section .data


;	Messages
MSG_INTRO			db		"The console demo module has started"
MSG_INTRO_LEN		equ		$-MSG_INTRO

MSG_STDERR_TEST		db		"This message should print to STDERR"
MSG_STDERR_TEST_LEN	equ	$-MSG_STDERR_TEST

MSG_ASK_INPUT		db		"Please enter 5 characters now: "
MSG_ASK_INPUT_LEN	equ		$-MSG_ASK_INPUT

MSG_ECHO_SIZE		db		"Your input was this many bytes long (including null terminator): "
MSG_ECHO_SIZE_LEN	equ		$-MSG_ECHO_SIZE
MSG_ECHO			db		"Your input was the following: "
MSG_ECHO_LEN		equ		$-MSG_ECHO

INPUT_BUFFER_LEN	equ		8192

CRLF				db		13,10
CRLF_LEN			equ		$-CRLF


;	Files names (don't forget the null terminator!)
FILENAME_TO_READ	db		"input.txt",0
FILENAME_TO_WRITE	db		"output.txt",0


;	File open flags
FILE_FLAGS_READ		equ		0


;	File create flags
FILE_PERMS_STANDARD	equ		00640q


;	Syscall codes
SYS_READ			equ		0
SYS_WRITE			equ		1
SYS_OPEN			equ		2
SYS_CREATE			equ		85
SYS_CLOSE			equ		3


;	File descriptors
FD_STDIN			equ		0
FD_STDOUT			equ		1
FD_STDERR			equ		2


;;;;;;;;;;;;;;;
;	BSS Section
section .bss

INPUT_BUFFER			resb	8192
INPUT_BUFFER_USED		resq	1

;;;;;;;;;;;;;;;;
;	Text Section
section .text

extern libPuhfessorP_printRegisters
extern libPuhfessorP_printSignedInteger64

;;;;;;;;;;;;;;;;;;;;;;;;
;	void console_demo();
global console_demo
console_demo:
	
	call welcome
	call stderr_test
	call stdin_test
	call file_tests
	
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

;;;;;;;;;;;;;;;;;;;;;;;
;;	void stderr_test();
stderr_test:
	
	;;	Print a message to standard error (STDERR)
	mov rax, SYS_WRITE
	mov rdi, FD_STDERR
	mov rsi, MSG_STDERR_TEST
	mov rdx, MSG_STDERR_TEST_LEN
	syscall
	call crlf
	
	ret

;;;;;;;;;;;;;;;;;;;;;;
;;	void stdin_test();
stdin_test:
	
	;;	Read some characters from STDIN
	mov rax, SYS_READ
	mov rdi, FD_STDIN
	mov rsi, INPUT_BUFFER
	mov rdx, INPUT_BUFFER_LEN
	syscall
	;;	Save the number of valid characters inside the buffer
	mov [INPUT_BUFFER_USED], rax
	
	;;	Print the size acknowledgement prelude message
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_ECHO_SIZE
	mov rdx, MSG_ECHO_SIZE_LEN
	syscall
	
	;;	Print the size of the user's input
	mov rdi, [INPUT_BUFFER_USED]
	call libPuhfessorP_printSignedInteger64
	call crlf
	
	;;	Print the echoback prelude message
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG_ECHO
	mov rdx, MSG_ECHO_LEN
	syscall
	
	;;	Print the user's input back to them
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, INPUT_BUFFER
	mov rdx, [INPUT_BUFFER_USED]
	syscall
	
	ret

;;;;;;;;;;;;;;;;;;;;;;
;;	void file_tests();
;;
;;	Register usage:
;;		r12: Input file handle
;;		r13: Output file handle
;;		r14: Count of bytes read from the input file
file_tests:
	
	;	Prologue
	push r12
	push r13
	push r14
	
	;;	Open the input file for reading
	;;	For this demo, assume no errors (not smart as a long ter strategy)
	mov rax, SYS_OPEN
	mov rdi, FILENAME_TO_READ		; File name
	mov rsi, FILE_FLAGS_READ		; File status flags
	syscall
	mov r12, rax					; Save the file handle
	
	;;	Open the output file for writing
	;;	For this demo, assume no errors (not smart as a long ter strategy)
	;;	We use the create system call because we want this to succeed even if the file doesn't yet exist
	mov rax, SYS_CREATE
	mov rdi, FILENAME_TO_WRITE		; File name
	mov rsi, FILE_PERMS_STANDARD	; File's initial permissions
	syscall
	mov r13, rax					; Save the file handle
	
	call libPuhfessorP_printRegisters
	
	;;	Now that we've got both files open,
	;;	let's read from the input file so we can later write to the output file
	mov rax, SYS_READ
	mov rdi, r12					; File descriptor (input file)
	mov rsi, INPUT_BUFFER			; Address of where to store the characters
	mov rdx, INPUT_BUFFER_LEN		; Maximum count to read (size of our buffer)
	syscall
	mov r14, rax					; Remember how many bytes we read from the file
	
	;;	Now we (hopefully) have INPUT_BUFFER filled with data from
	;;	the input file.
	;;	Let's write it to the output file
	mov rax, SYS_WRITE
	mov rdi, r13					; File descriptor (output file)
	mov rsi, INPUT_BUFFER			; Address of where to find the data to write
	mov rdx, r14					; Number of bytes to write to the file (same as the number we got from the infile)
	syscall
	
	;;	Now, properly close both file handles, to avoid our program hogging resources
	;;	(imagine forgetting to do this in a more robust/complex program; you'd waste tons of memory and file handles)
	mov rax, SYS_CLOSE
	mov rdi, r12					; Closing the input file, by its handle
	syscall
	;
	mov rax, SYS_CLOSE
	mov rdi, r13					; Closing the output file, by its handle
	syscall
	
	;	Epilogue
	pop r14
	pop r13
	pop r12
	
	ret

;;	Prints CRLF
crlf:
	
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, CRLF
	mov rdx, CRLF_LEN
	syscall
	
	ret







