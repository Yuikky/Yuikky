; Author: Jingwei Geng.
; Course number / section:CS_271_001_U2020
; Project ID : Program#4						Due date : Aug 2 by 11 : 59pm
; Description:Write a MASM program to perform the tasks shown below.Be sure to test your program and ensure
; that it rejects incorrect input values.
; 1. Introduce the program.
; 2. Get a user request in the range[min = 15 ..max = 200].
; 3. Generate request random integers in the range[lo = 100 ..hi = 999], storing them in consecutive
; elements of an array.
; 4. Display the list of integers before sorting, 10 numbers per line.
; 5. Sort the list in descending order(i.e., largest first).
; 6. Calculate and display the median value, rounded to the nearest integer.
; 7. Display the sorted list, 10 numbers per line.
; **EC: Display the numbers ordered by column instead of by row
; **EC: Implement the sorting functionality using a recursive Merge Sort algorithm.



Include Irvine32.inc



ExitProcess PROTO, dwExitCode:DWORD
; notes:
;		1)the important preconditions for most of the functions :
;			The input array size is in[15, 200]
;			The input value is in[100, 999]
;		2)I use the push - pop idiom, so the used registers will not change after the function's finishment
;
; I will not mention the above 2 points in all following functions' description
min = 15
max = 200
lo = 100
hi = 999
.data
introduce_string BYTE "Sorting Random Integers", 10,
"Programmed by Author Name", 10,
"This program generates random numbers in the range [100 .. 999],", 10,
"displays the original list, sorts the list, and calculates the", 10,
"median value. Finally, it displays the list sorted in descending order.", 10, 0
line_buffer BYTE 1024 DUP(0)
show_string1 BYTE "How many numbers should be generated? [15 .. 200]: ", 0
show_string2 BYTE "Invalid input", 10, 0
show_string3 BYTE "The unsorted random numbers:", 10, 0
show_string5 BYTE "The sorted list:", 10, 0
show_string6 BYTE "Thanks for using my program!", 10, 0
show_string7 BYTE "The median is ", 0
show_string8 BYTE "**EC: Display the numbers ordered by column instead of by row(from 10 number in a row to 10 number in a column)", 10,
"**EC: Implement the sorting functionality using a recursive Merge Sort algorithm.", 10, 0
array_content DWORD 200 DUP(0)
array_content_copy DWORD 200 DUP(0); it will be used by the extra credit
request_count DWORD 0
.code
main PROC

; output the introduce string
push OFFSET introduce_string
call introduction

; input the elements count and check its validation
push OFFSET request_count
push OFFSET show_string2
push OFFSET show_string1
call getData

; fill array
push request_count
push OFFSET array_content
call fillArray

; copy from array_content to array_content_copy
push OFFSET array_content
push OFFSET array_content_copy
push request_count
call copyArray

; show unsorted array:
push OFFSET array_content
push request_count
push OFFSET show_string3
call displayList

; sort array
push OFFSET array_content
push request_count
call sortList

; show median
push OFFSET array_content
push request_count
push OFFSET show_string7
call displayMedian

push OFFSET array_content
push request_count
push OFFSET show_string5
call displayList

; copy from array_content_copy to array_content
push OFFSET array_content_copy
push OFFSET array_content
push request_count
call copyArray

mov edx, OFFSET show_string8
call WriteString
; show unsorted array:
push OFFSET array_content
push request_count
push OFFSET show_string3
call displayListByColumn

; sort array
push OFFSET array_content
push request_count
call mergeSortList

push OFFSET array_content
push request_count
push OFFSET show_string5
call displayListByColumn


mov edx, OFFSET show_string6
call WriteString

INVOKE ExitProcess, 0
main ENDP

; Title:				copyArray
; Description:		copy array from a_array to b_array
; Receives:			a_array(reference), b_array(reference), size(value)
; Returns:			none
; Precondition:		none
; Registers changed : none
copyArray PROC
push ebp
mov ebp, esp

