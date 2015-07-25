TITLE Program3		(Program3.asm)

; Program Description: Prints x amount of composite numbers 
; Author: Sean Reilly
; Date Created: 7/23/2015
; Last Modification Date: 7/25/2015

INCLUDE Irvine32.inc

    PER_LINE_MAX = 10 ;adjust here to change the max lines
    PER_PAGE_MAX = 40
    LOWER = 1
    UPPER = 400

.data
    intro			BYTE	"Composite Numbers Programmed by Sean Reilly",0
    instruct1		BYTE	"Enter the number of composite numbers you would like to see.",0
    instruct2		BYTE	"I'll accept orders for up to 400 composites.",0                      
    instruct3       BYTE    "Enter the number of composites to display [1 .. 400]: ", 0
	goodbye         BYTE    "Results certified by Sean Reilly.  Goodbye.", 0
    range		    BYTE    "Out of range. Try Again.", 0
    continue	    BYTE    "Press any key to continue... ", 0
    ;**EC: only check prime divisors, see below
    divisor         DWORD   2, 3, 5, 7, 0 ;check if prime
    userValue       DWORD   ? 
    testValue       DWORD   4 ; begins at number 4, adjust if needed 
    countsComp      DWORD   ? 
    perLine         DWORD   0 
    padSingle	    BYTE    "   ", 0 ; padding for single digit
    padDouble	    BYTE    "  ", 0  ; padding for double digit
    padTriple	    BYTE    " ", 0   ; padding for triple digit
    perPage         DWORD   ?
    
.code
main PROC
    mov     edx, OFFSET intro ;introduce programmer and present instructions
    call    WriteString
    call    CrLf
    
    mov     edx, OFFSET instruct1
    call    WriteString
    call    CrLf
    
    mov     edx, OFFSET instruct2
    call    WriteString
    call    CrLf
    
    getData: ;get user entered number
    mov     edx, OFFSET instruct3
    call    WriteString
    call    ReadInt
    mov     userValue, eax
    
    cmp     eax, UPPER ;check input to make sure it's not above 400 or below 1
    jg      error
    cmp     eax, LOWER
    jl      error
    jmp     printNumbers 
    
    error:
    mov     edx, OFFSET range
    call    WriteString
    call    CrLf
    jmp     getData
    
    mov     countsComp, 0
    mov     perLine, 0
    mov     perPage, 0
    
    printNumbers:
    
    mov     eax, perPage ;checks to see if new page needs to be created
    cmp     eax, PER_PAGE_MAX
    je      newPage
    
    mov     eax, userValue
    cmp     eax, countsComp 
    je      exitLoop
    
    call    isComposite
    inc     testValue

    mov     eax, perLine ;checks if a new line needs to start, adjust at top for different results
    cmp     eax, PER_LINE_MAX
    je      newLine
    
    jmp     printNumbers  
    
    newLine:
    call    CrLf
    mov     perLine, 0
    jmp     printNumbers
    
    newPage:
	;**EC: Display more composites, but show them one page at a time. The user can “Press any key to continue …” to view the next page. 
    mov     edx, OFFSET continue 
    call    WriteString
    
    keyFind:
    mov     eax, 50 
    call    Delay
    call    ReadKey 
    jz      keyFind
        
    mov     perPage, 0
    call    CrLf
    call    CrLf
    jmp     printNumbers
    
 
    exitLoop:

    call    CrLf
    call    CrLf
    mov     edx, OFFSET goodbye ;program ends, print goodbye message
    call    WriteString
    call    CrLf

	exit ; exit main
main ENDP

isComposite PROC
    pushad
    
    ;**EC: only check prime divisors
    mov     eax, testValue
    cmp     eax, 5
    je      complete
    cmp     eax, 7
    je      complete
    mov     ebx, 0   
    mov     esi, OFFSET divisor

	divisible:
    mov     edx, 0
    mov     eax, testValue
    mov     ebx, [esi]
    div     ebx
    cmp     edx, 0  
    jz      comp 
    inc     esi
    mov     ebx, [esi]
    cmp     ebx, 0
    je      complete
    jmp     divisible

    comp:
    mov     eax, testValue
    call    numPadding
    call    WriteDec
    inc     countsComp
    inc     perLine
    inc     perPage
    
    complete:
    popad
    ret
isComposite ENDP

numPadding PROC
    pushad

    ;check how many digits in testValue
    mov     eax, testValue
    cmp     eax, 10
    jl      single
    cmp     eax, 100
    jl      double
    cmp     eax, 1000
    jl      triple
        
    single: 
	;**EC: align the output columns
    mov     edx, OFFSET padSingle
    call    WriteString
    jmp     endPad
    
    double:
	;**EC: align the output columns
    mov     edx, OFFSET padDouble
    call    WriteString
    jmp     endPad
    
    triple:
	;**EC: align the output columns
    mov     edx, OFFSET padTriple
    call    WriteString
    jmp     endPad
    
    endPad:
    popad
    ret

numPadding ENDP

END main