TITLE Program 1			(Program1.asm)

; Program Description: Display your name and program title, display instructions, enter 2 numbers, calculate sum, difference, product, and quotient, display terminating message
; Author: Sean Reilly
; Date Created: 06/24/2015
; Last Modification Date: 7/4/2015

INCLUDE Irvine32.inc

.data
intro		BYTE	"Program 1 by Sean Reilly",0
instruct	BYTE	"This program will take 2 numbers that you enter and calcualte the sum, difference, product and quotient",0
number1		DWORD	?	;Int #1 to be entered by user
number2		DWORD	?	;Int #2 to be entered by user
prompt1		BYTE	"Please enter the first number now: ",0
prompt2		BYTE	"Please enter the second number now (less than or equal to the first): ",0
sum			DWORD	?	;calcualtes sum of number 1 and number 2
difference	DWORD	?	;calculates the difference of number 1 and number 2
product		DWORD	?	;calculates the product of number 1 and number 2
quotient	DWORD	?	;calculates the quotient of number 1 and number 2
remainder	DWORD	?	;calculates the remainder of the quotient of number 1 and number 2
results		BYTE	"The results are the following:  ",0
sumRes		BYTE	"Sum: ",0
difRes		BYTE	"Difference: ",0
prodRes		BYTE	"Product: ",0
quoRes		BYTE	"Quotient: ",0
remRes		BYTE	"The quotient has a remainder of: ",0
goodbye		BYTE	"That was fun! Adios!",0

.code
main PROC

;Introduce me
	mov		edx, OFFSET	intro
	call	WriteString
	call	CrLf	;new line

;Instructions
	mov		edx, OFFSET instruct
	call	WriteString
	call	CrLf

L1:

;Get user input for 2 numbers
	mov		edx, OFFSET prompt1
	call	WriteString
	call	ReadInt
	mov		number1, eax
	call	CrLf
	mov		edx, OFFSET prompt2
	call	WriteString
	call	ReadInt
	mov		number2, eax
	call	CrLf

	cmp		eax, number1 ;extra credit
	jg		L1

;calc the sum
	mov		eax, number1
	add		eax, number2 
	mov		sum, eax

;print the sum
	mov		edx, OFFSET sumRes	
	call	WriteString
	mov		edx, OFFSET sum
	call	WriteInt
	call	CrLf

;calc the difference
	mov		eax, number1
	mov		ebx, number2
	sub		eax, ebx
	mov		difference, eax

;print the difference
	mov		edx, OFFSET	difRes
	call	WriteString
	mov		edx, OFFSET difference
	call	WriteInt
	call	CrLf

;calc product
	mov		eax, number1 
	mov		ebx, number2
	mul		ebx
	mov		product, eax

;print the product
	mov		edx, OFFSET prodRes
	call	WriteString
	mov		edx, OFFSET product
	call	WriteInt
	call	CrLf

;calc the quotient and remainder
	
	mov		eax, number1
	mov		ebx, number2
	mov		edx, 0
	div		ebx
	mov		quotient, eax
	mov		remainder, edx
	
;print quotient
	mov		edx, OFFSET quoRes
	call	WriteString
	mov		edx, OFFSET quotient
	call	WriteInt
	call	CrLf

;print remainder
	mov		edx, OFFSET remRes
	call	WriteString
	mov		edx, OFFSET remainder
	call	WriteInt
	call	CrLf

;print goodbye
	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf

; exit to operating system
	exit

main ENDP

END main