push eax
push ebx
push ecx
push esi
push edi

mov ecx, [ebp + 8]
mov esi, [ebp + 16]
mov edi, [ebp + 12]
mov ebx, 0
COPY_LOOP:
mov eax, [esi + ebx * 4]
mov[edi + ebx * 4], eax
inc ebx
loop COPY_LOOP

pop edi
pop esi
pop ecx
pop ebx
pop eax

pop ebp
ret 12
copyArray ENDP

; Title:				introduction
; Description:		show introduction message
; Receives:			introduce_string(reference)
; Returns:			none
; Precondition:		none
; Registers changed : none
introduction PROC
push ebp
mov ebp, esp

push edx
mov edx, [ebp + 8]
call WriteString
pop edx

pop ebp
ret 4
introduction ENDP

; Title:				getData
; Description:		input the array size
; Receives:			request(reference), show_string2(reference), show_string1(reference)
; Returns:			none
; Precondition:		none
; Registers changed : none
getData PROC
push ebp
mov ebp, esp
push edx
push eax
jmp NORMAL_READ_COUNT
ERROR_READ_COUNT :
mov edx, [ebp + 12]
call WriteString
NORMAL_READ_COUNT :
mov edx, [ebp + 8]
call WriteString
call ReadDec
cmp eax, min
jl ERROR_READ_COUNT
cmp eax, max
jg ERROR_READ_COUNT

mov edx, [ebp + 16]
mov[edx], eax

pop eax
pop edx

pop ebp
ret 12
getData ENDP

; Title:				displayMedian
; Description:		display the media value
; Receives:			array(reference), request(value), show_string7(reference)
; Returns:			none
; Precondition:		none
; Registers changed : none
displayMedian PROC
push ebp
mov ebp, esp
mov esi, [ebp + 16]
mov eax, [ebp + 12]
mov dx, 0
mov ecx, 2
div cx
cmp dx, 0
jz EVEN_PROCESS
movzx eax, ax
mov eax, [esi + eax * 4]
jmp EXIT_MEDIAN
EVEN_PROCESS :
movzx eax, ax
mov ebx, [esi + eax * 4]
dec eax
add ebx, [esi + eax * 4]
mov eax, ebx
mov dx, 0
mov ecx, 2
div cx
movzx eax, ax
cmp dx, 0
jz EXIT_MEDIAN
inc eax

EXIT_MEDIAN :
mov edx, [ebp + 8]
call WriteString
call WriteDec
mov al, 46
call WriteChar
mov al, 10
call WriteChar
pop ebp
ret 12
displayMedian ENDP

; Title:				displayList
; Description:		display the list by row
; Receives:			array(reference), request(value), title(reference)
; Returns:			none
; Precondition:		none
; Registers changed : none
displayList PROC
push ebp
mov ebp, esp

push eax
push ebx
push ecx
push edx
push esi
push edi

mov edx, [ebp + 8]
call WriteString
mov esi, [ebp + 16]
mov ecx, [ebp + 12]
mov ebx, 0
L1:
mov eax, [esi]
call WriteDec
inc ebx
push eax
push ebx
mov eax, ebx
mov dx, 0
mov bx, 10
div bx
pop ebx
pop eax

cmp dx, 0
jz SHOW_NEW_LINE
push ecx
push eax
mov ecx, 5
SPACE_5:
mov al, 32
call WriteChar
loop SPACE_5
pop eax
pop ecx
jmp EXIT_IF1
SHOW_NEW_LINE :
cmp ebx, [ebp + 12]
jz EXIT_IF1
mov al, 10
call WriteChar
EXIT_IF1 :
add esi, 4
loop L1

mov al, 10
call WriteChar

pop edi
pop esi
pop edx
pop ecx
pop ebx
pop eax

pop ebp
ret 12
displayList ENDP

