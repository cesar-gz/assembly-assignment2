; CPSC 240, Cesar Gutierrez

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .data
	
	SYS_WRITE		equ	1
	SYS_EXIT			equ	60
	
	EXIT					equ	214
	
	FD_STDIN			equ	0
	FD_STDOUT		equ	1
	FD_STDERR		equ	2

	LOCAL_VAR_COUNT	equ	100

	CRLF					db	13,10
	CRLF_LEN		equ	$-CRLF
	
	FIRST_MESSAGE					db	"This program will reverse your array of integers. Enter a sequence of long integers separated by the enter key. Enter 'q' to quit."
	FIRST_MESSAGE_LEN		equ	$-FIRST_MESSAGE
	
	SEC_MESSAGE					db	"Enter the next integer: "
	SEC_MESSAGE_LEN			equ	$-SEC_MESSAGE
	
	THR_MESSAGE					db	"You entered: "
	THR_MESSAGE_LEN			equ	$-THR_MESSAGE
	
	FOU_MESSAGE					db	"That doesn't make sense so we are going to move on"
	FOU_MESSAGE_LEN			equ	$-FOU_MESSAGE
	
	USERS_INPUT						dq	0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text

extern libPuhfessorP_printSignedInteger64
extern libPuhfessorP_inputSignedInteger64

global manager
manager:

	call crlf
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, FIRST_MESSAGE
	mov rdx, FIRST_MESSAGE_LEN
	syscall
	call crlf

	push rbp		;register base pointer
	push rbx
	push r12
	push r13
	push r14
	push r15
	
	;;;;;; Array allocation;;;;;;;;;;
	
	mov rbp, rsp	; have the stack pointer point to the base pointer(where we started the array)
	mov r10, LOCAL_VAR_COUNT		; r10 = 100 integers
	imul r10, 8			; 100 integers * 8 bytes = our allocation of space
	sub rsp, r10		;  move the stack pointer to r10
	mov r12, rsp		; have the stack pointer point to the first integer
	
	;;;;;;; Filling in the Array;;;;;;;
array_builder:

	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, SEC_MESSAGE							; asking for input message
	mov rdx, SEC_MESSAGE_LEN
	syscall
	call crlf
	
	call libPuhfessorP_inputSignedInteger64
	mov [USERS_INPUT], rax							; their actual input - > rax -> USERS_INPUT
	
	mov r15, 9223372036854775808
	cmp [USERS_INPUT], r15						; if their input is not a number the array is finished
	je invalidInput
	
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, THR_MESSAGE							; printing out input message
	mov rdx, THR_MESSAGE_LEN
	syscall
	mov rdi, [USERS_INPUT]
	call libPuhfessorP_printSignedInteger64 	;the users input has been printed, "You've entered : " message
	call crlf
	
	mov r14, 0													; have the offset/index at 0
	cmp r14, LOCAL_VAR_COUNT			; 0 (our array index) compared to our size of the array : LOCAL_VAR_COUNT
	jge array_finished
	
	mov r13, [USERS_INPUT]
	mov [r12 + (r14 * 8)], r13	; array[r14 ( our pointer)] = r13
	inc r14
	jmp array_builder

invalidInput:
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, FOU_MESSAGE							; "that doesn't make sense" message based on the users invalid input
	mov rdx, FOU_MESSAGE_LEN
	syscall
	call crlf

array_finished:
	nop

	;;;;;;; Clean up
	mov rsp, rbp
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
		
goodbye:
	
	mov rax, EXIT
	ret

crlf:
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, CRLF
	mov rdx, CRLF_LEN
	syscall
	ret
