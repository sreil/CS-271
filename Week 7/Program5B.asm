TITLE Program5B			(Program5B.asm)

; Program Description: Combinations calculator
; Author: Sean Reilly
; Date Created: 8/4/15
; Last Modification Date: 8/9/15

INCLUDE Irvine32.inc

HI = 12 ;upper limit
LOWN = 3	
LOWR = 1

.data
instruct				BYTE	"Welcome to the Combinations Calculator", 0
instruct2				BYTE	"           Implemented by Sean Reilly", 0
instruct3				BYTE	"I'll give you a combinations problem. You enter your answer,", 0
instruct4				BYTE	"and I'll let you know if you're right.", 0
directions				BYTE	"Problem:", 0
directions2				BYTE	"Number of elements in the set: ", 0
directions3				BYTE	"Number of elements to choose from the set: ", 0
directions4				BYTE	"How many ways can you choose? ", 0
results					BYTE	"There are ", 0
results2				BYTE	" combinations of ", 0
results3				BYTE	" items from a set of ", 0
incorrect				BYTE	"You need more practice.", 0
right					BYTE	"You are correct!", 0
error					BYTE	"Invalid response. ", 0
notNumber				BYTE	"Input is not a number.", 0
another					BYTE	"Another problem (y/n)? ", 0
response				BYTE	10 DUP(0)
yes						BYTE	"y, Y", 0
no						BYTE	"n, N", 0
goodbye					BYTE	"OK ... goodbye.", 0
string					BYTE	33 DUP(0)	
answer					DWORD	?	; user's answer
total					DWORD	?	; total
set						DWORD	?	; n value
choose					DWORD	?	; r value

Write		MACRO	buffer
	push	edx
	mov		edx, OFFSET buffer
	call	WriteString
	pop		edx
ENDM

.code
main PROC

	call	Randomize
	pushad

	call	introduction

anotherProb:

	push	OFFSET set
	push	OFFSET choose
	call	generate
	
	push	OFFSET answer
	call	getAnswer

	push	set
	push	choose
	push	OFFSET total
	call	combinations			; calculate result (combinations calls factorial)

	push	set
	push	choose
	push	answer
	push	total
	call	showResults				; show calculated result and display user performance

	call	nextProblem				; check to see if user would like to do another problem

	mov		esi, OFFSET response	; if user response is y, then show another problem
	mov		edi, OFFSET yes
	cmpsb
	je		anotherProb
	Write	goodbye			; otherwise, display goodbye message
	call	CrLf

	popad
	exit
main ENDP

introduction PROC

	Write		instruct ;displays instructions and my name
	call	CrLf
	Write		instruct2
	call	CrLf
	call	CrLf

	Write		instruct3
	call	CrLf
	Write		instruct4

	ret 8
introduction ENDP

generate PROC
	push	ebp
	mov		ebp, esp
	pushad

	mov		eax, HI			
	sub		eax, LOWN	
	inc		eax

	call	RandomRange
	
	add		eax, LOWN
	mov		ebx, [ebp+12]	
	mov		[ebx], eax

	mov		eax, [ebx]
	sub		eax, LOWR
	inc		eax
	
	call	RandomRange

	add		eax, LOWR
	mov		ebx, [ebp+8]	
	mov		[ebx], eax

	call	CrLf
	Write	directions
	call	CrLf

	Write	directions2
	mov		ebx, [ebp+12]
	mov		eax, [ebx]
	call	WriteDec
	call	CrLf
	
	Write	directions3
	mov		ebx, [ebp+8]
	mov		eax, [ebx]
	call	WriteDec
	call	CrLf

	popad
	pop		ebp
	ret		8

generate ENDP

getAnswer PROC ;gets users answer
	push	ebp
	mov		ebp, esp
	pushad

wrong:
	mov		eax, 0
	mov		ebx, [ebp+8]
	mov		[ebx], eax

	Write	directions4
	mov		edx, OFFSET string
	mov		ecx, 32
	call	ReadString
	mov		ecx, eax
	mov		esi, OFFSET string