; Title:				displayList
; Description:		display the list by column
; Receives:			array(reference), request(value), title(reference)
; Returns:			none
; Precondition:		none
; Registers changed : none
displayListByColumn PROC
push ebp
mov ebp, esp

mov edx, [ebp + 8]
call WriteString

push eax
push ebx
push ecx
push edx
push esi
push edi

mov esi, [ebp + 16]

mov ecx, [ebp + 12]
mov ebx, 0; col_idx
mov edi, 0; row_idx
L1 :
push esi
push ebx
mov eax, ebx
mov ebx, 40
mul ebx
lea esi, [esi + eax]
lea esi, [esi + edi * 4]
mov eax, [esi]
call WriteDec
pop ebx
pop esi

inc ebx
mov eax, ebx
push ebx
mov ebx, 10
mul ebx
add eax, edi
cmp eax, [ebp + 12]
pop ebx

jge SHOW_NEW_LINE
push ecx
push eax
mov ecx, 5
SPACE_5:
mov al, 32
call WriteChar
loop SPACE_5
pop eax
pop ecx
jmp EXIT_IF1
SHOW_NEW_LINE :
inc edi
mov ebx, 0
mov al, 10
call WriteChar
EXIT_IF1 :
loop L1

; mov al, 10
; call WriteChar

pop edi
pop esi
pop edx
pop ecx
pop ebx
pop eax

pop ebp
ret 12
displayListByColumn ENDP
; Title:				fillArray
; Description:		fill the array with random value
; Receives:			array(reference), request(value)
; Returns:			none
; Precondition:		none
; Registers changed : none
fillArray PROC
push ebp
mov ebp, esp

push esi
push ecx
push eax

mov esi, [ebp + 8]
mov ecx, [ebp + 12]
L1:
mov eax, hi - lo + 1
inc eax
call RandomRange
add eax, lo
mov[esi], eax
add esi, 4
loop L1

pop eax
pop ecx
pop esi

pop ebp
ret 8
fillArray ENDP

; Title:				SmartCmp
; Description:		compare 2 values
; Receives:			v1(value), v2(value)
; Returns:			none
; Precondition:		none
; Registers changed : none
SmartCmp PROC
push ebp
mov ebp, esp

push eax
push ebx

mov eax, [ebp + 12]
mov ebx, [ebp + 8]
cmp eax, ebx

pop ebx
pop eax

pop ebp
ret 8
SmartCmp ENDP

; Title:			Exchange
; Description:		swap 2 values
; Receives:			v1(reference), v2(reference)
; Returns:			none
; Precondition:		none
; Registers changed : none
Exchange PROC
push ebp
mov ebp, esp

push eax
push ebx
push ecx
push edx

mov eax, [ebp + 12]
mov ebx, [ebp + 8]
mov ecx, [eax]
mov edx, [ebx]
mov[eax], edx
mov[ebx], ecx

pop edx
pop ecx
pop ebx
pop eax

pop ebp
ret 8
Exchange ENDP



; Title:			sortList
; Description:		sort the list by selection sort
; Receives:			array(reference), request(value)
; Returns:			none
; Precondition:		none
; Registers changed : none
sortList PROC
push ebp
mov ebp, esp

push eax
push ebx
push ecx
push edx
push esi

mov edx, [ebp + 8]
sub edx, 1
mov esi, [ebp + 12]

mov ecx, 0
FOR_1:
cmp ecx, edx
jge BREAK_1
mov eax, ecx
mov ebx, ecx
inc ebx
FOR_2 :
cmp ebx, [ebp + 8]
jge BREAK_2
push[esi + ebx * 4]
push[esi + eax * 4]
call SmartCmp
jle EXIT_IF
push ecx
mov ecx, eax
mov eax, ebx
mov ebx, ecx
pop ecx
EXIT_IF :
inc ebx
jmp FOR_2
BREAK_2 :
push ebx
lea ebx, [esi + eax * 4]
push ebx
lea ebx, [esi + ecx * 4]
push ebx
call Exchange
pop ebx
inc ecx
jmp FOR_1

