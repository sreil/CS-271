TITLE Program Template			(template.asm)

; Program Description: Display your name and program title, display instructions, enter 2 numbers, calculate sum, difference, product, and quotient, display terminating message
; Author: Sean Reilly
; Date Created: 06/24/2015
; Last Modification Date: 06/24/2015

INCLUDE Irvine32.inc

; (insert symbol definitions here)

.data

intro		BYTE	"Program 1 by Sean Reilly"	;displays my name
intro2		BYTE	"Enter here"				;CHANGE THIS
instruction	BYTE	"This will take 2 numbers that you enter and calcualte the sum, difference, product and quotient", 0
number1		DWORD	"Please enter the first number: "
number2		DWORD	"Please enter the second number: "
sum			DWORD	?							;calcualtes sum of number 1 and number 2
difference	DWORD	?							;calculates the difference of number 1 and number 2
product		DWORD	?							;calculates the product of number 1 and number 2
quotient	DWORD	?							;calculates the quotient of number 1 and number 2
remainder	DWORD	?							;calculates the remainder of the quotient of number 1 and number 2
result		BYTE	"The results are the following: ", 0
sumRes		BYTE	"Sum: ", 0
difRes		BYTE	"Difference: ", 0
prodRes		BYTE	"Product: ", 0
quotRes		BYTE	"Quotient: ", 0
remRes		BYTE	"The quotient has a remainder of: ", 0
terminate	BYTE	"That was fun! Adios!", 0

.code
main PROC

; (insert executable instructions here)

	exit		; exit to operating system
main ENDP

; (insert additional procedures here)

END main