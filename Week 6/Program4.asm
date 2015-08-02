TITLE Program Program4		(Program4.asm)

; Program Description: Sorts random integers
;1. Introduce the program.
;2. Get a user request in the range [min = 10 .. max = 200].
;3. Generate request random integers in the range [lo = 100 .. hi = 999], storing them in consecutive elements
;of an array.
;4. Display the list of integers before sorting, 10 numbers per line.
;5. Sort the list in descending order (i.e., largest first).
;6. Calculate and display the median value, rounded to the nearest integer.
;7. Display the sorted list, 10 numbers per line.
; Author: Sean Reilly
; Date Created: 7/27/15
; Last Modification Date: 8/2/15

INCLUDE Irvine32.inc

; CONSTANTS
    MIN = 10
    MAX = 200
    RANDOMLOW = 100
    RANDOMHIGH = 999

.data

	intro           BYTE    "Sorting Random Integers                          Programmed by Sean Reilly", 13, 10
	intro2			BYTE    "This program generates random numbers in the range [100 .. 999],", 13, 10
    intro3          BYTE    "displays the original list, sorts the list, and calculates ", 13, 10
	intro4			BYTE	"the median value.  Finally, it displays the list sorted in descending order.", 0
                            
    extracredit     BYTE    "------------------------------------------------------------", 13, 10, 
                            "**EC: Recursive Sorting Algorithm.", 13, 10,
                            "**EC: Other: Added alignment procedure for use with any numbers.", 13, 10,
                            "------------------------------------------------------------", 0
                            
    numPrompt       BYTE    "How many numbers should be generated [10 .. 200]? ", 0
    error	        BYTE    "Invalid Input", 0
    unsorted        BYTE    "The unsorted random numbers are: ", 0
	median	        BYTE    "The median is: ", 0 
    sorted          BYTE    "The sorted list: ", 0
    array           DWORD   MAX DUP(0)   
    input           DWORD   ?
    testValue       DWORD   ?
    perLine         DWORD   10 ;
    allign          BYTE    "   ", 0 
    allign2			BYTE    "  ", 0  
    allign3		    BYTE    " ", 0   
    
.code
main PROC
  
    call    Randomize ;activate

    call    introduction ; run the introduction/ec message
    
    push    OFFSET input 
    call    getData ;gets data from user
    
    push    input ;fills array with random #'s
    push    OFFSET array
    call    fillArray
    
    mov     edx, OFFSET unsorted ;print unsorted array
    call    WriteString
    call    CrLf
    
    push    input ;parameters for displayList
    push    OFFSET array
    call    displayList
    
    push    OFFSET array ;sort array
    push    0
    mov     eax, input
    dec     eax
    push    eax 
    call    quickSort
    
    mov     edx, OFFSET median ;print median
    call    WriteString
    
    push    input
    push    OFFSET array
    call    printsMedian
    
    mov     edx, OFFSET sorted ;print sorted array
    call    WriteString
    call    CrLf
    
    push    input
    push    OFFSET array
    call    displayList    
    
    exit 
main ENDP

introduction PROC ;introduce the program
    mov     edx, OFFSET intro
    call    WriteString
    call    CrLf

	mov     edx, OFFSET intro2
    call    CrLf
	mov     edx, OFFSET intro3
	mov     edx, OFFSET intro4
    
	mov     edx, OFFSET extracredit
    call    WriteString
    call    CrLf
    
    ret
introduction ENDP 

getData PROC USES eax edx ebp

    mov     ebp, esp
    
    promptLoop:
        mov     edx, OFFSET numPrompt
        call    WriteString
        call    ReadInt
        
        cmp     eax, MAX
        jle     lessThanMax
        jg      notValid
        
    lessThanMax:
        cmp     eax, MIN
        jl      notValid
        jmp     Valid
        
    notValid:
        mov     edx, OFFSET error
        call    WriteString
        call    CrLf
        jmp     promptLoop
        
    Valid:
        mov     ebx, [ebp+16] 
        mov     [ebx], eax    
        call    CrLf
      
    ret 4
getData ENDP

fillArray PROC USES esi ecx eax ebp
   
    mov     ebp, esp
    mov     esi, [ebp+20] 
    mov     ecx, [ebp+24] ; counter 

    mov     eax, RANDOMHIGH
    sub     eax, RANDOMLOW
    inc     eax
    
    fill:
        call    RandomRange
        add     eax, RANDOMLOW
        mov     [esi], eax
        add     esi, SIZEOF DWORD
        loop    fill
    
    ret 8
fillArray ENDP

quickSort PROC USES eax ebx ecx esi ebp
  
    mov     ebp, esp
    sub     esp, 4        
    mov     esi, [ebp+32] 

    mov     eax, [ebp+28]
    cmp     eax, [ebp+24]
    jl      sort   
    jmp     sortEnd
    
    sort:
        lea     esi, [ebp-4]
        push    esi         
        push    [ebp+32]    
        push    [ebp+28]    
        push    [ebp+24]    
        call    partition   
        
        push    [ebp+32]    ;@array
        push    [ebp+28]    ;start
        mov     eax, [ebp-4]
        dec     eax
        push    eax         ;p-1
        call    quickSort
        
        push    [ebp+32]    ;@array
        mov     eax, [ebp-4]
        inc     eax
        push    eax         ;p+1
        push    [ebp+24]    ;end
        call    quickSort
        
    sortEnd:
    mov     esp, ebp
    ret 12
