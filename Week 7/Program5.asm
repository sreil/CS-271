TITLE Program5			(Program5.asm)

; Program Description:
; Author: Sean Reilly
; Date Created: 8/4/15
; Last Modification Date: 8/4/15

INCLUDE Irvine32.inc


myWriteString	MACRO	buffer
	push	edx
	mov		edx, OFFSET buffer
	call	WriteString
	pop		edx

	ENDM

.data

instruct				BYTE	"Welcome to the Combinations Calculator", 0
instruct2				BYTE	"     Implemented by Sean Reilly", 0
instruct3				BYTE	"I'll give you a combinations problem. You enter your answer,", 0
instruct4				BYTE	"and I'll let you know if you're right.", 0
prompt					BYTE	"Problem:", 0
prompt2					BYTE	"Number of elements in the set: ", 0
prompt3					BYTE	"Number of elements to choose from the set: ", 0
prompt4					BYTE	"How many ways can you choose? ", 0


.code
main PROC

; (insert executable instructions here)

	exit		; exit to operating system
main ENDP

intro PROC

	myWriteString	instruct ;introduce programmer and set up program
	call	CrLf
	myWriteString	instruct2
	call	CrLf
	myWriteString	instruct3
	call	CrLf
	myWriteString	instruct4

	ret
intro ENDP

END main