BREAK_1 :
pop esi
pop edx
pop ecx
pop ebx
pop eax

pop ebp
ret 8
sortList ENDP

; Title:				mergeSortList
; Description:		sort the list by merge sort
; Receives:			array(reference), request(value)
; Returns:			none
; Precondition:		none
; Registers changed : none
mergeSortList PROC
push ebp
mov ebp, esp

push eax
push ebx
push ecx
push edx

mov eax, [ebp + 8]
mov ebx, 4
mul ebx
sub esp, eax
mov ebx, esp
add ebx, 4

push 0
push[ebp + 8]
push[ebp + 12]
push ebx
call mergeSortListInner
add esp, eax

pop edx
pop ecx
pop ebx
pop eax

pop ebp
ret 8
mergeSortList ENDP

; Title:				mergeSortListInner
; Description:		sort the list by merge sort, it will be called by mergeSortList and itself
; Receives:			array_begin_index(value), array_end_index(value), array(reference), copy_array(reference)
; Returns:			none
; Precondition:		none
; Registers changed : none
mergeSortListInner PROC
push ebp
mov ebp, esp

push eax
push ebx
push ecx
push edx
push esi
push edi

; left begin : eax
; middle: ebx
; right_begin: ecx
; end: edx
; total begin : edi

mov eax, [ebp + 20]
mov edx, [ebp + 16]

inc eax
cmp eax, edx
jge EXIT_1
dec eax

add eax, edx
push edx
mov dx, 0
mov ecx, 2
div cx
pop edx
movzx eax, ax
mov ebx, eax
mov ecx, ebx
mov eax, [ebp + 20]
mov edi, eax

push eax
push ebx
push[ebp + 12]
push[ebp + 8]
call mergeSortListInner

push ebx
push edx
push[ebp + 12]
push[ebp + 8]
call mergeSortListInner

;; merge the left and right array
FIRST_LOOP:
cmp eax, ebx
jge SECOND_LOOP
cmp ecx, edx
jge SECOND_LOOP

mov esi, [ebp + 12]
push edx
mov edx, [esi + eax * 4]
cmp edx, [esi + ecx * 4]
jl CHOOSE_RIGHT
mov esi, [ebp + 8]
mov[esi + edi * 4], edx
inc eax
jmp FIRST_LOOP_CONTINUE
CHOOSE_RIGHT :
mov edx, [esi + ecx * 4]
mov esi, [ebp + 8]
mov[esi + edi * 4], edx
inc ecx
FIRST_LOOP_CONTINUE :
inc edi
pop edx
jmp FIRST_LOOP

SECOND_LOOP :
cmp eax, ebx
jge THIRD_LOOP
push edx
mov esi, [ebp + 12]
mov edx, [esi + eax * 4]
mov esi, [ebp + 8]
mov[esi + edi * 4], edx
inc edi
inc eax
pop edx
jmp SECOND_LOOP
THIRD_LOOP :
cmp ecx, edx
jge COPY_BACK
push edx
mov esi, [ebp + 12]
mov edx, [esi + ecx * 4]
mov esi, [ebp + 8]
mov[esi + edi * 4], edx
inc edi
inc ecx
pop edx
jmp THIRD_LOOP

COPY_BACK :
mov eax, [ebp + 20]
mov esi, [ebp + 12]
mov edi, [ebp + 8]
FORTH_LOOP :
	cmp eax, edx
	jge EXIT_1
	mov ebx, [edi + eax * 4]
	mov[esi + eax * 4], ebx
	inc eax
	jmp FORTH_LOOP


	EXIT_1 :
pop edi
pop esi
pop edx
pop ecx
pop ebx
pop eax

pop ebp
ret 16
mergeSortListInner ENDP

END main