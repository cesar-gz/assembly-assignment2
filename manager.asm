; CPSC 240, Cesar Gutierrez

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .data
	
	SYS_WRITE		equ	1
	SYS_EXIT			equ	60
	
	EXIT					equ	214
	
	FD_STDIN			equ	0
	FD_STDOUT		equ	1
	FD_STDERR		equ	2

	CRLF					db	13,10
	CRLF_LEN		equ	$-CRLF
	
	FIRST_MESSAGE					db	"This program will reverse your array of integers. Enter a sequence of long integers separated by the enter key. Enter 'q' to quit."
	FIRST_MESSAGE_LEN		equ	$-FIRST_MESSAGE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text


global manager
manager:

	call crlf
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, FIRST_MESSAGE
	mov rdx, FIRST_MESSAGE_LEN
	syscall
	call crlf

	
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
