TITLE Program3		(Program3.asm)

; Program Description:
; Author: Sean Reilly
; Date Created: 7/23/2015
; Last Modification Date: 7/23/2015

INCLUDE Irvine32.inc

	LOWER = 1
	UPPER = 400

.data
	intro			BYTE		"Composite Numbers Programmed by Sean Reilly",0
	instruct1		BYTE		"Enter the number of composite numbers you would like to see.",0
	instruct2		BYTE		"I’ll accept orders for up to 400 composites.",0
	instruct3		BYTE		"Enter the number of composites to display [1 .. 400]: ",0
	errMsg			BYTE		"Out of range. Try again.",0
	bye				BYTE		"Results certified by Sean Reilly.  Goodbye.", 0
	spaces			BYTE		"   ",0

	userInput		DWORD		?
	compositeNum	DWORD		?
	lineCounter		DWORD		0

.data

; (insert variables here)

.code
main PROC

; (insert executable instructions here)

	exit		; exit to operating system
main ENDP

; (insert additional procedures here)

END main