quickSort ENDP

partition PROC USES eax ebx ecx esi ebp
    
    mov     ebp, esp
    sub     esp, 8        
    mov     esi, [ebp+32] 
    
    mov     eax, [ebp+28]
    mov     ebx, SIZEOF DWORD
    mul     ebx
    mov     eax, [esi+eax]
    mov     [ebp-4], eax
    
    mov     eax, [ebp+28]
    mov     [ebp-8], eax
    inc     eax
    mov     ecx, eax  
    
    outerLoop:
        cmp     ecx, [ebp+24] 
        jg      endLoop
        
        inner:
        mov     eax, ecx       
        mov     ebx, SIZEOF DWORD
        mul     ebx
        mov     eax, [esi+eax]       
        cmp     eax, [ebp-4]   
        jl      next         
        
        push    [ebp+32]    ;swap
        mov     eax, [ebp-8]
        inc     eax
        push    eax         
        push    ecx         
        call    swap
        push    [ebp+32]    
        push    [ebp-8]     
        mov     eax, [ebp-8]
        inc     eax
        push    eax   
        call    swap

        mov     eax, [ebp-8]
        inc     eax
        mov     [ebp-8], eax

        next:
        inc     ecx     
        jmp     outerLoop
        
        
    endLoop:
    mov     eax, [ebp+36]
    mov     ebx, [ebp-8]
    mov     [eax], ebx
    mov     esp, ebp
    ret 12
partition ENDP

swap PROC USES eax ebx ecx esi ebp ;swaps elements in array

    mov     ebp, esp
    sub     esp, 4        
    mov     esi, [ebp+32] 

    mov     eax, [ebp+28]      
    mov     ebx, SIZEOF DWORD
    mul     ebx
    mov     ebx, [esi+eax]
    mov     DWORD PTR [ebp-4], ebx
    
    mov     eax, [ebp+24]   
    mov     ebx, SIZEOF DWORD
    mul     ebx
    mov     ecx, [esi+eax]
    mov     eax, [ebp+28]   
    mul     ebx
    mov     [esi+eax], ecx
    
    mov     eax, [ebp+24]
    mov     ebx, SIZEOF DWORD
    mul     ebx
    mov     ecx, [ebp-4]
    mov     [esi+eax], ecx
    
    mov     esp, ebp
    ret 12
swap ENDP

printsMedian PROC ;prints median
    pushad
    
    mov     ebp, esp
    mov     esi, [ebp+36] 
    mov     ecx, [ebp+40] 

    cdq
    mov     eax, ecx
    mov     ecx, 2
    div     ecx
    mov     ecx, eax ;save the result
    
    cmp     edx, 0 
    jz      isEven
    jmp     isOdd
    
    isEven:
    mov     ebx, SIZEOF DWORD
    mul     ebx
    mov     ebx, [esi+eax]  
    
    mov     eax, ecx
    dec     eax
    mov     ecx, SIZEOF DWORD
    mul     ecx
    mov     ecx, [esi+eax] 
    
    cdq
    mov     eax, ebx
    add     eax, ecx
    mov     ebx, 2
    div     ebx
    
    jmp     printMedian
    
    isOdd:
    mov     ebx, SIZEOF DWORD
    mul     ebx
    mov     ebx, [esi+eax]
    mov     eax, ebx
    
    printMedian:
    call    WriteDec
    call    CrLf
    call    CrLf
    
    popad
    ret     8
printsMedian ENDP

displayList PROC USES ebx ecx esi ebp ;prints array
    
    mov     ebp, esp
    mov     esi, [ebp+20] 
    mov     ecx, [ebp+24] 
    mov     ebx, 0 
    
    display:
        mov     eax, [esi] 
        call    WriteDec
        
        mov     testValue, eax
        push    testValue
        call    numAllign
        
        add     esi, SIZEOF DWORD
        
        inc     ebx
        cmp     ebx, perLine
        jl      next
        
        newLine:
            call    CrLf
            mov     ebx, 0
            
        next:
            loop    display
        
    call    CrLf
    call    CrLf
    ret 8
displayList ENDP

numAllign PROC USES eax edx ebp ;alligns numbers in an orderly fashion

    mov     ebp, esp
    
    mov     eax, [ebp+16] 
    cmp     eax, 10
    jl      single
    cmp     eax, 1000
    jl      double
    cmp     eax, 10000
    jl      triple
    
    single:
    mov     edx, OFFSET allign
    call    WriteString
    jmp     endAllign
    
    double:
    mov     edx, OFFSET allign2
    call    WriteString
    jmp     endAllign
    
    triple:
    mov     edx, OFFSET allign3
    call    WriteString
    jmp     endAllign
    
    endAllign:
    ret 4

numAllign ENDP

END main