TITLE Program2		(Program2.asm)

; Program Description: Calculates Fibonacci numbers
;1) Getting string input
;2) Designing and implementing a counted loop
;3) Designing and implementing a post-test loop
;4) Keeping track of a previous value
;5) Implementing data validation
; Author: Sean Reilly
; Date Created: July 8, 2015
; Last Modification Date: July 8, 2015

INCLUDE Irvine32.inc

; (insert symbol definitions here)

.data

intro1		BYTE	"Fibonacci Numbers", 0
intro2		BYTE	"Programmed by Sean Reilly", 0
prompt1		BYTE	"What's your name? ", 0
prompt2		BYTE	"Nice to meet you, ", 0
prompt3		BYTE	"Enter the number of Fibonacci terms to be displayed ", 0
prompt4		BYTE	"Give the number as an integer in the range [1 .. 46].", 0
instruct1	BYTE	"How many Fibonacci terms do you want?", 0
instruct2	BYTE	"You must enter a number between 1 - 46.", 0
error		BYTE	"Out of range. Enter a number in [1 .. 46]", 0
;exit		BYTE	"Results certified by Sean Reilly", 0
exit2		BYTE	"Goodbye, ", 0
userName	DWORD	30 DUP(0)
num1		DWORD	?
num2		DWORD	?
total		DWORD	?
column		DWORD	?

.code
main PROC

; (insert executable instructions here)
;Extra-credit options (original definition must be fulfilled):
;1. Display the numbers in aligned columns.
;2. Do something incredible.

	exit		; exit to operating system
main ENDP

; (insert additional procedures here)

END main