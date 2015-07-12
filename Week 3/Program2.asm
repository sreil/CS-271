TITLE Program2		(Program2.asm)

; Program Description: Calculates Fibonacci numbers
;1) Getting string input
;2) Designing and implementing a counted loop
;3) Designing and implementing a post-test loop
;4) Keeping track of a previous value
;5) Implementing data validation
; Author: Sean Reilly
; Date Created: July 8, 2015
; Last Modification Date: July 11, 2015

INCLUDE Irvine32.inc

LIMIT EQU <46>

.data

intro1			BYTE	"Fibonacci Numbers ", 0
intro2			BYTE	"Programmed by Sean Reilly ", 0
prompt1			BYTE	"What's your name? ", 0
prompt2			BYTE	"Hello, ", 0
prompt3			BYTE	"Enter the number of Fibonacci terms to be displayed ", 0
prompt4			BYTE	"Give the number as an integer in the range [1 .. 46].", 0
fibPrompt		BYTE	"How many Fibonacci terms do you want? ", 0
error			BYTE	"Out of range. Please enter an integer in [1 .. 46].", 0
certified		BYTE	"Results certified by Sean Reilly.", 0;
goodbye			BYTE	"Goodbye, ", 0
spaces			BYTE	"     ", 0 ;for extra credit
userName		BYTE	33 DUP(0)
userNum			DWORD	?	
fibNum			DWORD	?	
fib1			DWORD	?
fib2			DWORD	?	
columns			DWORD	?	; to keep track of multiples of five

.code
main PROC

; Display the program title and programmer’s name
	mov		edx, OFFSET intro1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro2
	call	WriteString
	call	CrLf
	call	CrLf
; Then get the user’s name, and greet the user
	mov		edx, OFFSET prompt1
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	ReadString
	mov		edx, OFFSET prompt2
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

; Prompt the user to enter the number of Fibonacci terms to be displayed. Advise the user to enter an integer
;in the range [1 .. 46].
	mov		edx, OFFSET prompt3
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt4
	call	WriteString
	call	CrLf
	call	CrLf
	jmp		getInput

rangeCheck: ; displays error message if outside the 1-46 range
	mov		edx, OFFSET error
	call	WriteString
	call	CrLf

getInput: ; Get and validate the user input (n). 
	mov		edx, OFFSET fibPrompt
	call	WriteString
	call	ReadInt
	call	CrLf
	mov		userNum, eax

; checks the lower input
	mov		eax, userNum
	mov		ebx, 1
	cmp		eax, ebx
	jge		checkUpper
	jmp		rangeCheck

checkUpper: ; check the upper limit
	mov		eax, userNum
	mov		ebx, LIMIT
	cmp		eax, ebx
	jg		rangeCheck

; Calculate and display all of the Fibonacci numbers up to and including the nth term. The results should be
; displayed 5 terms per line with at least 5 spaces between terms

	call	CrLf
	mov		eax, 1		; first term
	mov		fib1, eax
	call	WriteDec
	mov		edx, OFFSET spaces ;puts 5 spaces between the numbers
	call	WriteString

	mov		eax, 1		
	cmp		eax, userNum
	jz		endOfDisplay	 ; End if asked for one termif asked for 1 number, will display 1

	mov		eax, 1		 
	mov		fib2, eax
	call	WriteDec
	mov		edx, OFFSET spaces
	call	WriteString

	mov		eax, 2
	cmp		eax, userNum
	jz		endOfDisplay	 ; End if asked for two terms

	mov		ecx, userNum  
	dec		ecx			 
	dec		ecx			 

	mov		eax, 2		 
	mov		columns, eax

fibCalc: 
	mov		eax, fib1		
	add		eax, fib2
	mov		fibNum, eax
	call	WriteDec
	mov		edx, OFFSET spaces
	call	WriteString

	inc		columns		
	mov		edx, 0
	mov		eax, columns
	mov		ebx, 5
	div		ebx
	cmp		edx, 0			
	jz		newLine	;new line to display 5 numbers per line		
	jmp		noNewLine		

newLine:
	call	CrLf

noNewLine:						
	mov		eax, fib2		
	mov		fib1, eax		
	mov		eax, fibNum
	mov		fib2, eax		
	loop	fibCalc				

endOfDisplay: ; Display a parting message that includes the user’s name, and terminate the program.
	call	CrLf
	call	CrLf
	mov		edx, OFFSET certified
	call	WriteString
	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main