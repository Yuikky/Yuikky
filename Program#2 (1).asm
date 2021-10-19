; Author: Jingwei Geng.
; Course number / section:CS_271_001_U2020
; Project ID : Program#2						Due date : Jul 12 by 11 : 59pm
; Description:
;		1. Display the program title and programmer¡¯s name.Then prompt the user for their name and greet
;		them(by name).
;		2.Prompt the user to enter the number of Fibonacci terms to be displayed.Advise the user to enter
;		an integer in the range[1 .. 46].
;		3.Get and validate the user input(n).
;		4.Calculate and display all of the Fibonacci numbers up to and including the n term.
;		5.Display a parting message that includes the user¡¯s name, and terminate the program.


INCLUDE Irvine32.inc

.data

; declare the introduce parts

Info_1			    BYTE "Fibonacci Numbers", 0
Info_2				BYTE "Programmed by Jingwei Geng.", 0
Info_3				BYTE "Enter the number of Fibonacci terms to be displayed.", 0
Info_4				BYTE "Provide the number as an integer in the range [1 .. 46].", 0
Info_5				BYTE "How many Fibonacci terms do you want? ", 0

; declare the Fibonacci_terms number and Helper number
Fibonacci_terms		DWORD ?
Helper				DWORD ?

; declare the output format
space				BYTE "     ", 0
Name_get			BYTE "What's your name?", 0
Hello_message		BYTE "Hello, ", 0
Error_info			BYTE "Out of range. Enter a number in [1 .. 46]", 0

; username get
User_name			BYTE 20 DUP(0)

; specical output number
Output_term1		BYTE "1", 0
Output_term2		BYTE "1    1", 0

; Ending information
Endmessage_1		BYTE "Results certified by Jingwei Geng", 0
Endmessage_2		BYTE "Goodbye, ", 0
Fib_number_1		DWORD ?
Fib_number_2		DWORD ?







.code
main PROC

; -------------- - Introduce Parts------------------
mov		edx, OFFSET Info_1
call WriteString
call Crlf

mov		edx, OFFSET Info_2
call WriteString
call Crlf

; -------------- - Get username parts.--------------------

mov		edx, OFFSET Name_get
call WriteString
mov		edx, OFFSET User_name
mov		ecx, 19
call ReadString
call Crlf

; ------------Welcome user parts--------------------
mov       edx, OFFSET Hello_message
call   WriteString
mov       edx, OFFSET User_name
call   WriteString
call   CrLf

; ---------------- - Ask user to enter the fibnacci terms-------- -
mov		edx, OFFSET Info_3
call WriteString
call Crlf

mov		edx, OFFSET Info_4
call WriteString
call Crlf
call Crlf

; ------------Number gets------------ -
number_get:
mov		edx, OFFSET Info_5
call WriteString
call ReadInt
mov		Fibonacci_terms, eax
call Crlf
; --------compare the number parts------------

; if number is 1, jmp to output 1 parts, only output 1
cmp		eax, 1
je		Output_1
; if number is 2, jmp to output 1 parts, only output 1, 1
cmp		eax, 2
je		Output_2
; compare the number with 46, if large jump to error_check
cmp		eax, 46
jg		error_check
; compare the number with 46, if less jump to error_check
cmp		eax, 1
jl		error_check

; if the number is between 1 and 46, move the terms to ecx(loop times)
mov	ecx, Fibonacci_terms
; jump to normal_output
jmp Normal_output


; ----------error_check, output the number out range and back to number_get parts------ -
error_check:
mov       edx, OFFSET Error_info
call   WriteString
call   CrLf
jmp number_get

; --------------output 1, when the usernumber is 1------ -
Output_1:
mov       edx, OFFSET Output_term1
call   WriteString
call   CrLf
jmp End_parts

; --------------output 1, 1, when the usernumber is 2------ -
Output_2 :
mov       edx, OFFSET Output_term2
call   WriteString
call   CrLf
jmp End_parts

; --------------output normal format, when the number[1.46]--------
; ------ - print the 1, 1 first------
Normal_output:
mov       edx, OFFSET Output_term2
call   WriteString
sub ecx, 2
mov		eax, 1
mov Fib_number_1, eax
mov		eax, 1
mov Fib_number_2, eax

; and assigned the fibnumber are 1 and 1
; jump to calculate parts
jmp Print_fibnumber



; ------------------------calculate the number parts
Print_fibnumber :
; Step1:number1 + number2
; Step2:output the results
; Step3:assign number2 = number 1, result = number2
; Step4:decrease the term - 1, do the loop,
mov		eax, Fib_number_1
add		eax, Fib_number_2
mov     edx, OFFSET space
call   WriteString
mov		Helper, eax
call   WriteDec

mov		eax, Fib_number_2
mov		Fib_number_1, eax
mov		eax, Helper
mov		Fib_number_2, eax




dec		Fibonacci_terms

loop Print_fibnumber





; ____________End parts___________________

End_parts :
call   CrLf
call   CrLf
mov       edx, OFFSET Endmessage_1
call   WriteString
call   CrLf
mov       edx, OFFSET Endmessage_2
call   WriteString
mov       edx, OFFSET User_name
call   WriteString
call   CrLf



exit
main ENDP
END main