next:
	mov		ebx, [ebp+8]
	mov		eax, [ebx]
	mov		ebx, 10
	mul		ebx
	
	mov		ebx, [ebp+8]
	mov		[ebx], eax
	mov		al, [esi]
	cmp		al, 48
	jl		invalid

	cmp		al, 57
	jg		invalid

	inc		esi
	sub		al, 48
		
	mov		ebx, [ebp+8]
	add		[ebx], al

	loop	next
	jmp		quit

invalid:
	Write	notNumber
	call	CrLf
	jmp		wrong

quit:
	popad
	pop		ebp
	ret		4
getAnswer ENDP

combinations PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	edx
	sub		esp, 16

	push	[ebp+16]
	push	[ebp+8]
	call	calculation

	mov		ebx, [ebp+8]				
	mov		eax, [ebx]
	mov		DWORD PTR [ebp-4], eax

	push	[ebp+12]
	push	[ebp+8]
	call	calculation

	mov		ebx, [ebp+8]
	mov		eax, [ebx]
	mov		DWORD PTR [ebp-8], eax

	mov		eax, [ebp+16]
	mov		ebx, [ebp+12]
	sub		eax, ebx
	cmp		eax, 0
	je		resultIsOne
	mov		DWORD PTR [ebp-12], eax

	push	[ebp-12]
	push	[ebp+8]
	call	calculation

	mov		ebx, [ebp+8]
	mov		eax, [ebx]
	mov		DWORD PTR [ebp-16], eax

	mov		eax, [ebp-8]
	mov		ebx, [ebp-16]
	mul		ebx

	mov		edx, 0
	mov		ebx, eax
	mov		eax, [ebp-4]
	div		ebx

	mov		ebx, [ebp+8]
	mov		[ebx], eax
	jmp		quit

resultIsOne:
	mov		eax, 1
	mov		ebx, [ebp+8]
	mov		[ebx], eax
	mov		eax, [ebx]

quit:
	pop		edx
	pop		ebx
	pop		eax
	mov		esp, ebp
	pop		ebp
	ret		12
combinations ENDP

calculation PROC
	push	ebp
	mov		ebp, esp
	pushad	

	mov		eax, [ebp+12]
	mov		ebx, [ebp+8]
	cmp		eax, 0
	ja		recursive
	mov		esi, [ebp+8]
	mov		eax, 1
	mov		[esi], eax
	jmp		quit

recursive:

	dec		eax
	push	eax
	push	ebx
	call	calculation
	mov		esi, [ebp+8]
	mov		ebx, [esi]
	mov		eax, [ebp+12]	
	mul		ebx
	mov		[esi], eax
	
quit:		
	popad
	pop		ebp				
	ret		8

calculation ENDP

showResults PROC
	push	ebp
	mov		ebp, esp
	pushad
	
	call	CrLf
	Write	results
	mov		eax, [ebp+8]
	call	WriteDec

	Write	results2
	mov		eax, [ebp+16]
	call	WriteDec

	Write	results3
	mov		eax, [ebp+20]
	call	WriteDec
	call	CrlF
	
	mov		eax, [ebp+12]
	cmp		eax, [ebp+8]
	je		correct
	call	CrlF

	Write	incorrect
	call	CrLf
	call	CrLf
	jmp		quit

correct:
	Write	right
	call	CrLf
	call	CrLf
quit:			
	popad
	pop		ebp
	ret		16

showResults ENDP

nextProblem PROC
	
	pushad

askYOrN:

	Write	another
	mov		edx, OFFSET response
	mov		ecx, 9
	call	ReadString

	mov		esi, OFFSET response
	mov		edi, OFFSET yes
	cmpsb
	je		quit

	mov		esi, OFFSET response
	mov		edi, OFFSET no
	cmpsb
	je		quit

	Write	error
	jmp		askYOrN	

quit:
	popad
	ret

nextProblem ENDP

END main